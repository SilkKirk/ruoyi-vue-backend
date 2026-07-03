package com.ruoyi.workflow.service.impl;

import java.io.InputStream;
import java.util.*;
import java.util.stream.Collectors;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.engine.HistoryService;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.TaskService;
import org.flowable.common.engine.impl.identity.Authentication;
import org.flowable.engine.history.HistoricActivityInstance;
import org.flowable.engine.history.HistoricProcessInstance;
import org.flowable.variable.api.history.HistoricVariableInstance;
import org.flowable.task.api.history.HistoricTaskInstance;
import org.flowable.engine.repository.ProcessDefinition;
import org.flowable.engine.runtime.ProcessInstance;
import org.flowable.engine.ProcessEngine;
import org.flowable.image.ProcessDiagramGenerator;
import org.flowable.engine.task.Comment;
import org.flowable.task.api.DelegationState;
import org.flowable.task.api.Task;
import org.flowable.task.api.history.HistoricTaskInstanceQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.common.enums.FlowComment;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.handler.WorkflowBusinessHandler;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import cn.hutool.core.util.StrUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * 流程任务 服务层实现
 *
 * @author ruoyi
 */
@Slf4j
@Service
public class WorkflowTaskServiceImpl implements IWorkflowTaskService
{
    @Autowired
    private TaskService taskService;

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private HistoryService historyService;

    @Autowired
    private WorkflowBusinessHandlerRegistry handlerRegistry;

    @Autowired
    private ProcessEngine processEngine;

    @Autowired
    private ISysUserService sysUserService;

    @Override
    public Page<WorkflowTask> selectTodoList(Page<WorkflowTask> page, WorkflowTask task)
    {
        String username = SecurityUtils.getUsername();

        org.flowable.task.api.TaskQuery taskQuery = taskService.createTaskQuery()
                .taskAssignee(username);
        if (StrUtil.isNotBlank(task.getTaskName()))
        {
            taskQuery.taskNameLike("%" + task.getTaskName() + "%");
        }
        List<Task> taskList = taskQuery
                .orderByTaskCreateTime().desc()
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        org.flowable.task.api.TaskQuery countQuery = taskService.createTaskQuery()
                .taskAssignee(username);
        if (StrUtil.isNotBlank(task.getTaskName()))
        {
            countQuery.taskNameLike("%" + task.getTaskName() + "%");
        }
        long count = countQuery.count();

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

        org.flowable.task.api.history.HistoricTaskInstanceQuery histQuery = historyService.createHistoricTaskInstanceQuery()
                .taskAssignee(username)
                .finished();
        if (StrUtil.isNotBlank(task.getTaskName()))
        {
            histQuery.taskNameLike("%" + task.getTaskName() + "%");
        }

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
        int fromIndex = Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize());
        int toIndex = Math.min(fromIndex + Math.toIntExact(page.getPageSize()), taskList.size());
        if (fromIndex < taskList.size()) {
            taskList = taskList.subList(fromIndex, toIndex);
        } else {
            taskList = Collections.emptyList();
        }

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
        final Map<String, Object> processVars = new HashMap<>();
        if (variables != null)
        {
            processVars.putAll(variables);
        }

        if (StrUtil.isNotBlank(comment))
        {
            // 通过意见存为 Flowable 原生评论（type="0" 对齐 approved=0）
            if (task != null) {
                taskService.addComment(taskId, task.getProcessInstanceId(),
                        FlowComment.NORMAL.getType(), comment);
            }
            processVars.put(FlowableProcessConstants.COMMENT_VAR, comment);
        }

        if (variables != null)
        {
            for (Map.Entry<String, Object> entry : variables.entrySet())
            {
                if (FlowableProcessConstants.APPROVED_VAR.equals(entry.getKey()))
                {
                    // approved 设为 process 级别变量，供网关条件判断
                    runtimeService.setVariable(procInstId, entry.getKey(), entry.getValue());
                }
                else
                {
                    taskService.setVariableLocal(taskId, entry.getKey(), entry.getValue());
                }
            }
        }

        taskService.complete(taskId);

        handleProcessCompletion(procInstId, businessKey, processVars);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitForApproval(String businessType, String businessId, Map<String, Object> variables) {
        WorkflowBusinessConfig config = handlerRegistry.getConfig(businessType);
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionKey(config.getProcessDefinitionKey())
                .latestVersion()
                .singleResult();
        if (pd == null) {
            throw new RuntimeException("未找到流程定义: " + config.getProcessDefinitionKey());
        }
        // 设置流程变量
        Map<String, Object> vars = variables != null ? variables : new HashMap<>();
        vars.put(FlowableProcessConstants.BUSINESS_TYPE_VAR, businessType);
        // 设置流程发起人（存入流程变量供排他网关/Assignee表达式使用）
        String loginUsername = SecurityUtils.getUsername();
        if (StrUtil.isNotBlank(loginUsername)) {
            Authentication.setAuthenticatedUserId(loginUsername);
            vars.put(FlowableProcessConstants.INITIATOR_VAR, loginUsername);
        }
        // 启动流程
        ProcessInstance pi = runtimeService.startProcessInstanceById(pd.getId(), businessId, vars);
        // 回调处理器
        WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessType);
        Object businessData = handler.loadBusinessData(businessId);
        if (businessData != null) {
            handler.onProcessStarted(businessData, pi.getId());
        }
    }

    @Override
    public Object loadBusinessData(String businessType, String businessId) {
        WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessType);
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
        runtimeService.setVariable(task.getProcessInstanceId(), FlowableProcessConstants.APPROVED_VAR, 1);

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
    public List<Map<String, Object>> getHistoryList(String instanceId) {
        List<Map<String, Object>> result = new ArrayList<>();

        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();

        if (hpi != null) {
            Map<String, Object> startEvent = buildStartEvent(hpi, instanceId);
            if (startEvent != null) {
                result.add(startEvent);
            }
        }

        result.addAll(buildTaskItems(instanceId));

        if (hpi != null && hpi.getEndTime() != null) {
            result.add(buildEndEvent(hpi));
        }
        return result;
    }

    @Override
    public String getTaskFlowChart(String taskId)
    {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (task == null)
        {
            return null;
        }

        String instanceId = task.getProcessInstanceId();
        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();

        String definitionId = processInstance != null
                ? processInstance.getProcessDefinitionId()
                : task.getProcessDefinitionId();

        BpmnModel bpmnModel = repositoryService.getBpmnModel(definitionId);
        if (bpmnModel == null)
        {
            return null;
        }

        List<String> activeActivityIds = runtimeService.getActiveActivityIds(instanceId);

        try
        {
            ProcessDiagramGenerator generator = processEngine.getProcessEngineConfiguration().getProcessDiagramGenerator();
            InputStream is = generator.generateDiagram(
                    bpmnModel, "png", activeActivityIds, new ArrayList<>(),
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

        // 补全办理人名称和部门
        fillUserInfo(wt, task.getAssignee());

        // 获取流程名称（从ProcessDefinition）
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(task.getProcessDefinitionId()).singleResult();
        if (pd != null) wt.setProcessName(pd.getName());

        // 获取业务Key
        ProcessInstance pi = runtimeService.createProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        if (pi != null) {
            wt.setBusinessKey(pi.getBusinessKey());
            String bt = (String) runtimeService.getVariable(pi.getId(), FlowableProcessConstants.BUSINESS_TYPE_VAR);
            wt.setBusinessType(bt);
            try {
                WorkflowBusinessConfig cfg = handlerRegistry.getConfig(bt);
                wt.setDetailRoute(cfg.getDetailRoute());
                WorkflowBusinessHandler h = handlerRegistry.getHandler(bt);
                wt.setBusinessSummary(h.getBusinessSummary(h.loadBusinessData(wt.getBusinessKey())));
            } catch (Exception e) {}
        }

        // ----- 推导任务状态 -----
        deriveTaskStatus(wt, task);
        return wt;
    }

    /**
     * 推导任务状态：Created / Assigned / Delegated / Rejected / Returned
     */
    private void deriveTaskStatus(WorkflowTask wt, Task task) {
        // 基础状态：Delegated / Assigned / Created
        if (DelegationState.PENDING.equals(task.getDelegationState())) {
            wt.setStatus("Delegated");
        } else if (task.getAssignee() != null) {
            wt.setStatus("Assigned");
        } else {
            wt.setStatus("Created");
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
                    wt.setStatus("Rejected");
                }
            }
        } catch (Exception e) {
            // 静默，保留基础状态
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

        // 补全办理人名称和部门
        fillUserInfo(wt, task.getAssignee());

        // 获取流程名称（从ProcessDefinition）
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(task.getProcessDefinitionId()).singleResult();
        if (pd != null) wt.setProcessName(pd.getName());

        // 已办任务状态固定为 Completed
        wt.setStatus("Completed");

        // 获取业务Key和流程状态
        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        if (hpi != null) {
            wt.setBusinessKey(hpi.getBusinessKey());
            wt.setProcessStatus(hpi.getEndTime() != null ? "COMPLETED" : "RUNNING");
            HistoricVariableInstance btVar = (HistoricVariableInstance) historyService.createHistoricVariableInstanceQuery()
                    .processInstanceId(task.getProcessInstanceId()).variableName(FlowableProcessConstants.BUSINESS_TYPE_VAR).singleResult();
            wt.setBusinessType(btVar != null ? (String) btVar.getValue() : null);
            if (btVar != null) {
                try {
                    String bt = (String) btVar.getValue();
                    WorkflowBusinessConfig cfg = handlerRegistry.getConfig(bt);
                    wt.setDetailRoute(cfg.getDetailRoute());
                    WorkflowBusinessHandler h = handlerRegistry.getHandler(bt);
                    wt.setBusinessSummary(h.getBusinessSummary(h.loadBusinessData(wt.getBusinessKey())));
                } catch (Exception e) {}
            }
        }
        return wt;
    }

    /**
     * 根据用户名补全用户昵称和部门名称
     */
    private void fillUserInfo(WorkflowTask wt, String username) {
        if (StrUtil.isBlank(username)) return;
        SysUser user = sysUserService.selectUserByUserName(username);
        if (user != null) {
            wt.setAssigneeName(user.getNickName());
            if (user.getDept() != null) {
                wt.setDeptName(user.getDept().getDeptName());
            }
        }
    }

    /**
     * 流程结束回调：处理流程完成后的业务逻辑
     */
    private void handleProcessCompletion(String procInstId, String businessKey, Map<String, Object> processVars) {
        long runningCount = runtimeService.createProcessInstanceQuery()
                .processInstanceId(procInstId).count();
        if (runningCount == 0) {
            String businessType = (String) historyService.createHistoricVariableInstanceQuery()
                    .processInstanceId(procInstId).variableName(FlowableProcessConstants.BUSINESS_TYPE_VAR).singleResult().getValue();
            if (businessType != null) {
                try {
                    WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessType);
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

    /**
     * 构建流程开始事件
     */
    private Map<String, Object> buildStartEvent(HistoricProcessInstance hpi, String instanceId) {
        String initiatorUserId = hpi.getStartUserId();
        HistoricVariableInstance initVar = historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(instanceId).variableName(FlowableProcessConstants.INITIATOR_VAR).singleResult();
        if (initVar != null) {
            initiatorUserId = (String) initVar.getValue();
        }
        String initiatorName = initiatorUserId;
        String initiatorDept = "";
        if (StrUtil.isNotBlank(initiatorUserId)) {
            SysUser initUser = sysUserService.selectUserByUserName(initiatorUserId);
            if (initUser != null) {
                initiatorName = initUser.getNickName();
                if (initUser.getDept() != null) {
                    initiatorDept = initUser.getDept().getDeptName();
                }
            }
        }
        Map<String, Object> event = new HashMap<>();
        event.put("taskName", "流程发起");
        event.put("assignee", initiatorUserId);
        event.put("assigneeName", initiatorName);
        event.put("assigneeDeptName", initiatorDept);
        event.put("startTime", hpi.getStartTime());
        event.put("endTime", hpi.getStartTime());
        event.put("comment", "");
        event.put("type", "start");
        return event;
    }

    /**
     * 构建审批节点列表
     */
    private List<Map<String, Object>> buildTaskItems(String instanceId) {
        // 查询各任务级别的变量
        Map<String, Map<String, Object>> taskVars = new HashMap<>();
        for (HistoricVariableInstance v : historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(instanceId).list()) {
            if (v.getTaskId() != null) {
                taskVars.computeIfAbsent(v.getTaskId(), k -> new HashMap<>())
                        .put(v.getVariableName(), v.getValue());
            }
        }

        List<Map<String, Object>> items = new ArrayList<>();
        List<HistoricTaskInstance> list = historyService.createHistoricTaskInstanceQuery()
                .processInstanceId(instanceId)
                .orderByHistoricTaskInstanceStartTime().asc()
                .list();
        for (HistoricTaskInstance hti : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("taskName", hti.getName());
            item.put("assignee", hti.getAssignee());
            String assigneeName = hti.getAssignee();
            String assigneeDept = "";
            if (StrUtil.isNotBlank(hti.getAssignee())) {
                SysUser usr = sysUserService.selectUserByUserName(hti.getAssignee());
                if (usr != null) {
                    assigneeName = usr.getNickName();
                    if (usr.getDept() != null) {
                        assigneeDept = usr.getDept().getDeptName();
                    }
                }
            }
            item.put("assigneeName", assigneeName);
            item.put("assigneeDeptName", assigneeDept);
            item.put("startTime", hti.getCreateTime());
            item.put("endTime", hti.getEndTime());
            item.put("duration", hti.getDurationInMillis());
            item.put("type", "task");
            Map<String, Object> vars = taskVars.get(hti.getId());
            item.put(FlowableProcessConstants.COMMENT_VAR, vars != null ? vars.getOrDefault(FlowableProcessConstants.COMMENT_VAR, "") : "");
            item.put(FlowableProcessConstants.APPROVED_VAR, vars != null ? vars.get(FlowableProcessConstants.APPROVED_VAR) : null);
            items.add(item);
        }
        return items;
    }

    /**
     * 构建流程结束事件
     */
    private Map<String, Object> buildEndEvent(HistoricProcessInstance hpi) {
        Map<String, Object> event = new HashMap<>();
        event.put("taskName", "流程结束");
        event.put("assignee", "");
        event.put("startTime", hpi.getEndTime());
        event.put("endTime", hpi.getEndTime());
        event.put("comment", "");
        event.put("type", "end");
        return event;
    }
}
