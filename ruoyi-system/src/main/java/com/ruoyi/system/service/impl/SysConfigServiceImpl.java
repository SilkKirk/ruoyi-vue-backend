package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Collection;
import java.util.List;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.SysConfigMapper;
import com.ruoyi.system.service.ISysConfigService;

@Service
public class SysConfigServiceImpl extends ServiceImpl<SysConfigMapper, SysConfig> implements ISysConfigService
{
    @Autowired private SysConfigMapper configMapper;
    @Autowired private RedisCache redisCache;

    @PostConstruct
    public void init() { loadingConfigCache(); }

    @Override
    public String selectConfigByKey(String configKey)
    {
        String configValue = Convert.toStr(redisCache.getCacheObject(getCacheKey(configKey)));
        if (StringUtils.isNotEmpty(configValue)) return configValue;
        SysConfig retConfig = configMapper.selectOneByQuery(
            QueryWrapper.create().where(SysConfig::getConfigKey).eq(configKey)
        );
        if (StringUtils.isNotNull(retConfig))
        {
            redisCache.setCacheObject(getCacheKey(configKey), retConfig.getConfigValue());
            return retConfig.getConfigValue();
        }
        return StringUtils.EMPTY;
    }

    @Override
    public boolean selectCaptchaEnabled()
    {
        String captchaEnabled = selectConfigByKey("sys.account.captchaEnabled");
        if (StringUtils.isEmpty(captchaEnabled)) return true;
        return Convert.toBool(captchaEnabled);
    }

    

    

    

    @Override
    public void loadingConfigCache()
    {
        List<SysConfig> configsList = configMapper.selectListByQuery(QueryWrapper.create());
        for (SysConfig config : configsList)
            redisCache.setCacheObject(getCacheKey(config.getConfigKey()), config.getConfigValue());
    }

    @Override
    public void clearConfigCache()
    {
        Collection<String> keys = redisCache.keys(CacheConstants.SYS_CONFIG_KEY + "*");
        redisCache.deleteObject(keys);
    }

    @Override
    public void resetConfigCache() { clearConfigCache(); loadingConfigCache(); }

    @Override
    public boolean checkConfigKeyUnique(SysConfig config)
    {
        Long configId = StringUtils.isNull(config.getConfigId()) ? -1L : config.getConfigId();
        SysConfig info = configMapper.selectOneByQuery(
            QueryWrapper.create().where(SysConfig::getConfigKey).eq(config.getConfigKey())
        );
        if (StringUtils.isNotNull(info) && info.getConfigId().longValue() != configId.longValue())
            return UserConstants.NOT_UNIQUE;
        return UserConstants.UNIQUE;
    }

    private String getCacheKey(String configKey) { return CacheConstants.SYS_CONFIG_KEY + configKey; }
}

