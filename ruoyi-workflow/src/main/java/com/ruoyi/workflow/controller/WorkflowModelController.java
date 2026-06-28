package com.ruoyi.workflow.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import com.ruoyi.workflow.domain.WorkflowModel;
import com.ruoyi.workflow.service.IWorkflowModelService;

import java.util.Map;

/**
 * 流程模型 控制器
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/workflow/model")
public class WorkflowModelController extends BaseController
{
    @Autowired
    private IWorkflowModelService workflowModelService;

    /**
     * 分页查询模型列表
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:list')")
    @GetMapping("/list")
    public TableDataInfo list(WorkflowModel model)
    {
        return getDataTable(workflowModelService.selectModelList(startPage(WorkflowModel.class), model));
    }

    /**
     * 获取模型详情
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:query')")
    @GetMapping("/{modelId}")
    public AjaxResult getInfo(@PathVariable String modelId)
    {
        return success(workflowModelService.selectModelById(modelId));
    }

    /**
     * 获取模型BPMN XML
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:query')")
    @GetMapping("/bpmnXml/{modelId}")
    public AjaxResult getBpmnXml(@PathVariable String modelId)
    {
        return AjaxResult.success("操作成功", workflowModelService.getModelBpmnXml(modelId));
    }

    /**
     * 新增模型
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:add')")
    @Log(title = "流程模型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody WorkflowModel model)
    {
        String modelId = workflowModelService.insertModel(model);
        return success(modelId);
    }

    /**
     * 保存模型BPMN XML
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:edit')")
    @Log(title = "流程模型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult save(@RequestBody Map<String, Object> params)
    {
        String modelId = (String) params.get("modelId");
        String bpmnXml = (String) params.get("bpmnXml");
        workflowModelService.saveModel(modelId, bpmnXml);
        return success();
    }

    /**
     * 删除模型
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:remove')")
    @Log(title = "流程模型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{modelId}")
    public AjaxResult remove(@PathVariable String modelId)
    {
        return toAjax(workflowModelService.deleteModelById(modelId));
    }

    /**
     * 部署模型
     */
    @PreAuthorize("@ss.hasPermi('workflow:model:deploy')")
    @Log(title = "流程模型", businessType = BusinessType.OTHER)
    @PostMapping("/deploy/{modelId}")
    public AjaxResult deploy(@PathVariable String modelId)
    {
        try
        {
            String deploymentId = workflowModelService.deployModel(modelId);
            return success(deploymentId);
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }
    }
}
