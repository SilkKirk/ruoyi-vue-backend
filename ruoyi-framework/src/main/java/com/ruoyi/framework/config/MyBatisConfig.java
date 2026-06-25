package com.ruoyi.framework.config;

import org.springframework.context.annotation.Configuration;

/**
 * MyBatis-Flex 配置
 * <p>
 * 分页由 {@link com.ruoyi.common.utils.PageUtils#paginate} 直接调用
 * MyBatis-Flex 原生 {@code BaseMapper.paginate()} 实现，无需额外拦截器。
 *
 * @author ruoyi
 */
@Configuration
public class MyBatisConfig
{
}
