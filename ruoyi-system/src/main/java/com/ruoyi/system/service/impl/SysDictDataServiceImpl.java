package com.ruoyi.system.service.impl;

import com.mybatisflex.spring.service.impl.ServiceImpl;
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
public class SysDictDataServiceImpl extends ServiceImpl<SysDictDataMapper, SysDictData> implements ISysDictDataService
{
    @Autowired private SysDictDataMapper dictDataMapper;

    

    @Override
    public String selectDictLabel(String dictType, String dictValue)
    {
        SysDictData data = dictDataMapper.selectOneByQuery(
            QueryWrapper.create().where(SysDictData::getDictType).eq(dictType).and(SysDictData::getDictValue).eq(dictValue)
        );
        return data != null ? data.getDictLabel() : "";
    }

}


