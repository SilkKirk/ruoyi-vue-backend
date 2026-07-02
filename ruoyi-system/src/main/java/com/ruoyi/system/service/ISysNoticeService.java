package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import com.mybatisflex.core.paginate.Page;
import java.util.List;
import com.ruoyi.system.domain.SysNotice;

/**
 * 公告 服务层
 * 
 * @author ruoyi
 */
public interface ISysNoticeService extends IService<SysNotice>
{
    /**
     * 查询公告列表
     */
    public List<SysNotice> selectNoticeList(SysNotice notice);

    /**
     * 分页查询公告
     */
    public Page<SysNotice> selectNoticePage(Page<SysNotice> page, SysNotice notice);
}
