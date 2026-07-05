package com.ruoyi.workflow.common.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum FlowComment {

    NORMAL("0", "通过"),
    REJECT("1", "驳回");

    private final String type;
    private final String remark;
}
