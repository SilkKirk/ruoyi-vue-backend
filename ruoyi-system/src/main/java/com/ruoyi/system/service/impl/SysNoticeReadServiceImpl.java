package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.domain.SysNoticeRead;
import com.ruoyi.system.mapper.SysNoticeReadMapper;
import com.ruoyi.system.service.ISysNoticeReadService;

@Service
public class SysNoticeReadServiceImpl extends ServiceImpl<SysNoticeReadMapper, SysNoticeRead> implements ISysNoticeReadService
{
    @Autowired private SysNoticeReadMapper noticeReadMapper;

    @Override
    public void markRead(Long noticeId, Long userId) {
        SysNoticeRead record = new SysNoticeRead(); record.setNoticeId(noticeId); record.setUserId(userId);
        noticeReadMapper.insertSelective(record);
    }

    @Override
    public int selectUnreadCount(Long userId) {
        return (int) noticeReadMapper.selectCountByQuery(
            QueryWrapper.create().where(SysNoticeRead::getUserId).eq(userId)
        );
    }

    @Override
    public List<SysNotice> selectNoticeListWithReadStatus(Long userId, int limit) {
        // 复杂查询可通过 MyBatis-Flex Db + Row 或返回自定义结果
        return List.of();
    }

    @Override
    public void markReadBatch(Long userId, Long[] noticeIds) {
        if (noticeIds == null || noticeIds.length == 0) return;
        for (Long noticeId : noticeIds) markRead(noticeId, userId);
    }

    @Override public List<Map<String, Object>> selectReadUsersByNoticeId(Long noticeId, String searchValue) { return List.of(); }
    @Override
    public void deleteByNoticeIds(Long[] noticeIds) {
        noticeReadMapper.deleteByQuery(QueryWrapper.create().where(SysNoticeRead::getNoticeId).in(java.util.Arrays.asList(noticeIds)));
    }
}
