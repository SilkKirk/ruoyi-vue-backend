package com.ruoyi.workflow.handler;

import com.ruoyi.workflow.domain.LeaveTest;
import com.ruoyi.workflow.mapper.LeaveTestMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 请假测试业务的工作流处理器
 */
@Component
public class LeaveWorkflowHandler implements WorkflowBusinessHandler {

    @Autowired
    private LeaveTestMapper leaveTestMapper;

    @Override
    public String getBusinessType() {
        return "leave";
    }

    @Override
    public String getProcessDefinitionKey() {
        return "test";
    }

    @Override
    public Object loadBusinessData(String businessId) {
        return leaveTestMapper.selectOneById(businessId);
    }

    @Override
    public void onProcessStarted(Object businessData, String processInstanceId) {
        LeaveTest leave = (LeaveTest) businessData;
        leave.setStatus("1");
        leave.setProcessInstanceId(processInstanceId);
        leaveTestMapper.update(leave);
    }

    @Override
    public void onProcessCompleted(Object businessData, String processInstanceId, boolean approved) {
        LeaveTest leave = (LeaveTest) businessData;
        leave.setStatus(approved ? "2" : "3");
        leaveTestMapper.update(leave);
    }

    @Override
    public String getDetailRoute() {
        return "/workflow/leave/detail/";
    }

    @Override
    public String getBusinessSummary(Object businessData) {
        if (businessData instanceof LeaveTest) {
            return ((LeaveTest) businessData).getUserName() + "的请假申请";
        }
        return "";
    }
}
