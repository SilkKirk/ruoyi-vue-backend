package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.system.domain.SysLogininfor;
import com.ruoyi.system.mapper.SysLogininforMapper;
import com.ruoyi.system.service.ISysLogininforService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

/**
 * 系统访问日志情况信息 服务层处理
 * 
 * @author ruoyi
 */
@Service
public class SysLogininforServiceImpl extends ServiceImpl<SysLogininforMapper, SysLogininfor> implements ISysLogininforService
{

    @Autowired
    private SysLogininforMapper logininforMapper;

    @Override
    public List<SysLogininfor> selectLogininforList(SysLogininfor logininfor) {
        QueryWrapper qw = buildLogininforQuery(logininfor);
        return logininforMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysLogininfor> selectLogininforPage(Page<SysLogininfor> page, SysLogininfor logininfor) {
        QueryWrapper qw = buildLogininforQuery(logininfor);
        return logininforMapper.paginate(page, qw);
    }

    private QueryWrapper buildLogininforQuery(SysLogininfor logininfor) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(logininfor.getIpaddr())) qw.like(SysLogininfor::getIpaddr, logininfor.getIpaddr());
        if (StrUtil.isNotEmpty(logininfor.getStatus())) qw.eq(SysLogininfor::getStatus, logininfor.getStatus());
        if (StrUtil.isNotEmpty(logininfor.getUserName())) qw.like(SysLogininfor::getUserName, logininfor.getUserName());
        if (ObjectUtil.isNotNull(logininfor.getParams().get("beginTime"))) qw.ge(SysLogininfor::getLoginTime, logininfor.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(logininfor.getParams().get("endTime"))) qw.le(SysLogininfor::getLoginTime, logininfor.getParams().get("endTime"));
        qw.orderBy(SysLogininfor::getInfoId, false);
        return qw;
    }

    /**
     * 新增系统登录日志
     * 
     * @param logininfor 访问日志对象
     */
    @Override
    public void insertLogininfor(SysLogininfor logininfor)
    {
        logininforMapper.insertSelective(logininfor);
    }

    /**
     * 清空系统登录日志
     */
    @Override
    public void cleanLogininfor()
    {
        logininforMapper.deleteByQuery(QueryWrapper.create());
    }
}

