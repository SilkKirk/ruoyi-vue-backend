package com.ruoyi.workflow.handler;

import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.service.IWorkflowBusinessConfigService;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 工作流业务处理器注册中心
 * 从 workflow_business_config 表加载配置，通过 Spring Bean 名称获取实际的 Handler
 */
@Component
public class WorkflowBusinessHandlerRegistry {

    private static final Logger log = LoggerFactory.getLogger(WorkflowBusinessHandlerRegistry.class);

    @Autowired
    private IWorkflowBusinessConfigService configService;

    @Autowired
    private ApplicationContext applicationContext;

    private volatile Map<String, WorkflowBusinessConfig> configCache = new HashMap<>();

    @PostConstruct
    public void init() {
        reload();
        log.info("WorkflowBusinessHandlerRegistry initialized with {} configs", configCache.size());
    }

    public synchronized void reload() {
        try {
            List<WorkflowBusinessConfig> list = configService.listAll();
            configCache = list.stream()
                    .filter(c -> "1".equals(c.getStatus()))
                    .collect(Collectors.toMap(
                            WorkflowBusinessConfig::getProcessDefinitionKey,
                            c -> c,
                            (a, b) -> b
                    ));
            log.info("WorkflowBusinessHandlerRegistry reloaded: {} active configs", configCache.size());
        } catch (Exception e) {
            log.warn("Failed to reload WorkflowBusinessHandlerRegistry (config table may not exist yet): {}", e.getMessage());
        }
    }

    public WorkflowBusinessConfig getConfig(String processDefinitionKey) {
        WorkflowBusinessConfig config = configCache.get(processDefinitionKey);
        if (config == null) {
            reload();
            config = configCache.get(processDefinitionKey);
        }
        if (config == null) {
            throw new RuntimeException("未找到流程定义Key [" + processDefinitionKey + "] 的业务配置，请在[流程业务配置]菜单中配置");
        }
        return config;
    }

    public WorkflowBusinessHandler getHandler(String processDefinitionKey) {
        WorkflowBusinessConfig config = getConfig(processDefinitionKey);
        Object bean = applicationContext.getBean(config.getServiceBeanName());
        if (!(bean instanceof WorkflowBusinessHandler handler)) {
            throw new RuntimeException("Bean [" + config.getServiceBeanName() + "] 未实现 WorkflowBusinessHandler 接口");
        }
        return handler;
    }

    public List<WorkflowBusinessConfig> getAllConfigs() {
        return new ArrayList<>(configCache.values());
    }

    /**
     * 根据 Service Bean 名称查找对应的业务配置
     */
    public WorkflowBusinessConfig getConfigByBeanName(String beanName) {
        return configCache.values().stream()
                .filter(c -> c.getServiceBeanName().equals(beanName))
                .findFirst()
                .orElse(null);
    }

    public List<String> getAvailableHandlerBeanNames() {
        return Arrays.asList(applicationContext.getBeanNamesForType(WorkflowBusinessHandler.class));
    }
}
