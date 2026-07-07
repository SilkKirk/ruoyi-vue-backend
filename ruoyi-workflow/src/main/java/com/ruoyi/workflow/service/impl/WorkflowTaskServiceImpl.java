package com.ruoyi.workflow.service.impl;

import java.util.*;
import java.util.stream.Collectors;

import org.flowable.engine.HistoryService;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.TaskService;
import org.flowable.common.engine.impl.identity.Authentication;
import org.flowable.engine.history.HistoricProcessInstance;
import org.flowable.variable.api.history.HistoricVariableInstance;
import org.flowable.task.api.history.HistoricTaskInstance;
import org.flowable.engine.repository.ProcessDefinition;
import org.flowable.engine.runtime.ProcessInstance;
import org.flowable.task.api.DelegationState;
import org.flowable.task.api.Task;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.common.enums.FlowComment;
import com.ruoyi.workflow.common.utils.UserInfoHelper;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.domain.vo.HistoryEvent;
import com.ruoyi.workflow.handler.WorkflowBusinessHandler;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 流程任务 服务层实现
 *
 * @author ruoyi
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkflowTaskServiceImpl implements IWorkflowTaskService
{
    private final TaskService taskService;

    private final RuntimeService runtimeService;

    private final RepositoryService repositoryService;

    private final HistoryService historyService;

    private final WorkflowBusinessHandlerRegistry handlerRegistry;

    private final UserInfoHelper userInfoHelper;

    @Override
    public Page<WorkflowTask> selectTodoList(Page<WorkflowTask> page, WorkflowTask task)
    {
        String username = SecurityUtils.getUsername();

        org.flowable.task.api.TaskQuery query = createTodoQuery(username, task.getTaskName())
                .orderByTaskCreateTime().desc();
        List<Task> taskList = query
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        long count = query.count();

        List<WorkflowTask> resultList = taskList.stream()
                .map(this::convertTaskToWorkflowTask)
                .collect(Collectors.toList());

        page.setRecords(resultList);
        page.setTotalRow(count);
        return page;
    }

    @Override
    public Page<WorkflowTask> selectDoneList(Page<WorkflowTask> page, WorkflowTask task)
    {
        String username = SecurityUtils.getUsername();

        org.flowable.task.api.history.HistoricTaskInstanceQuery histQuery = createDoneQuery(username, task.getTaskName());

        // 查询全部已办任务，按完成时间倒序
        List<HistoricTaskInstance> allList = histQuery
                .orderByHistoricTaskInstanceEndTime().desc()
                .list();

        // 按流程实例去重：同一流程在已办列表只展示最新一条
        Map<String, HistoricTaskInstance> dedupMap = new LinkedHashMap<>();
        for (HistoricTaskInstance hti : allList) {
            dedupMap.putIfAbsent(hti.getProcessInstanceId(), hti);
        }
        List<HistoricTaskInstance> taskList = new ArrayList<>(dedupMap.values());

        // 手动分页（去重后无法依赖 Flowable 原生分页）
        long count = taskList.size();
        taskList = CollUtil.page((int)page.getPageNumber() - 1, (int)page.getPageSize(), taskList);

        List<WorkflowTask> resultList = taskList.stream()
                .map(this::convertHistoricTaskToWorkflowTask)
                .collect(Collectors.toList());

        page.setRecords(resultList);
        page.setTotalRow(count);
        return page;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void completeTask(String taskId, Map<String, Object> variables, String comment)
    {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        String businessKey = null;
        String procInstId = null;
        if (task != null) {
            procInstId = task.getProcessInstanceId();
            ProcessInstance pi = runtimeService.createProcessInstanceQuery()
                    .processInstanceId(procInstId).singleResult();
            if (pi != null) businessKey = pi.getBusinessKey();
        }

        // 保存传入变量的快照（process 级别：approved 等），供流程结束回调使用
        Map<String, Object> processVars = variables != null ? new HashMap<>(variables) : new HashMap<>();

        if (StrUtil.isNotBlank(comment))
        {
            // 通过意见存为 Flowable 原生评论（type="0" 对齐 approved=0）
            if (procInstId != null) {
                taskService.addComment(taskId, procInstId,
                        FlowComment.NORMAL.getType(), comment);
            }
            processVars.put(FlowableProcessConstants.COMMENT_VAR, comment);
        }

        if (variables != null)
        {
            String pid = procInstId;
            variables.forEach((key, value) ->
            {
                if (FlowableProcessConstants.APPROVED_VAR.equals(key))
                {
                    runtimeService.setVariable(pid, key, value);
                }
                else
                {
                    taskService.setVariableLocal(taskId, key, value);
                }
            });
        }

        taskService.complete(taskId);

        handleProcessCompletion(procInstId, businessKey, processVars);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void startProcess(String businessCode, String businessId, Map<String, Object> variables) {
        WorkflowBusinessConfig config = handlerRegistry.getConfig(businessCode);
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionKey(config.getProcessDefinitionKey())
                .latestVersion()
                .singleResult();
        if (pd == null) {
            throw new RuntimeException("未找到流程定义: " + config.getProcessDefinitionKey());
        }
        Map<String, Object> vars = variables != null ? new HashMap<>(variables) : new HashMap<>();
        vars.put(FlowableProcessConstants.BUSINESS_CODE_VAR, businessCode);
        String loginUsername = SecurityUtils.getUsername();
        if (StrUtil.isNotBlank(loginUsername)) {
            Authentication.setAuthenticatedUserId(loginUsername);
            vars.put(FlowableProcessConstants.INITIATOR_VAR, loginUsername);
        }
        ProcessInstance pi = runtimeService.startProcessInstanceById(pd.getId(), businessId, vars);
        WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessCode);
        Object businessData = handler.loadBusinessData(businessId);
        if (businessData != null) {
            handler.onProcessStarted(businessData, pi.getId());
        }
    }

    @Override
    public Object loadBusinessData(String businessCode, String businessId) {
        WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessCode);
        return handler.loadBusinessData(businessId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectTask(String taskId, String comment)
    {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (task == null) {
            throw new RuntimeException("任务不存在");
        }

        // 驳回意见存为 Flowable 原生评论（type="1" 对齐 approved=1 / ${approved == 1}）
        taskService.addComment(taskId, task.getProcessInstanceId(),
                FlowComment.REJECT.getType(), comment);

        // approved=1 存 process 级别，供排他网关条件 ${approved == 1} 路由到"修改申请"
        runtimeService.setVariable(task.getProcessInstanceId(), FlowableProcessConstants.APPROVED_VAR, FlowComment.REJECT.getType());

        // 完成任务，网关已消费 approved 变量
        taskService.complete(taskId);

        // 清除 approved，后续流程不残留此变量
        runtimeService.removeVariable(task.getProcessInstanceId(), FlowableProcessConstants.APPROVED_VAR);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void transferTask(String taskId, String userId)
    {
        // 转办：设置新的办理人
        taskService.setAssignee(taskId, userId);
    }

    @Override
    public List<HistoryEvent> getHistoryList(String instanceId) {
        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();

        if (hpi == null) return buildTaskItems(instanceId);

        List<HistoryEvent> result = new ArrayList<>();
        result.add(buildStartEvent(hpi, instanceId));
        result.addAll(buildTaskItems(instanceId));
        if (hpi.getEndTime() != null) {
            result.add(buildEndEvent(hpi));
        }
        return result;
    }

    private org.flowable.task.api.TaskQuery createTodoQuery(String username, String taskName) {
        org.flowable.task.api.TaskQuery query = taskService.createTaskQuery().taskAssignee(username);
        if (StrUtil.isNotBlank(taskName)) {
            query.taskNameLike("%" + taskName + "%");
        }
        return query;
    }

    private org.flowable.task.api.history.HistoricTaskInstanceQuery createDoneQuery(String username, String taskName) {
        org.flowable.task.api.history.HistoricTaskInstanceQuery query = historyService.createHistoricTaskInstanceQuery()
                .taskAssignee(username).finished();
        if (StrUtil.isNotBlank(taskName)) {
            query.taskNameLike("%" + taskName + "%");
        }
        return query;
    }

    private HistoricVariableInstance queryHistoricVar(String processInstanceId, String varName) {
        return historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(processInstanceId).variableName(varName).singleResult();
    }

    /**
     * 转换运行中任务
     */
    private WorkflowTask convertTaskToWorkflowTask(Task task)
    {
        WorkflowTask wt = new WorkflowTask();
        wt.setTaskId(task.getId());
        wt.setTaskName(task.getName());
        wt.setTaskDefKey(task.getTaskDefinitionKey());
        wt.setInstanceId(task.getProcessInstanceId());
        wt.setDefinitionId(task.getProcessDefinitionId());
        wt.setAssignee(task.getAssignee());
        wt.setCreateTime(task.getCreateTime());

        ProcessInstance pi = runtimeService.createProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        String bizKey = null, bizCode = null;
        if (pi != null) {
            bizKey = pi.getBusinessKey();
            bizCode = (String) runtimeService.getVariable(pi.getId(), FlowableProcessConstants.BUSINESS_CODE_VAR);
            wt.setBusinessKey(bizKey);
            wt.setBusinessCode(bizCode);
        }
        populateCommonTaskFields(wt, task.getProcessDefinitionId(), task.getAssignee(), bizKey, bizCode);
        deriveTaskStatus(wt, task);
        return wt;
    }

    private void populateCommonTaskFields(WorkflowTask wt, String processDefId, String assignee, String businessKey, String businessCode) {
        var userInfo = userInfoHelper.getUserInfo(assignee);
        wt.setAssigneeName(userInfo.nickname());
        wt.setDeptName(userInfo.deptName());
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(processDefId).singleResult();
        if (pd != null) wt.setProcessName(pd.getName());
        handlerRegistry.fillTaskBusinessInfo(wt, businessCode, businessKey);
    }

    /**
     * 推导任务状态：Created / Assigned / Delegated / Rejected / Returned
     */
    private void deriveTaskStatus(WorkflowTask wt, Task task) {
        // 基础状态：Delegated / Assigned / Created
        if (DelegationState.PENDING.equals(task.getDelegationState())) {
            wt.setStatus(FlowableProcessConstants.TASK_DELEGATED);
        } else if (task.getAssignee() != null) {
            wt.setStatus(FlowableProcessConstants.TASK_ASSIGNED);
        } else {
            wt.setStatus(FlowableProcessConstants.TASK_CREATED);
        }

        // 检查上一个已完成的任务是否有驳回评论，有则当前任务是由驳回产生的"修改申请"
        try {
            HistoricTaskInstance lastFinished = historyService.createHistoricTaskInstanceQuery()
                    .processInstanceId(task.getProcessInstanceId())
                    .finished()
                    .orderByHistoricTaskInstanceEndTime()
                    .desc()
                    .listPage(0, 1)
                    .stream().findFirst().orElse(null);
            if (lastFinished != null && lastFinished.getId() != null) {
                // 用流程评论查询（ACT_HI_COMMENT 表），按任务 ID 过滤出驳回类型
                boolean hasReject = taskService.getProcessInstanceComments(
                        task.getProcessInstanceId(), FlowComment.REJECT.getType())
                        .stream()
                        .anyMatch(c -> lastFinished.getId().equals(c.getTaskId()));
                if (hasReject) {
                    wt.setStatus(FlowableProcessConstants.TASK_REJECTED);
                }
            }
        } catch (Exception e) {
            log.debug("推导任务状态失败，保留基础状态", e);
        }
    }

    /**
     * 转换历史任务
     */
    private WorkflowTask convertHistoricTaskToWorkflowTask(HistoricTaskInstance task)
    {
        WorkflowTask wt = new WorkflowTask();
        wt.setTaskId(task.getId());
        wt.setTaskName(task.getName());
        wt.setTaskDefKey(task.getTaskDefinitionKey());
        wt.setInstanceId(task.getProcessInstanceId());
        wt.setDefinitionId(task.getProcessDefinitionId());
        wt.setAssignee(task.getAssignee());
        wt.setCreateTime(task.getCreateTime());
        wt.setCompleteTime(task.getEndTime());
        wt.setStatus(FlowableProcessConstants.TASK_COMPLETED);

        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        String bizKey = null, bizCode = null;
        if (hpi != null) {
            bizKey = hpi.getBusinessKey();
            wt.setBusinessKey(bizKey);
            wt.setProcessStatus(hpi.getEndTime() != null ? FlowableProcessConstants.INSTANCE_COMPLETED : FlowableProcessConstants.INSTANCE_RUNNING);
            HistoricVariableInstance btVar = queryHistoricVar(task.getProcessInstanceId(), FlowableProcessConstants.BUSINESS_CODE_VAR);
            if (btVar != null) {
                bizCode = (String) btVar.getValue();
                wt.setBusinessCode(bizCode);
            }
        }
        populateCommonTaskFields(wt, task.getProcessDefinitionId(), task.getAssignee(), bizKey, bizCode);
        return wt;
    }

    /**
     * 流程结束回调：处理流程完成后的业务逻辑
     */
    private void handleProcessCompletion(String procInstId, String businessKey, Map<String, Object> processVars) {
        long runningCount = runtimeService.createProcessInstanceQuery()
                .processInstanceId(procInstId).count();
        if (runningCount == 0) {
            HistoricVariableInstance varInst = queryHistoricVar(procInstId, FlowableProcessConstants.BUSINESS_CODE_VAR);
            String businessCode = varInst != null ? (String) varInst.getValue() : null;
            if (businessCode != null) {
                try {
                    WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessCode);
                    Object businessData = handler.loadBusinessData(businessKey);
                    if (businessData != null) {
                        handler.onProcessCompleted(businessData, procInstId, processVars);
                    }
                } catch (Exception e) {
                    log.warn("流程结束回调失败", e);
                }
            }
        }
    }

    private HistoryEvent buildStartEvent(HistoricProcessInstance hpi, String instanceId) {
        String initiatorUserId = hpi.getStartUserId();
        HistoricVariableInstance initVar = queryHistoricVar(instanceId, FlowableProcessConstants.INITIATOR_VAR);
        if (initVar != null) {
            initiatorUserId = (String) initVar.getValue();
        }
        var info = userInfoHelper.getUserInfo(initiatorUserId);
        return new HistoryEvent(
                "流程发起",
                info.username(),
                info.nickname(),
                info.deptName(),
                hpi.getStartTime(),
                hpi.getStartTime(),
                null,
                "start",
                "",
                null);
    }

    private List<HistoryEvent> buildTaskItems(String instanceId) {
        Map<String, Map<String, Object>> taskVars = new HashMap<>();
        historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(instanceId).list()
                .forEach(v -> {
                    if (v.getTaskId() != null) {
                        taskVars.computeIfAbsent(v.getTaskId(), k -> new HashMap<>())
                                .put(v.getVariableName(), v.getValue());
                    }
                });

        List<HistoricTaskInstance> list = historyService.createHistoricTaskInstanceQuery()
                .processInstanceId(instanceId)
                .orderByHistoricTaskInstanceStartTime().asc()
                .list();
        return list.stream().map(hti -> {
            var info = userInfoHelper.getUserInfo(hti.getAssignee());
            Map<String, Object> vars = taskVars.getOrDefault(hti.getId(), Collections.emptyMap());
            return new HistoryEvent(
                    hti.getName(),
                    info.username(),
                    info.nickname(),
                    info.deptName(),
                    hti.getCreateTime(),
                    hti.getEndTime(),
                    hti.getDurationInMillis(),
                    "task",
                    (String) vars.getOrDefault(FlowableProcessConstants.COMMENT_VAR, ""),
                    (Integer) vars.get(FlowableProcessConstants.APPROVED_VAR));
        }).collect(Collectors.toList());
    }

    /**
     * 构建流程结束事件
     */
    private HistoryEvent buildEndEvent(HistoricProcessInstance hpi) {
        return new HistoryEvent("流程结束", "", null, null,
                hpi.getEndTime(), hpi.getEndTime(), null, "end", "", null);
    }
}
