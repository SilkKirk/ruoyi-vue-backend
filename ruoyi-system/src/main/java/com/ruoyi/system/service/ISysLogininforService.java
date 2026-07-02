package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import com.mybatisflex.core.paginate.Page;
import java.util.List;
import com.ruoyi.system.domain.SysLogininfor;

/**
 * 系统访问日志情况信息 服务层
 * 
 * @author ruoyi
 */
public interface ISysLogininforService extends IService<SysLogininfor>
{
    /**
     * 查询登录日志列表
     */
    public List<SysLogininfor> selectLogininforList(SysLogininfor logininfor);

    /**
     * 分页查询登录日志
     */
    public Page<SysLogininfor> selectLogininforPage(Page<SysLogininfor> page, SysLogininfor logininfor);

    /**
     * 新增系统登录日志
     * 
     * @param logininfor 访问日志对象
     */
    public void insertLogininfor(SysLogininfor logininfor);

    /**
     * 清空系统登录日志
     */
    public void cleanLogininfor();
}
