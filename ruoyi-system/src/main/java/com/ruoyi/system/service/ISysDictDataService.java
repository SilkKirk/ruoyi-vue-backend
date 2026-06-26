package com.ruoyi.system.service;

import com.mybatisflex.core.service.IService;
import java.util.List;
import com.ruoyi.common.core.domain.entity.SysDictData;

/**
 * 字典 业务层
 * 
 * @author ruoyi
 */
public interface ISysDictDataService extends IService<SysDictData>
{
    /**
     * 根据字典类型和字典键值查询字典数据信息
     * 
     * @param dictType 字典类型
     * @param dictValue 字典键值
     * @return 字典标签
     */
    public String selectDictLabel(String dictType, String dictValue);
}
