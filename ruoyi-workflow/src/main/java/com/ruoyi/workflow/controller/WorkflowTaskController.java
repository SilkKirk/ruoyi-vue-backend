package com.ruoyi.workflow.controller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.service.IWorkflowTaskService;

/**
 * 流程任务 控制器
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/workflow/task")
public class WorkflowTaskController extends BaseController
{
    @Autowired
    private static final Logger log = LoggerFactory.getLogger(WorkflowTaskController.class);
    @Autowired
    private IWorkflowTaskService workflowTaskService;

    /**
     * 查询我的待办任务
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:todoList')")
    @GetMapping("/todoList")
    public TableDataInfo todoList(WorkflowTask task)
    {
        return getDataTable(workflowTaskService.selectTodoList(startPage(WorkflowTask.class), task));
    }

    /**
     * 查询我的已办任务
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:doneList')")
    @GetMapping("/doneList")
    public TableDataInfo doneList(WorkflowTask task)
    {
        return getDataTable(workflowTaskService.selectDoneList(startPage(WorkflowTask.class), task));
    }

    /**
     * 审批通过
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:execute')")
    @Log(title = "流程任务", businessType = BusinessType.UPDATE)
    @PostMapping("/complete")
    public AjaxResult complete(@RequestBody WorkflowTask task)
    {
        workflowTaskService.completeTask(task.getTaskId(), task.getVariables(), task.getComment());
        return success();
    }

    /**
     * 驳回任务
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:execute')")
    @Log(title = "流程任务", businessType = BusinessType.UPDATE)
    @PostMapping("/reject")
    public AjaxResult reject(@RequestBody WorkflowTask task)
    {
        try
        {
            workflowTaskService.rejectTask(task.getTaskId(), task.getComment());
            return success();
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }
    }

    /**
     * 转办任务
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:transfer')")
    @Log(title = "流程任务", businessType = BusinessType.UPDATE)
    @PostMapping("/transfer")
    public AjaxResult transfer(@RequestBody WorkflowTask task)
    {
        workflowTaskService.transferTask(task.getTaskId(), task.getTransferUserId());
        return success();
    }

    /**
     * 通用提交审批（测试新架构）
     */
    @PostMapping("/start")
    public AjaxResult start(@RequestBody Map<String, String> params) {
        String businessType = params.get("businessType");
        String businessId = params.get("businessId");
        workflowTaskService.submitForApproval(businessType, businessId, null);
        return success();
    }

    /**
     * 获取审批历史（按实例ID）
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:query')")
    @GetMapping("/history/{instanceId}")
    public AjaxResult history(@PathVariable String instanceId) {
        return success(workflowTaskService.getHistoryList(instanceId));
    }

    /**
     * 通用业务数据查询（供待办/已办查看详情）
     */
    @GetMapping("/businessData/{businessType}/{businessId}")
    public AjaxResult businessData(@PathVariable String businessType, @PathVariable String businessId) {
        return success(workflowTaskService.loadBusinessData(businessType, businessId));
    }

    /**
     * 获取任务流程图
     */
    @PreAuthorize("@ss.hasPermi('workflow:task:query')")
    @GetMapping("/flowChart/{taskId}")
    public AjaxResult flowChart(@PathVariable String taskId)
    {
        String base64 = workflowTaskService.getTaskFlowChart(taskId);
        return AjaxResult.success("操作成功", base64);
    }
}
