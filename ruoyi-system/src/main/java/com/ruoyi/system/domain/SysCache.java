package com.ruoyi.system.domain;

import lombok.Data;
import cn.hutool.core.util.StrUtil;

/**
 * 缓存信息
 * 
 * @author ruoyi
 */
@Data
public class SysCache
{
    /** 缓存名称 */
    private String cacheName = "";

    /** 缓存键名 */
    private String cacheKey = "";

    /** 缓存内容 */
    private String cacheValue = "";

    /** 备注 */
    private String remark = "";

    public SysCache()
    {

    }

    public SysCache(String cacheName, String remark)
    {
        this.cacheName = cacheName;
        this.remark = remark;
    }

    public SysCache(String cacheName, String cacheKey, String cacheValue)
    {
        this.cacheName = StrUtil.replace(cacheName, ":", "");
        this.cacheKey = StrUtil.replace(cacheKey, cacheName, "");
        this.cacheValue = cacheValue;
    }
}
