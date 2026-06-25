package com.ruoyi.quartz.service.impl;

import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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
public class SysJobLogServiceImpl implements ISysJobLogService
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
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(jobLog.getJobName())) qw.like(SysJobLog::getJobName, jobLog.getJobName());
        if (StringUtils.isNotEmpty(jobLog.getJobGroup())) qw.eq(SysJobLog::getJobGroup, jobLog.getJobGroup());
        if (StringUtils.isNotEmpty(jobLog.getStatus())) qw.eq(SysJobLog::getStatus, jobLog.getStatus());
        if (StringUtils.isNotEmpty(jobLog.getInvokeTarget())) qw.like(SysJobLog::getInvokeTarget, jobLog.getInvokeTarget());
        if (StringUtils.isNotNull(jobLog.getParams().get("beginTime"))) qw.ge(SysJobLog::getCreateTime, jobLog.getParams().get("beginTime"));
        if (StringUtils.isNotNull(jobLog.getParams().get("endTime"))) qw.le(SysJobLog::getCreateTime, jobLog.getParams().get("endTime"));
        qw.orderBy(SysJobLog::getJobLogId, false);
        return jobLogMapper.selectListByQuery(qw);
    }

    /**
     * 通过调度任务日志ID查询调度信息
     * 
     * @param jobLogId 调度任务日志ID
     * @return 调度任务日志对象信息
     */
    @Override
    public SysJobLog selectJobLogById(Long jobLogId)
    {
        return jobLogMapper.selectOneById(jobLogId);
    }

    /**
     * 新增任务日志
     * 
     * @param jobLog 调度日志信息
     */
    @Override
    public void addJobLog(SysJobLog jobLog)
    {
        jobLogMapper.insertSelective(jobLog);
    }

    /**
     * 批量删除调度日志信息
     * 
     * @param logIds 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteJobLogByIds(Long[] logIds)
    {
        return jobLogMapper.deleteBatchByIds(Arrays.asList(logIds));
    }

    /**
     * 删除任务日志
     * 
     * @param jobId 调度日志ID
     */
    @Override
    public int deleteJobLogById(Long jobId)
    {
        return jobLogMapper.deleteById(jobId);
    }

    /**
     * 清空任务日志
     */
    @Override
    public void cleanJobLog()
    {
        jobLogMapper.deleteByQuery(QueryWrapper.create().where("1=1"));
    }
}
