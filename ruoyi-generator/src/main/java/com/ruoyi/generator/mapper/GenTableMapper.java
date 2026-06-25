package com.ruoyi.generator.mapper;

import org.apache.ibatis.annotations.Update;
import com.mybatisflex.core.BaseMapper;
import com.ruoyi.generator.domain.GenTable;

public interface GenTableMapper extends BaseMapper<GenTable>
{
    @Update("${sql}")
    int createTable(String sql);
}
