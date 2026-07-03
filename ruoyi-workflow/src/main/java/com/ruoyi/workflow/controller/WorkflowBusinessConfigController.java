package com.ruoyi.workflow.controller;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.service.IWorkflowBusinessConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/workflow/business/config")
public class WorkflowBusinessConfigController extends BaseController {

    @Autowired
    private IWorkflowBusinessConfigService configService;

    @Autowired
    private WorkflowBusinessHandlerRegistry handlerRegistry;

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:list')")
    @GetMapping("/list")
    public TableDataInfo list(WorkflowBusinessConfig config) {
        Page<WorkflowBusinessConfig> page = configService.selectConfigList(startPage(WorkflowBusinessConfig.class), config);
        return getDataTable(page);
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable String id) {
        return success(configService.selectConfigById(id));
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:add')")
    @Log(title = "流程业务配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody WorkflowBusinessConfig config) {
        int rows = configService.insertConfig(config);
        if (rows > 0) {
            handlerRegistry.reload();
            return success(config.getId());
        }
        return error();
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:edit')")
    @Log(title = "流程业务配置", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    public AjaxResult edit(@RequestBody WorkflowBusinessConfig config) {
        int rows = configService.updateConfig(config);
        if (rows > 0) {
            handlerRegistry.reload();
        }
        return toAjax(rows);
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:remove')")
    @Log(title = "流程业务配置", businessType = BusinessType.DELETE)
    @PostMapping("/{id}")
    public AjaxResult remove(@PathVariable String id) {
        int rows = configService.deleteConfigById(id);
        if (rows > 0) {
            handlerRegistry.reload();
        }
        return toAjax(rows);
    }

    @GetMapping("/handlerBeanNames")
    public AjaxResult getHandlerBeanNames() {
        List<String> names = handlerRegistry.getAvailableHandlerBeanNames();
        return success(names);
    }
}
