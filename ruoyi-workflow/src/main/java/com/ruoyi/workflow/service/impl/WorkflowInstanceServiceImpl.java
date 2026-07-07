package com.ruoyi.workflow.service.impl;

import java.util.*;
import java.util.stream.Collectors;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.engine.HistoryService;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.RuntimeService;
import org.flowable.common.engine.impl.identity.Authentication;
import org.flowable.engine.history.HistoricProcessInstance;
import org.flowable.variable.api.history.HistoricVariableInstance;
import org.flowable.engine.repository.ProcessDefinition;
import org.flowable.engine.runtime.ProcessInstance;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.domain.WorkflowInstance;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.service.IWorkflowInstanceService;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 流程实例 服务层实现
 *
 * @author ruoyi
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkflowInstanceServiceImpl implements IWorkflowInstanceService
{
    private final RuntimeService runtimeService;

    private final RepositoryService repositoryService;

    private final HistoryService historyService;

    private final WorkflowBusinessHandlerRegistry handlerRegistry;

    @Override
    public Page<WorkflowInstance> selectInstanceList(Page<WorkflowInstance> page, WorkflowInstance instance)
    {
        org.flowable.engine.runtime.ProcessInstanceQuery query = createRunningInstanceQuery(instance.getProcessName())
                .orderByStartTime().desc();
        List<ProcessInstance> instanceList = query
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        long count = query.count();

        List<WorkflowInstance> resultList = instanceList.stream()
                .map(this::convertRunningToWorkflowInstance)
                .collect(Collectors.toList());

        page.setRecords(resultList);
        page.setTotalRow(count);
        return page;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String startProcessInstance(String definitionId, String businessKey, Map<String, Object> variables)
    {
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(definitionId).singleResult();

        if (pd == null)
        {
            throw new RuntimeException("流程定义不存在");
        }

        // 设置发起人
        String loginUsername = SecurityUtils.getUsername();
        Map<String, Object> vars = variables != null ? new HashMap<>(variables) : new HashMap<>();
        vars.put(FlowableProcessConstants.INITIATOR_VAR, loginUsername);
        // 设置 Flowable 认证用户，确保 startUserId 被记录
        if (StrUtil.isNotBlank(loginUsername)) {
            Authentication.setAuthenticatedUserId(loginUsername);
        }

        ProcessInstance processInstance = runtimeService
                .startProcessInstanceById(definitionId, businessKey, vars);

        return processInstance.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void stopProcessInstance(String instanceId, String reason)
    {
        runtimeService.deleteProcessInstance(instanceId, reason);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateState(String instanceId, int state)
    {
        if (state == FlowableProcessConstants.SUSPEND_STATE)
        {
            runtimeService.suspendProcessInstanceById(instanceId);
        }
        else if (state == FlowableProcessConstants.ACTIVE_STATE)
        {
            runtimeService.activateProcessInstanceById(instanceId);
        }
    }

    @Override
    public Page<WorkflowInstance> selectMyInstanceList(Page<WorkflowInstance> page, WorkflowInstance instance)
    {
        String username = SecurityUtils.getUsername();

        org.flowable.engine.history.HistoricProcessInstanceQuery histQuery = createMyInstanceQuery(username, instance)
                .orderByProcessInstanceStartTime().desc();

        List<HistoricProcessInstance> histList = histQuery
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        long count = histQuery.count();

        // 组装结果
        List<WorkflowInstance> resultList = histList.stream()
                .map(this::convertHistoricToWorkflowInstance)
                .collect(Collectors.toList());

        page.setRecords(resultList);
        page.setTotalRow(count);
        return page;
    }

    @Override
    public WorkflowInstance selectInstanceById(String instanceId)
    {
        ProcessInstance pi = runtimeService.createProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();
        if (pi != null)
        {
            return convertRunningToWorkflowInstance(pi);
        }

        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();
        if (hpi != null)
        {
            return convertHistoricToWorkflowInstance(hpi);
        }
        return null;
    }

    private org.flowable.engine.runtime.ProcessInstanceQuery createRunningInstanceQuery(String processName) {
        org.flowable.engine.runtime.ProcessInstanceQuery q = runtimeService.createProcessInstanceQuery();
        if (StrUtil.isNotBlank(processName)) {
            q.processDefinitionName(processName);
        }
        return q;
    }

    private org.flowable.engine.history.HistoricProcessInstanceQuery createMyInstanceQuery(String username, WorkflowInstance instance) {
        org.flowable.engine.history.HistoricProcessInstanceQuery q = historyService
                .createHistoricProcessInstanceQuery().startedBy(username);
        if (instance != null) {
            if (StrUtil.isNotBlank(instance.getProcessName())) {
                q.processDefinitionName(instance.getProcessName());
            }
            if (StrUtil.isNotBlank(instance.getStatus())) {
                if (FlowableProcessConstants.INSTANCE_COMPLETED.equals(instance.getStatus())) {
                    q.finished();
                } else if (FlowableProcessConstants.INSTANCE_RUNNING.equals(instance.getStatus())) {
                    q.unfinished();
                }
            }
        }
        return q;
    }

    private HistoricVariableInstance queryHistoricVar(String processInstanceId, String varName) {
        return historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(processInstanceId).variableName(varName).singleResult();
    }

    /**
     * 转换运行中的流程实例
     */
    private WorkflowInstance convertRunningToWorkflowInstance(ProcessInstance pi)
    {
        WorkflowInstance wi = new WorkflowInstance();
        wi.setInstanceId(pi.getId());
        wi.setDefinitionId(pi.getProcessDefinitionId());
        wi.setProcessKey(pi.getProcessDefinitionKey());
        wi.setBusinessKey(pi.getBusinessKey());
        wi.setStartUserId(pi.getStartUserId());
        wi.setStartTime(pi.getStartTime());
        wi.setStatus(pi.isSuspended() ? FlowableProcessConstants.INSTANCE_SUSPENDED : FlowableProcessConstants.INSTANCE_RUNNING);
        wi.setDeploymentId(pi.getDeploymentId());

        wi.setBusinessCode((String) runtimeService.getVariable(pi.getId(), FlowableProcessConstants.BUSINESS_CODE_VAR));
        String initiator = (String) runtimeService.getVariable(pi.getId(), FlowableProcessConstants.INITIATOR_VAR);
        wi.setStartUserName(StrUtil.blankToDefault(initiator, pi.getStartUserId()));

        populateCommonInstanceFields(wi, pi.getProcessDefinitionId());

        wi.setCurrentActivity(resolveActivityNames(
                repositoryService.getBpmnModel(pi.getProcessDefinitionId()),
                runtimeService.getActiveActivityIds(pi.getId())));
        return wi;
    }

    /**
     * 转换已完成的流程实例
     */
    private WorkflowInstance convertHistoricToWorkflowInstance(HistoricProcessInstance hpi)
    {
        WorkflowInstance wi = new WorkflowInstance();
        wi.setInstanceId(hpi.getId());
        wi.setDefinitionId(hpi.getProcessDefinitionId());
        wi.setProcessKey(hpi.getProcessDefinitionKey());
        wi.setBusinessKey(hpi.getBusinessKey());
        wi.setStartUserId(hpi.getStartUserId());
        wi.setStartTime(hpi.getStartTime());
        wi.setEndTime(hpi.getEndTime());
        wi.setStatus(hpi.getEndTime() != null ? FlowableProcessConstants.INSTANCE_COMPLETED : FlowableProcessConstants.INSTANCE_RUNNING);
        wi.setDeploymentId(hpi.getDeploymentId());

        HistoricVariableInstance btVar = queryHistoricVar(hpi.getId(), FlowableProcessConstants.BUSINESS_CODE_VAR);
        wi.setBusinessCode(btVar != null ? (String) btVar.getValue() : null);
        HistoricVariableInstance initVar = queryHistoricVar(hpi.getId(), FlowableProcessConstants.INITIATOR_VAR);
        wi.setStartUserName(initVar != null ? (String) initVar.getValue() : hpi.getStartUserId());

        populateCommonInstanceFields(wi, hpi.getProcessDefinitionId());

        if (hpi.getEndTime() == null) {
            wi.setCurrentActivity(resolveActivityNames(
                    repositoryService.getBpmnModel(hpi.getProcessDefinitionId()),
                    runtimeService.getActiveActivityIds(hpi.getId())));
        }
        return wi;
    }

    private void populateCommonInstanceFields(WorkflowInstance wi, String processDefId) {
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(processDefId).singleResult();
        wi.setProcessName(pd != null ? pd.getName() : processDefId);
        if (pd != null) wi.setVersion(pd.getVersion());
        handlerRegistry.fillInstanceBusinessInfo(wi);
    }

    private String resolveActivityNames(BpmnModel bpmnModel, List<String> activeIds) {
        if (activeIds == null || activeIds.isEmpty() || bpmnModel == null) return null;
        return activeIds.stream()
                .map(id -> { org.flowable.bpmn.model.FlowElement fe = bpmnModel.getFlowElement(id);
                    return fe != null ? (fe.getName() != null ? fe.getName() : fe.getId()) : id; })
                .collect(Collectors.joining(","));
    }
}
