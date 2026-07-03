package com.ruoyi.workflow.domain;

import java.util.Date;
import java.util.Map;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 流程任务视图对象
 *
 * @author ruoyi
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class WorkflowTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    private String taskId;

    /** 任务名称 */
    private String taskName;

    /** 任务定义Key */
    private String taskDefKey;

    /** 流程实例ID */
    private String instanceId;

    /** 流程定义ID */
    private String definitionId;

    /** 流程名称 */
    private String processName;

    /** 业务Key */
    private String businessKey;

    /** 任务办理人ID */
    private String assignee;

    /** 任务办理人名称 */
    private String assigneeName;

    /** 任务办理人部门 */
    private String deptName;

    /** 候选人IDs（逗号分隔） */
    private String candidateUsers;

    /** 候选组IDs（逗号分隔） */
    private String candidateGroups;

    /** 任务创建时间 */
    private Date createTime;

    /** 任务完成时间 */
    private Date completeTime;

    /** 审批意见 */
    private String comment;

    /** 流程变量（审批时使用） */
    private Map<String, Object> variables;

    /** 操作类型（complete=通过, reject=驳回, transfer=转办） */
    private String action;

    /** 转办目标用户ID */
    private String transferUserId;

    /** 流程状态（RUNNING/COMPLETED） */
    private String processStatus;

    /** 业务类型（如 leave） */
    private String businessType;

    /** 业务详情前端路由 */
    private String detailRoute;

    /** 业务摘要（如 "张三的请假申请"） */
    private String businessSummary;

    /**
     * 任务状态
     * Created / Assigned / Delegated / Completed / Rejected / Returned
     */
    private String status;
}
