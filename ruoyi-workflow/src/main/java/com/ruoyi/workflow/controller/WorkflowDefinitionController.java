package com.ruoyi.workflow.controller;

import java.util.Map;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.WorkflowDefinition;
import com.ruoyi.workflow.service.IWorkflowDefinitionService;
import lombok.RequiredArgsConstructor;

/**
 * 流程定义 控制器
 *
 * @author ruoyi
 */
@RequiredArgsConstructor
@RestController
@RequestMapping("/workflow/definition")
public class WorkflowDefinitionController extends BaseController
{
    private final IWorkflowDefinitionService workflowDefinitionService;

    /**
     * 分页查询流程定义列表
     */
    @PreAuthorize("@ss.hasPermi('workflow:definition:list')")
    @GetMapping("/list")
    public TableDataInfo list(WorkflowDefinition definition)
    {
        return getDataTable(workflowDefinitionService.selectDefinitionList(startPage(WorkflowDefinition.class), definition));
    }

    /**
     * 挂起/激活流程定义
     */
    @PreAuthorize("@ss.hasPermi('workflow:definition:edit')")
    @Log(title = "流程定义", businessType = BusinessType.UPDATE)
    @PostMapping("/updateState")
    public AjaxResult updateState(@RequestBody Map<String, Object> params)
    {
        String definitionId = (String) params.get("definitionId");
        int state = ((Number) params.get("state")).intValue();
        return toAjax(workflowDefinitionService.updateState(definitionId, state));
    }

    /**
     * 获取所有已部署流程定义的Key和名称列表（供业务配置下拉使用）
     */
    @GetMapping("/processDefinitionKeys")
    public AjaxResult getProcessDefinitionKeys() {
        return success(workflowDefinitionService.getProcessDefinitionKeys());
    }

    /**
     * 获取流程图数据（BPMN XML + 可选活动状态）
     */
    @GetMapping("/diagramInfo")
    public AjaxResult diagramInfo(@RequestParam(required=false) String definitionId,
                                  @RequestParam(required=false) String instanceId)
    {
        return success(workflowDefinitionService.getDiagramInfo(definitionId, instanceId));
    }

    /**
     * 删除流程定义
     */
    @PreAuthorize("@ss.hasPermi('workflow:definition:remove')")
    @Log(title = "流程定义", businessType = BusinessType.DELETE)
    @PostMapping("/{definitionId}")
    public AjaxResult remove(@PathVariable String definitionId)
    {
        return toAjax(workflowDefinitionService.deleteDefinitionById(definitionId));
    }
}
