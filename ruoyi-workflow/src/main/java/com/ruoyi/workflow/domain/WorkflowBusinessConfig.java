package com.ruoyi.workflow.domain;

import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.Table;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Table("workflow_business_config")
public class WorkflowBusinessConfig extends BaseEntity {
    @Id
    private String id;
    private String processDefinitionKey;
    private String businessName;
    private String detailRoute;
    private String serviceBeanName;
    private String status;
}
