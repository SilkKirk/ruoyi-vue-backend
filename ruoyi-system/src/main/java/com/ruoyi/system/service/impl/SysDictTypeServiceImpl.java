package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.core.domain.entity.SysDictType;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DictUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.mapper.SysDictDataMapper;
import com.ruoyi.system.mapper.SysDictTypeMapper;
import com.ruoyi.system.service.ISysDictTypeService;

/**
 * 字典 业务层处理
 * 
 * @author ruoyi
 */
@Service
public class SysDictTypeServiceImpl extends ServiceImpl<SysDictTypeMapper, SysDictType> implements ISysDictTypeService
{
    @Autowired
    private SysDictTypeMapper dictTypeMapper;

    @Autowired
    private SysDictDataMapper dictDataMapper;

    @Override
    public List<SysDictType> selectDictTypeList(SysDictType dictType) {
        QueryWrapper qw = buildDictTypeQuery(dictType);
        return dictTypeMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysDictType> selectDictTypePage(Page<SysDictType> page, SysDictType dictType) {
        QueryWrapper qw = buildDictTypeQuery(dictType);
        return dictTypeMapper.paginate(page, qw);
    }

    private QueryWrapper buildDictTypeQuery(SysDictType dictType) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(dictType.getDictName())) qw.like(SysDictType::getDictName, dictType.getDictName());
        if (StringUtils.isNotEmpty(dictType.getStatus())) qw.eq(SysDictType::getStatus, dictType.getStatus());
        if (StringUtils.isNotEmpty(dictType.getDictType())) qw.like(SysDictType::getDictType, dictType.getDictType());
        if (StringUtils.isNotNull(dictType.getParams().get("beginTime"))) qw.ge(SysDictType::getCreateTime, dictType.getParams().get("beginTime"));
        if (StringUtils.isNotNull(dictType.getParams().get("endTime"))) qw.le(SysDictType::getCreateTime, dictType.getParams().get("endTime"));
        qw.orderBy(SysDictType::getCreateTime, false);
        return qw;
    }

    /**
     * 项目启动时，初始化字典到缓存
     */
    @PostConstruct
    public void init()
    {
        loadingDictCache();
    }

    /**
     * 根据条件分页查询字典类型
     * 
     * @param dictType 字典类型信息
     * @return 字典类型集合信息
     */
    

    /**
     * 根据字典类型查询字典数据
     * 
     * @param dictType 字典类型
     * @return 字典数据集合信息
     */
    @Override
    public List<SysDictData> selectDictDataByType(String dictType)
    {
        List<SysDictData> dictDatas = DictUtils.getDictCache(dictType);
        if (StringUtils.isNotEmpty(dictDatas))
        {
            return dictDatas;
        }
        dictDatas = dictDataMapper.selectListByQuery(QueryWrapper.create().where(SysDictData::getDictType).eq(dictType));
        if (StringUtils.isNotEmpty(dictDatas))
        {
            DictUtils.setDictCache(dictType, dictDatas);
            return dictDatas;
        }
        return null;
    }

    /**
     * 根据字典类型查询信息
     * 
     * @param dictType 字典类型
     * @return 字典类型
     */
    @Override
    public SysDictType selectDictTypeByType(String dictType)
    {
        return dictTypeMapper.selectOneByQuery(QueryWrapper.create().where(SysDictType::getDictType).eq(dictType));
    }

    @Override
    public boolean hasDictDataByType(String dictType)
    {
        return dictDataMapper.selectCountByQuery(QueryWrapper.create().where(SysDictData::getDictType).eq(dictType)) > 0;
    }

    /**
     * 加载字典缓存数据
     */
    @Override
    public void loadingDictCache()
    {
        SysDictData dictData = new SysDictData();
        dictData.setStatus("0");
        Map<String, List<SysDictData>> dictDataMap = dictDataMapper.selectListByQuery(
            QueryWrapper.create().where(SysDictData::getStatus).eq("0")
        ).stream().collect(Collectors.groupingBy(SysDictData::getDictType));
        for (Map.Entry<String, List<SysDictData>> entry : dictDataMap.entrySet())
        {
            DictUtils.setDictCache(entry.getKey(), entry.getValue().stream().sorted(Comparator.comparing(SysDictData::getDictSort)).collect(Collectors.toList()));
        }
    }

    /**
     * 清空字典缓存数据
     */
    @Override
    public void clearDictCache()
    {
        DictUtils.clearDictCache();
    }

    /**
     * 重置字典缓存数据
     */
    @Override
    public void resetDictCache()
    {
        clearDictCache();
        loadingDictCache();
    }

    /**
     * 新增保存字典类型信息
     * 
     * @param dict 字典类型信息
     * @return 结果
     */
    @Override
    public boolean save(SysDictType dict)
    {
        return dictTypeMapper.insertSelective(dict) > 0;
    }

    /**
     * 修改保存字典类型信息（同时更新该类型下所有字典数据的类型名）
     * 
     * @param dict 字典类型信息
     * @return 结果
     */
    @Override
    @Transactional
    public boolean updateById(SysDictType dict)
    {
        SysDictType oldDict = dictTypeMapper.selectOneById(dict.getDictId());
        SysDictData updateData = new SysDictData();
        updateData.setDictType(dict.getDictType());
        dictDataMapper.updateByQuery(updateData, QueryWrapper.create().where(SysDictData::getDictType).eq(oldDict.getDictType()));
        return dictTypeMapper.update(dict) > 0;
    }

    /**
     * 校验字典类型称是否唯一
     * 
     * @param dict 字典类型
     * @return 结果
     */
    @Override
    public boolean checkDictTypeUnique(SysDictType dict)
    {
        return dictTypeMapper.selectCountByQuery(
            QueryWrapper.create().where(SysDictType::getDictType).eq(dict.getDictType())
                .and(SysDictType::getDictId).ne(dict.getDictId() == null ? -1L : dict.getDictId())
        ) == 0;
    }
}


