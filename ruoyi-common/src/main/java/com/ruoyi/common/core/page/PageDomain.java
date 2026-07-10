package com.ruoyi.common.core.page;

import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PageDomain
{
    private Integer pageNum;

    private Integer pageSize;

    private String orderByColumn;

    private String isAsc = "asc";

    private Boolean reasonable = true;

    public String getOrderBy()
    {
        if (StrUtil.isEmpty(orderByColumn))
        {
            return "";
        }
        return StrUtil.toUnderlineCase(orderByColumn) + " " + isAsc;
    }

    public String getIsAsc()
    {
        return isAsc;
    }

    public void setIsAsc(String isAsc)
    {
        if (StrUtil.isNotEmpty(isAsc))
        {
            if ("ascending".equals(isAsc))
            {
                isAsc = "asc";
            }
            else if ("descending".equals(isAsc))
            {
                isAsc = "desc";
            }
            this.isAsc = isAsc;
        }
    }

    public Boolean getReasonable()
    {
        if (ObjectUtil.isNull(reasonable))
        {
            return Boolean.TRUE;
        }
        return reasonable;
    }
}
