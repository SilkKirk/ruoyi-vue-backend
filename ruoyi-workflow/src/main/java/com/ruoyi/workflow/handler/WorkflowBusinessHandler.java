package com.ruoyi.workflow.handler;

import java.util.Map;

/**
 * 工作流业务处理器接口
 * 每种业务（请假、报销等）实现此接口，与工作流引擎解耦
 * 配置信息（流程定义Key、详情路由等）存储在 workflow_business_config 表中
 */
public interface WorkflowBusinessHandler {

    /** 根据业务 ID 加载业务数据 */
    Object loadBusinessData(String businessId);

    /** 流程启动回调 */
    default void onProcessStarted(Object businessData, String processInstanceId) {}

    /**
     * 流程结束回调
     * @param processVariables 流程结束时的变量快照，包含 approved、businessType 等
     */
    void onProcessCompleted(Object businessData, String processInstanceId, Map<String, Object> processVariables);

    /** 业务摘要（用于待办列表显示），如 "张三的请假申请" */
    default String getBusinessSummary(Object businessData) { return ""; }
}
