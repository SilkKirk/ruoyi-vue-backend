package com.ruoyi.workflow.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 流程定义视图对象
 *
 * @author ruoyi
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class WorkflowDefinition extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 定义ID */
    private String definitionId;

    /** 流程名称 */
    private String name;

    /** 流程Key */
    private String key;

    /** 分类 */
    private String category;

    /** 版本 */
    private Integer version;

    /** 描述 */
    private String description;

    /** 部署ID */
    private String deploymentId;

    /** 是否挂起（1=挂起，0=激活） */
    private Integer suspended;

    /** BPMN XML */
    private String bpmnXml;
}
