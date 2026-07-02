package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;
import jakarta.validation.Validator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.utils.DataScopeHelper;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanValidators;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.system.domain.SysPost;
import com.ruoyi.system.domain.SysUserPost;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.system.mapper.*;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.system.service.*;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.collection.CollUtil;

@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements ISysUserService
{
    private static final Logger log = LoggerFactory.getLogger(SysUserServiceImpl.class);

    @Autowired private SysUserMapper userMapper;
    @Autowired private SysDeptMapper deptMapper;
    @Autowired private SysRoleMapper roleMapper;
    @Autowired private SysPostMapper postMapper;
    @Autowired private SysUserRoleMapper userRoleMapper;
    @Autowired private SysUserPostMapper userPostMapper;
    @Autowired private ISysConfigService configService;
    @Autowired private ISysDeptService deptService;
    @Autowired protected Validator validator;

    @Override
    public List<SysUser> selectUserList(SysUser user) {
        QueryWrapper qw = buildUserQuery(user);
        return userMapper.selectListByQuery(qw);
    }

    @Override
    public List<SysUser> selectAllocatedList(SysUser user) {
        QueryWrapper qw = buildUserQuery(user);
        qw.and("exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = ?)", user.getRoleId());
        return userMapper.selectListByQuery(qw);
    }

    @Override
    public List<SysUser> selectUnallocatedList(SysUser user) {
        QueryWrapper qw = buildUserQuery(user);
        qw.and("not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = ?)", user.getRoleId());
        return userMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysUser> selectUserPage(Page<SysUser> page, SysUser user) {
        QueryWrapper qw = buildUserQuery(user);
        return userMapper.paginate(page, qw);
    }

    @Override
    public Page<SysUser> selectAllocatedPage(Page<SysUser> page, SysUser user) {
        QueryWrapper qw = buildUserQuery(user);
        qw.and("exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = ?)", user.getRoleId());
        return userMapper.paginate(page, qw);
    }

    @Override
    public Page<SysUser> selectUnallocatedPage(Page<SysUser> page, SysUser user) {
        QueryWrapper qw = buildUserQuery(user);
        qw.and("not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = ?)", user.getRoleId());
        return userMapper.paginate(page, qw);
    }

    private QueryWrapper buildUserQuery(SysUser user) {
        QueryWrapper qw = QueryWrapper.create();
        qw.from("sys_user").as("u")
            .leftJoin("sys_dept").as("d").on("u.dept_id = d.dept_id")
            .select("u.*, d.dept_name, d.leader")
            .where("u.del_flag = '0'");
        if (ObjectUtil.isNotNull(user.getUserId()) && user.getUserId() != 0) qw.eq("u.user_id", user.getUserId());
        if (StrUtil.isNotEmpty(user.getUserName())) qw.like("u.user_name", user.getUserName());
        if (StrUtil.isNotEmpty(user.getStatus())) qw.eq("u.status", user.getStatus());
        if (StrUtil.isNotEmpty(user.getPhonenumber())) qw.like("u.phonenumber", user.getPhonenumber());
        if (ObjectUtil.isNotNull(user.getDeptId()) && user.getDeptId() != 0)
            qw.and("(u.dept_id = ? or u.dept_id in (select t.dept_id from sys_dept t where find_in_set(?, ancestors)))", user.getDeptId(), user.getDeptId());
        if (ObjectUtil.isNotNull(user.getParams().get("beginTime"))) qw.ge("u.create_time", user.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(user.getParams().get("endTime"))) qw.le("u.create_time", user.getParams().get("endTime"));
        // 应用数据权限过滤条件（由 @DataScope 注解触发注入）
        DataScopeHelper.applyDataScope(qw, user.getParams());
        return qw;
    }

    @Override
    public SysUser selectUserByUserName(String userName) {
        SysUser user = userMapper.selectOneByQuery(
            QueryWrapper.create().where(SysUser::getUserName).eq(userName).and(SysUser::getDelFlag).eq("0")
        );
        if (user != null && user.getDeptId() != null) {
            user.setDept(deptMapper.selectOneById(user.getDeptId()));
        }
        if (user != null) {
            user.setRoles(roleMapper.selectListByQuery(
                QueryWrapper.create()
                    .select("r.*").from("sys_role").as("r")
                    .leftJoin("sys_user_role").as("ur").on("r.role_id = ur.role_id")
                    .where("ur.user_id = ?", user.getUserId())
            ));
        }
        return user;
    }

    @Override public SysUser getById(Serializable userId) {
        return selectUserById((Long) userId);
    }

    @Override public SysUser selectUserById(Long userId) {
        SysUser user = userMapper.selectOneById(userId);
        if (user != null && user.getDeptId() != null) {
            user.setDept(deptMapper.selectOneById(user.getDeptId()));
        }
        if (user != null) {
            user.setRoles(roleMapper.selectListByQuery(
                QueryWrapper.create()
                    .select("r.*").from("sys_role").as("r")
                    .leftJoin("sys_user_role").as("ur").on("r.role_id = ur.role_id")
                    .where("ur.user_id = ?", userId)
            ));
        }
        return user;
    }

    @Override
    public String selectUserRoleGroup(String userName) {
        List<SysRole> list = roleMapper.selectListByQuery(
            QueryWrapper.create()
                .select("r.*").from("sys_role").as("r")
                .leftJoin("sys_user_role").as("ur").on("r.role_id = ur.role_id")
                .leftJoin("sys_user").as("u").on("u.user_id = ur.user_id")
                .where("u.user_name = ?", userName)
        );
        return CollectionUtils.isEmpty(list) ? StrUtil.EMPTY : list.stream().map(SysRole::getRoleName).collect(Collectors.joining(","));
    }

    @Override
    public String selectUserPostGroup(String userName) {
        List<SysPost> list = postMapper.selectListByQuery(
            QueryWrapper.create()
                .select("p.*").from("sys_post").as("p")
                .leftJoin("sys_user_post").as("up").on("p.post_id = up.post_id")
                .leftJoin("sys_user").as("u").on("u.user_id = up.user_id")
                .where("u.user_name = ?", userName)
        );
        return CollectionUtils.isEmpty(list) ? StrUtil.EMPTY : list.stream().map(SysPost::getPostName).collect(Collectors.joining(","));
    }

    @Override
    public boolean checkUserNameUnique(SysUser user) {
        return userMapper.selectCountByQuery(
            QueryWrapper.create().where(SysUser::getUserName).eq(user.getUserName()).and(SysUser::getDelFlag).eq("0")
                .and(SysUser::getUserId).ne(user.getUserId() == null ? -1L : user.getUserId())
        ) == 0;
    }

    @Override
    public boolean checkPhoneUnique(SysUser user) {
        return userMapper.selectCountByQuery(
            QueryWrapper.create().where(SysUser::getPhonenumber).eq(user.getPhonenumber()).and(SysUser::getDelFlag).eq("0")
                .and(SysUser::getUserId).ne(user.getUserId() == null ? -1L : user.getUserId())
        ) == 0;
    }

    @Override
    public boolean checkEmailUnique(SysUser user) {
        return userMapper.selectCountByQuery(
            QueryWrapper.create().where(SysUser::getEmail).eq(user.getEmail()).and(SysUser::getDelFlag).eq("0")
                .and(SysUser::getUserId).ne(user.getUserId() == null ? -1L : user.getUserId())
        ) == 0;
    }

    @Override
    public void checkUserAllowed(SysUser user) {
        if (ObjectUtil.isNotNull(user.getUserId()) && user.isAdmin()) throw new ServiceException("不允许操作超级管理员用户");
    }

    @Override
    public void checkUserDataScope(Long userId) {
        if (!SecurityUtils.isAdmin()) {
            SysUser user = new SysUser(); user.setUserId(userId);
            if (CollUtil.isEmpty(selectUserList(user))) throw new ServiceException("没有权限访问用户数据！");
        }
    }

    @Override @Transactional
    public boolean save(SysUser user) {
        int rows = userMapper.insertSelective(user);
        insertUserPost(user); insertUserRole(user);
        return rows > 0;
    }

    @Override public boolean registerUser(SysUser user) { return userMapper.insertSelective(user) > 0; }

    @Override @Transactional
    public boolean updateById(SysUser user) {
        Long userId = user.getUserId();
        // 只有表单包含岗位/角色数据时才更新关联
        if (user.getRoleIds() != null) {
            userRoleMapper.deleteByQuery(QueryWrapper.create().where(SysUserRole::getUserId).eq(userId));
            insertUserRole(user);
        }
        if (user.getPostIds() != null) {
            userPostMapper.deleteByQuery(QueryWrapper.create().where(SysUserPost::getUserId).eq(userId));
            insertUserPost(user);
        }
        return userMapper.update(user) > 0;
    }

    @Override @Transactional
    public void insertUserAuth(Long userId, Long[] roleIds) {
        userRoleMapper.deleteByQuery(QueryWrapper.create().where(SysUserRole::getUserId).eq(userId));
        insertUserRole(userId, roleIds);
    }

    @Override
    public int updateUserStatus(SysUser user) {
        return userMapper.update(user);
    }

    @Override public int updateUserProfile(SysUser user) { return userMapper.update(user); }

    @Override
    public boolean updateUserAvatar(Long userId, String avatar) {
        SysUser user = new SysUser(); user.setUserId(userId); user.setAvatar(avatar);
        return userMapper.update(user) > 0;
    }

    @Override
    public void updateLoginInfo(Long userId, String loginIp, Date loginDate) {
        SysUser user = new SysUser(); user.setUserId(userId); user.setLoginIp(loginIp); user.setLoginDate(loginDate);
        userMapper.update(user);
    }

    @Override
    public int resetPwd(SysUser user) {
        SysUser u = new SysUser(); u.setUserId(user.getUserId()); u.setPassword(user.getPassword());
        return userMapper.update(u);
    }

    @Override
    public int resetUserPwd(Long userId, String password) {
        SysUser u = new SysUser(); u.setUserId(userId); u.setPassword(password);
        return userMapper.update(u);
    }

    public void insertUserRole(SysUser user) { insertUserRole(user.getUserId(), user.getRoleIds()); }

    public void insertUserPost(SysUser user) {
        Long[] posts = user.getPostIds();
        if (ArrayUtil.isNotEmpty(posts)) {
            List<SysUserPost> list = new ArrayList<>();
            for (Long postId : posts) { SysUserPost up = new SysUserPost(); up.setUserId(user.getUserId()); up.setPostId(postId); list.add(up); }
            userPostMapper.insertBatch(list, list.size());
        }
    }

    public void insertUserRole(Long userId, Long[] roleIds) {
        if (ArrayUtil.isNotEmpty(roleIds)) {
            List<SysUserRole> list = new ArrayList<>();
            for (Long roleId : roleIds) { SysUserRole ur = new SysUserRole(); ur.setUserId(userId); ur.setRoleId(roleId); list.add(ur); }
            userRoleMapper.insertBatch(list, list.size());
        }
    }

    @Override @Transactional
    public boolean removeById(Serializable userId) {
        userRoleMapper.deleteByQuery(QueryWrapper.create().where(SysUserRole::getUserId).eq(userId));
        userPostMapper.deleteByQuery(QueryWrapper.create().where(SysUserPost::getUserId).eq(userId));
        return userMapper.deleteById(userId) > 0;
    }

    @Override @Transactional
    public boolean removeByIds(Collection<? extends Serializable> userIds) {
        for (Serializable id : userIds) { checkUserAllowed(new SysUser((Long) id)); checkUserDataScope((Long) id); }
        userRoleMapper.deleteByQuery(QueryWrapper.create().where(SysUserRole::getUserId).in(userIds));
        userPostMapper.deleteByQuery(QueryWrapper.create().where(SysUserPost::getUserId).in(userIds));
        return userMapper.deleteBatchByIds(userIds) > 0;
    }

    @Override
    public String importUser(List<SysUser> userList, Boolean isUpdateSupport, String operName) {
        if (ObjectUtil.isNull(userList) || userList.isEmpty()) throw new ServiceException("导入用户数据不能为空！");
        int successNum = 0, failureNum = 0;
        StringBuilder successMsg = new StringBuilder(), failureMsg = new StringBuilder();
        for (SysUser user : userList) {
            try {
                SysUser u = selectUserByUserName(user.getUserName());
                if (ObjectUtil.isNull(u)) {
                    BeanValidators.validateWithException(validator, user);
                    deptService.checkDeptDataScope(user.getDeptId());
                    user.setPassword(SecurityUtils.encryptPassword(configService.selectConfigByKey("sys.user.initPassword")));
                    user.setCreateBy(operName);
                    userMapper.insertSelective(user);
                    successNum++; successMsg.append("<br/>").append(successNum).append("、账号 ").append(user.getUserName()).append(" 导入成功");
                } else if (isUpdateSupport) {
                    BeanValidators.validateWithException(validator, user);
                    checkUserAllowed(u); checkUserDataScope(u.getUserId());
                    deptService.checkDeptDataScope(user.getDeptId());
                    user.setUserId(u.getUserId()); user.setUpdateBy(operName);
                    userMapper.update(user);
                    successNum++; successMsg.append("<br/>").append(successNum).append("、账号 ").append(user.getUserName()).append(" 更新成功");
                } else { failureNum++; failureMsg.append("<br/>").append(failureNum).append("、账号 ").append(user.getUserName()).append(" 已存在"); }
            } catch (Exception e) {
                failureNum++; failureMsg.append("<br/>").append(failureNum).append("、账号 ").append(user.getUserName()).append(" 导入失败：").append(e.getMessage());
                log.error(failureMsg.toString(), e);
            }
        }
        if (failureNum > 0) { failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下："); throw new ServiceException(failureMsg.toString()); }
        else successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        return successMsg.toString();
    }
}
