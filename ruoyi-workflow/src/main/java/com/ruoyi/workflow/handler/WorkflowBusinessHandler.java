package com.ruoyi.workflow.handler;

/**
 * 工作流业务处理器接口
 * 每种业务（请假、报销等）实现此接口，与工作流引擎解耦
 */
public interface WorkflowBusinessHandler {

    /** 业务类型标识，如 "leave" */
    String getBusinessType();

    /** 对应的流程定义 Key */
    String getProcessDefinitionKey();

    /** 根据业务 ID 加载业务数据 */
    Object loadBusinessData(String businessId);

    /** 流程启动回调 */
    default void onProcessStarted(Object businessData, String processInstanceId) {}

    /** 流程结束回调 */
    void onProcessCompleted(Object businessData, String processInstanceId, boolean approved);

    /** 业务详情前端路由路径，如 /workflow/leave/detail/ */
    default String getDetailRoute() { return ""; }

    /** 业务摘要（用于待办列表显示），如 "张三的请假申请" */
    default String getBusinessSummary(Object businessData) { return ""; }
}
