package com.ruoyi.workflow.service.impl;

import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.workflow.domain.LeaveTest;
import com.ruoyi.workflow.mapper.LeaveTestMapper;
import com.ruoyi.workflow.service.ILeaveTestService;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LeaveTestServiceImpl implements ILeaveTestService {

    @Autowired
    private LeaveTestMapper leaveTestMapper;

    @Autowired
    private IWorkflowTaskService workflowTaskService;

    @Override
    public Page<LeaveTest> selectLeaveTestList(Page<LeaveTest> page, LeaveTest leaveTest) {
        QueryWrapper qw = QueryWrapper.create()
                .select()
                .from("leave_test")
                .orderBy("create_time", false);
        if (leaveTest.getUserName() != null && !leaveTest.getUserName().isEmpty()) {
            qw.and("user_name like ?", "%" + leaveTest.getUserName() + "%");
        }
        return leaveTestMapper.paginate(page.getPageNumber(), page.getPageSize(), qw);
    }

    @Override
    public LeaveTest selectLeaveTestById(String id) {
        return leaveTestMapper.selectOneById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertLeaveTest(LeaveTest leaveTest) {
        leaveTest.setStatus("0");
        leaveTest.setId(java.util.UUID.randomUUID().toString());
        int rows = leaveTestMapper.insert(leaveTest);
        // 插入后自动通过通用工作流服务提交审批（业务层不感知 Flowable）
        workflowTaskService.submitForApproval("leave", leaveTest.getId(), null);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateLeaveTest(LeaveTest leaveTest) {
        return leaveTestMapper.update(leaveTest);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteLeaveTestById(String id) {
        return leaveTestMapper.deleteById(id);
    }
}
