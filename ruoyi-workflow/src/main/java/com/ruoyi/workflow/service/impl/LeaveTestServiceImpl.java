package com.ruoyi.workflow.service.impl;

import java.util.Map;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.domain.LeaveTest;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.handler.WorkflowBusinessHandler;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.mapper.LeaveTestMapper;
import com.ruoyi.workflow.service.ILeaveTestService;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("leaveTestServiceImpl")
public class LeaveTestServiceImpl implements ILeaveTestService, WorkflowBusinessHandler, BeanNameAware {

    private String beanName;

    @Override
    public void setBeanName(String name) {
        this.beanName = name;
    }

    @Autowired
    private LeaveTestMapper leaveTestMapper;

    @Autowired
    private IWorkflowTaskService workflowTaskService;

    @Autowired
    private WorkflowBusinessHandlerRegistry handlerRegistry;

    @Override
    public Page<LeaveTest> selectLeaveTestList(Page<LeaveTest> page, LeaveTest leaveTest) {
        QueryWrapper qw = QueryWrapper.create()
                .select()
                .from("leave_test")
                .orderBy("create_time", false);
        if (leaveTest.getUserName() != null && !leaveTest.getUserName().isEmpty()) {
            qw.and("user_name like ?", "%" + leaveTest.getUserName() + "%");
        }
        return leaveTestMapper.paginate(page.getPageNumber(), page.getPageSize(), qw);
    }

    @Override
    public LeaveTest selectLeaveTestById(Long id) {
        return leaveTestMapper.selectOneById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertLeaveTest(LeaveTest leaveTest) {
        leaveTest.setStatus("0");
        int rows = leaveTestMapper.insert(leaveTest);
        // 从业务配置表动态获取当前 Service 对应的流程定义 Key
        WorkflowBusinessConfig config = handlerRegistry.getConfigByBeanName(beanName);
        if (config != null) {
            workflowTaskService.submitForApproval(config.getProcessDefinitionKey(), String.valueOf(leaveTest.getId()), null);
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateLeaveTest(LeaveTest leaveTest) {
        return leaveTestMapper.update(leaveTest);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteLeaveTestById(Long id) {
        return leaveTestMapper.deleteById(id);
    }

    // ====== WorkflowBusinessHandler 实现 ======

    @Override
    public Object loadBusinessData(String businessId) {
        return leaveTestMapper.selectOneById(Long.valueOf(businessId));
    }

    @Override
    public void onProcessStarted(Object businessData, String processInstanceId) {
        LeaveTest leave = (LeaveTest) businessData;
        leave.setStatus("1");
        leave.setProcessInstanceId(processInstanceId);
        leaveTestMapper.update(leave);
    }

    @Override
    public void onProcessCompleted(Object businessData, String processInstanceId, Map<String, Object> processVariables) {
        LeaveTest leave = (LeaveTest) businessData;
        Object approved = processVariables != null ? processVariables.get(FlowableProcessConstants.APPROVED_VAR) : null;
        leave.setStatus(approved != null && Integer.valueOf(0).equals(approved) ? "2" : "3");
        leaveTestMapper.update(leave);
    }

    @Override
    public String getBusinessSummary(Object businessData) {
        if (businessData instanceof LeaveTest) {
            return ((LeaveTest) businessData).getUserName() + "的请假申请";
        }
        return "";
    }
}
