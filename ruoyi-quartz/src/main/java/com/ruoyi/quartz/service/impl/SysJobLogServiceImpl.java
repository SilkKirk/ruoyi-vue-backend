package com.ruoyi.quartz.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.quartz.domain.SysJobLog;
import com.ruoyi.quartz.mapper.SysJobLogMapper;
import com.ruoyi.quartz.service.ISysJobLogService;

/**
 * 定时任务调度日志信息 服务层
 * 
 * @author ruoyi
 */
@Service
public class SysJobLogServiceImpl extends ServiceImpl<SysJobLogMapper, SysJobLog> implements ISysJobLogService
{
    @Autowired
    private SysJobLogMapper jobLogMapper;

    /**
     * 获取quartz调度器日志的计划任务
     * 
     * @param jobLog 调度日志信息
     * @return 调度任务日志集合
     */
    @Override
    public List<SysJobLog> selectJobLogList(SysJobLog jobLog)
    {
        QueryWrapper qw = buildJobLogQuery(jobLog);
        return jobLogMapper.selectListByQuery(qw);
    }

    private QueryWrapper buildJobLogQuery(SysJobLog jobLog) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(jobLog.getJobName())) qw.like(SysJobLog::getJobName, jobLog.getJobName());
        if (StringUtils.isNotEmpty(jobLog.getJobGroup())) qw.eq(SysJobLog::getJobGroup, jobLog.getJobGroup());
        if (StringUtils.isNotEmpty(jobLog.getStatus())) qw.eq(SysJobLog::getStatus, jobLog.getStatus());
        if (StringUtils.isNotEmpty(jobLog.getInvokeTarget())) qw.like(SysJobLog::getInvokeTarget, jobLog.getInvokeTarget());
        if (StringUtils.isNotNull(jobLog.getParams().get("beginTime"))) qw.ge(SysJobLog::getCreateTime, jobLog.getParams().get("beginTime"));
        if (StringUtils.isNotNull(jobLog.getParams().get("endTime"))) qw.le(SysJobLog::getCreateTime, jobLog.getParams().get("endTime"));
        qw.orderBy(SysJobLog::getJobLogId, false);
        return qw;
    }

    @Override
    public Page<SysJobLog> selectJobLogPage(Page<SysJobLog> page, SysJobLog jobLog)
    {
        QueryWrapper qw = buildJobLogQuery(jobLog);
        return jobLogMapper.paginate(page, qw);
    }

    @Override
    public void cleanJobLog()
    {
        jobLogMapper.deleteByQuery(QueryWrapper.create());
    }
}
