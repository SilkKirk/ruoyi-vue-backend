package com.ruoyi.workflow.service;

import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.service.IService;
import com.ruoyi.workflow.domain.LeaveTest;

public interface ILeaveTestService extends IService<LeaveTest> {
    Page<LeaveTest> selectLeaveTestList(Page<LeaveTest> page, LeaveTest leaveTest);
    boolean insertLeaveTest(LeaveTest leaveTest);
}
