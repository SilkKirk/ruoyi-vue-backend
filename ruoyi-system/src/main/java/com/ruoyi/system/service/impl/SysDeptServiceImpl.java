package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import com.ruoyi.common.utils.TreeUtils;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.utils.DataScopeHelper;
import com.ruoyi.common.core.domain.TreeSelect;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.mapper.SysRoleMapper;
import com.ruoyi.system.service.ISysDeptService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.collection.CollUtil;

@Service
public class SysDeptServiceImpl extends ServiceImpl<SysDeptMapper, SysDept> implements ISysDeptService
{
    @Autowired private SysDeptMapper deptMapper;
    @Autowired private SysRoleMapper roleMapper;

    @Override
    public List<SysDept> selectDeptList(SysDept dept) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(dept.getDeptName())) qw.like(SysDept::getDeptName, dept.getDeptName());
        if (StrUtil.isNotEmpty(dept.getStatus())) qw.eq(SysDept::getStatus, dept.getStatus());
        // 应用数据权限过滤条件（由 @DataScope 注解触发注入）
        DataScopeHelper.applyDataScope(qw, dept.getParams());
        return deptMapper.selectListByQuery(qw);
    }

    @Override
    public List<TreeSelect> selectDeptTreeList(SysDept dept) {
        // 直接基于数据权限过滤结果构建树，不过滤祖先节点，权限优先
        return buildDeptTreeSelect(selectDeptList(dept));
    }
    @Override
    public int selectNormalChildrenDeptById(Long deptId) {
        return (int) deptMapper.selectCountByQuery(
            QueryWrapper.create().where(SysDept::getParentId).eq(deptId).and(SysDept::getStatus).eq("0")
        );
    }

    @Override public boolean hasChildByDeptId(Long deptId) { return selectNormalChildrenDeptById(deptId) > 0; }

    @Override
    public boolean checkDeptExistUser(Long deptId) {
        return deptMapper.selectCountByQuery(
            QueryWrapper.create().where(SysDept::getDeptId).eq(deptId)
        ) > 0;
    }

    @Override
    public boolean checkDeptNameUnique(SysDept dept) {
        Long deptId = ObjectUtil.isNull(dept.getDeptId()) ? -1L : dept.getDeptId();
        SysDept info = deptMapper.selectOneByQuery(
            QueryWrapper.create().where(SysDept::getDeptName).eq(dept.getDeptName()).and(SysDept::getParentId).eq(dept.getParentId())
        );
        return info == null || info.getDeptId().longValue() == deptId.longValue();
    }

    @Override
    public void checkDeptDataScope(Long deptId) {
        if (!SecurityUtils.isAdmin() && ObjectUtil.isNotNull(deptId)) {
            SysDept dept = new SysDept(); dept.setDeptId(deptId);
            if (CollUtil.isEmpty(selectDeptList(dept)))
                throw new ServiceException("没有权限访问部门数据！");
        }
    }

    @Override
    public List<Long> selectDeptListByRoleId(Long roleId) {
        SysRole role = roleMapper.selectOneById(roleId);
        // 非管理员复用数据权限过滤，只返回用户有权访问的部门
        if (SecurityUtils.isAdmin()) {
            return deptMapper.selectListByQuery(
                QueryWrapper.create().select(SysDept::getDeptId).where(SysDept::getStatus).eq("0")
            ).stream().map(SysDept::getDeptId).toList();
        }
        return selectDeptList(new SysDept()).stream().map(SysDept::getDeptId).toList();
    }

    @Override
    public boolean save(SysDept dept) {
        SysDept info = deptMapper.selectOneById(dept.getParentId());
        if (!UserConstants.DEPT_NORMAL.equals(info.getStatus()))
            throw new ServiceException("部门停用，不允许新增");
        dept.setAncestors(info.getAncestors() + "," + dept.getParentId());
        return deptMapper.insertSelective(dept) > 0;
    }

    @Override
    public boolean updateById(SysDept dept) {
        SysDept newParent = deptMapper.selectOneById(dept.getParentId());
        SysDept oldDept = deptMapper.selectOneById(dept.getDeptId());
        if (newParent != null && oldDept != null) {
            String newAncestors = newParent.getAncestors() + "," + newParent.getDeptId();
            dept.setAncestors(newAncestors);
            updateDeptChildren(dept.getDeptId(), newAncestors, oldDept.getAncestors());
        }
        int result = deptMapper.update(dept);
        if (UserConstants.DEPT_NORMAL.equals(dept.getStatus()) && StrUtil.isNotEmpty(dept.getAncestors())
                && !StrUtil.equals("0", dept.getAncestors()))
            updateParentDeptStatusNormal(dept);
        return result > 0;
    }

    private void updateParentDeptStatusNormal(SysDept dept) {
        String[] ancestorIds = dept.getAncestors().split(",");
        for (String id : ancestorIds) {
            if (!"0".equals(id)) {
                SysDept d = new SysDept(); d.setDeptId(Long.valueOf(id)); d.setStatus("0");
                deptMapper.update(d);
            }
        }
    }

    public void updateDeptChildren(Long deptId, String newAncestors, String oldAncestors) {
        List<SysDept> children = deptMapper.selectListByQuery(
            QueryWrapper.create().where(SysDept::getParentId).eq(deptId)
        );
        for (SysDept child : children)
            child.setAncestors(child.getAncestors().replaceFirst(oldAncestors, newAncestors));
        if (!children.isEmpty())
            children.forEach(deptMapper::update);
    }

    @Override @Transactional(rollbackFor = Exception.class)
    public void updateDeptSort(String[] deptIds, String[] orderNums) {
        for (int i = 0; i < deptIds.length; i++) {
            SysDept dept = new SysDept();
            dept.setDeptId(Long.valueOf(deptIds[i]));
            dept.setOrderNum(Integer.valueOf(orderNums[i]));
            deptMapper.update(dept);
        }
    }

    @Override public List<SysDept> buildDeptTree(List<SysDept> depts) {
        return TreeUtils.buildTree(depts, 0L, SysDept::getDeptId, SysDept::getParentId, SysDept::setChildren);
    }

    @Override public List<TreeSelect> buildDeptTreeSelect(List<SysDept> depts) {
        return buildDeptTree(depts).stream().map(TreeSelect::new).collect(Collectors.toList());
    }
}
