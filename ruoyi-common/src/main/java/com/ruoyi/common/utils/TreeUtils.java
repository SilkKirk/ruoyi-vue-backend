package com.ruoyi.common.utils;

import cn.hutool.core.lang.tree.Tree;
import cn.hutool.core.lang.tree.TreeUtil;
import java.util.List;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 树结构构建工具类
 * <p>基于 Hutool TreeUtil 封装，将扁平数据列表转换为树形结构。</p>
 *
 * @author ruoyi
 */
public class TreeUtils {

    /**
     * 从扁平列表构建树形结构
     * <p>根节点由 {@code rootId} 决定：节点.parentId == rootId 的节点为根节点。</p>
     *
     * @param list           扁平数据列表
     * @param rootId         根节点父ID（顶级节点通常是 0L）
     * @param idGetter       获取节点ID的方法引用（如 {@code SysDept::getDeptId}）
     * @param parentIdGetter 获取父节点ID的方法引用（如 {@code SysDept::getParentId}）
     * @param childrenSetter 设置子节点列表的方法引用（如 {@code SysDept::setChildren}）
     * @param <T>            实体类型
     * @return 树形结构列表，未找到根节点时返回空列表
     */
    @SuppressWarnings("unchecked")
    public static <T> List<T> buildTree(List<T> list, Long rootId,
                                        Function<T, Long> idGetter,
                                        Function<T, Long> parentIdGetter,
                                        BiConsumer<T, List<T>> childrenSetter) {
        if (list == null || list.isEmpty()) return list;

        List<Tree<Long>> treeList = TreeUtil.build(list, rootId, (entity, tree) -> {
            tree.setId(idGetter.apply(entity));
            tree.setParentId(parentIdGetter.apply(entity));
            tree.put("raw", entity);
        });

        if (treeList == null || treeList.isEmpty()) return list;

        return treeList.stream()
            .map(node -> treeToEntity(node, childrenSetter))
            .collect(Collectors.toList());
    }

    @SuppressWarnings("unchecked")
    private static <T> T treeToEntity(Tree<Long> node, BiConsumer<T, List<T>> childrenSetter) {
        T entity = (T) node.get("raw");
        List<Tree<Long>> children = node.getChildren();
        if (children != null && !children.isEmpty()) {
            List<T> childEntities = children.stream()
                .map(child -> treeToEntity(child, childrenSetter))
                .collect(Collectors.toList());
            childrenSetter.accept(entity, childEntities);
        }
        return entity;
    }
}
