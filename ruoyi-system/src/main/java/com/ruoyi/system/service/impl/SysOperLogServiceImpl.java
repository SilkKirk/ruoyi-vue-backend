package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysOperLog;
import com.ruoyi.system.mapper.SysOperLogMapper;
import com.ruoyi.system.service.ISysOperLogService;

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
     * 查询系统操作日志集合
     * 
     * @param operLog 操作日志对象
     * @return 操作日志集合
     */
    @Override
    public List<SysOperLog> selectOperLogList(SysOperLog operLog)
    {
        QueryWrapper qw = buildOperLogQuery(operLog);
        return operLogMapper.selectListByQuery(qw);
    }

    private QueryWrapper buildOperLogQuery(SysOperLog operLog) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(operLog.getOperIp())) qw.like(SysOperLog::getOperIp, operLog.getOperIp());
        if (StringUtils.isNotEmpty(operLog.getTitle())) qw.like(SysOperLog::getTitle, operLog.getTitle());
        if (StringUtils.isNotNull(operLog.getBusinessType())) qw.eq(SysOperLog::getBusinessType, operLog.getBusinessType());
        if (StringUtils.isNotNull(operLog.getStatus())) qw.eq(SysOperLog::getStatus, operLog.getStatus());
        if (StringUtils.isNotEmpty(operLog.getOperName())) qw.like(SysOperLog::getOperName, operLog.getOperName());
        if (StringUtils.isNotNull(operLog.getParams().get("beginTime"))) qw.ge(SysOperLog::getOperTime, operLog.getParams().get("beginTime"));
        if (StringUtils.isNotNull(operLog.getParams().get("endTime"))) qw.le(SysOperLog::getOperTime, operLog.getParams().get("endTime"));
        qw.orderBy(SysOperLog::getOperId, false);
        return qw;
    }

    @Override
    public Page<SysOperLog> selectOperLogPage(Page<SysOperLog> page, SysOperLog operLog)
    {
        QueryWrapper qw = buildOperLogQuery(operLog);
        return operLogMapper.paginate(page, qw);
    }

    /**
     * 批量删除系统操作日志
     * 
     * @param operIds 需要删除的操作日志ID
     * @return 结果
     */
    @Override
    public int deleteOperLogByIds(Long[] operIds)
    {
        return operLogMapper.deleteBatchByIds(Arrays.asList(operIds));
    }

    /**
     * 查询操作日志详细
     * 
     * @param operId 操作ID
     * @return 操作日志对象
     */
    @Override
    public SysOperLog selectOperLogById(Long operId)
    {
        return operLogMapper.selectOneById(operId);
    }

    /**
     * 清空操作日志
     */
    @Override
    public void cleanOperLog()
    {
        operLogMapper.deleteByQuery(QueryWrapper.create().where("1=1"));
    }
}
