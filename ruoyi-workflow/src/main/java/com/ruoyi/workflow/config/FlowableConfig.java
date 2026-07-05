package com.ruoyi.workflow.config;

import org.flowable.spring.SpringProcessEngineConfiguration;
import org.flowable.spring.boot.EngineConfigurationConfigurer;
import org.springframework.context.annotation.Configuration;

/**
 * Flowable 工作流引擎配置
 *
 * @author ruoyi
 */
@Configuration
public class FlowableConfig implements EngineConfigurationConfigurer<SpringProcessEngineConfiguration>
{
    @Override
    public void configure(SpringProcessEngineConfiguration engineConfiguration)
    {
        // 设置流程变量映射为下划线风格（与数据库列名匹配）
        engineConfiguration.setDatabaseTablePrefix("");
        // 设置字体（用于流程图中文显示，使用逻辑字体名确保跨平台兼容）
        engineConfiguration.setActivityFontName("SansSerif");
        engineConfiguration.setLabelFontName("SansSerif");
        engineConfiguration.setAnnotationFontName("SansSerif");
    }
}
