package com.ruoyi.common.utils;

import java.util.List;
import com.mybatisflex.core.BaseMapper;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.common.core.page.PageDomain;
import com.ruoyi.common.core.page.TableSupport;
import com.ruoyi.common.utils.sql.SqlUtil;

/**
 * 分页工具类（MyBatis-Flex 版本）
 * 
 * @author ruoyi
 */
public class PageUtils
{
    private static final ThreadLocal<PageParams> PAGE_THREAD_LOCAL = new ThreadLocal<>();
    private static final ThreadLocal<Long> TOTAL_THREAD_LOCAL = new ThreadLocal<>();

    /**
     * 设置请求分页数据
     */
    public static void startPage()
    {
        PageDomain pageDomain = TableSupport.buildPageRequest();
        Integer pageNum = pageDomain.getPageNum();
        Integer pageSize = pageDomain.getPageSize();
        String orderBy = SqlUtil.escapeOrderBySql(pageDomain.getOrderBy());
        Boolean reasonable = pageDomain.getReasonable();
        PAGE_THREAD_LOCAL.set(new PageParams(pageNum, pageSize, orderBy, reasonable));
    }

    /**
     * 执行分页查询（MyBatis-Flex 原生分页）
     * <p>
     * 如果 ThreadLocal 中存在分页参数则分页，否则直接查询全部。
     * 自动将 {@link PageParams#getOrderBy()} 应用到 QueryWrapper 的排序中。
     * 若未设置分页参数（startPage 未被调用），则退化为全量查询。
     *
     * @param mapper BaseMapper 实例
     * @param qw     已构建的 QueryWrapper（不含分页/排序）
     * @return 分页结果列表（或全量列表）
     */
    @SuppressWarnings("unchecked")
    public static <T> List<T> paginate(BaseMapper<T> mapper, QueryWrapper qw)
    {
        PageParams params = PAGE_THREAD_LOCAL.get();
        if (params == null)
        {
            return mapper.selectListByQuery(qw);
        }

        PAGE_THREAD_LOCAL.remove();

        // 1. 应用动态排序（兼容前端 orderByColumn/isAsc 参数）
        if (StringUtils.isNotEmpty(params.getOrderBy()))
        {
            qw.orderBy(params.getOrderBy());
        }

        int pageNum = params.getPageNum();
        int pageSize = params.getPageSize();

        // 2. 执行 MyBatis-Flex 原生分页
        Page<T> page = mapper.paginate(pageNum, pageSize, qw);

        // 3. reasonable：页码越界时回退到最后一页重新查询
        if (params.isReasonable() && page.getRecords().isEmpty() && page.getTotalRow() > 0 && pageNum > 1)
        {
            long totalPage = (page.getTotalRow() + pageSize - 1) / pageSize;
            if (pageNum > totalPage)
            {
                page = mapper.paginate((int) totalPage, pageSize, qw);
            }
        }

        TOTAL_THREAD_LOCAL.set(page.getTotalRow());
        return page.getRecords();
    }

    /**
     * 清理分页的线程变量
     */
    public static void clearPage()
    {
        PAGE_THREAD_LOCAL.remove();
        TOTAL_THREAD_LOCAL.remove();
    }

    /**
     * 获取总记录数（由 paginate 方法写入）
     */
    public static Long getTotal()
    {
        return TOTAL_THREAD_LOCAL.get();
    }

    /**
     * 分页参数内部类
     */
    public static class PageParams
    {
        private final int pageNum;
        private final int pageSize;
        private final String orderBy;
        private final boolean reasonable;

        public PageParams(int pageNum, int pageSize, String orderBy, boolean reasonable)
        {
            this.pageNum = pageNum;
            this.pageSize = pageSize;
            this.orderBy = orderBy;
            this.reasonable = reasonable;
        }

        public int getPageNum() { return pageNum; }
        public int getPageSize() { return pageSize; }
        public String getOrderBy() { return orderBy; }
        public boolean isReasonable() { return reasonable; }
    }
}
