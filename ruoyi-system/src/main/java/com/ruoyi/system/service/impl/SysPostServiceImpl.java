package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.io.Serializable;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.SysPost;
import com.ruoyi.system.domain.SysUserPost;
import com.ruoyi.system.mapper.SysPostMapper;
import com.ruoyi.system.mapper.SysUserPostMapper;
import com.ruoyi.system.service.ISysPostService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;

/**
 * 岗位信息 服务层处理
 * 
 * @author ruoyi
 */
@Service
public class SysPostServiceImpl extends ServiceImpl<SysPostMapper, SysPost> implements ISysPostService
{
    @Autowired
    private SysPostMapper postMapper;

    @Autowired
    private SysUserPostMapper userPostMapper;

    @Override
    public List<SysPost> selectPostList(SysPost post) {
        QueryWrapper qw = buildPostQuery(post);
        return postMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysPost> selectPostPage(Page<SysPost> page, SysPost post) {
        QueryWrapper qw = buildPostQuery(post);
        return postMapper.paginate(page, qw);
    }

    private QueryWrapper buildPostQuery(SysPost post) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(post.getPostCode())) qw.like(SysPost::getPostCode, post.getPostCode());
        if (StrUtil.isNotEmpty(post.getStatus())) qw.eq(SysPost::getStatus, post.getStatus());
        if (StrUtil.isNotEmpty(post.getPostName())) qw.like(SysPost::getPostName, post.getPostName());
        if (ObjectUtil.isNotNull(post.getParams().get("beginTime"))) qw.ge(SysPost::getCreateTime, post.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(post.getParams().get("endTime"))) qw.le(SysPost::getCreateTime, post.getParams().get("endTime"));
        qw.orderBy(SysPost::getPostSort, true);
        return qw;
    }

    /**
     * 查询岗位信息集合
     * 
     * @param post 岗位信息
     * @return 岗位信息集合
     */
    

    /**
     * 根据用户ID获取岗位选择框列表
     * 
     * @param userId 用户ID
     * @return 选中岗位ID列表
     */
    @Override
    public List<Long> selectPostListByUserId(Long userId)
    {
        return userPostMapper.selectListByQuery(
            QueryWrapper.create().select(SysUserPost::getPostId).where(SysUserPost::getUserId).eq(userId)
        ).stream().map(SysUserPost::getPostId).collect(Collectors.toList());
    }

    /**
     * 校验岗位名称是否唯一
     */
    @Override
    public boolean checkPostNameUnique(SysPost post)
    {
        return postMapper.selectCountByQuery(
            QueryWrapper.create().where(SysPost::getPostName).eq(post.getPostName())
                .and(SysPost::getPostId).ne(post.getPostId() == null ? -1L : post.getPostId())
        ) == 0;
    }

    /**
     * 校验岗位编码是否唯一
     */
    @Override
    public boolean checkPostCodeUnique(SysPost post)
    {
        return postMapper.selectCountByQuery(
            QueryWrapper.create().where(SysPost::getPostCode).eq(post.getPostCode())
                .and(SysPost::getPostId).ne(post.getPostId() == null ? -1L : post.getPostId())
        ) == 0;
    }

    /**
     * 通过岗位ID查询岗位使用数量
     * 
     * @param postId 岗位ID
     * @return 结果
     */
    @Override
    public int countUserPostById(Long postId)
    {
        return (int) userPostMapper.selectCountByQuery(QueryWrapper.create().where(SysUserPost::getPostId).eq(postId));
    }

    /**
     * 批量删除岗位信息
     * 
     * @param postIds 需要删除的岗位ID
     * @return 结果
     */
    @Override
    public boolean removeByIds(Collection<? extends Serializable> postIds)
    {
        for (Serializable id : postIds)
        {
            Long postId = (Long) id;
            SysPost post = getById(postId);
            if (countUserPostById(postId) > 0)
            {
                throw new ServiceException(String.format("%1$s已分配,不能删除", post.getPostName()));
            }
        }
        return mapper.deleteBatchByIds(postIds) > 0;
    }

}

