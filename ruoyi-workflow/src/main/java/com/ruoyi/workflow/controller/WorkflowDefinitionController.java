package com.ruoyi.workflow.controller;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
import com.ruoyi.workflow.domain.WorkflowDefinition;
import com.ruoyi.workflow.service.IWorkflowDefinitionService;

/**
 * 流程定义 控制器
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/workflow/definition")
public class WorkflowDefinitionController extends BaseController
{
    @Autowired
    private IWorkflowDefinitionService workflowDefinitionService;

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
     * 获取流程定义BPMN XML
     */
    @PreAuthorize("@ss.hasPermi('workflow:definition:query')")
    @GetMapping("/bpmnXml/{definitionId}")
    public AjaxResult getBpmnXml(@PathVariable String definitionId)
    {
        return AjaxResult.success("操作成功", workflowDefinitionService.getDefinitionBpmnXml(definitionId));
    }

    /**
     * 挂起/激活流程定义
     */
    @PreAuthorize("@ss.hasPermi('workflow:definition:edit')")
    @Log(title = "流程定义", businessType = BusinessType.UPDATE)
    @PutMapping("/updateState")
    public AjaxResult updateState(@RequestBody Map<String, Object> params)
    {
        String definitionId = (String) params.get("definitionId");
        int state = (int) params.get("state");
        return toAjax(workflowDefinitionService.updateState(definitionId, state));
    }

    /**
     * 删除流程定义
     */
    @PreAuthorize("@ss.hasPermi('workflow:definition:remove')")
    @Log(title = "流程定义", businessType = BusinessType.DELETE)
    @DeleteMapping("/{definitionId}")
    public AjaxResult remove(@PathVariable String definitionId)
    {
        return toAjax(workflowDefinitionService.deleteDefinitionById(definitionId));
    }
}
