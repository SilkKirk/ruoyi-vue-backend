package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import java.util.List;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.system.domain.SysPost;

/**
 * 岗位信息 服务层
 * 
 * @author ruoyi
 */
public interface ISysPostService extends IService<SysPost>
{
    /**
     * 查询岗位列表
     */
    public List<SysPost> selectPostList(SysPost post);

    /**
     * 分页查询岗位
     */
    public Page<SysPost> selectPostPage(Page<SysPost> page, SysPost post);

    /**
     * 根据用户ID获取岗位选择框列表
     * 
     * @param userId 用户ID
     * @return 选中岗位ID列表
     */
    public List<Long> selectPostListByUserId(Long userId);

    /**
     * 校验岗位名称
     * 
     * @param post 岗位信息
     * @return 结果
     */
    public boolean checkPostNameUnique(SysPost post);

    /**
     * 校验岗位编码
     * 
     * @param post 岗位信息
     * @return 结果
     */
    public boolean checkPostCodeUnique(SysPost post);

    /**
     * 通过岗位ID查询岗位使用数量
     * 
     * @param postId 岗位ID
     * @return 结果
     */
    public int countUserPostById(Long postId);
}
