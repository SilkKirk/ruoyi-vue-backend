package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.system.domain.SysOperLog;
import com.ruoyi.system.mapper.SysOperLogMapper;
import com.ruoyi.system.service.ISysOperLogService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

/**
 * 操作日志 服务层处理
 * 
 * @author ruoyi
 */
@Service
public class SysOperLogServiceImpl extends ServiceImpl<SysOperLogMapper, SysOperLog> implements ISysOperLogService
{
    @Autowired
    private SysOperLogMapper operLogMapper;

    @Override
    public List<SysOperLog> selectOperLogList(SysOperLog operLog) {
        QueryWrapper qw = buildOperLogQuery(operLog);
        return operLogMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysOperLog> selectOperLogPage(Page<SysOperLog> page, SysOperLog operLog) {
        QueryWrapper qw = buildOperLogQuery(operLog);
        return operLogMapper.paginate(page, qw);
    }

    private QueryWrapper buildOperLogQuery(SysOperLog operLog) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(operLog.getOperIp())) qw.like(SysOperLog::getOperIp, operLog.getOperIp());
        if (StrUtil.isNotEmpty(operLog.getTitle())) qw.like(SysOperLog::getTitle, operLog.getTitle());
        if (ObjectUtil.isNotNull(operLog.getBusinessType())) qw.eq(SysOperLog::getBusinessType, operLog.getBusinessType());
        if (ObjectUtil.isNotNull(operLog.getStatus())) qw.eq(SysOperLog::getStatus, operLog.getStatus());
        if (StrUtil.isNotEmpty(operLog.getOperName())) qw.like(SysOperLog::getOperName, operLog.getOperName());
        if (ObjectUtil.isNotNull(operLog.getParams().get("beginTime"))) qw.ge(SysOperLog::getOperTime, operLog.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(operLog.getParams().get("endTime"))) qw.le(SysOperLog::getOperTime, operLog.getParams().get("endTime"));
        qw.orderBy(SysOperLog::getOperId, false);
        return qw;
    }

    /**
     * 新增操作日志
     * 
     * @param operLog 操作日志对象
     */
    @Override
    public void insertOperlog(SysOperLog operLog)
    {
        operLogMapper.insertSelective(operLog);
    }

    /**
     * 清空操作日志
     */
    @Override
    public void cleanOperLog()
    {
        operLogMapper.deleteByQuery(QueryWrapper.create());
    }
}

