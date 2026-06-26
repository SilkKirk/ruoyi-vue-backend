package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.mapper.SysNoticeMapper;
import com.ruoyi.system.service.ISysNoticeService;

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

    /**
     * 查询公告信息
     * 
     * @param noticeId 公告ID
     * @return 公告信息
     */
    @Override
    public SysNotice selectNoticeById(Long noticeId)
    {
        return noticeMapper.selectOneById(noticeId);
    }

    /**
     * 查询公告列表
     * 
     * @param notice 公告信息
     * @return 公告集合
     */
    @Override
    public List<SysNotice> selectNoticeList(SysNotice notice)
    {
        QueryWrapper qw = buildNoticeQuery(notice);
        return noticeMapper.selectListByQuery(qw);
    }

    private QueryWrapper buildNoticeQuery(SysNotice notice) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(notice.getNoticeTitle())) qw.like(SysNotice::getNoticeTitle, notice.getNoticeTitle());
        if (StringUtils.isNotEmpty(notice.getNoticeType())) qw.eq(SysNotice::getNoticeType, notice.getNoticeType());
        if (StringUtils.isNotEmpty(notice.getCreateBy())) qw.like(SysNotice::getCreateBy, notice.getCreateBy());
        if (StringUtils.isNotNull(notice.getParams().get("beginTime"))) qw.ge(SysNotice::getCreateTime, notice.getParams().get("beginTime"));
        if (StringUtils.isNotNull(notice.getParams().get("endTime"))) qw.le(SysNotice::getCreateTime, notice.getParams().get("endTime"));
        qw.orderBy(SysNotice::getCreateTime, false);
        return qw;
    }

    @Override
    public Page<SysNotice> selectNoticePage(Page<SysNotice> page, SysNotice notice)
    {
        QueryWrapper qw = buildNoticeQuery(notice);
        return noticeMapper.paginate(page, qw);
    }

    /**
     * 新增公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    @Override
    public int insertNotice(SysNotice notice)
    {
        return noticeMapper.insertSelective(notice);
    }

    /**
     * 修改公告
     * 
     * @param notice 公告信息
     * @return 结果
     */
    @Override
    public int updateNotice(SysNotice notice)
    {
        return noticeMapper.update(notice);
    }

    /**
     * 删除公告对象
     * 
     * @param noticeId 公告ID
     * @return 结果
     */
    @Override
    public int deleteNoticeById(Long noticeId)
    {
        return noticeMapper.deleteById(noticeId);
    }

    /**
     * 批量删除公告信息
     * 
     * @param noticeIds 需要删除的公告ID
     * @return 结果
     */
    @Override
    public int deleteNoticeByIds(Long[] noticeIds)
    {
        return noticeMapper.deleteBatchByIds(Arrays.asList(noticeIds));
    }
}
