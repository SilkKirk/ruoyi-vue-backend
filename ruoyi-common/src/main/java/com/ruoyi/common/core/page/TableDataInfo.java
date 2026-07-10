package com.ruoyi.common.core.page;

import java.io.Serializable;
import java.util.List;
import lombok.Data;

@Data
public class TableDataInfo implements Serializable
{
    private static final long serialVersionUID = 1L;

    private long total;

    private List<?> rows;

    private int code;

    private String msg;

    public TableDataInfo()
    {
    }

    public TableDataInfo(List<?> list, long total)
    {
        this.rows = list;
        this.total = total;
    }
}
