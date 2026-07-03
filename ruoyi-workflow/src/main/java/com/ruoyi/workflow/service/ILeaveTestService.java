package com.ruoyi.workflow.service;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.LeaveTest;

public interface ILeaveTestService {
    Page<LeaveTest> selectLeaveTestList(Page<LeaveTest> page, LeaveTest leaveTest);
    LeaveTest selectLeaveTestById(Long id);
    int insertLeaveTest(LeaveTest leaveTest);
    int updateLeaveTest(LeaveTest leaveTest);
    int deleteLeaveTestById(Long id);

}
