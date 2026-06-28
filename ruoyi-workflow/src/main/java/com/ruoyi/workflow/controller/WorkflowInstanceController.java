package com.ruoyi.workflow.controller;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.WorkflowInstance;
import com.ruoyi.workflow.service.IWorkflowInstanceService;

/**
 * 流程实例 控制器
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/workflow/instance")
public class WorkflowInstanceController extends BaseController
{
    @Autowired
    private IWorkflowInstanceService workflowInstanceService;

    /**
     * 分页查询流程实例列表
     */
    @PreAuthorize("@ss.hasPermi('workflow:instance:list')")
    @GetMapping("/list")
    public TableDataInfo list(WorkflowInstance instance)
    {
        return getDataTable(workflowInstanceService.selectInstanceList(startPage(WorkflowInstance.class), instance));
    }

    /**
     * 启动流程实例
     */
    @PreAuthorize("@ss.hasPermi('workflow:instance:start')")
    @Log(title = "流程实例", businessType = BusinessType.OTHER)
    @PostMapping("/start")
    public AjaxResult start(@RequestBody Map<String, Object> params)
    {
        String definitionId = (String) params.get("definitionId");
        String businessKey = (String) params.get("businessKey");
        @SuppressWarnings("unchecked")
        Map<String, Object> variables = (Map<String, Object>) params.get("variables");

        try
        {
            String instanceId = workflowInstanceService.startProcessInstance(definitionId, businessKey, variables);
            return success(instanceId);
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }
    }

    /**
     * 终止流程实例
     */
    @PreAuthorize("@ss.hasPermi('workflow:instance:stop')")
    @Log(title = "流程实例", businessType = BusinessType.OTHER)
    @PutMapping("/stop/{instanceId}")
    public AjaxResult stop(@PathVariable String instanceId, @RequestBody(required = false) Map<String, String> params)
    {
        String reason = params != null ? params.get("reason") : "手动终止";
        workflowInstanceService.stopProcessInstance(instanceId, reason);
        return success();
    }

    /**
     * 挂起/激活流程实例
     */
    @PreAuthorize("@ss.hasPermi('workflow:instance:edit')")
    @Log(title = "流程实例", businessType = BusinessType.UPDATE)
    @PutMapping("/updateState")
    public AjaxResult updateState(@RequestBody Map<String, Object> params)
    {
        String instanceId = (String) params.get("instanceId");
        int state = (int) params.get("state");
        workflowInstanceService.updateState(instanceId, state);
        return success();
    }

    /**
     * 获取流程图高亮跟踪
     */
    @PreAuthorize("@ss.hasPermi('workflow:instance:query')")
    @GetMapping("/diagram/{instanceId}")
    public AjaxResult diagram(@PathVariable String instanceId)
    {
        String base64 = workflowInstanceService.getInstanceDiagram(instanceId);
        return AjaxResult.success("操作成功", base64);
    }
}
