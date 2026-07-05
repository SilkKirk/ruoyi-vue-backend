package com.ruoyi.workflow.common;

/**
 * 流程变量名称常量
 * 统一管理 Flowable 流程变量名，避免魔术字符串散落各处
 */
public final class FlowableProcessConstants {

    private FlowableProcessConstants() {
        // 工具类，禁止实例化
    }

    /** 审批结果（0=通过, 1=驳回），process 级别变量，供排他网关条件 ${approved == 0} / ${approved == 1} 使用 */
    public static final String APPROVED_VAR = "approved";

    /** 业务 Code（即 serviceBeanName），process 级别变量，标识该流程实例对应的业务类型 */
    public static final String BUSINESS_CODE_VAR = "businessCode";

    /** 流程发起人登录名，process 级别变量，供 Assignee 表达式 ${initiator} 使用 */
    public static final String INITIATOR_VAR = "initiator";

    /** 审批意见文本，task 级别变量（历史记录用） */
    public static final String COMMENT_VAR = "comment";

    /** 流程定义/实例 挂起状态值 */
    public static final int SUSPEND_STATE = 1;

    /** 流程定义/实例 激活状态值 */
    public static final int ACTIVE_STATE = 2;

    // ========== 业务实体流程状态 ==========

    /** 未提交（草稿） */
    public static final String STATUS_DRAFT = "0";

    /** 审批中 */
    public static final String STATUS_IN_PROGRESS = "1";

    /** 驳回 */
    public static final String STATUS_REJECTED = "2";

    /** 通过 */
    public static final String STATUS_APPROVED = "3";

    // ========== 配置启用状态 ==========

    /** 业务配置启用 */
    public static final String CONFIG_STATUS_ENABLED = "1";

    // ========== 任务状态 ==========

    /** 任务-委派 */
    public static final String TASK_DELEGATED = "Delegated";
    /** 任务-已签收 */
    public static final String TASK_ASSIGNED = "Assigned";
    /** 任务-待签收 */
    public static final String TASK_CREATED = "Created";
    /** 任务-驳回 */
    public static final String TASK_REJECTED = "Rejected";
    /** 任务-已完成 */
    public static final String TASK_COMPLETED = "Completed";

    // ========== 实例状态 ==========

    /** 实例-运行中 */
    public static final String INSTANCE_RUNNING = "RUNNING";
    /** 实例-已完成 */
    public static final String INSTANCE_COMPLETED = "COMPLETED";
    /** 实例-已挂起 */
    public static final String INSTANCE_SUSPENDED = "SUSPENDED";
}
