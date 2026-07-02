package com.ruoyi.quartz.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import java.util.Properties;

/**
 * 单机内存定时任务配置
 */
@Configuration
public class ScheduleMemoryConfig
{
    @Bean
    public SchedulerFactoryBean schedulerFactoryBean()
    {
        SchedulerFactoryBean factory = new SchedulerFactoryBean();

        Properties prop = new Properties();
        prop.put("org.quartz.scheduler.instanceName", "RuoyiScheduler");
        prop.put("org.quartz.scheduler.instanceId", "AUTO");
        prop.put("org.quartz.threadPool.class", "org.quartz.simpl.SimpleThreadPool");
        prop.put("org.quartz.threadPool.threadCount", "20");
        prop.put("org.quartz.threadPool.threadPriority", "5");

        factory.setQuartzProperties(prop);
        factory.setSchedulerName("RuoyiScheduler");
        factory.setStartupDelay(1);
        factory.setApplicationContextSchedulerContextKey("applicationContextKey");
        factory.setOverwriteExistingJobs(true);
        factory.setAutoStartup(true);

        return factory;
    }
}
