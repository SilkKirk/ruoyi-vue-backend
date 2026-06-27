package com.ruoyi.workflow.domain;

import java.util.Date;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 流程实例视图对象
 *
 * @author ruoyi
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class WorkflowInstance extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 实例ID */
    private String instanceId;

    /** 流程定义ID */
    private String definitionId;

    /** 流程名称 */
    private String processName;

    /** 流程Key */
    private String processKey;

    /** 业务Key */
    private String businessKey;

    /** 发起人 */
    private String startUserId;

    /** 发起人名称 */
    private String startUserName;

    /** 发起时间 */
    private Date startTime;

    /** 结束时间 */
    private Date endTime;

    /** 状态（RUNNING=运行中, SUSPENDED=挂起, COMPLETED=已完成, TERMINATED=已终止） */
    private String status;

    /** 当前活动节点 */
    private String currentActivity;

    /** 部署ID */
    private String deploymentId;

    /** 流程版本 */
    private Integer version;

    /** 业务类型（如 leave） */
    private String businessType;
}
