package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import com.mybatisflex.core.paginate.Page;
import java.util.List;
import com.ruoyi.system.domain.SysOperLog;

/**
 * 操作日志 服务层
 * 
 * @author ruoyi
 */
public interface ISysOperLogService extends IService<SysOperLog>
{
    /**
     * 查询操作日志列表
     */
    public List<SysOperLog> selectOperLogList(SysOperLog operLog);

    /**
     * 分页查询操作日志
     */
    public Page<SysOperLog> selectOperLogPage(Page<SysOperLog> page, SysOperLog operLog);

    /**
     * 新增操作日志
     * 
     * @param operLog 操作日志对象
     */
    public void insertOperlog(SysOperLog operLog);

    /**
     * 清空操作日志
     */
    public void cleanOperLog();
}
