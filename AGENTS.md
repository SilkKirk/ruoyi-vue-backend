# RuoYi 后端 — Agent 指令

Spring Boot 4.1 / JDK 17 / MyBatis-Flex 1.11 (**非 MyBatis**) / Flowable 8.0 / SpringDoc 3.0 / Hutool 5.8 / Lombok。

## 构建与启动

```bash
mvn clean install -DskipTests                                       # 编译（无测试）
java -jar ruoyi-admin/target/ruoyi-admin.jar                         # 直接启动
mvn spring-boot:run -f ruoyi-admin/pom.xml                           # Maven 启动
ry.bat                                                               # Windows 菜单启停
```

**启动流程（Windows）**：
1. `cd ruoyi-vue-backend && mvn clean install -DskipTests`
2. 杀旧进程：`netstat -ano | Select-String ":8080"` 取 PID 后 `Stop-Process -Id $pid -Force`
3. `java -jar ruoyi-admin/target/ruoyi-admin.jar`（或用 `start-server` 后台运行）
4. 轮询 8080 端口确认就绪

## 项目布局

| 模块 | 作用 |
|------|------|
| `ruoyi-admin` | 入口 `com.ruoyi.RuoYiApplication`，配置文件在此 |
| `ruoyi-workflow` | **自定义模块**（非上游），Flowable 工作流 |

其余 5 模块（framework/system/common/quartz/generator）为标准 RuoYi 结构。

## 关键配置文件

- `ruoyi-admin/src/main/resources/application.yml` — 主配置 + Flowable + token
- `ruoyi-admin/src/main/resources/application-druid.yml` — 数据源 + Druid 监控台
- `pom.xml` — 依赖版本，阿里云镜像 `https://maven.aliyun.com/repository/public`

## Controller 分页模式

所有列表接口统一模式：
```java
return getDataTable(service.selectXxxList(startPage(Xxx.class), xxx));
```
`startPage(EntityClass)` 由 `BaseController` 提供，自动读取 `pageNum`/`pageSize` 查询参数并返回 MyBatis-Flex `Page` 对象。

**常见陷阱**：查询参数（如 `processName`）会通过 Spring 绑定到实体类，但 **Service 层必须显式应用到 Flowable/MyBatis 查询中**，否则过滤无效。

## 安全要点

- 免认证路径：`/druid/**` `/swagger-ui/**` `/v3/api-docs/**` `/profile/**`
- XSS 过滤器仅对 JSON content-type 生效（form/query 绕过）
- 防盗链接口未启用（`referer.enabled: false`）

### 硬编码凭据

| 资源 | 凭据 |
|------|------|
| MySQL | `ruoyi / 123456` |
| Redis | `123456` |
| Druid 监控 | `ruoyi / 123456` |
| JWT secret | 64 字符固定串 |
| 管理员 | `admin / admin123` |

## Flowable 工作流

- `database-schema-update: true` 启动自动建表
- `check-process-definitions: false` 不自动部署 BPMN
- 模块入口：`ruoyi-workflow/src/main/java/com/ruoyi/workflow/`
- **HistoricProcessInstanceQuery 无 processDefinitionNameLike 方法**，名称过滤只能用 `processDefinitionName(exactName)` 精确匹配
- 状态过滤用 `.finished()` / `.unfinished()`，区分已结束和运行中

## MyBatis-Flex 注意事项

- 使用 `QueryWrapper`、`@Table`、`@Column` 注解，非标准 MyBatis XML（但兼容 XML）
- 分页用 `Page<T>` 泛型类，非 `PageInfo` 或 `RowBounds`
- Druid 配置 `multi-statement-allow: true`

## 运维坑点

- Maven 仓库缓存偶尔损坏（`E:\maven\maven-repository\com\ruoyi`），`mvn clean install` 重装可修复
- `AsyncManager` 的 `shutdown()` 从未被调用（无 `@PreDestroy`）
- `scheduler.clear()` 在启动时清除所有 Quartz 任务
- Redis `keys(*)` 在 TokenService / DictUtils / CacheController 中使用（生产 O(N) 风险）

## 已知代码缺陷

- **路径穿越**：`CommonController.download()` 未防御绝对路径
- **SQL 注入**：`DataScopeHelper` 中 `qw.and(condition)` 直接拼接原始 SQL
- **异常泄露**：多个 Controller 将 `e.getMessage()` 返回给前端
- **TestController 并发**：静态 `LinkedHashMap` 非线程安全

## 提交通知

- 勿提交 `ruoyi-admin.err`、`*.log` 等运行产物
- 勿将 `e.getMessage()` 返回给客户端
- 空 `catch` 至少打一条日志
- `@PathVariable` 加 `@Min`/`@Max` 校验
