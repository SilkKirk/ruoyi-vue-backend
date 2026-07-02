package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import com.ruoyi.common.utils.TreeUtils;
import java.util.*;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.TreeSelect;
import com.ruoyi.common.core.domain.entity.SysMenu;
import com.ruoyi.common.core.domain.entity.SysRole;
import cn.hutool.core.convert.Convert;
import cn.hutool.core.collection.CollUtil;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysRoleMenu;
import com.ruoyi.system.domain.vo.MetaVo;
import com.ruoyi.system.domain.vo.RouterVo;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.ISysMenuService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

@Service
public class SysMenuServiceImpl extends ServiceImpl<SysMenuMapper, SysMenu> implements ISysMenuService
{
    private static final Logger log = LoggerFactory.getLogger(SysMenuServiceImpl.class);
    public static final Long MENU_ROOT_ID = 0L;

    @Autowired private SysMenuMapper menuMapper;
    @Autowired private SysRoleMapper roleMapper;
    @Autowired private SysRoleMenuMapper roleMenuMapper;

    @Override public List<SysMenu> selectMenuList(Long userId) { return selectMenuList(new SysMenu(), userId); }

    @Override
    public List<SysMenu> selectMenuList(SysMenu menu, Long userId) {
        if (SecurityUtils.isAdmin(userId)) {
            QueryWrapper qw = QueryWrapper.create();
            if (StrUtil.isNotEmpty(menu.getMenuName())) qw.like(SysMenu::getMenuName, menu.getMenuName());
            if (StrUtil.isNotEmpty(menu.getStatus())) qw.eq(SysMenu::getStatus, menu.getStatus());
            qw.orderBy(SysMenu::getParentId, true).orderBy(SysMenu::getOrderNum, true);
            return menuMapper.selectListByQuery(qw);
        }
        return menuMapper.selectListByQuery(
            QueryWrapper.create()
                .select("distinct m.*")
                .from("sys_menu").as("m")
                .leftJoin("sys_role_menu").as("rm").on("m.menu_id = rm.menu_id")
                .leftJoin("sys_user_role").as("ur").on("rm.role_id = ur.role_id")
                .where("ur.user_id = ? and m.status = '0'", userId)
                .orderBy("m.parent_id", true).orderBy("m.order_num", true)
        );
    }

    @Override
    public Set<String> selectMenuPermsByUserId(Long userId) {
        List<String> perms;
        if (SecurityUtils.isAdmin(userId)) {
            perms = menuMapper.selectListByQuery(
                QueryWrapper.create().select("perms").where("perms is not null and perms != ''")
            ).stream().map(SysMenu::getPerms).collect(Collectors.toList());
        } else {
            perms = menuMapper.selectListByQuery(
                QueryWrapper.create()
                    .select("distinct m.perms").from("sys_menu").as("m")
                    .leftJoin("sys_role_menu").as("rm").on("m.menu_id = rm.menu_id")
                    .leftJoin("sys_user_role").as("ur").on("rm.role_id = ur.role_id")
                    .where("ur.user_id = ? and m.status = '0' and m.perms is not null and m.perms != ''", userId)
            ).stream().map(SysMenu::getPerms).collect(Collectors.toList());
        }
        Set<String> permsSet = new HashSet<>();
        for (String perm : perms) if (StrUtil.isNotEmpty(perm)) permsSet.addAll(Arrays.asList(perm.trim().split(",")));
        return permsSet;
    }

    @Override
    public Set<String> selectMenuPermsByRoleId(Long roleId) {
        List<String> perms = menuMapper.selectListByQuery(
            QueryWrapper.create()
                .select("distinct m.perms").from("sys_menu").as("m")
                .leftJoin("sys_role_menu").as("rm").on("m.menu_id = rm.menu_id")
                .where("rm.role_id = ? and m.perms is not null and m.perms != ''", roleId)
        ).stream().map(SysMenu::getPerms).collect(Collectors.toList());
        Set<String> permsSet = new HashSet<>();
        for (String perm : perms) if (StrUtil.isNotEmpty(perm)) permsSet.addAll(Arrays.asList(perm.trim().split(",")));
        return permsSet;
    }

    @Override
    public List<SysMenu> selectMenuTreeByUserId(Long userId) {
        List<SysMenu> menus;
        if (SecurityUtils.isAdmin(userId)) {
            menus = menuMapper.selectListByQuery(
                QueryWrapper.create()
                    .where(SysMenu::getMenuType).in("M", "C")
                    .and(SysMenu::getStatus).eq("0")
                    .orderBy(SysMenu::getParentId, true).orderBy(SysMenu::getOrderNum, true)
            );
        } else {
            menus = menuMapper.selectListByQuery(
                QueryWrapper.create()
                    .select("distinct m.*").from("sys_menu").as("m")
                    .leftJoin("sys_role_menu").as("rm").on("m.menu_id = rm.menu_id")
                    .leftJoin("sys_user_role").as("ur").on("rm.role_id = ur.role_id")
                    .where("ur.user_id = ? and m.menu_type in ('M','C') and m.status = '0'", userId)
                    .orderBy("m.parent_id", true).orderBy("m.order_num", true)
            );
        }
        return getChildPerms(menus, MENU_ROOT_ID);
    }

    @Override
    public List<Long> selectMenuListByRoleId(Long roleId) {
        SysRole role = roleMapper.selectOneById(roleId);
        QueryWrapper qw = QueryWrapper.create()
            .select("m.menu_id").from("sys_menu").as("m")
            .leftJoin("sys_role_menu").as("rm").on("m.menu_id = rm.menu_id")
            .where("rm.role_id = ?", roleId)
            .orderBy("m.parent_id", true).orderBy("m.order_num", true);
        if (role != null && role.isMenuCheckStrictly()) {
            qw.and("m.menu_id not in (select m.parent_id from sys_menu m inner join sys_role_menu rm on m.menu_id = rm.menu_id and rm.role_id = ?)", roleId);
        }
        return menuMapper.selectListByQuery(qw).stream().map(SysMenu::getMenuId).toList();
    }

    // ============= Router building methods =============
    @Override
    public List<RouterVo> buildMenus(List<SysMenu> menus) {
        List<RouterVo> routers = new LinkedList<>();
        for (SysMenu menu : menus) {
            RouterVo router = new RouterVo();
            router.setHidden("1".equals(menu.getVisible()));
            router.setName(getRouteName(menu)); router.setPath(getRouterPath(menu));
            router.setComponent(getComponent(menu)); router.setQuery(menu.getQuery());
            router.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon(), StrUtil.equals("1", menu.getIsCache()), menu.getPath()));
            List<SysMenu> cMenus = menu.getChildren();
            if (CollUtil.isNotEmpty(cMenus) && UserConstants.TYPE_DIR.equals(menu.getMenuType())) {
                router.setAlwaysShow(true); router.setRedirect("noRedirect"); router.setChildren(buildMenus(cMenus));
            } else if (isMenuFrame(menu)) {
                router.setMeta(null);
                List<RouterVo> childrenList = new ArrayList<>(); RouterVo children = new RouterVo();
                children.setPath(menu.getPath()); children.setComponent(menu.getComponent());
                children.setName(getRouteName(menu.getRouteName(), menu.getPath()));
                children.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon(), StrUtil.equals("1", menu.getIsCache()), menu.getPath()));
                children.setQuery(menu.getQuery()); childrenList.add(children); router.setChildren(childrenList);
            } else if (menu.getParentId().intValue() == MENU_ROOT_ID && isInnerLink(menu)) {
                router.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon())); router.setPath("/");
                List<RouterVo> childrenList = new ArrayList<>(); RouterVo children = new RouterVo();
                children.setPath(innerLinkReplaceEach(menu.getPath())); children.setComponent(UserConstants.INNER_LINK);
                children.setName(getRouteName(menu.getRouteName(), innerLinkReplaceEach(menu.getPath())));
                children.setMeta(new MetaVo(menu.getMenuName(), menu.getIcon(), menu.getPath()));
                childrenList.add(children); router.setChildren(childrenList);
            }
            routers.add(router);
        }
        return routers;
    }

    @Override public List<SysMenu> buildMenuTree(List<SysMenu> menus) {
        return TreeUtils.buildTree(menus, MENU_ROOT_ID, SysMenu::getMenuId, SysMenu::getParentId, SysMenu::setChildren);
    }

    @Override public List<TreeSelect> buildMenuTreeSelect(List<SysMenu> menus) {
        return buildMenuTree(menus).stream().map(TreeSelect::new).collect(Collectors.toList());
    }

    @Override
    public boolean hasChildByMenuId(Long menuId) {
        return menuMapper.selectCountByQuery(QueryWrapper.create().where(SysMenu::getParentId).eq(menuId)) > 0;
    }
    @Override
    public boolean checkMenuExistRole(Long menuId) {
        return roleMenuMapper.selectCountByQuery(QueryWrapper.create().where(SysRoleMenu::getMenuId).eq(menuId)) > 0;
    }

    @Override @Transactional(rollbackFor = Exception.class)
    public void updateMenuSort(String[] menuIds, String[] orderNums) {
        for (int i = 0; i < menuIds.length; i++) {
            SysMenu menu = new SysMenu(); menu.setMenuId(Convert.toLong(menuIds[i])); menu.setOrderNum(Convert.toInt(orderNums[i]));
            menuMapper.update(menu);
        }
    }

    @Override
    public boolean checkMenuNameUnique(SysMenu menu) {
        Long menuId = ObjectUtil.isNull(menu.getMenuId()) ? -1L : menu.getMenuId();
        SysMenu info = menuMapper.selectOneByQuery(
            QueryWrapper.create().where(SysMenu::getMenuName).eq(menu.getMenuName()).and(SysMenu::getParentId).eq(menu.getParentId())
        );
        return info == null || info.getMenuId().longValue() == menuId.longValue();
    }

    @Override
    public boolean checkRouteConfigUnique(SysMenu menu) {
        Long menuId = ObjectUtil.isNull(menu.getMenuId()) ? -1L : menu.getMenuId();
        String path = menu.getPath();
        String routeName = StrUtil.isEmpty(menu.getRouteName()) ? path : menu.getRouteName();
        List<SysMenu> list = menuMapper.selectListByQuery(
            QueryWrapper.create().where("path = ? or route_name = ?", path, routeName)
        );
        for (SysMenu m : list) {
            if (m.getMenuId().longValue() != menuId.longValue()) {
                Long dbParentId = m.getParentId(); String dbPath = m.getPath();
                String dbRouteName = StrUtil.isEmpty(m.getRouteName()) ? dbPath : m.getRouteName();
                if (StrUtil.equalsAnyIgnoreCase(path, dbPath) && menu.getParentId().longValue() == dbParentId.longValue()) {
                    log.warn("[同级路由冲突] {}", dbPath); return UserConstants.NOT_UNIQUE;
                } else if (StrUtil.equalsAnyIgnoreCase(path, dbPath) && menu.getParentId().longValue() == MENU_ROOT_ID) {
                    log.warn("[根目录路由冲突] {}", path); return UserConstants.NOT_UNIQUE;
                } else if (StrUtil.equalsAnyIgnoreCase(routeName, dbRouteName)) {
                    log.warn("[路由名称冲突] {}", routeName); return UserConstants.NOT_UNIQUE;
                }
            }
        }
        return UserConstants.UNIQUE;
    }

    // ===== Helpers =====
    public String getRouteName(SysMenu menu) { return isMenuFrame(menu) ? StrUtil.EMPTY : getRouteName(menu.getRouteName(), menu.getPath()); }
    public String getRouteName(String name, String path) { return StrUtil.upperFirst(StrUtil.isNotEmpty(name) ? name : path); }
    public String getRouterPath(SysMenu menu) {
        String routerPath = menu.getPath();
        if (menu.getParentId().intValue() != MENU_ROOT_ID && isInnerLink(menu)) routerPath = innerLinkReplaceEach(routerPath);
        if (MENU_ROOT_ID == menu.getParentId().intValue() && UserConstants.TYPE_DIR.equals(menu.getMenuType()) && UserConstants.NO_FRAME.equals(menu.getIsFrame())) routerPath = "/" + menu.getPath();
        else if (isMenuFrame(menu)) routerPath = "/";
        return routerPath;
    }
    public String getComponent(SysMenu menu) {
        String component = UserConstants.LAYOUT;
        if (StrUtil.isNotEmpty(menu.getComponent()) && !isMenuFrame(menu)) component = menu.getComponent();
        else if (StrUtil.isEmpty(menu.getComponent()) && menu.getParentId().intValue() != MENU_ROOT_ID && isInnerLink(menu)) component = UserConstants.INNER_LINK;
        else if (StrUtil.isEmpty(menu.getComponent()) && isParentView(menu)) component = UserConstants.PARENT_VIEW;
        return component;
    }
    public boolean isMenuFrame(SysMenu menu) { return menu.getParentId().intValue() == MENU_ROOT_ID && UserConstants.TYPE_MENU.equals(menu.getMenuType()) && menu.getIsFrame().equals(UserConstants.NO_FRAME); }
    public boolean isParentView(SysMenu menu) { return menu.getParentId().intValue() != MENU_ROOT_ID && UserConstants.TYPE_DIR.equals(menu.getMenuType()); }
    public boolean isInnerLink(SysMenu menu) { return menu.getIsFrame().equals(UserConstants.NO_FRAME) && StrUtil.startWithAny(menu.getPath(), "http://", "https://"); }
    public List<SysMenu> getChildPerms(List<SysMenu> list, long parentId) {
        return TreeUtils.buildTree(list, parentId, SysMenu::getMenuId, SysMenu::getParentId, SysMenu::setChildren);
    }
    public String innerLinkReplaceEach(String path) { return StringUtils.replaceEach(path, new String[]{Constants.HTTP, Constants.HTTPS, Constants.WWW, ".", ":"}, new String[]{"", "", "", "/", "/"}); }
}
