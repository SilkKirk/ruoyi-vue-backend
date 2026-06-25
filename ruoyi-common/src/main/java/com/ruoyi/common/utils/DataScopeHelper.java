package com.ruoyi.common.utils;

import java.util.Map;
import com.mybatisflex.core.query.QueryWrapper;

/**
 * 数据权限工具类 — 将 DataScopeAspect 注入的 SQL 条件应用到 MyBatis-Flex QueryWrapper
 * 
 * @author ruoyi
 */
public class DataScopeHelper
{
    /** 与 DataScopeAspect.DATA_SCOPE 保持一致的 key */
    public static final String DATA_SCOPE = "dataScope";

    /**
     * 将 dataScope 条件应用到 MyBatis-Flex QueryWrapper
     * 调用方应在构建好 QueryWrapper 之后、执行查询之前调用此方法
     *
     * @param qw     MyBatis-Flex QueryWrapper
     * @param params 查询参数 Map（从 BaseEntity.getParams() 获取）
     */
    public static void applyDataScope(QueryWrapper qw, Map<String, Object> params)
    {
        if (params != null && params.containsKey(DATA_SCOPE))
        {
            String condition = (String) params.get(DATA_SCOPE);
            if (StringUtils.isNotBlank(condition))
            {
                qw.and(condition);
            }
        }
    }
}
