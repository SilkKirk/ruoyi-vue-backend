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
import org.flowable.task.api.Task;
import org.flowable.task.api.history.HistoricTaskInstanceQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.handler.WorkflowBusinessHandler;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import cn.hutool.core.util.StrUtil;

/**
 * 流程任务 服务层实现
 *
 * @author ruoyi
 */
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
        List<HistoricTaskInstance> taskList = histQuery
                .orderByHistoricTaskInstanceEndTime().desc()
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        org.flowable.task.api.history.HistoricTaskInstanceQuery histCountQuery = historyService.createHistoricTaskInstanceQuery()
                .taskAssignee(username)
                .finished();
        if (StrUtil.isNotBlank(task.getTaskName()))
        {
            histCountQuery.taskNameLike("%" + task.getTaskName() + "%");
        }
        long count = histCountQuery.count();

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
        // 获取任务信息（记录业务key用于后续更新）
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        String businessKey = null;
        String procInstId = null;
        if (task != null) {
            procInstId = task.getProcessInstanceId();
            ProcessInstance pi = runtimeService.createProcessInstanceQuery()
                    .processInstanceId(procInstId).singleResult();
            if (pi != null) businessKey = pi.getBusinessKey();
        }

        if (StrUtil.isNotBlank(comment))
        {
            if (variables != null)
            {
                variables.put("comment", comment);
                variables.put("approved", true);
            }
        }

        // 将审批相关变量存为任务级别（task-local），每个任务独立保留
        if (variables != null)
        {
            for (Map.Entry<String, Object> entry : variables.entrySet())
            {
                taskService.setVariableLocal(taskId, entry.getKey(), entry.getValue());
            }
        }

        taskService.complete(taskId);

        // 检查流程是否已结束，通过Handler回调更新业务状态
        if (procInstId != null && businessKey != null) {
            long runningCount = runtimeService.createProcessInstanceQuery()
                    .processInstanceId(procInstId).count();
            if (runningCount == 0) {
                String businessType = (String) historyService.createHistoricVariableInstanceQuery()
                        .processInstanceId(procInstId).variableName("businessType").singleResult().getValue();
                if (businessType != null) {
                    WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessType);
                    Object businessData = handler.loadBusinessData(businessKey);
                    if (businessData != null) {
                        // 从最后完成的任务中读取审批结果（任务级别变量）
                        List<HistoricTaskInstance> doneTasks = historyService.createHistoricTaskInstanceQuery()
                                .processInstanceId(procInstId).finished()
                                .orderByHistoricTaskInstanceEndTime().desc()
                                .listPage(0, 1);
                        boolean approved = false;
                        if (!doneTasks.isEmpty()) {
                            HistoricVariableInstance v = historyService.createHistoricVariableInstanceQuery()
                                    .taskId(doneTasks.get(0).getId()).variableName("approved").singleResult();
                            approved = v != null && Boolean.TRUE.equals(v.getValue());
                        }
                        handler.onProcessCompleted(businessData, procInstId, approved);
                    }
                }
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitForApproval(String businessType, String businessId, Map<String, Object> variables) {
        WorkflowBusinessHandler handler = handlerRegistry.getHandler(businessType);
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionKey(handler.getProcessDefinitionKey())
                .latestVersion()
                .singleResult();
        if (pd == null) {
            throw new RuntimeException("未找到流程定义: " + handler.getProcessDefinitionKey());
        }
        // 设置流程变量
        Map<String, Object> vars = variables != null ? variables : new HashMap<>();
        vars.put("businessType", businessType);
        // 设置流程发起人（确保 Flowable 记录 startUserId）
        String loginUsername = SecurityUtils.getUsername();
        if (StrUtil.isNotBlank(loginUsername)) {
            Authentication.setAuthenticatedUserId(loginUsername);
        }
        // 启动流程
        ProcessInstance pi = runtimeService.startProcessInstanceById(pd.getId(), businessId, vars);
        // 回调处理器
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
        // 获取当前任务
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (task == null)
        {
            throw new RuntimeException("任务不存在");
        }

        // 获取流程实例
        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        if (processInstance == null)
        {
            throw new RuntimeException("流程实例不存在");
        }

        // 设置审批意见（任务级别变量）
        taskService.setVariableLocal(taskId, "comment", comment);
        taskService.setVariableLocal(taskId, "approved", false);

        // 获取历史活动节点，找到上一个用户任务节点
        List<HistoricActivityInstance> historyList = historyService.createHistoricActivityInstanceQuery()
                .processInstanceId(task.getProcessInstanceId())
                .activityType("userTask")
                .finished()
                .orderByHistoricActivityInstanceEndTime().desc()
                .list();

        if (historyList.size() < 2)
        {
            throw new RuntimeException("没有可驳回的上一个节点");
        }

        // 取倒数第二个（当前正在审批的是最后一个）
        HistoricActivityInstance lastUserTask = null;
        for (HistoricActivityInstance act : historyList)
        {
            // 找到当前任务之前的最后一个已完成用户任务
            if (!act.getActivityId().equals(task.getTaskDefinitionKey()))
            {
                lastUserTask = act;
                break;
            }
        }

        if (lastUserTask == null)
        {
            throw new RuntimeException("没有可驳回的上一个节点");
        }

        // 驳回：修改流程实例，跳转到目标节点
        runtimeService.createChangeActivityStateBuilder()
                .processInstanceId(task.getProcessInstanceId())
                .moveActivityIdTo(task.getTaskDefinitionKey(), lastUserTask.getActivityId())
                .changeState();
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

        // 查询流程实例（开始/结束时间）
        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();

        // 流程开始事件
        if (hpi != null) {
            // 查询发起人名称（优先用 initiator 流程变量）
            String initiatorUserId = hpi.getStartUserId();
            HistoricVariableInstance initVar = historyService.createHistoricVariableInstanceQuery()
                    .processInstanceId(instanceId).variableName("initiator").singleResult();
            if (initVar != null) {
                initiatorUserId = (String) initVar.getValue();
            }
            // 查询发起人的昵称和部门
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
            Map<String, Object> startEvent = new HashMap<>();
            startEvent.put("taskName", "流程发起");
            startEvent.put("assignee", initiatorUserId);
            startEvent.put("assigneeName", initiatorName);
            startEvent.put("assigneeDeptName", initiatorDept);
            startEvent.put("startTime", hpi.getStartTime());
            startEvent.put("endTime", hpi.getStartTime());
            startEvent.put("comment", "");
            startEvent.put("type", "start");
            result.add(startEvent);
        }

        // 查询各任务级别的变量（comment/approved 每个任务独立保留）
        Map<String, Map<String, Object>> taskVars = new HashMap<>();
        for (HistoricVariableInstance v : historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(instanceId).list()) {
            if (v.getTaskId() != null) {
                taskVars.computeIfAbsent(v.getTaskId(), k -> new HashMap<>())
                        .put(v.getVariableName(), v.getValue());
            }
        }

        // 审批节点
        List<HistoricTaskInstance> list = historyService.createHistoricTaskInstanceQuery()
                .processInstanceId(instanceId)
                .orderByHistoricTaskInstanceStartTime().asc()
                .list();
        for (HistoricTaskInstance hti : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("taskName", hti.getName());
            item.put("assignee", hti.getAssignee());
            // 查询审批人昵称和部门
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
            item.put("comment", vars != null ? vars.getOrDefault("comment", "") : "");
            item.put("approved", vars != null ? vars.get("approved") : null);
            result.add(item);
        }

        // 流程结束事件
        if (hpi != null && hpi.getEndTime() != null) {
            Map<String, Object> endEvent = new HashMap<>();
            endEvent.put("taskName", "流程结束");
            endEvent.put("assignee", "");
            endEvent.put("startTime", hpi.getEndTime());
            endEvent.put("endTime", hpi.getEndTime());
            endEvent.put("comment", "");
            endEvent.put("type", "end");
            result.add(endEvent);
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
            String bt = (String) runtimeService.getVariable(pi.getId(), "businessType");
            wt.setBusinessType(bt);
            try {
                WorkflowBusinessHandler h = handlerRegistry.getHandler(bt);
                wt.setDetailRoute(h.getDetailRoute());
                wt.setBusinessSummary(h.getBusinessSummary(h.loadBusinessData(wt.getBusinessKey())));
            } catch (Exception e) {}
        }
        return wt;
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

        // 获取业务Key和流程状态
        HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                .processInstanceId(task.getProcessInstanceId()).singleResult();
        if (hpi != null) {
            wt.setBusinessKey(hpi.getBusinessKey());
            wt.setProcessStatus(hpi.getEndTime() != null ? "COMPLETED" : "RUNNING");
            HistoricVariableInstance btVar = (HistoricVariableInstance) historyService.createHistoricVariableInstanceQuery()
                    .processInstanceId(task.getProcessInstanceId()).variableName("businessType").singleResult();
            wt.setBusinessType(btVar != null ? (String) btVar.getValue() : null);
            if (btVar != null) {
                try {
                    WorkflowBusinessHandler h = handlerRegistry.getHandler((String) btVar.getValue());
                    wt.setDetailRoute(h.getDetailRoute());
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

}
