package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.utils.DictUtils;
import com.ruoyi.system.mapper.SysDictDataMapper;
import com.ruoyi.system.service.ISysDictDataService;
import cn.hutool.core.util.StrUtil;

@Service
public class SysDictDataServiceImpl extends ServiceImpl<SysDictDataMapper, SysDictData> implements ISysDictDataService
{
    @Autowired private SysDictDataMapper dictDataMapper;

    @Override
    public List<SysDictData> selectDictDataList(SysDictData dictData) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(dictData.getDictType())) qw.eq(SysDictData::getDictType, dictData.getDictType());
        if (StrUtil.isNotEmpty(dictData.getDictLabel())) qw.like(SysDictData::getDictLabel, dictData.getDictLabel());
        if (StrUtil.isNotEmpty(dictData.getStatus())) qw.eq(SysDictData::getStatus, dictData.getStatus());
        return dictDataMapper.selectListByQuery(qw);
    }

    @Override
    public Page<SysDictData> selectDictDataPage(Page<SysDictData> page, SysDictData dictData) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(dictData.getDictType())) qw.eq(SysDictData::getDictType, dictData.getDictType());
        if (StrUtil.isNotEmpty(dictData.getDictLabel())) qw.like(SysDictData::getDictLabel, dictData.getDictLabel());
        if (StrUtil.isNotEmpty(dictData.getStatus())) qw.eq(SysDictData::getStatus, dictData.getStatus());
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

}

