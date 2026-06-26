# Repository Guidelines

## Project Structure & Module Organization

This is **RuoYi-Vue v3.9.2**, a Spring Boot 3 + Vue 2 full-stack rapid development framework. The backend is a Maven multi-module project; the frontend lives under `ruoyi-ui/`.

```
ruoyi-vue-backend/
├── ruoyi-admin/          # Entry point (RuoYiApplication.java) + REST controllers
│   └── src/main/java/com/ruoyi/web/controller/
│       ├── common/       # Captcha, file upload/download
│       ├── monitor/      # Server, cache, logs, online users
│       ├── system/       # User, role, menu, dept, notice, config...
│       └── tool/         # Swagger test controller
├── ruoyi-common/         # Shared utils, enums, annotations, base classes, XSS filter
├── ruoyi-framework/      # Security (JWT + Spring Security), AOP aspects, data source, configs, interceptors
├── ruoyi-system/         # Business services + MyBatis-Flex mappers + domain entities
├── ruoyi-quartz/         # Scheduled-task management module
├── ruoyi-generator/      # Code generator (Velocity templates)
├── ruoyi-ui/             # Vue 2 frontend (Vue CLI, Element UI)
├── sql/                  # Database init scripts (ry_20260417.sql, quartz.sql)
└── pom.xml               # Parent POM (JDK 17, Spring Boot 3.5.11, MyBatis-Flex 1.10.9)
```

Key patterns:
- Controllers extend `BaseController` and use `@PreAuthorize("@ss.hasPermi('system:user:list')")` for permissions.
- Services follow the `ISysXxxService` / `SysXxxServiceImpl` naming convention.
- **Mappers use MyBatis-Flex exclusively** — no XML mapper files. Each mapper extends `BaseMapper<Entity>` and queries are built with `QueryWrapper` in service implementations.
- Entities are annotated with `@Table("table_name")` and `@Id` from `com.mybatisflex.annotation`.

## Build, Test, and Development Commands

### Backend (Maven)

```bash
# Compile all modules
mvn clean compile

# Package the admin module as a runnable JAR
mvn clean package -pl ruoyi-admin -am

# Run locally (JDK 17+ required, MySQL + Redis must be running)
cd ruoyi-admin && mvn spring-boot:run
```

### Frontend (Vue CLI)

```bash
cd ruoyi-ui
npm install           # Install dependencies
npm run dev           # Start dev server (hot-reload)
npm run build:prod    # Production build
```

### Startup Scripts

- **Linux/macOS**: `./ry.sh start|stop|restart|status` (JVM: `-Xms512m -Xmx1024m`)
- **Windows**: `ry.bat` or `bin/run.bat`

### Database

Import the SQL scripts in order:
1. `sql/ry_20260417.sql` — core system tables + seed data
2. `sql/quartz.sql` — Quartz scheduler tables

Update `ruoyi-admin/src/main/resources/application-druid.yml` with your DB credentials.

## Coding Style & Naming Conventions

- **Java**: Follow standard Java conventions. Controllers use `@Autowired` field injection on interfaces. Each method documents permission requirements with `@PreAuthorize`.
- **Frontend**: 2-space indentation, LF line endings, UTF-8 encoding (see `ruoyi-ui/.editorconfig`).
- **Package naming**: `com.ruoyi.<module>.<layer>` — e.g., `com.ruoyi.system.service`, `com.ruoyi.generator.controller`.
- **Entity naming**: Domain classes in `com.ruoyi.common.core.domain.entity` (e.g., `SysUser`, `SysRole`); related tables use `SysUserRole`, `SysRoleMenu`, etc.

## MyBatis-Flex Data Access Patterns

### Entities

Entities use MyBatis-Flex annotations instead of XML mapping:

```java
@Table("sys_user")
public class SysUser extends BaseEntity {
    @Id
    private Long userId;
    private String userName;
    // ...
}
```

### Mappers

Mappers extend `BaseMapper<Entity>` — no XML and no method declarations needed:

```java
public interface SysUserMapper extends BaseMapper<SysUser> { }
```

### Query Building

Build queries in service implementations with `QueryWrapper`:

```java
QueryWrapper qw = QueryWrapper.create()
    .select(...)
    .from(SysUser.class)
    .where(SysUser::getUserName).like(name)
    .orderBy(SysUser::getCreateTime, false);
```

### Pagination

Use `PageUtils.startPage(pageNum, pageSize, orderBy)` before executing the query and `PageUtils.clearPage()` in `BaseController.getDataTable()`. A custom `FlexPageInterceptor` (registered in `MyBatisConfig`) intercepts SQL to inject `LIMIT` and run a separate `COUNT` query.

### Data Scope

Use `DataScopeHelper.applyDataScope(queryWrapper, entity.getParams())` to inject row-level data permission conditions set by `DataScopeAspect`.

### Auto Trim

The `@AutoTrim` annotation auto-trims String fields on deserialization. It works via:
- **JSON**: `AutoTrimModule` (Jackson module, registered in `ApplicationConfig`)
- **Form/query params**: `AutoTrimControllerAdvice` (Spring `@InitBinder`)

Apply `@AutoTrim` on a class to trim all String fields, or on individual fields for targeted trimming.

## Testing Guidelines

The repository does not currently include a test suite. When adding tests:
- Place them under `src/test/java/` mirroring the main source path.
- Use JUnit 5 (included via Spring Boot starter).
- Name test classes `*Test.java` or `*Tests.java`.

## Commit & Pull Request Guidelines

- **Commit style**: Descriptive Chinese-language summaries (e.g., `用户密码支持自定义配置规则`). Keep each commit focused on a single logical change.
- **PRs**: Reference the upstream Gitee repository at `https://gitee.com/y_project/RuoYi-Vue`. Include a clear description of the problem solved, linked issues if any, and screenshots for UI changes.
- **Branch strategy**: This is the `springboot3` branch (JDK 17 / Spring Boot 3.x). See the README for the `master` (Spring Boot 4.x) and `springboot2` (JDK 8) branches.

## Security & Configuration Tips

- **JWT secret**: Override `token.secret` in `application.yml` for production.
- **Password policy**: Max retry count (`user.password.maxRetryCount`) and lock time (`user.password.lockTime`) are configurable.
- **XSS filter**: Enabled by default on `/system/*`, `/monitor/*`, `/tool/*`. Add exclusions in `xss.excludes`.
- **Druid console**: Available at `/druid/` (default login: `ruoyi` / `123456`). Restrict access in production.
