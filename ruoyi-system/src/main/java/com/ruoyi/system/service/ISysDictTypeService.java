package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import java.util.List;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.core.domain.entity.SysDictType;

/**
 * 字典 业务层
 * 
 * @author ruoyi
 */
public interface ISysDictTypeService extends IService<SysDictType>
{
    /**
     * 查询字典类型列表
     */
    public List<SysDictType> selectDictTypeList(SysDictType dictType);

    /**
     * 分页查询字典类型
     */
    public Page<SysDictType> selectDictTypePage(Page<SysDictType> page, SysDictType dictType);

    /**
     * 根据字典类型查询字典数据
     * 
     * @param dictType 字典类型
     * @return 字典数据集合信息
     */
    public List<SysDictData> selectDictDataByType(String dictType);

    /**
     * 根据字典类型查询信息
     * 
     * @param dictType 字典类型
     * @return 字典类型
     */
    public SysDictType selectDictTypeByType(String dictType);

    /**
     * 查询字典类型下是否存在字典数据
     *
     * @param dictType 字典类型
     * @return true 存在 false 不存在
     */
    public boolean hasDictDataByType(String dictType);

    /**
     * 加载字典缓存数据
     */
    public void loadingDictCache();

    /**
     * 清空字典缓存数据
     */
    public void clearDictCache();

    /**
     * 重置字典缓存数据
     */
    public void resetDictCache();

    /**
     * 校验字典类型称是否唯一
     * 
     * @param dictType 字典类型
     * @return 结果
     */
    public boolean checkDictTypeUnique(SysDictType dictType);
}
