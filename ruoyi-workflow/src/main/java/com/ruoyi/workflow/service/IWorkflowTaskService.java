package com.ruoyi.workflow.service;

import java.util.List;
import java.util.Map;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowTask;

/**
 * 流程任务 服务层
 *
 * @author ruoyi
 */
public interface IWorkflowTaskService
{
    /**
     * 查询我的待办任务
     */
    Page<WorkflowTask> selectTodoList(Page<WorkflowTask> page, WorkflowTask task);

    /**
     * 查询我的已办任务
     */
    Page<WorkflowTask> selectDoneList(Page<WorkflowTask> page, WorkflowTask task);

    /**
     * 审批通过（complete）
     */
    void completeTask(String taskId, Map<String, Object> variables, String comment);

    /**
     * 驳回任务（退回上一节点）
     */
    void rejectTask(String taskId, String comment);

    /**
     * 转办任务
     */
    void transferTask(String taskId, String userId);

    /**
     * 获取任务流程图跟踪
     */
    String getTaskFlowChart(String taskId);

    /**
     * 获取审批历史
     */
    List<Map<String, Object>> getHistoryList(String instanceId);

    /**
     * 通用提交审批（业务层调用，与流程引擎解耦）
     * @param businessType 业务类型（如 leave）
     * @param businessId 业务主键
     * @param variables 流程变量
     */
    void submitForApproval(String businessType, String businessId, Map<String, Object> variables);

    /**
     * 通用查询业务数据（供待办/已办查看详情使用）
     * @param businessType 业务类型
     * @param businessId 业务主键
     * @return 业务数据对象
     */
    Object loadBusinessData(String businessType, String businessId);
}
