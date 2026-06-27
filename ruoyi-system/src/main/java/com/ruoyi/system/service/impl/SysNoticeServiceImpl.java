package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.mapper.SysNoticeMapper;
import com.ruoyi.system.service.ISysNoticeService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

/**
 * 公告 服务层实现
 * 
 * @author ruoyi
 */
@Service
public class SysNoticeServiceImpl extends ServiceImpl<SysNoticeMapper, SysNotice> implements ISysNoticeService
{
    @Autowired
    private SysNoticeMapper noticeMapper;

    @Override
    public List<SysNotice> selectNoticeList(SysNotice notice) {
        QueryWrapper qw = buildNoticeQuery(notice);
        return noticeMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysNotice> selectNoticePage(Page<SysNotice> page, SysNotice notice) {
        QueryWrapper qw = buildNoticeQuery(notice);
        return noticeMapper.paginate(page, qw);
    }

    private QueryWrapper buildNoticeQuery(SysNotice notice) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(notice.getNoticeTitle())) qw.like(SysNotice::getNoticeTitle, notice.getNoticeTitle());
        if (StrUtil.isNotEmpty(notice.getNoticeType())) qw.eq(SysNotice::getNoticeType, notice.getNoticeType());
        if (StrUtil.isNotEmpty(notice.getCreateBy())) qw.like(SysNotice::getCreateBy, notice.getCreateBy());
        if (ObjectUtil.isNotNull(notice.getParams().get("beginTime"))) qw.ge(SysNotice::getCreateTime, notice.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(notice.getParams().get("endTime"))) qw.le(SysNotice::getCreateTime, notice.getParams().get("endTime"));
        qw.orderBy(SysNotice::getCreateTime, false);
        return qw;
    }
}

