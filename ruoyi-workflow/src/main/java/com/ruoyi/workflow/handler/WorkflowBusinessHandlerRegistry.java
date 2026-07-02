package com.ruoyi.workflow.handler;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * 工作流业务处理器注册中心
 * Spring 启动时自动扫描所有 WorkflowBusinessHandler Bean
 */
@Component
public class WorkflowBusinessHandlerRegistry implements ApplicationContextAware {

    private final Map<String, WorkflowBusinessHandler> handlers = new HashMap<>();

    @Override
    public void setApplicationContext(ApplicationContext ctx) throws BeansException {
        ctx.getBeansOfType(WorkflowBusinessHandler.class)
                .values()
                .forEach(h -> handlers.put(h.getBusinessType(), h));
    }

    public WorkflowBusinessHandler getHandler(String businessType) {
        WorkflowBusinessHandler handler = handlers.get(businessType);
        if (handler == null) {
            throw new RuntimeException("未找到业务类型 [" + businessType + "] 的工作流处理器");
        }
        return handler;
    }

    public Map<String, WorkflowBusinessHandler> getAllHandlers() {
        return handlers;
    }
}
