package com.ruoyi.workflow.service;

import java.util.List;
import java.util.Map;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.domain.vo.HistoryEvent;

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
     * 获取审批历史
     */
    List<HistoryEvent> getHistoryList(String instanceId);

    /**
     * 业务方主动启动流程
     * @param businessCode 业务 Code（即 serviceBeanName，对应 WorkflowBusinessHandler 实现类的 Spring Bean 名称）
     * @param businessId 业务主键
     * @param variables 流程变量
     */
    void startProcess(String businessCode, String businessId, Map<String, Object> variables);

    /**
     * 通用查询业务数据（供待办/已办查看详情使用）
     * @param businessCode 业务 Code
     * @param businessId 业务主键
     * @return 业务数据对象
     */
    Object loadBusinessData(String businessCode, String businessId);
}
