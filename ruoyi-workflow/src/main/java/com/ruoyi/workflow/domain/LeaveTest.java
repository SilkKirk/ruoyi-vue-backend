package com.ruoyi.workflow.domain;

import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.Table;
import com.mybatisflex.annotation.KeyType;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@Table("leave_test")
public class LeaveTest extends WorkflowBaseEntity {
    @Id(keyType = KeyType.Auto)
    private Long id;
    private String userName;
    private String leaveType;
    private Date startDate;
    private Date endDate;
    private String reason;
}
