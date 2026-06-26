package com.ruoyi.system.service.impl;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysRoleDept;
import com.ruoyi.system.domain.SysRoleMenu;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.system.mapper.SysRoleDeptMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.mapper.SysRoleMenuMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.service.ISysRoleService;

@Service
public class SysRoleServiceImpl implements ISysRoleService
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

    private QueryWrapper buildRoleQuery(SysRole role) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(role.getRoleName())) qw.like(SysRole::getRoleName, role.getRoleName());
        if (StringUtils.isNotEmpty(role.getRoleKey())) qw.like(SysRole::getRoleKey, role.getRoleKey());
        if (StringUtils.isNotEmpty(role.getStatus())) qw.eq(SysRole::getStatus, role.getStatus());
        if (StringUtils.isNotNull(role.getParams().get("beginTime"))) qw.ge(SysRole::getCreateTime, role.getParams().get("beginTime"));
        if (StringUtils.isNotNull(role.getParams().get("endTime"))) qw.le(SysRole::getCreateTime, role.getParams().get("endTime"));
        qw.orderBy(SysRole::getRoleSort, true);
        return qw;
    }

    @Override
    public Page<SysRole> selectRolePage(Page<SysRole> page, SysRole role) {
        QueryWrapper qw = buildRoleQuery(role);
        return roleMapper.paginate(page, qw);
    }

    @Override
    public List<SysRole> selectRolesByUserId(Long userId) {
        List<SysRole> userRoles = roleMapper.selectListByQuery(
            QueryWrapper.create()
                .select("r.*").from("sys_role").as("r")
                .leftJoin("sys_user_role").as("ur").on("r.role_id = ur.role_id")
                .where("ur.user_id = " + userId)
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
                .where("ur.user_id = " + userId + " and r.del_flag = '0'")
        );
        Set<String> permsSet = new HashSet<>();
        for (SysRole perm : perms)
            if (perm != null) permsSet.addAll(Arrays.asList(perm.getRoleKey().trim().split(",")));
        return permsSet;
    }

    @Override public List<SysRole> selectRoleAll() { return selectRoleList(new SysRole()); }
    @Override public SysRole selectRoleById(Long roleId) { return roleMapper.selectOneById(roleId); }

    @Override
    public List<Long> selectRoleListByUserId(Long userId) {
        return userRoleMapper.selectListByQuery(
            QueryWrapper.create().select(SysUserRole::getRoleId).where(SysUserRole::getUserId).eq(userId)
        ).stream().map(SysUserRole::getRoleId).toList();
    }

    @Override
    public boolean checkRoleNameUnique(SysRole role) {
        Long roleId = StringUtils.isNull(role.getRoleId()) ? -1L : role.getRoleId();
        SysRole info = roleMapper.selectOneByQuery(QueryWrapper.create().where(SysRole::getRoleName).eq(role.getRoleName()));
        return info == null || info.getRoleId().longValue() == roleId.longValue();
    }

    @Override
    public boolean checkRoleKeyUnique(SysRole role) {
        Long roleId = StringUtils.isNull(role.getRoleId()) ? -1L : role.getRoleId();
        SysRole info = roleMapper.selectOneByQuery(QueryWrapper.create().where(SysRole::getRoleKey).eq(role.getRoleKey()));
        return info == null || info.getRoleId().longValue() == roleId.longValue();
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
                if (StringUtils.isEmpty(selectRoleList(role)))
                    throw new ServiceException("没有权限访问角色数据！");
            }
        }
    }

    @Override
    public int countUserRoleByRoleId(Long roleId) {
        return (int) userRoleMapper.selectCountByQuery(QueryWrapper.create().where(SysUserRole::getRoleId).eq(roleId));
    }

    @Override @Transactional
    public int insertRole(SysRole role) { roleMapper.insertSelective(role); return insertRoleMenu(role); }

    @Override @Transactional
    public int updateRole(SysRole role) { roleMapper.update(role); roleMenuMapper.deleteByQuery(QueryWrapper.create().where(SysRoleMenu::getRoleId).eq(role.getRoleId())); return insertRoleMenu(role); }

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
    public int deleteRoleById(Long roleId) {
        roleMenuMapper.deleteByQuery(QueryWrapper.create().where(SysRoleMenu::getRoleId).eq(roleId));
        roleDeptMapper.deleteByQuery(QueryWrapper.create().where(SysRoleDept::getRoleId).eq(roleId));
        return roleMapper.deleteById(roleId);
    }

    @Override @Transactional
    public int deleteRoleByIds(Long[] roleIds) {
        for (Long roleId : roleIds) {
            checkRoleAllowed(new SysRole(roleId)); checkRoleDataScope(roleId);
            SysRole role = selectRoleById(roleId);
            if (countUserRoleByRoleId(roleId) > 0) throw new ServiceException(String.format("%1$s已分配,不能删除", role.getRoleName()));
        }
        roleMenuMapper.deleteByQuery(QueryWrapper.create().where(SysRoleMenu::getRoleId).in(Arrays.asList(roleIds)));
        roleDeptMapper.deleteByQuery(QueryWrapper.create().where(SysRoleDept::getRoleId).in(Arrays.asList(roleIds)));
        return roleMapper.deleteBatchByIds(Arrays.asList(roleIds));
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
