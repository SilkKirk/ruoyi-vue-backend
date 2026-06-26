package com.ruoyi.system.domain;

import com.mybatisflex.annotation.Table;
import com.mybatisflex.annotation.Id;
import lombok.Data;

/**
 * 角色和菜单关联 sys_role_menu
 * 
 * @author ruoyi
 */
@Table("sys_role_menu")
@Data
public class SysRoleMenu
{
    /** 角色ID */
@Id
    private Long roleId;
    
    /** 菜单ID */
@Id
    private Long menuId;
}
