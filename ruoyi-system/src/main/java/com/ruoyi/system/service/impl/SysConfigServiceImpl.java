package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Collection;
import java.util.List;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.redis.RedisCache;
import cn.hutool.core.convert.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.SysConfigMapper;
import com.ruoyi.system.service.ISysConfigService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

@Service
public class SysConfigServiceImpl extends ServiceImpl<SysConfigMapper, SysConfig> implements ISysConfigService
{
    @Autowired private SysConfigMapper configMapper;
    @Autowired private RedisCache redisCache;

    @Override
    public List<SysConfig> selectConfigList(SysConfig config) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(config.getConfigName())) qw.like(SysConfig::getConfigName, config.getConfigName());
        if (StrUtil.isNotEmpty(config.getConfigType())) qw.eq(SysConfig::getConfigType, config.getConfigType());
        if (StrUtil.isNotEmpty(config.getConfigKey())) qw.like(SysConfig::getConfigKey, config.getConfigKey());
        if (ObjectUtil.isNotNull(config.getParams().get("beginTime"))) qw.ge(SysConfig::getCreateTime, config.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(config.getParams().get("endTime"))) qw.le(SysConfig::getCreateTime, config.getParams().get("endTime"));
        return configMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysConfig> selectConfigPage(Page<SysConfig> page, SysConfig config) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(config.getConfigName())) qw.like(SysConfig::getConfigName, config.getConfigName());
        if (StrUtil.isNotEmpty(config.getConfigType())) qw.eq(SysConfig::getConfigType, config.getConfigType());
        if (StrUtil.isNotEmpty(config.getConfigKey())) qw.like(SysConfig::getConfigKey, config.getConfigKey());
        if (ObjectUtil.isNotNull(config.getParams().get("beginTime"))) qw.ge(SysConfig::getCreateTime, config.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(config.getParams().get("endTime"))) qw.le(SysConfig::getCreateTime, config.getParams().get("endTime"));
        return configMapper.paginate(page, qw);
    }

    @PostConstruct
    public void init() { loadingConfigCache(); }

    @Override
    public String selectConfigByKey(String configKey)
    {
        String configValue = Convert.toStr(redisCache.getCacheObject(getCacheKey(configKey)));
        if (StrUtil.isNotEmpty(configValue)) return configValue;
        SysConfig retConfig = configMapper.selectOneByQuery(
            QueryWrapper.create().where(SysConfig::getConfigKey).eq(configKey)
        );
        if (ObjectUtil.isNotNull(retConfig))
        {
            redisCache.setCacheObject(getCacheKey(configKey), retConfig.getConfigValue());
            return retConfig.getConfigValue();
        }
        return StrUtil.EMPTY;
    }

    @Override
    public boolean selectCaptchaEnabled()
    {
        String captchaEnabled = selectConfigByKey("sys.account.captchaEnabled");
        if (StrUtil.isEmpty(captchaEnabled)) return true;
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

    @Override @Transactional
    public boolean save(SysConfig config) {
        boolean result = super.save(config);
        if (result) resetConfigCache();
        return result;
    }

    @Override @Transactional
    public boolean updateById(SysConfig config) {
        boolean result = super.updateById(config);
        if (result) resetConfigCache();
        return result;
    }

    @Override
    public boolean checkConfigKeyUnique(SysConfig config)
    {
        return configMapper.selectCountByQuery(
            QueryWrapper.create().where(SysConfig::getConfigKey).eq(config.getConfigKey())
                .and(SysConfig::getConfigId).ne(config.getConfigId() == null ? -1L : config.getConfigId())
        ) == 0;
    }

    private String getCacheKey(String configKey) { return CacheConstants.SYS_CONFIG_KEY + configKey; }
}

