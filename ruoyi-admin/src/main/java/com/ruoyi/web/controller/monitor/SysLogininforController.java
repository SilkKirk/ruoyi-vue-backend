package com.ruoyi.web.controller.monitor;

import java.util.List;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.core.page.TableSupport;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.framework.web.service.SysPasswordService;
import com.ruoyi.system.domain.SysLogininfor;
import com.ruoyi.system.service.ISysLogininforService;

/**
 * 系统访问记录
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/monitor/logininfor")
public class SysLogininforController extends BaseController
{
    @Autowired
    private ISysLogininforService logininforService;

    @Autowired
    private SysPasswordService passwordService;

    @PreAuthorize("@ss.hasPermi('monitor:logininfor:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysLogininfor logininfor)
    {
        Page<SysLogininfor> page = startPage(SysLogininfor.class);
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(logininfor.getIpaddr())) qw.like(SysLogininfor::getIpaddr, logininfor.getIpaddr());
        if (StringUtils.isNotEmpty(logininfor.getStatus())) qw.eq(SysLogininfor::getStatus, logininfor.getStatus());
        if (StringUtils.isNotEmpty(logininfor.getUserName())) qw.like(SysLogininfor::getUserName, logininfor.getUserName());
        if (StringUtils.isNotNull(logininfor.getParams().get("beginTime"))) qw.ge(SysLogininfor::getLoginTime, logininfor.getParams().get("beginTime"));
        if (StringUtils.isNotNull(logininfor.getParams().get("endTime"))) qw.le(SysLogininfor::getLoginTime, logininfor.getParams().get("endTime"));
        qw.orderBy(SysLogininfor::getInfoId, false);
        page = logininforService.page(page, qw);
        return getDataTable(page);
    }

    @Log(title = "登录日志", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('monitor:logininfor:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysLogininfor logininfor)
    {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(logininfor.getIpaddr())) qw.like(SysLogininfor::getIpaddr, logininfor.getIpaddr());
        if (StringUtils.isNotEmpty(logininfor.getStatus())) qw.eq(SysLogininfor::getStatus, logininfor.getStatus());
        if (StringUtils.isNotEmpty(logininfor.getUserName())) qw.like(SysLogininfor::getUserName, logininfor.getUserName());
        if (StringUtils.isNotNull(logininfor.getParams().get("beginTime"))) qw.ge(SysLogininfor::getLoginTime, logininfor.getParams().get("beginTime"));
        if (StringUtils.isNotNull(logininfor.getParams().get("endTime"))) qw.le(SysLogininfor::getLoginTime, logininfor.getParams().get("endTime"));
        qw.orderBy(SysLogininfor::getInfoId, false);
        List<SysLogininfor> list = logininforService.list(qw);
        ExcelUtil<SysLogininfor> util = new ExcelUtil<SysLogininfor>(SysLogininfor.class);
        util.exportExcel(response, list, "登录日志");
    }

    @PreAuthorize("@ss.hasPermi('monitor:logininfor:remove')")
    @Log(title = "登录日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{infoIds}")
    public AjaxResult remove(@PathVariable Long[] infoIds)
    {
        return toAjax(logininforService.removeByIds(java.util.Arrays.asList(infoIds)));
    }

    @PreAuthorize("@ss.hasPermi('monitor:logininfor:remove')")
    @Log(title = "登录日志", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean")
    public AjaxResult clean()
    {
        logininforService.cleanLogininfor();
        return success();
    }

    @PreAuthorize("@ss.hasPermi('monitor:logininfor:unlock')")
    @Log(title = "账户解锁", businessType = BusinessType.OTHER)
    @GetMapping("/unlock/{userName}")
    public AjaxResult unlock(@PathVariable("userName") String userName)
    {
        passwordService.clearLoginRecordCache(userName);
        return success();
    }
}



