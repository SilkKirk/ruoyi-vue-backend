package com.ruoyi.system.domain;

import com.mybatisflex.annotation.Table;
import com.mybatisflex.annotation.Id;
import lombok.Data;

/**
 * 角色和部门关联 sys_role_dept
 * 
 * @author ruoyi
 */
@Table("sys_role_dept")
@Data
public class SysRoleDept
{
    /** 角色ID */
@Id
    private Long roleId;
    
    /** 部门ID */
@Id
    private Long deptId;
}
