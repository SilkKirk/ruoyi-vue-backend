package com.ruoyi.workflow.service.impl;

import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.domain.LeaveTest;
import com.ruoyi.workflow.handler.AbstractWorkflowAwareService;
import com.ruoyi.workflow.service.ILeaveTestService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cn.hutool.core.util.StrUtil;

@Service("leaveTestServiceImpl")
public class LeaveTestServiceImpl extends AbstractWorkflowAwareService<LeaveTest> implements ILeaveTestService {

    @Override
    public Page<LeaveTest> selectLeaveTestList(Page<LeaveTest> page, LeaveTest leaveTest) {
        QueryWrapper qw = QueryWrapper.create()
                .select()
                .from(LeaveTest.class)
                .orderBy(LeaveTest::getStartDate, false);
        if (StrUtil.isNotBlank(leaveTest.getUserName())) {
            qw.and(LeaveTest::getUserName).like(leaveTest.getUserName());
        }
        return page(page, qw);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insertLeaveTest(LeaveTest leaveTest) {
        leaveTest.setStatus(FlowableProcessConstants.STATUS_DRAFT);
        boolean ok = save(leaveTest);
        if (ok) {
            startWorkflow(String.valueOf(leaveTest.getId()));
        }
        return ok;
    }

    @Override
    public String getBusinessSummary(Object businessData) {
        return ((LeaveTest) businessData).getUserName() + "的请假申请";
    }
}
