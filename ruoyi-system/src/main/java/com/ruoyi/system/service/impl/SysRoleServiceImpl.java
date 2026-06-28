package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.io.Serializable;
import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DataScopeHelper;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysRoleDept;
import com.ruoyi.system.domain.SysRoleMenu;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.system.mapper.SysRoleDeptMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysRoleMenuMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.service.ISysRoleService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.collection.CollUtil;

@Service
public class SysRoleServiceImpl extends ServiceImpl<SysRoleMapper, SysRole> implements ISysRoleService
{
    @Autowired private SysRoleMapper roleMapper;
    @Autowired private SysRoleMenuMapper roleMenuMapper;
    @Autowired private SysUserRoleMapper userRoleMapper;
    @Autowired private SysRoleDeptMapper roleDeptMapper;

    @Override
    public List<SysRole> selectRoleList(SysRole role) {
        QueryWrapper qw = buildRoleQuery(role);
        return roleMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysRole> selectRolePage(Page<SysRole> page, SysRole role) {
        QueryWrapper qw = buildRoleQuery(role);
        return roleMapper.paginate(page, qw);
    }

    private QueryWrapper buildRoleQuery(SysRole role) {
        QueryWrapper qw = QueryWrapper.create().from("sys_role").as("r");
        if (StrUtil.isNotEmpty(role.getRoleName())) qw.like(SysRole::getRoleName, role.getRoleName());
        if (StrUtil.isNotEmpty(role.getRoleKey())) qw.like(SysRole::getRoleKey, role.getRoleKey());
        if (StrUtil.isNotEmpty(role.getStatus())) qw.eq(SysRole::getStatus, role.getStatus());
        if (ObjectUtil.isNotNull(role.getParams().get("beginTime"))) qw.ge(SysRole::getCreateTime, role.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(role.getParams().get("endTime"))) qw.le(SysRole::getCreateTime, role.getParams().get("endTime"));
        // 非超级管理员：隐藏超级管理员角色，并按数据权限过滤可查看的角色
        if (!SecurityUtils.isAdmin()) {
            qw.and("r.role_id <> 1");
            // 应用数据权限过滤（由 @DataScope 注解注入条件）
            DataScopeHelper.applyDataScope(qw, role.getParams());
        }
        // 查询单表字段，不需要group by
        qw.select("r.*");
        qw.orderBy(SysRole::getRoleSort, true);
        return qw;
    }

    @Override
    public List<SysRole> selectRolesByUserId(Long userId) {
        List<SysRole> userRoles = roleMapper.selectListByQuery(
            QueryWrapper.create()
                .select("r.*").from("sys_role").as("r")
                .leftJoin("sys_user_role").as("ur").on("r.role_id = ur.role_id")
                .where("ur.user_id = ?", userId)
        );
        List<SysRole> roles = selectRoleAll();
        for (SysRole role : roles)
            for (SysRole userRole : userRoles)
                if (role.getRoleId().longValue() == userRole.getRoleId().longValue()) { role.setFlag(true); break; }
        return roles;
    }

    @Override
    public Set<String> selectRolePermissionByUserId(Long userId) {
        List<SysRole> perms = roleMapper.selectListByQuery(
            QueryWrapper.create()
                .select("r.*").from("sys_role").as("r")
                .leftJoin("sys_user_role").as("ur").on("r.role_id = ur.role_id")
                .where("ur.user_id = ? and r.del_flag = '0'", userId)
        );
        Set<String> permsSet = new HashSet<>();
        for (SysRole perm : perms)
            if (perm != null) permsSet.addAll(Arrays.asList(perm.getRoleKey().trim().split(",")));
        return permsSet;
    }

    @Override public List<SysRole> selectRoleAll() { return selectRoleList(new SysRole()); }

    @Override
    public List<Long> selectRoleListByUserId(Long userId) {
        return userRoleMapper.selectListByQuery(
            QueryWrapper.create().select(SysUserRole::getRoleId).where(SysUserRole::getUserId).eq(userId)
        ).stream().map(SysUserRole::getRoleId).toList();
    }

    @Override
    public boolean checkRoleNameUnique(SysRole role) {
        return roleMapper.selectCountByQuery(
            QueryWrapper.create().where(SysRole::getRoleName).eq(role.getRoleName())
                .and(SysRole::getRoleId).ne(role.getRoleId() == null ? -1L : role.getRoleId())
        ) == 0;
    }

    @Override
    public boolean checkRoleKeyUnique(SysRole role) {
        return roleMapper.selectCountByQuery(
            QueryWrapper.create().where(SysRole::getRoleKey).eq(role.getRoleKey())
                .and(SysRole::getRoleId).ne(role.getRoleId() == null ? -1L : role.getRoleId())
        ) == 0;
    }

    @Override
    public void checkRoleAllowed(SysRole role) {
        if (role != null && role.isAdmin()) throw new ServiceException("不允许操作超级管理员角色");
    }

    @Override
    public void checkRoleDataScope(Long... roleIds) {
        if (!SecurityUtils.isAdmin()) {
            for (Long roleId : roleIds) {
                SysRole role = new SysRole(); role.setRoleId(roleId);
                if (CollUtil.isEmpty(selectRoleList(role)))
                    throw new ServiceException("没有权限访问角色数据！");
            }
        }
    }

    @Override
    public int countUserRoleByRoleId(Long roleId) {
        return (int) userRoleMapper.selectCountByQuery(QueryWrapper.create().where(SysUserRole::getRoleId).eq(roleId));
    }

    @Override @Transactional
    public boolean save(SysRole role) { roleMapper.insertSelective(role); return insertRoleMenu(role) > 0; }

    @Override @Transactional
    public boolean updateById(SysRole role) {
        roleMapper.update(role);
        // 只有表单包含菜单数据时才更新菜单关联
        if (role.getMenuIds() != null) {
            roleMenuMapper.deleteByQuery(QueryWrapper.create().where(SysRoleMenu::getRoleId).eq(role.getRoleId()));
            return insertRoleMenu(role) > 0;
        }
        return true;
    }

    @Override public int updateRoleStatus(SysRole role) { return roleMapper.update(role); }

    @Override @Transactional
    public int authDataScope(SysRole role) {
        roleMapper.update(role);
        roleDeptMapper.deleteByQuery(QueryWrapper.create().where(SysRoleDept::getRoleId).eq(role.getRoleId()));
        return insertRoleDept(role);
    }

    public int insertRoleMenu(SysRole role) {
        if (role.getMenuIds() == null || role.getMenuIds().length == 0) return 1;
        List<SysRoleMenu> list = new ArrayList<>();
        for (Long menuId : role.getMenuIds()) { SysRoleMenu rm = new SysRoleMenu(); rm.setRoleId(role.getRoleId()); rm.setMenuId(menuId); list.add(rm); }
        roleMenuMapper.insertBatch(list, list.size());
        return list.size();
    }

    public int insertRoleDept(SysRole role) {
        if (role.getDeptIds() == null || role.getDeptIds().length == 0) return 1;
        List<SysRoleDept> list = new ArrayList<>();
        for (Long deptId : role.getDeptIds()) { SysRoleDept rd = new SysRoleDept(); rd.setRoleId(role.getRoleId()); rd.setDeptId(deptId); list.add(rd); }
        roleDeptMapper.insertBatch(list, list.size());
        return list.size();
    }

    @Override @Transactional
    public boolean removeById(Serializable roleId) {
        roleMenuMapper.deleteByQuery(QueryWrapper.create().where(SysRoleMenu::getRoleId).eq(roleId));
        roleDeptMapper.deleteByQuery(QueryWrapper.create().where(SysRoleDept::getRoleId).eq(roleId));
        return roleMapper.deleteById((Long) roleId) > 0;
    }

    @Override @Transactional
    public boolean removeByIds(Collection<? extends Serializable> roleIds) {
        for (Serializable id : roleIds) {
            Long roleId = (Long) id;
            checkRoleAllowed(new SysRole(roleId)); checkRoleDataScope(roleId);
            SysRole role = getById(roleId);
            if (countUserRoleByRoleId(roleId) > 0) throw new ServiceException(String.format("%1$s已分配,不能删除", role.getRoleName()));
        }
        roleMenuMapper.deleteByQuery(QueryWrapper.create().where(SysRoleMenu::getRoleId).in(roleIds));
        roleDeptMapper.deleteByQuery(QueryWrapper.create().where(SysRoleDept::getRoleId).in(roleIds));
        return roleMapper.deleteBatchByIds(roleIds) > 0;
    }

    @Override
    public int deleteAuthUser(SysUserRole userRole) {
        return userRoleMapper.deleteByQuery(QueryWrapper.create().where(SysUserRole::getUserId).eq(userRole.getUserId()).and(SysUserRole::getRoleId).eq(userRole.getRoleId()));
    }

    @Override
    public int deleteAuthUsers(Long roleId, Long[] userIds) {
        return userRoleMapper.deleteByQuery(QueryWrapper.create().where(SysUserRole::getRoleId).eq(roleId).and(SysUserRole::getUserId).in(Arrays.asList(userIds)));
    }

    @Override
    public int insertAuthUsers(Long roleId, Long[] userIds) {
        List<SysUserRole> list = new ArrayList<>();
        for (Long userId : userIds) { SysUserRole ur = new SysUserRole(); ur.setUserId(userId); ur.setRoleId(roleId); list.add(ur); }
        return userRoleMapper.insertBatch(list, list.size());
    }
}

