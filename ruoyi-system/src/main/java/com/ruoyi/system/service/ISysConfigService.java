package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import com.mybatisflex.core.paginate.Page;
import java.util.List;
import com.ruoyi.system.domain.SysConfig;

/**
 * 参数配置 服务层
 * 
 * @author ruoyi
 */
public interface ISysConfigService extends IService<SysConfig>
{
    /**
     * 查询参数配置列表
     */
    public List<SysConfig> selectConfigList(SysConfig config);

    /**
     * 分页查询参数配置
     */
    public Page<SysConfig> selectConfigPage(Page<SysConfig> page, SysConfig config);

    /**
     * 根据键名查询参数配置信息
     * 
     * @param configKey 参数键名
     * @return 参数键值
     */
    public String selectConfigByKey(String configKey);

    /**
     * 获取验证码开关
     * 
     * @return true开启，false关闭
     */
    public boolean selectCaptchaEnabled();

    /**
     * 加载参数缓存数据
     */
    public void loadingConfigCache();

    /**
     * 清空参数缓存数据
     */
    public void clearConfigCache();

    /**
     * 重置参数缓存数据
     */
    public void resetConfigCache();

    /**
     * 校验参数键名是否唯一
     * 
     * @param config 参数信息
     * @return 结果
     */
    public boolean checkConfigKeyUnique(SysConfig config);
}
