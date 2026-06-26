package com.ruoyi.generator.service;

import com.mybatisflex.core.service.IService;
import java.util.List;
import com.ruoyi.generator.domain.GenTableColumn;

/**
 * 业务字段 服务层
 * 
 * @author ruoyi
 */
public interface IGenTableColumnService extends IService<GenTableColumn>
{
    /**
     * 查询业务字段列表
     * 
     * @param tableId 业务字段编号
     * @return 业务字段集合
     */
    public List<GenTableColumn> selectGenTableColumnListByTableId(Long tableId);
}
