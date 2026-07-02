# RuoYi 后端 (v3.9.2) — Agent 指令

## 项目结构

Maven 多模块（7 个），JDK 17，Spring Boot 4.1.0，MyBatis-Flex，Flowable 7.1.0，SpringDoc。

| 模块 | 用途 |
|------|------|
| `ruoyi-admin` | Web 启动入口（Spring Boot main class） |
| `ruoyi-framework` | 安全配置、拦截器、跨域、线程池 |
| `ruoyi-system` | 系统业务服务（用户、角色、菜单等） |
| `ruoyi-common` | 工具类、异常定义、过滤器 |
| `ruoyi-quartz` | Quartz 定时任务 |
| `ruoyi-generator` | 代码生成器 |
| `ruoyi-workflow` | Flowable 工作流引擎 |

## 常用命令

```bash
mvn clean package -DskipTests          # 构建（无测试配置，默认跳过）
java -jar ruoyi-admin/target/ruoyi-admin.jar
ry.sh start|stop|restart|status        # Linux 启停
docker compose up -d                   # Docker 一键部署（含前端）
```

## 关键配置文件

- `ruoyi-admin/src/main/resources/application.yml` — 主配置（token/Redis/验证码/XSS/防盗链）
- `ruoyi-admin/src/main/resources/application-druid.yml` — 数据源、Druid 监控台
- `pom.xml` — 版本声明（所有依赖版本集中管理）

## 架构要点

### 安全（SecurityConfig.java）
- `/druid/**`、`/swagger-ui/**`、`/v3/api-docs/**`、`/swagger-ui/**`、`/profile/**` 均为 **`.permitAll()`**（第 103-106 行），无需认证即可访问
- CORS：`addAllowedOriginPattern("*")` 允许所有来源（ResourcesConfig.java）
- XSS 过滤器：仅对 JSON content-type 生效，表单参数和 query string 会绕过
- 防盗链（RefererFilter）：`referer.contains(domain)` 可用子域名绕过；空域名列表使过滤器完全失效
- 所有凭据硬编码在 yml 中（DB: ruoyi/123456, Redis: 123456, Druid 监控: ruoyi/123456, JWT secret 固定 64 字符）

### MyBatis-Flex（非 MyBatis）
- 使用 `QueryWrapper`、`@Table`、`@Column` 注解，非标准 MyBatis XML
- Mapper XML 仍兼容，但推荐 Flex 原生 API
- Druid 墙配置 `multi-statement-allow: true`（允许多语句 SQL）

### Flowable 工作流
- `database-schema-update: true` 启动时自动建表
- `check-process-definitions: false` 不自动部署 classpath 下的 BPMN 文件
- Flowable 7.1.0 可能有已知 CVE，注意及时更新

## 已知问题（来自代码审查）

- **路径穿越**：CommonController.download() 使用用户传入 fileName 拼接路径，`checkAllowDownload` 未防御绝对路径
- **SQL 注入风险**：DataScopeHelper 中 `qw.and(condition)` 直接拼接原始 SQL 条件
- **Quartz 任务丢失**：SysJobServiceImpl:45 `scheduler.clear()` 启动时清除所有已注册任务
- **AsyncManager 泄漏**：shutdown() 方法从未被调用（无 @PreDestroy），线程池会被 JVM 直接终止
- **Redis keys()**：TokenService、DictUtils、CacheController 在生产路径使用 O(N) 的 `keys()` 命令
- **响应流提前关闭**：FileUtils.writeBytes() 中 `IoUtil.close(os)` 在上层 Servlet 完成写入前关闭了 OutputStream
- **异常信息泄露**：多个 Controller 将 `e.getMessage()` 直接返回给前端
- **TestController 并发**：静态 LinkedHashMap 在多线程 PUT/DELETE 下非线程安全

## 提交通知

- 硬编码凭据（DB/Redis/JWT/监控台）必须先外置为环境变量
- 不要将 `e.getMessage()` 返回给客户端
- 空 `catch(Exception e) {}` 至少打一条日志
- `@PathVariable` ID 参数需加 `@Min`/`@Max` 校验
- 工具库 Hutool 5.8.46 可能有 SSRF 漏洞（CVE-2024-33681），考虑升级