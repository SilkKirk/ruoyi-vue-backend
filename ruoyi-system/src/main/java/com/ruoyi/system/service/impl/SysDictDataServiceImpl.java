package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.utils.DictUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.mapper.SysDictDataMapper;
import com.ruoyi.system.service.ISysDictDataService;

@Service
public class SysDictDataServiceImpl implements ISysDictDataService
{
    @Autowired private SysDictDataMapper dictDataMapper;

    @Override
    public List<SysDictData> selectDictDataList(SysDictData dictData)
    {
        QueryWrapper qw = buildDictDataQuery(dictData);
        return dictDataMapper.selectListByQuery(qw);
    }

    private QueryWrapper buildDictDataQuery(SysDictData dictData) {
        QueryWrapper qw = QueryWrapper.create();
        if (StringUtils.isNotEmpty(dictData.getDictType())) qw.eq(SysDictData::getDictType, dictData.getDictType());
        if (StringUtils.isNotEmpty(dictData.getDictLabel())) qw.like(SysDictData::getDictLabel, dictData.getDictLabel());
        if (StringUtils.isNotEmpty(dictData.getStatus())) qw.eq(SysDictData::getStatus, dictData.getStatus());
        return qw;
    }

    @Override
    public Page<SysDictData> selectDictDataPage(Page<SysDictData> page, SysDictData dictData)
    {
        QueryWrapper qw = buildDictDataQuery(dictData);
        return dictDataMapper.paginate(page, qw);
    }

    @Override
    public String selectDictLabel(String dictType, String dictValue)
    {
        SysDictData data = dictDataMapper.selectOneByQuery(
            QueryWrapper.create().where(SysDictData::getDictType).eq(dictType).and(SysDictData::getDictValue).eq(dictValue)
        );
        return data != null ? data.getDictLabel() : "";
    }

    @Override
    public SysDictData selectDictDataById(Long dictCode)
    {
        return dictDataMapper.selectOneById(dictCode);
    }

    @Override
    public void deleteDictDataByIds(Long[] dictCodes)
    {
        for (Long dictCode : dictCodes)
        {
            SysDictData data = selectDictDataById(dictCode);
            dictDataMapper.deleteById(dictCode);
            List<SysDictData> dictDatas = selectDictDataByType(data.getDictType());
            DictUtils.setDictCache(data.getDictType(), dictDatas);
        }
    }

    @Override
    public int insertDictData(SysDictData data)
    {
        int row = dictDataMapper.insertSelective(data);
        if (row > 0)
        {
            List<SysDictData> dictDatas = selectDictDataByType(data.getDictType());
            DictUtils.setDictCache(data.getDictType(), dictDatas);
        }
        return row;
    }

    @Override
    public int updateDictData(SysDictData data)
    {
        int row = dictDataMapper.update(data);
        if (row > 0)
        {
            List<SysDictData> dictDatas = selectDictDataByType(data.getDictType());
            DictUtils.setDictCache(data.getDictType(), dictDatas);
        }
        return row;
    }

    private List<SysDictData> selectDictDataByType(String dictType)
    {
        return dictDataMapper.selectListByQuery(
            QueryWrapper.create().where(SysDictData::getDictType).eq(dictType).orderBy(SysDictData::getDictSort, true)
        );
    }
}
