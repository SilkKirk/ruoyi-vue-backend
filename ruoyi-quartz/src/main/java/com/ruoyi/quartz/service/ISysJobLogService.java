package com.ruoyi.quartz.service;

import com.mybatisflex.core.service.IService;
import java.util.List;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.quartz.domain.SysJobLog;

/**
 * 定时任务调度日志信息信息 服务层
 * 
 * @author ruoyi
 */
public interface ISysJobLogService extends IService<SysJobLog>
{
    /**
     * 获取quartz调度器日志的计划任务
     * 
     * @param jobLog 调度日志信息
     * @return 调度任务日志集合
     */
    public List<SysJobLog> selectJobLogList(SysJobLog jobLog);

    public Page<SysJobLog> selectJobLogPage(Page<SysJobLog> page, SysJobLog jobLog);

    /**
     * 清空任务日志
     */
    public void cleanJobLog();
}
