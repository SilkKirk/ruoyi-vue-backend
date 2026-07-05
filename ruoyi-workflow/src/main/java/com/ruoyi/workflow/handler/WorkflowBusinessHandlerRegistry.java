package com.ruoyi.workflow.handler;

import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.domain.WorkflowInstance;
import com.ruoyi.workflow.domain.WorkflowTask;
import com.ruoyi.workflow.common.event.ConfigChangeEvent;
import com.ruoyi.workflow.service.IWorkflowBusinessConfigService;
import jakarta.annotation.PostConstruct;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 工作流业务处理器注册中心
 * 从 workflow_business_config 表加载配置，通过 serviceBeanName 作为业务标识
 */
@Slf4j
@RequiredArgsConstructor
@Component
public class WorkflowBusinessHandlerRegistry {

    private final IWorkflowBusinessConfigService configService;
    private final ApplicationContext applicationContext;

    private volatile Map<String, WorkflowBusinessConfig> configCache = new HashMap<>();

    @PostConstruct
    public void init() {
        reload();
        log.info("WorkflowBusinessHandlerRegistry initialized with {} configs", configCache.size());
    }

    @EventListener
    public void onConfigChange(ConfigChangeEvent event) {
        log.info("Workflow business config changed, reloading cache");
        reload();
    }

    public synchronized void reload() {
        try {
            List<WorkflowBusinessConfig> list = configService.list();
            configCache = list.stream()
                    .filter(c -> FlowableProcessConstants.CONFIG_STATUS_ENABLED.equals(c.getStatus()))
                    .collect(Collectors.toMap(
                            WorkflowBusinessConfig::getServiceBeanName,
                            c -> c,
                            (a, b) -> b
                    ));
            log.info("WorkflowBusinessHandlerRegistry reloaded: {} active configs", configCache.size());
        } catch (Exception e) {
            log.warn("Failed to reload WorkflowBusinessHandlerRegistry (config table may not exist yet): {}", e.getMessage());
        }
    }

    public WorkflowBusinessConfig getConfig(String businessCode) {
        WorkflowBusinessConfig config = configCache.get(businessCode);
        if (config == null) {
            reload();
            config = configCache.get(businessCode);
        }
        if (config == null) {
            throw new RuntimeException("未找到业务Code [" + businessCode + "] 的流程业务配置，请在[流程业务配置]菜单中配置");
        }
        return config;
    }

    public WorkflowBusinessHandler getHandler(String businessCode) {
        WorkflowBusinessConfig config = getConfig(businessCode);
        Object bean = applicationContext.getBean(config.getServiceBeanName());
        if (!(bean instanceof WorkflowBusinessHandler handler)) {
            throw new RuntimeException("Bean [" + config.getServiceBeanName() + "] 未实现 WorkflowBusinessHandler 接口");
        }
        return handler;
    }

    public record BusinessInfo(String detailRoute, String businessSummary) {}

    public BusinessInfo getBusinessInfo(String businessCode, String businessKey) {
        if (StrUtil.hasBlank(businessCode, businessKey)) return null;
        try {
            WorkflowBusinessConfig cfg = getConfig(businessCode);
            WorkflowBusinessHandler h = getHandler(businessCode);
            Object data = h.loadBusinessData(businessKey);
            String summary = data != null ? h.getBusinessSummary(data) : null;
            return new BusinessInfo(cfg.getDetailRoute(), summary);
        } catch (Exception e) {
            log.warn("获取业务信息失败: businessCode={}, businessKey={}", businessCode, businessKey, e);
            return null;
        }
    }

    public void fillTaskBusinessInfo(WorkflowTask wt, String businessCode, String businessKey) {
        BusinessInfo info = getBusinessInfo(businessCode, businessKey);
        if (info != null) {
            wt.setDetailRoute(info.detailRoute());
            wt.setBusinessSummary(info.businessSummary());
        }
    }

    public void fillInstanceBusinessInfo(WorkflowInstance wi) {
        BusinessInfo info = getBusinessInfo(wi.getBusinessCode(), wi.getBusinessKey());
        if (info != null) {
            wi.setDetailRoute(info.detailRoute());
            wi.setBusinessSummary(info.businessSummary());
        }
    }

    public List<String> getAvailableHandlerBeanNames() {
        return Arrays.asList(applicationContext.getBeanNamesForType(WorkflowBusinessHandler.class));
    }
}
