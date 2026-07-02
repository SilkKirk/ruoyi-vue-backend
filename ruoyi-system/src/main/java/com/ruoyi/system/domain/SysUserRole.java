package com.ruoyi.system.domain;

import com.mybatisflex.annotation.Table;
import com.mybatisflex.annotation.Id;
import lombok.Data;

/**
 * 用户和角色关联 sys_user_role
 * 
 * @author ruoyi
 */
@Table("sys_user_role")
@Data
public class SysUserRole
{
    /** 用户ID */
@Id
    private Long userId;
    
    /** 角色ID */
@Id
    private Long roleId;
}
