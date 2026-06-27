package com.ruoyi.workflow.service.impl;

import java.io.InputStream;
import java.util.*;
import java.util.stream.Collectors;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.engine.HistoryService;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.history.HistoricActivityInstance;
import org.flowable.engine.history.HistoricProcessInstance;
import org.flowable.variable.api.history.HistoricVariableInstance;
import org.flowable.engine.repository.ProcessDefinition;
import org.flowable.engine.runtime.ProcessInstance;
import org.flowable.image.impl.DefaultProcessDiagramGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.workflow.domain.WorkflowInstance;
import com.ruoyi.workflow.service.IWorkflowInstanceService;
import cn.hutool.core.util.StrUtil;

/**
 * 流程实例 服务层实现
 *
 * @author ruoyi
 */
@Service
public class WorkflowInstanceServiceImpl implements IWorkflowInstanceService
{
    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private HistoryService historyService;

    @Override
    public Page<WorkflowInstance> selectInstanceList(Page<WorkflowInstance> page, WorkflowInstance instance)
    {
        org.flowable.engine.runtime.ProcessInstanceQuery piQuery = runtimeService.createProcessInstanceQuery();
        if (StrUtil.isNotBlank(instance.getProcessName()))
        {
            piQuery.processDefinitionName(instance.getProcessName());
        }
        List<ProcessInstance> instanceList = piQuery
                .orderByStartTime().desc()
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        org.flowable.engine.runtime.ProcessInstanceQuery countPiQuery = runtimeService.createProcessInstanceQuery();
        if (StrUtil.isNotBlank(instance.getProcessName()))
        {
            countPiQuery.processDefinitionName(instance.getProcessName());
        }
        long count = countPiQuery
                .count();

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
        if (variables != null)
        {
            variables.put("initiator", SecurityUtils.getUsername());
        }

        ProcessInstance processInstance = runtimeService
                .startProcessInstanceById(definitionId, businessKey, variables);

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
        if (state == 1)
        {
            runtimeService.suspendProcessInstanceById(instanceId);
        }
        else if (state == 2)
        {
            runtimeService.activateProcessInstanceById(instanceId);
        }
    }

    @Override
    public String getInstanceDiagram(String instanceId)
    {
        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();

        String definitionId;
        if (processInstance != null)
        {
            definitionId = processInstance.getProcessDefinitionId();
        }
        else
        {
            // 已完成的流程从历史中获取
            HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                    .processInstanceId(instanceId).singleResult();
            if (hpi == null)
            {
                return null;
            }
            definitionId = hpi.getProcessDefinitionId();
        }

        BpmnModel bpmnModel = repositoryService.getBpmnModel(definitionId);
        if (bpmnModel == null)
        {
            return null;
        }

        // 获取已完成的节点ID（标绿高亮）
        List<String> completedActivityIds = new ArrayList<>();
        List<HistoricActivityInstance> completedActs = historyService.createHistoricActivityInstanceQuery()
                .processInstanceId(instanceId)
                .finished()
                .list();
        for (HistoricActivityInstance act : completedActs) {
            completedActivityIds.add(act.getActivityId());
        }

        // 获取当前活跃节点ID
        List<String> activeActivityIds = new ArrayList<>();
        if (processInstance != null)
        {
            activeActivityIds = runtimeService.getActiveActivityIds(instanceId);
        }

        // 合并所有需高亮的节点
        Set<String> allHighlighted = new HashSet<>();
        allHighlighted.addAll(completedActivityIds);
        allHighlighted.addAll(activeActivityIds);

        // 生成高亮流程图
        try
        {
            DefaultProcessDiagramGenerator generator = new DefaultProcessDiagramGenerator();
            InputStream is = generator.generateDiagram(
                    bpmnModel, "png", new ArrayList<>(allHighlighted), new ArrayList<>(),
                    "宋体", "宋体", "宋体", null, 1.0,
                    true);
            byte[] bytes = is.readAllBytes();
            is.close();
            return Base64.getEncoder().encodeToString(bytes);
        }
        catch (Exception e)
        {
            throw new RuntimeException("生成流程图失败", e);
        }
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
        wi.setStatus(pi.isSuspended() ? "SUSPENDED" : "RUNNING");
        wi.setDeploymentId(pi.getDeploymentId());

        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(pi.getProcessDefinitionId()).singleResult();
        wi.setProcessName(pd != null ? pd.getName() : pi.getName());
        if (pd != null)
        {
            wi.setVersion(pd.getVersion());
        }
        wi.setBusinessType((String) runtimeService.getVariable(pi.getId(), "businessType"));
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
        ProcessDefinition pd2 = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(hpi.getProcessDefinitionId()).singleResult();
        wi.setProcessName(pd2 != null ? pd2.getName() : hpi.getName());
        wi.setBusinessKey(hpi.getBusinessKey());
        wi.setStartUserId(hpi.getStartUserId());
        wi.setStartTime(hpi.getStartTime());
        wi.setEndTime(hpi.getEndTime());
        wi.setStatus("COMPLETED");
        wi.setDeploymentId(hpi.getDeploymentId());
        HistoricVariableInstance btVar = (HistoricVariableInstance) historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(hpi.getId()).variableName("businessType").singleResult();
        wi.setBusinessType(btVar != null ? (String) btVar.getValue() : null);
        return wi;
    }
}
