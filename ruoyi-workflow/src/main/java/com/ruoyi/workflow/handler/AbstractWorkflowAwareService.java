package com.ruoyi.workflow.handler;

import java.util.Map;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.domain.WorkflowBaseEntity;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.Setter;

public abstract class AbstractWorkflowAwareService<T extends WorkflowBaseEntity>
        extends ServiceImpl<BaseMapper<T>, T>
        implements WorkflowBusinessHandler, BeanNameAware {

    @Setter
    private String beanName;

    @Autowired
    protected IWorkflowTaskService workflowTaskService;

    protected void startWorkflow(String businessId) {
        if (beanName != null) {
            workflowTaskService.startProcess(beanName, businessId, null);
        }
    }

    @Override
    public Object loadBusinessData(String businessId) {
        if (businessId == null) return null;
        return getById(Long.valueOf(businessId));
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onProcessStarted(Object businessData, String processInstanceId) {
        T entity = (T) businessData;
        entity.setStatus(FlowableProcessConstants.STATUS_IN_PROGRESS);
        entity.setProcessInstanceId(processInstanceId);
        updateById(entity);
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onProcessCompleted(Object businessData, String processInstanceId,
                                   Map<String, Object> processVariables) {
        T entity = (T) businessData;
        Object approved = processVariables != null
                ? processVariables.get(FlowableProcessConstants.APPROVED_VAR) : null;
        entity.setStatus(approved != null && Integer.valueOf(0).equals(approved)
                ? FlowableProcessConstants.STATUS_REJECTED
                : FlowableProcessConstants.STATUS_APPROVED);
        updateById(entity);
    }

    @Override
    public abstract String getBusinessSummary(Object businessData);
}
