package com.ruoyi.workflow.common.enums;

/**
 * 流程意见类型
 */
public enum FlowComment {

    /** 通过 (0 与 approved=0 / BPMN 条件 ${approved == 0} 一致) */
    NORMAL("0", "通过"),

    /** 驳回 (1 与 approved=1 / BPMN 条件 ${approved == 1} 一致) */
    REJECT("1", "驳回");

    private final String type;
    private final String remark;

    FlowComment(String type, String remark) {
        this.type = type;
        this.remark = remark;
    }

    public String getType() {
        return type;
    }

    public String getRemark() {
        return remark;
    }
}
