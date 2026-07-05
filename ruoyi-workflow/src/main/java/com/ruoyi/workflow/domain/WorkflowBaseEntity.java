package com.ruoyi.workflow.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 工作流业务实体基类
 * 所有接入工作流的业务实体继承此类，基类自动提供 status、processInstanceId
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class WorkflowBaseEntity extends BaseEntity {
    private String status;
    private String processInstanceId;
}
