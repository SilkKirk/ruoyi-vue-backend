package com.ruoyi.workflow.domain;

import java.util.Date;
import com.ruoyi.common.core.domain.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 流程模型视图对象
 *
 * @author ruoyi
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class WorkflowModel extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 模型ID */
    private String modelId;

    /** 模型名称 */
    private String name;

    /** 模型Key */
    private String key;

    /** 模型分类 */
    private String category;

    /** 模型版本 */
    private Integer version;

    /** 模型描述 */
    private String description;

    /** 部署时间 */
    private String deployTime;

    /** 部署ID（已部署时非空） */
    private String deploymentId;

    /** BPMN XML 内容（编辑时使用） */
    private String bpmnXml;
}
