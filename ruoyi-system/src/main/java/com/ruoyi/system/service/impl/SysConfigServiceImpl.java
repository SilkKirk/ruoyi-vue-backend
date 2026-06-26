package com.ruoyi.system.service.impl;

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
public class SysConfigServiceImpl implements ISysConfigService
{
    @Autowired private SysConfigMapper configMapper;
    @Autowired private RedisCache redisCache;

    @PostConstruct
    public void init() { loadingConfigCache(); }

    @Override
    public SysConfig selectConfigById(Long configId)
    {
        return configMapper.selectOneById(configId);
    }

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
    public List<SysConfig> selectConfigList(SysConfig config)
    {
        QueryWrapper qw = buildConfigQuery(config);
        return configMapper.selectListByQuery(qw);
    }

    private QueryWrapper buildConfigQuery(SysConfig config) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(config.getConfigName())) qw.like(SysConfig::getConfigName, config.getConfigName());
        if (StringUtils.isNotEmpty(config.getConfigType())) qw.eq(SysConfig::getConfigType, config.getConfigType());
        if (StringUtils.isNotEmpty(config.getConfigKey())) qw.like(SysConfig::getConfigKey, config.getConfigKey());
        if (StringUtils.isNotNull(config.getParams().get("beginTime"))) qw.ge(SysConfig::getCreateTime, config.getParams().get("beginTime"));
        if (StringUtils.isNotNull(config.getParams().get("endTime"))) qw.le(SysConfig::getCreateTime, config.getParams().get("endTime"));
        return qw;
    }

    @Override
    public Page<SysConfig> selectConfigPage(Page<SysConfig> page, SysConfig config)
    {
        QueryWrapper qw = buildConfigQuery(config);
        return configMapper.paginate(page, qw);
    }

    @Override
    public int insertConfig(SysConfig config)
    {
        int row = configMapper.insertSelective(config);
        if (row > 0) redisCache.setCacheObject(getCacheKey(config.getConfigKey()), config.getConfigValue());
        return row;
    }

    @Override
    public int updateConfig(SysConfig config)
    {
        SysConfig temp = configMapper.selectOneById(config.getConfigId());
        if (!StringUtils.equals(temp.getConfigKey(), config.getConfigKey()))
            redisCache.deleteObject(getCacheKey(temp.getConfigKey()));
        int row = configMapper.update(config);
        if (row > 0) redisCache.setCacheObject(getCacheKey(config.getConfigKey()), config.getConfigValue());
        return row;
    }

    @Override
    public void deleteConfigByIds(Long[] configIds)
    {
        for (Long configId : configIds)
        {
            SysConfig config = selectConfigById(configId);
            if (StringUtils.equals(UserConstants.YES, config.getConfigType()))
                throw new ServiceException(String.format("内置参数【%1$s】不能删除 ", config.getConfigKey()));
            configMapper.deleteById(configId);
            redisCache.deleteObject(getCacheKey(config.getConfigKey()));
        }
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
