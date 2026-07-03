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

    /** 业务类型标识（如 leave、expense），process 级别变量 */
    public static final String BUSINESS_TYPE_VAR = "businessType";

    /** 流程发起人登录名，process 级别变量，供 Assignee 表达式 ${initiator} 使用 */
    public static final String INITIATOR_VAR = "initiator";

    /** 审批意见文本，task 级别变量（历史记录用） */
    public static final String COMMENT_VAR = "comment";
}
