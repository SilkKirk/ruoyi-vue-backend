package com.ruoyi.system.service.impl;

import com.mybatisflex.core.row.Db;
import com.mybatisflex.core.row.Row;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.system.domain.SysNotice;
import com.ruoyi.system.domain.SysNoticeRead;
import com.ruoyi.system.mapper.SysNoticeReadMapper;
import com.ruoyi.system.service.ISysNoticeReadService;
import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.util.StrUtil;

@Service
public class SysNoticeReadServiceImpl extends ServiceImpl<SysNoticeReadMapper, SysNoticeRead> implements ISysNoticeReadService
{
    @Autowired private SysNoticeReadMapper noticeReadMapper;

    @Override
    public void markRead(Long noticeId, Long userId) {
        SysNoticeRead record = new SysNoticeRead(); record.setNoticeId(noticeId); record.setUserId(userId); record.setReadTime(new Date());
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
        String sql = "SELECT n.notice_id, n.notice_title, n.notice_type, n.status, n.create_by, n.create_time, "
                   + "CASE WHEN r.notice_id IS NOT NULL THEN 1 ELSE 0 END AS isRead "
                   + "FROM sys_notice n "
                   + "LEFT JOIN sys_notice_read r ON r.notice_id = n.notice_id AND r.user_id = ? "
                   + "WHERE n.status = '0' ORDER BY n.notice_id DESC LIMIT ?";
        List<Row> rows = Db.selectListBySql(sql, userId, limit);
        List<SysNotice> list = new ArrayList<>();
        for (Row row : rows) {
            SysNotice notice = new SysNotice();
            notice.setNoticeId(row.getLong("notice_id"));
            notice.setNoticeTitle(row.getString("notice_title"));
            notice.setNoticeType(row.getString("notice_type"));
            notice.setStatus(row.getString("status"));
            notice.setCreateBy(row.getString("create_by"));
            Object ct = row.get("create_time");
            if (ct instanceof Date) notice.setCreateTime((Date) ct);
            notice.setIsRead(row.getBoolean("isRead"));
            list.add(notice);
        }
        return list;
    }

    @Override
    public void markReadBatch(Long userId, Long[] noticeIds) {
        if (ArrayUtil.isEmpty(noticeIds)) return;
        Date now = new Date();
        List<SysNoticeRead> list = new ArrayList<>();
        for (Long noticeId : noticeIds) {
            SysNoticeRead record = new SysNoticeRead();
            record.setNoticeId(noticeId); record.setUserId(userId); record.setReadTime(now);
            list.add(record);
        }
        noticeReadMapper.insertBatch(list);
    }

    @Override
    public List<Map<String, Object>> selectReadUsersByNoticeId(Long noticeId, String searchValue) {
        StringBuilder sql = new StringBuilder(
            "SELECT u.user_id, u.user_name, u.nick_name, d.dept_name, u.phonenumber, r.read_time "
            + "FROM sys_notice_read r "
            + "INNER JOIN sys_user u ON u.user_id = r.user_id AND u.del_flag = '0' "
            + "LEFT JOIN sys_dept d ON d.dept_id = u.dept_id "
            + "WHERE r.notice_id = ?"
        );
        List<Object> params = new ArrayList<>();
        params.add(noticeId);
        if (StrUtil.isNotBlank(searchValue)) {
            sql.append(" AND (u.user_name LIKE ? OR u.nick_name LIKE ?)");
            String likeVal = "%" + searchValue + "%";
            params.add(likeVal);
            params.add(likeVal);
        }
        sql.append(" ORDER BY r.read_time DESC");
        List<Row> rows = Db.selectListBySql(sql.toString(), params.toArray());
        List<Map<String, Object>> result = new ArrayList<>();
        for (Row row : rows) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("userId", row.getLong("user_id"));
            map.put("userName", row.getString("user_name"));
            map.put("nickName", row.getString("nick_name"));
            map.put("deptName", row.getString("dept_name"));
            map.put("phonenumber", row.getString("phonenumber"));
            Object rt = row.get("read_time");
            map.put("readTime", rt);
            result.add(map);
        }
        return result;
    }

    @Override
    public void deleteByNoticeIds(Long[] noticeIds) {
        noticeReadMapper.deleteByQuery(QueryWrapper.create().where(SysNoticeRead::getNoticeId).in(java.util.Arrays.asList(noticeIds)));
    }
}
