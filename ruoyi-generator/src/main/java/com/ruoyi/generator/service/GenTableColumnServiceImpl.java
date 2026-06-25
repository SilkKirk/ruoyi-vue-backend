package com.ruoyi.generator.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.generator.domain.GenTableColumn;
import com.ruoyi.generator.mapper.GenTableColumnMapper;

@Service
public class GenTableColumnServiceImpl implements IGenTableColumnService
{
    @Autowired private GenTableColumnMapper genTableColumnMapper;

    @Override
    public List<GenTableColumn> selectGenTableColumnListByTableId(Long tableId) {
        return genTableColumnMapper.selectListByQuery(
            QueryWrapper.create().where(GenTableColumn::getTableId).eq(tableId).orderBy(GenTableColumn::getSort, true)
        );
    }
}
