package com.ruoyi.generator.service;

import com.mybatisflex.spring.service.impl.ServiceImpl;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.IoUtil;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.GenConstants;
import cn.hutool.core.util.CharsetUtil;
import com.ruoyi.common.exception.ServiceException;
import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.core.row.Db;
import com.mybatisflex.core.row.Row;
import com.ruoyi.generator.domain.GenTable;
import com.ruoyi.generator.domain.GenTableColumn;
import com.ruoyi.generator.mapper.GenTableColumnMapper;
import com.ruoyi.generator.mapper.GenTableMapper;
import com.ruoyi.generator.util.GenUtils;
import com.ruoyi.generator.util.VelocityInitializer;
import com.ruoyi.generator.util.VelocityUtils;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.collection.CollUtil;

/**
 * 业务 服务层实现
 * 
 * @author ruoyi
 */
@Service
public class GenTableServiceImpl extends ServiceImpl<GenTableMapper, GenTable> implements IGenTableService
{
    private static final Logger log = LoggerFactory.getLogger(GenTableServiceImpl.class);

    @Autowired
    private GenTableMapper genTableMapper;

    @Autowired
    private GenTableColumnMapper genTableColumnMapper;

    /**
     * 查询业务信息
     * 
     * @param id 业务ID
     * @return 业务信息
     */
    @Override
    public GenTable selectGenTableById(Long id)
    {
        GenTable genTable = genTableMapper.selectOneById(id);
        if (genTable != null) {
            genTable.setColumns(genTableColumnMapper.selectListByQuery(
                QueryWrapper.create().where(GenTableColumn::getTableId).eq(id).orderBy(GenTableColumn::getSort, true)));
        }
        setTableFromOptions(genTable);
        return genTable;
    }

    /**
     * 查询业务列表
     * 
     * @param genTable 业务信息
     * @return 业务集合
     */
    @Override
    public List<GenTable> selectGenTableList(GenTable genTable)
    {
        QueryWrapper qw = buildGenTableQuery(genTable);
        return genTableMapper.selectListByQuery(qw);
    }

    private QueryWrapper buildGenTableQuery(GenTable genTable) {
        QueryWrapper qw = QueryWrapper.create();
        if (StrUtil.isNotEmpty(genTable.getTableName())) qw.like(GenTable::getTableName, genTable.getTableName());
        if (StrUtil.isNotEmpty(genTable.getTableComment())) qw.like(GenTable::getTableComment, genTable.getTableComment());
        if (ObjectUtil.isNotNull(genTable.getParams().get("beginTime"))) qw.ge(GenTable::getCreateTime, genTable.getParams().get("beginTime"));
        if (ObjectUtil.isNotNull(genTable.getParams().get("endTime"))) qw.le(GenTable::getCreateTime, genTable.getParams().get("endTime"));
        qw.orderBy(GenTable::getCreateTime, false);
        return qw;
    }

    @Override
    public Page<GenTable> selectGenTablePage(Page<GenTable> page, GenTable genTable)
    {
        QueryWrapper qw = buildGenTableQuery(genTable);
        return genTableMapper.paginate(page, qw);
    }

    @Override
    public Page<GenTable> selectDbTablePage(Page<GenTable> page, GenTable genTable)
    {
        List<GenTable> all = selectDbTableList(genTable);
        int total = all.size();
        long pageNumber = page.getPageNumber();
        long pageSize = page.getPageSize();
        int fromIndex = (int) ((pageNumber - 1) * pageSize);
        int toIndex = Math.min(fromIndex + (int) pageSize, total);
        if (fromIndex >= total) {
            page.setRecords(new ArrayList<>());
        } else {
            page.setRecords(all.subList(fromIndex, toIndex));
        }
        page.setTotalRow(total);
        return page;
    }

    /**
     * 查询据库列表
     * 
     * @param genTable 业务信息
     * @return 数据库表集合
     */
    @Override
    public List<GenTable> selectDbTableList(GenTable genTable)
    {
        String sql = "select TABLE_NAME as table_name, TABLE_COMMENT as table_comment, "
            + "CREATE_TIME as create_time, UPDATE_TIME as update_time "
            + "from information_schema.tables "
            + "where table_schema = (select database()) and table_name not like 'qrtz_%' and table_name not like 'gen_%' "
            + "and table_name not in (select table_name from gen_table) order by create_time desc";
        return Db.selectListBySql(sql).stream()            .map(r -> {
                GenTable t = new GenTable();
                t.setTableName(r.getString("table_name"));
                t.setTableComment(r.getString("table_comment"));
                Object ct = r.get("create_time");
                if (ct != null) t.setCreateTime(toDate(ct));
                Object ut = r.get("update_time");
                if (ut != null) t.setUpdateTime(toDate(ut));
                return t;
            })
            .collect(Collectors.toList());
    }
    private static Date toDate(Object val) {
        if (val == null) return null;
        if (val instanceof Timestamp) return new Date(((Timestamp) val).getTime());
        if (val instanceof LocalDateTime) return Timestamp.valueOf((LocalDateTime) val);
        if (val instanceof Date) return (Date) val;
        if (val instanceof Number) return new Date(((Number) val).longValue());
        return null;
    }

    /**
     * 查询据库列表
     * 
     * @param tableNames 表名称组
     * @return 数据库表集合
     */
    @Override
    public List<GenTable> selectDbTableListByNames(String[] tableNames)
    {
        if (tableNames == null || tableNames.length == 0) return new ArrayList<>();
        String join = "'" + String.join("','", tableNames) + "'";
        String sql = "select TABLE_NAME as table_name, TABLE_COMMENT as table_comment, "
            + "CREATE_TIME as create_time, UPDATE_TIME as update_time "
            + "from information_schema.tables "
            + "where table_name not like 'qrtz_%' and table_name not like 'gen_%' and table_schema = (select database()) "
            + "and table_name in (" + join + ")";
        return Db.selectListBySql(sql).stream()            .map(r -> {
                GenTable t = new GenTable();
                t.setTableName(r.getString("table_name"));
                t.setTableComment(r.getString("table_comment"));
                Object ct = r.get("create_time");
                if (ct != null) t.setCreateTime(toDate(ct));
                Object ut = r.get("update_time");
                if (ut != null) t.setUpdateTime(toDate(ut));
                return t;
            })
            .collect(Collectors.toList());
    }

    /**
     * 查询所有表信息
     * 
     * @return 表信息集合
     */
    @Override
    public List<GenTable> selectGenTableAll()
    {
        return genTableMapper.selectListByQuery(QueryWrapper.create());
    }

    /**
     * 修改业务
     * 
     * @param genTable 业务信息
     * @return 结果
     */
    @Override
    @Transactional
    public void updateGenTable(GenTable genTable)
    {
        String options = JSON.toJSONString(genTable.getParams());
        genTable.setOptions(options);
        genTable.setUpdateTime(new Date());
        int row = genTableMapper.update(genTable);
        if (row > 0)
        {
            for (GenTableColumn genTableColumn : genTable.getColumns())
            {
                genTableColumnMapper.update(genTableColumn);
            }
        }
    }

    /**
     * 删除业务对象
     * 
     * @param tableIds 需要删除的数据ID
     * @return 结果
     */
    @Override
    @Transactional
    public void deleteGenTableByIds(Long[] tableIds)
    {
        genTableMapper.deleteBatchByIds(Arrays.asList(tableIds));
        genTableColumnMapper.deleteByQuery(
            QueryWrapper.create().where(GenTableColumn::getTableId).in(Arrays.asList(tableIds))
        );
    }

    /**
     * 创建表
     *
     * @param sql 创建表语句
     * @return 结果
     */
    @Override
    public boolean createTable(String sql)
    {
        return Db.updateBySql(sql) == 0;
    }

    /**
     * 导入表结构
     * 
     * @param tableList 导入表列表
     */
    @Override
    @Transactional
    public void importGenTable(List<GenTable> tableList, String tplWebType, String operName)
    {
        try
        {
            for (GenTable table : tableList)
            {
                String tableName = table.getTableName();
                table.setTplWebType(tplWebType);
                GenUtils.initTable(table, operName);
                table.setCreateTime(new Date());
                table.setUpdateTime(new Date());
                int row = genTableMapper.insertSelective(table);
                if (row > 0)
                {
                    // 保存列信息（insertSelective 会自动回写自增ID到 table.tableId）
                    List<GenTableColumn> genTableColumns = selectDbTableColumnsByName(tableName);
                    for (GenTableColumn column : genTableColumns)
                    {
                        GenUtils.initColumnField(column, table);
                        genTableColumnMapper.insertSelective(column);
                    }
                }
            }
        }
        catch (Exception e)
        {
            throw new ServiceException("导入失败：" + e.getMessage());
        }
    }

    /**
     * 预览代码
     * 
     * @param tableId 表编号
     * @return 预览数据列表
     */
    @Override
    public Map<String, String> previewCode(Long tableId)
    {
        Map<String, String> dataMap = new LinkedHashMap<>();
        // 查询表信息
        GenTable table = selectGenTableById(tableId);
        // 设置主子表信息
        setSubTable(table);
        // 设置主键列信息
        setPkColumn(table);
        VelocityInitializer.initVelocity();

        VelocityContext context = VelocityUtils.prepareContext(table);

        // 获取模板列表
        List<String> templates = VelocityUtils.getTemplateList(table);
        for (String template : templates)
        {
            // 渲染模板
            StringWriter sw = new StringWriter();
            Template tpl = Velocity.getTemplate(template, Constants.UTF8);
            tpl.merge(context, sw);
            dataMap.put(template, sw.toString());
        }
        return dataMap;
    }

    /**
     * 生成代码（下载方式）
     * 
     * @param tableName 表名称
     * @return 数据
     */
    @Override
    public byte[] downloadCode(String tableName)
    {
        return downloadCode(new String[] { tableName });
    }

    /**
     * 生成代码（自定义路径）
     * 
     * @param tableName 表名称
     */
    @Override
    public void generatorCode(String tableName)
    {
        // 查询表信息
        GenTable table = genTableMapper.selectOneByQuery(QueryWrapper.create().where(GenTable::getTableName).eq(tableName));
        // 设置主子表信息
        setSubTable(table);
        // 设置主键列信息
        setPkColumn(table);

        VelocityInitializer.initVelocity();

        VelocityContext context = VelocityUtils.prepareContext(table);

        // 获取模板列表
        List<String> templates = VelocityUtils.getTemplateList(table);
        for (String template : templates)
        {
            if (!StrUtil.containsAny(template, "sql.vm", "api.js.vm", "api.ts.vm", "type.ts.vm", "index.ts.vm", "index.vue.vm", "index-tree.vue.vm", "view.vue.vm"))
            {
                // 渲染模板
                StringWriter sw = new StringWriter();
                Template tpl = Velocity.getTemplate(template, Constants.UTF8);
                tpl.merge(context, sw);
                try
                {
                    String path = getGenPath(table, template);
                    FileUtil.writeString(sw.toString(), new File(path), cn.hutool.core.util.CharsetUtil.UTF_8);
                }
                catch (Exception e)
                {
                    throw new ServiceException("渲染模板失败，表名：" + table.getTableName());
                }
            }
        }
    }

    /**
     * 同步数据库
     * 
     * @param tableName 表名称
     */
    @Override
    @Transactional
    public void synchDb(String tableName)
    {
        GenTable table = genTableMapper.selectOneByQuery(QueryWrapper.create().where(GenTable::getTableName).eq(tableName));
        if (table == null) return;
        List<GenTableColumn> tableColumns = genTableColumnMapper.selectListByQuery(
            QueryWrapper.create().where(GenTableColumn::getTableId).eq(table.getTableId()).orderBy(GenTableColumn::getSort, true));
        table.setColumns(tableColumns);
        Map<String, GenTableColumn> tableColumnMap = tableColumns.stream().collect(Collectors.toMap(GenTableColumn::getColumnName, Function.identity()));

        List<GenTableColumn> dbTableColumns = selectDbTableColumnsByName(tableName);
        if (CollUtil.isEmpty(dbTableColumns))
        {
            throw new ServiceException("同步数据失败，原表结构不存在");
        }
        List<String> dbTableColumnNames = dbTableColumns.stream().map(GenTableColumn::getColumnName).collect(Collectors.toList());

        dbTableColumns.forEach(column -> {
            GenUtils.initColumnField(column, table);
            if (tableColumnMap.containsKey(column.getColumnName()))
            {
                GenTableColumn prevColumn = tableColumnMap.get(column.getColumnName());
                column.setColumnId(prevColumn.getColumnId());
                if (column.isList())
                {
                    // 如果是列表，继续保留查询方式/字典类型选项
                    column.setDictType(prevColumn.getDictType());
                    column.setQueryType(prevColumn.getQueryType());
                }
                if (StrUtil.isNotEmpty(prevColumn.getIsRequired()) && !column.isPk()
                        && (column.isInsert() || column.isEdit())
                        && ((column.isUsableColumn()) || (!column.isSuperColumn())))
                {
                    // 如果是(新增/修改&非主键/非忽略及父属性)，继续保留必填/显示类型选项
                    column.setIsRequired(prevColumn.getIsRequired());
                    column.setHtmlType(prevColumn.getHtmlType());
                }
                genTableColumnMapper.update(column);
            }
            else
            {
                genTableColumnMapper.insertSelective(column);
            }
        });

        List<GenTableColumn> delColumns = tableColumns.stream().filter(column -> !dbTableColumnNames.contains(column.getColumnName())).collect(Collectors.toList());
        if (CollUtil.isNotEmpty(delColumns))
        {
            genTableColumnMapper.deleteByQuery(QueryWrapper.create().where(GenTableColumn::getColumnId).in(
                    delColumns.stream().map(GenTableColumn::getColumnId).collect(Collectors.toList())));
        }
    }

    /**
     * 批量生成代码（下载方式）
     * 
     * @param tableNames 表数组
     * @return 数据
     */
    @Override
    public byte[] downloadCode(String[] tableNames)
    {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ZipOutputStream zip = new ZipOutputStream(outputStream);
        Map<String, StringBuffer> typeFiles = new HashMap<>();
        for (String tableName : tableNames)
        {
            generatorCode(tableName, zip, typeFiles);
        }
        for (Map.Entry<String, StringBuffer> entry : typeFiles.entrySet())
        {
            writeToZip(zip, entry.getKey(), entry.getValue().toString());
        }
        IoUtil.close(zip);
        return outputStream.toByteArray();
    }

    /**
     * 查询表信息并生成代码
     */
    private void generatorCode(String tableName, ZipOutputStream zip, Map<String, StringBuffer> typeFiles)
    {
        // 查询表信息
        GenTable table = genTableMapper.selectOneByQuery(QueryWrapper.create().where(GenTable::getTableName).eq(tableName));
        // 设置主子表信息
        setSubTable(table);
        // 设置主键列信息
        setPkColumn(table);

        VelocityInitializer.initVelocity();

        VelocityContext context = VelocityUtils.prepareContext(table);

        // 获取模板列表
        List<String> templates = VelocityUtils.getTemplateList(table);
        for (String template : templates)
        {
            // 渲染模板
            StringWriter sw = new StringWriter();
            Template tpl = Velocity.getTemplate(template, Constants.UTF8);
            tpl.merge(context, sw);
            String fileName = VelocityUtils.getFileName(template, table);
            // index-bak.ts 模版，追加内容
            if (fileName.contains("index-bak.ts"))
            {
                if (!typeFiles.containsKey(fileName))
                {
                    typeFiles.put(fileName, new StringBuffer(sw.toString()));
                }
                else
                {
                    Arrays.stream(sw.toString().split("\n")).filter(line -> line.startsWith("export * from")).forEach(line -> typeFiles.get(fileName).append("\n").append(line));
                }
            }
            else
            {
                // 其他文件正常添加
                writeToZip(zip, fileName, sw.toString());
            }
        }
    }

    /**
     * 将字符串内容写入ZIP输出流
     * 
     * @param zip ZIP输出流
     * @param fileName ZIP条目名称（即文件名）
     * @param content 要写入的内容
     */
    private void writeToZip(ZipOutputStream zip, String fileName, String content)
    {
        try
        {
            zip.putNextEntry(new ZipEntry(fileName));
            IoUtil.write(zip, Constants.UTF8, false, content);
            zip.flush();
            zip.closeEntry();
        }
        catch (IOException e)
        {
            log.error("写入ZIP文件失败，文件名: " + fileName, e);
        }
    }

    /**
     * 修改保存参数校验
     * 
     * @param genTable 业务信息
     */
    @Override
    public void validateEdit(GenTable genTable)
    {
        if (GenConstants.TPL_TREE.equals(genTable.getTplCategory()))
        {
            String options = JSON.toJSONString(genTable.getParams());
            JSONObject paramsObj = JSON.parseObject(options);
            if (StrUtil.isEmpty(paramsObj.getString(GenConstants.TREE_CODE)))
            {
                throw new ServiceException("树编码字段不能为空");
            }
            else if (StrUtil.isEmpty(paramsObj.getString(GenConstants.TREE_PARENT_CODE)))
            {
                throw new ServiceException("树父编码字段不能为空");
            }
            else if (StrUtil.isEmpty(paramsObj.getString(GenConstants.TREE_NAME)))
            {
                throw new ServiceException("树名称字段不能为空");
            }
        }
        else if (GenConstants.TPL_SUB.equals(genTable.getTplCategory()))
        {
            if (StrUtil.isEmpty(genTable.getSubTableName()))
            {
                throw new ServiceException("关联子表的表名不能为空");
            }
            else if (StrUtil.isEmpty(genTable.getSubTableFkName()))
            {
                throw new ServiceException("子表关联的外键名不能为空");
            }
        }
    }

    /**
     * 设置主键列信息
     * 
     * @param table 业务表信息
     */
    public void setPkColumn(GenTable table)
    {
        for (GenTableColumn column : table.getColumns())
        {
            if (column.isPk())
            {
                table.setPkColumn(column);
                break;
            }
        }
        if (ObjectUtil.isNull(table.getPkColumn()))
        {
            table.setPkColumn(table.getColumns().get(0));
        }
        if (GenConstants.TPL_SUB.equals(table.getTplCategory()))
        {
            for (GenTableColumn column : table.getSubTable().getColumns())
            {
                if (column.isPk())
                {
                    table.getSubTable().setPkColumn(column);
                    break;
                }
            }
            if (ObjectUtil.isNull(table.getSubTable().getPkColumn()))
            {
                table.getSubTable().setPkColumn(table.getSubTable().getColumns().get(0));
            }
        }
    }

    /**
     * 设置主子表信息
     * 
     * @param table 业务表信息
     */
    public void setSubTable(GenTable table)
    {
        String subTableName = table.getSubTableName();
        if (StrUtil.isNotEmpty(subTableName))
        {
            table.setSubTable(genTableMapper.selectOneByQuery(QueryWrapper.create().where(GenTable::getTableName).eq(subTableName)));
        }
    }

    private List<GenTableColumn> selectDbTableColumnsByName(String tableName) {
        List<Row> rows = Db.selectListBySql(
            "select COLUMN_NAME as column_name, "
            + "(case when (IS_NULLABLE = 'no' and COLUMN_KEY != 'PRI') then '1' else '0' end) as is_required, "
            + "(case when COLUMN_KEY = 'PRI' then '1' else '0' end) as is_pk, "
            + "ORDINAL_POSITION as sort, "
            + "COLUMN_COMMENT as column_comment, "
            + "(case when EXTRA = 'auto_increment' then '1' else '0' end) as is_increment, "
            + "COLUMN_TYPE as column_type "
            + "from information_schema.columns where table_schema = (select database()) and table_name = '" + tableName + "' order by ORDINAL_POSITION"
        );
        List<GenTableColumn> result = new ArrayList<>();
        for (Row r : rows) {
            GenTableColumn c = new GenTableColumn();
            c.setColumnName(r.getString("column_name"));
            c.setIsRequired(r.getString("is_required"));
            c.setIsPk(r.getString("is_pk"));
            c.setSort(r.getInt("sort"));
            c.setColumnComment(r.getString("column_comment"));
            c.setIsIncrement(r.getString("is_increment"));
            c.setColumnType(r.getString("column_type"));
            result.add(c);
        }
        return result;
    }

    /**
     * 设置代码生成其他选项值
     * 
     * @param genTable 设置后的生成对象
     */
    public void setTableFromOptions(GenTable genTable)
    {
        JSONObject paramsObj = JSON.parseObject(genTable.getOptions());
        if (ObjectUtil.isNotNull(paramsObj))
        {
            String treeCode = paramsObj.getString(GenConstants.TREE_CODE);
            String treeParentCode = paramsObj.getString(GenConstants.TREE_PARENT_CODE);
            String treeName = paramsObj.getString(GenConstants.TREE_NAME);
            Long parentMenuId = paramsObj.getLongValue(GenConstants.PARENT_MENU_ID);
            String parentMenuName = paramsObj.getString(GenConstants.PARENT_MENU_NAME);
            boolean isView = paramsObj.getBooleanValue(GenConstants.GEN_VIEW);

            genTable.setTreeCode(treeCode);
            genTable.setTreeParentCode(treeParentCode);
            genTable.setTreeName(treeName);
            genTable.setParentMenuId(parentMenuId);
            genTable.setParentMenuName(parentMenuName);
            genTable.setView(isView);
        }
    }

    /**
     * 获取代码生成地址
     * 
     * @param table 业务表信息
     * @param template 模板文件路径
     * @return 生成地址
     */
    public static String getGenPath(GenTable table, String template)
    {
        String genPath = table.getGenPath();
        if (StrUtil.equals(genPath, "/"))
        {
            return System.getProperty("user.dir") + File.separator + "src" + File.separator + VelocityUtils.getFileName(template, table);
        }
        return genPath + File.separator + VelocityUtils.getFileName(template, table);
    }
}