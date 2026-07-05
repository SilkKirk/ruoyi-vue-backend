package com.ruoyi.workflow.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.service.IWorkflowTaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 流程任务 控制器
 *
 * @author ruoyi
 */
@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/workflow/task")
public class WorkflowTaskController extends BaseController
{
    private final IWorkflowTaskService workflowTaskService;

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
        workflowTaskService.rejectTask(task.getTaskId(), task.getComment());
        return success();
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
    @GetMapping("/businessData/{businessCode}/{businessId}")
    public AjaxResult businessData(@PathVariable String businessCode, @PathVariable String businessId) {
        return success(workflowTaskService.loadBusinessData(businessCode, businessId));
    }
}
