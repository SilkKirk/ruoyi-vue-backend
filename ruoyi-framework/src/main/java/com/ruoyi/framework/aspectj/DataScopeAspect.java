package com.ruoyi.framework.aspectj;

import java.util.ArrayList;
import java.util.List;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.convert.Convert;
import com.ruoyi.common.utils.DataScopeHelper;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.framework.security.context.PermissionContextHolder;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

/**
 * 数据过滤处理
 *
 * @author ruoyi
 */
@Aspect
@Component
public class DataScopeAspect
{
    @Before("@annotation(controllerDataScope)")
    public void doBefore(JoinPoint point, DataScope controllerDataScope) throws Throwable
    {
        clearDataScope(point);
        handleDataScope(point, controllerDataScope);
    }

    protected void handleDataScope(final JoinPoint joinPoint, DataScope controllerDataScope)
    {
        // 获取当前的用户
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (ObjectUtil.isNotNull(loginUser))
        {
            SysUser currentUser = loginUser.getUser();
            // 如果是超级管理员，则不过滤数据
            if (ObjectUtil.isNotNull(currentUser) && !currentUser.isAdmin())
            {
                String permission = StrUtil.emptyToDefault(controllerDataScope.permission(), PermissionContextHolder.getContext());
                dataScopeFilter(joinPoint, currentUser, controllerDataScope.userAlias(), controllerDataScope.deptAlias(), controllerDataScope.userField(), controllerDataScope.deptField(), permission);
            }
        }
    }

    /**
     * 数据范围过滤
     *
     * @param joinPoint 切点
     * @param user 用户
     * @param deptAlias 部门别名
     * @param userAlias 用户别名
     * @param permission 权限字符
     */
    public static void dataScopeFilter(JoinPoint joinPoint, SysUser user, String userAlias, String deptAlias, String userField, String deptField, String permission)
    {
        StringBuilder sqlString = new StringBuilder();
        List<String> conditions = new ArrayList<String>();
        List<String> scopeCustomIds = new ArrayList<String>();
        user.getRoles().forEach(role -> {
            if (Constants.Dept.DATA_SCOPE_CUSTOM.equals(role.getDataScope()) && StrUtil.equals(role.getStatus(), UserConstants.ROLE_NORMAL) && (StrUtil.isEmpty(permission) || CollUtil.containsAny(role.getPermissions(), java.util.Arrays.asList(Convert.toStrArray(permission)))))
            {
                scopeCustomIds.add(Convert.toStr(role.getRoleId()));
            }
        });

        for (SysRole role : user.getRoles())
        {
            String dataScope = role.getDataScope();
            if (conditions.contains(dataScope) || StrUtil.equals(role.getStatus(), UserConstants.ROLE_DISABLE))
            {
                continue;
            }
            if (StrUtil.isNotEmpty(permission) && !CollUtil.containsAny(role.getPermissions(), java.util.Arrays.asList(Convert.toStrArray(permission))))
            {
                continue;
            }
            if (Constants.Dept.DATA_SCOPE_ALL.equals(dataScope))
            {
                sqlString = new StringBuilder();
                conditions.add(dataScope);
                break;
            }
            else if (Constants.Dept.DATA_SCOPE_CUSTOM.equals(dataScope))
            {
                if (scopeCustomIds.size() > 1)
                {
                    // 多个自定数据权限使用in查询，避免多次拼接。
                    // 过滤只保留数字ID，防止SQL注入
                    String safeIds = scopeCustomIds.stream()
                        .filter(id -> id != null && id.matches("\\d+"))
                        .collect(java.util.stream.Collectors.joining(","));
                    if (safeIds.isEmpty()) continue;
                    sqlString.append(StrUtil.format(" OR {}.{} IN ( SELECT dept_id FROM sys_role_dept WHERE role_id in ({}) ) ", deptAlias, deptField, safeIds));
                }
                else
                {
                    sqlString.append(StrUtil.format(" OR {}.{} IN ( SELECT dept_id FROM sys_role_dept WHERE role_id = {} ) ", deptAlias, deptField, role.getRoleId()));
                }
            }
            else if (Constants.Dept.DATA_SCOPE_DEPT.equals(dataScope))
            {
                sqlString.append(StrUtil.format(" OR {}.{} = {} ", deptAlias, deptField, user.getDeptId()));
            }
            else if (Constants.Dept.DATA_SCOPE_DEPT_AND_CHILD.equals(dataScope))
            {
                sqlString.append(StrUtil.format(" OR {}.{} IN ( SELECT dept_id FROM sys_dept WHERE dept_id = {} or find_in_set( {} , ancestors ) )", deptAlias, deptField, user.getDeptId(), user.getDeptId()));
            }
            else if (Constants.Dept.DATA_SCOPE_SELF.equals(dataScope))
            {
                if (StrUtil.isNotBlank(userAlias))
                {
                    sqlString.append(StrUtil.format(" OR {}.{} = {} ", userAlias, userField, user.getUserId()));
                }
                else
                {
                    // 数据权限为仅本人且没有userAlias别名不查询任何数据
                    sqlString.append(StrUtil.format(" OR {}.{} = 0 ", deptAlias, deptField));
                }
            }
            conditions.add(dataScope);
        }

        // 角色都不包含传递过来的权限字符，这个时候sqlString也会为空，所以要限制一下,不查询任何数据
        if (CollUtil.isEmpty(conditions))
        {
            sqlString.append(StrUtil.format(" OR {}.{} = 0 ", deptAlias, deptField));
        }

        if (StrUtil.isNotBlank(sqlString.toString()))
        {
            Object params = joinPoint.getArgs()[0];
            if (ObjectUtil.isNotNull(params) && params instanceof BaseEntity)
            {
                BaseEntity baseEntity = (BaseEntity) params;
                // 去掉开头 " OR "，存储纯条件串，方便 MyBatis-Flex QueryWrapper.and() 直接使用
                baseEntity.getParams().put(DataScopeHelper.DATA_SCOPE, sqlString.substring(4));
            }
        }
    }

    /**
     * 拼接权限sql前先清空params.dataScope参数防止注入
     */
    private void clearDataScope(final JoinPoint joinPoint)
    {
        Object params = joinPoint.getArgs()[0];
        if (ObjectUtil.isNotNull(params) && params instanceof BaseEntity)
        {
            BaseEntity baseEntity = (BaseEntity) params;
            baseEntity.getParams().put(DataScopeHelper.DATA_SCOPE, "");
        }
    }
}
