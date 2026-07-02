package com.ruoyi.framework.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.mybatis.spring.annotation.MapperScan;
import com.fasterxml.jackson.databind.Module;
import com.ruoyi.common.config.serializer.AutoTrimModule;

/**
 * 程序注解配置
 *
 * @author ruoyi
 */
@Configuration
@EnableAspectJAutoProxy(exposeProxy = true)
@MapperScan("com.ruoyi.**.mapper")
public class ApplicationConfig
{
    /**
     * 自动 Trim 的 Jackson Module
     */
    @Bean
    public Module autoTrimModule()
    {
        return new AutoTrimModule();
    }
}
