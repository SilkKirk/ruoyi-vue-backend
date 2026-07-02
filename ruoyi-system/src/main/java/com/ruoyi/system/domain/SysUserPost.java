package com.ruoyi.system.domain;

import com.mybatisflex.annotation.Table;
import com.mybatisflex.annotation.Id;
import lombok.Data;

/**
 * 用户和岗位关联 sys_user_post
 * 
 * @author ruoyi
 */
@Table("sys_user_post")
@Data
public class SysUserPost
{
    /** 用户ID */
@Id
    private Long userId;
    
    /** 岗位ID */
@Id
    private Long postId;
}
