package com.ruoyi.system.domain;

import java.util.Date;
import com.mybatisflex.annotation.Table;
import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import lombok.Data;

/**
 * 公告已读记录表 sys_notice_read
 *
 * @author ruoyi
 */
@Table("sys_notice_read")
@Data
public class SysNoticeRead
{
    /** 主键 */
@Id(keyType = KeyType.Auto)
    private Long readId;

    /** 公告ID */
    private Long noticeId;

    /** 用户ID */
    private Long userId;

    /** 阅读时间 */
    private Date readTime;
}
