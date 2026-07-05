package com.ruoyi.workflow.common.utils;

import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.service.ISysUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import cn.hutool.core.util.StrUtil;

@Component
@RequiredArgsConstructor
public class UserInfoHelper {

    private final ISysUserService sysUserService;

    public String getNickname(String username) {
        if (StrUtil.isBlank(username)) return username;
        SysUser user = sysUserService.selectUserByUserName(username);
        return user != null ? user.getNickName() : username;
    }

    public String getDeptName(String username) {
        if (StrUtil.isBlank(username)) return "";
        SysUser user = sysUserService.selectUserByUserName(username);
        if (user != null && user.getDept() != null) {
            return user.getDept().getDeptName();
        }
        return "";
    }

    public UserInfoVo getUserInfo(String username) {
        if (StrUtil.isBlank(username)) {
            return new UserInfoVo(username, username, "");
        }
        SysUser user = sysUserService.selectUserByUserName(username);
        if (user != null) {
            return new UserInfoVo(username, user.getNickName(),
                    user.getDept() != null ? user.getDept().getDeptName() : "");
        }
        return new UserInfoVo(username, username, "");
    }

    public record UserInfoVo(String username, String nickname, String deptName) {}
}
