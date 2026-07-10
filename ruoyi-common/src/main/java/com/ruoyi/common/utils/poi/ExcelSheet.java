package com.ruoyi.common.utils.poi;

import java.util.ArrayList;
import java.util.List;
import lombok.Data;

@Data
public class ExcelSheet<T>
{
    private String sheetName;

    private List<T> list;

    private Class<T> clazz;

    private String title;

    public ExcelSheet(String sheetName, List<T> list, Class<T> clazz)
    {
        this(sheetName, list, clazz, "");
    }

    public ExcelSheet(String sheetName, List<T> list, Class<T> clazz, String title)
    {
        this.sheetName = sheetName;
        this.list = list != null ? list : new ArrayList<>();
        this.clazz = clazz;
        this.title = title != null ? title : "";
    }
}
