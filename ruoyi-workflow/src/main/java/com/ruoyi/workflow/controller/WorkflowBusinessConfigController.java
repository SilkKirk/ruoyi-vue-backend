package com.ruoyi.workflow.controller;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.common.event.ConfigChangeEvent;
import com.ruoyi.workflow.handler.WorkflowBusinessHandlerRegistry;
import com.ruoyi.workflow.service.IWorkflowBusinessConfigService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/workflow/business/config")
public class WorkflowBusinessConfigController extends BaseController {

    private final IWorkflowBusinessConfigService configService;
    private final ApplicationEventPublisher eventPublisher;
    private final WorkflowBusinessHandlerRegistry handlerRegistry;

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:list')")
    @GetMapping("/list")
    public TableDataInfo list(WorkflowBusinessConfig config) {
        Page<WorkflowBusinessConfig> page = configService.selectConfigList(startPage(WorkflowBusinessConfig.class), config);
        return getDataTable(page);
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable String id) {
        return success(configService.getById(id));
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:add')")
    @Log(title = "流程业务配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody WorkflowBusinessConfig config) {
        boolean ok = configService.insertConfig(config);
        if (ok) {
            eventPublisher.publishEvent(new ConfigChangeEvent());
            return success(config.getId());
        }
        return error();
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:edit')")
    @Log(title = "流程业务配置", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    public AjaxResult edit(@RequestBody WorkflowBusinessConfig config) {
        boolean ok = configService.updateById(config);
        if (ok) {
            eventPublisher.publishEvent(new ConfigChangeEvent());
        }
        return toAjax(ok);
    }

    @PreAuthorize("@ss.hasPermi('workflow:businessConfig:remove')")
    @Log(title = "流程业务配置", businessType = BusinessType.DELETE)
    @PostMapping("/{id}")
    public AjaxResult remove(@PathVariable String id) {
        boolean ok = configService.removeById(id);
        if (ok) {
            eventPublisher.publishEvent(new ConfigChangeEvent());
        }
        return toAjax(ok);
    }

    @GetMapping("/handlerBeanNames")
    public AjaxResult getHandlerBeanNames() {
        return success(handlerRegistry.getAvailableHandlerBeanNames());
    }
}
