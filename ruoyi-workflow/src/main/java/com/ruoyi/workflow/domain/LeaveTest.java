package com.ruoyi.workflow.domain;

import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.Table;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@Table("leave_test")
public class LeaveTest extends BaseEntity {
    @Id
    private String id;
    private String userName;
    private String leaveType;
    private Date startDate;
    private Date endDate;
    private String reason;
    private String status;      // 0=草稿,1=审批中,2=通过,3=驳回
    private String processInstanceId;
}
