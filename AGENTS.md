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
├── ruoyi-common/         # Shared utils, enums, annotations, base classes, XSS filter, TreeUtils
├── ruoyi-framework/      # Security (JWT + Spring Security), AOP aspects, data source, configs, interceptors
├── ruoyi-system/         # Business services + MyBatis-Flex mappers + domain entities
├── ruoyi-quartz/         # Scheduled-task management module
├── ruoyi-generator/      # Code generator (Velocity templates)
├── ruoyi-ui/             # Vue 2 frontend (Vue CLI, Element UI)
├── sql/                  # Database init scripts (ry_20260417.sql, quartz.sql)
└── pom.xml               # Parent POM (JDK 17, Spring Boot 3.5.14, MyBatis-Flex 1.10.9, Hutool 5.8.34)
```

Key patterns:
- Controllers extend `BaseController` and use `@PreAuthorize("@ss.hasPermi('system:user:list')")` for permissions.
- **Service interfaces extend `IService<Entity>`** (from `com.mybatisflex.core.service.IService`); implementations extend `ServiceImpl<Mapper, Entity>`.
- **Controllers use IService standard methods** (`getById`, `save`, `updateById`, `removeByIds`) — no custom `insert`/`update`/`delete` wrappers in services.
- Mappers extend `BaseMapper<Entity>` with no XML files; queries use `QueryWrapper`.
- Entities are annotated with `@Table("table_name")` and `@Id` from `com.mybatisflex.annotation`.

## Build, Test, and Development Commands

### Backend (Maven)

```bash
mvn clean compile                                    # Compile all modules
mvn clean package -pl ruoyi-admin -am                # Package admin as runnable JAR
cd ruoyi-admin && mvn spring-boot:run                # Run locally (JDK 17+, MySQL + Redis required)
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

1. Import `sql/ry_20260417.sql` (core tables + seed data), then `sql/quartz.sql`.
2. Update credentials in `ruoyi-admin/src/main/resources/application-druid.yml`.

## Coding Style & Naming Conventions

- **Java**: Standard Java conventions. Controllers use `@Autowired` field injection on interfaces. Service interfaces follow `ISysXxxService`; implementations `SysXxxServiceImpl`.
- **Frontend**: 2-space indentation, LF line endings, UTF-8 encoding (see `ruoyi-ui/.editorconfig`).
- **Package naming**: `com.ruoyi.<module>.<layer>` — e.g., `com.ruoyi.system.service`, `com.ruoyi.generator.controller`.
- **Entity naming**: Domain classes in `com.ruoyi.common.core.domain.entity` (`SysUser`, `SysRole`); join tables use `SysUserRole`, `SysRoleMenu`, etc.
- **Utilities**: Prefer **Hutool** (`cn.hutool.*`) over ad-hoc utility classes. Common patterns like tree-building are centralized in `TreeUtils` (wraps `cn.hutool.core.lang.tree.TreeUtil`).

## MyBatis-Flex Data Access Patterns

### Services

Service interfaces extend `IService<Entity>`; implementations extend `ServiceImpl<Mapper, Entity>`:

```java
public interface ISysUserService extends IService<SysUser> { }

public class SysUserServiceImpl
    extends ServiceImpl<SysUserMapper, SysUser>
    implements ISysUserService { }
```

`IService` provides built-in `getById()`, `save()`, `updateById()`, `removeByIds()`, `list()`, etc. — override only to add logic.

### Query Building

Build queries with `QueryWrapper` in service implementations:

```java
QueryWrapper qw = QueryWrapper.create()
    .select(...)
    .from(SysUser.class)
    .where(SysUser::getUserName).like(name)
    .orderBy(SysUser::getCreateTime, false);
```

### Pagination

`BaseController` provides `Page<T> startPage(Class<T>)` which reads page params from the request. Services use `mapper.paginate(page, queryWrapper)`:

```java
// Controller
Page<SysUser> page = startPage(SysUser.class);
page = userService.selectUserPage(page, user);
return getDataTable(page);

// Service
public Page<SysUser> selectUserPage(Page<SysUser> page, SysUser user) {
    QueryWrapper qw = buildUserQuery(user);
    return userMapper.paginate(page, qw);
}
```

### Data Scope

Use `DataScopeHelper.applyDataScope(queryWrapper, entity.getParams())` to inject row-level data permissions set by `DataScopeAspect`.

### Auto Trim

`@AutoTrim` trims String fields on deserialization — works via `AutoTrimModule` (Jackson) for JSON and `AutoTrimControllerAdvice` (`@InitBinder`) for form params.

### Tree Building

Use `TreeUtils.buildTree(flatList, rootId, idGetter, parentIdGetter, childrenSetter)` to convert flat entity lists to nested tree structures. Based on Hutool `TreeUtil`.

## Testing Guidelines

No test suite currently exists. When adding tests:
- Place them under `src/test/java/` mirroring the main source path.
- Use JUnit 5 (included via Spring Boot starter).
- Name test classes `*Test.java` or `*Tests.java`.

## Commit & Pull Request Guidelines

- **Commit style**: Descriptive Chinese-language summaries (e.g., `用户密码支持自定义配置规则`). One logical change per commit.
- **PRs**: Reference the upstream Gitee repository at `https://gitee.com/y_project/RuoYi-Vue`. Include a clear description, linked issues, and screenshots for UI changes.
- **Branch strategy**: This is the `springboot3` branch. See the README for `master` (Spring Boot 4.x) and `springboot2` branches.

## Security & Configuration Tips

- **JWT secret**: Override `token.secret` in `application.yml` for production.
- **Password policy**: Configure `user.password.maxRetryCount` and `user.password.lockTime`.
- **XSS filter**: Enabled on `/system/*`, `/monitor/*`, `/tool/*`. Add exclusions in `xss.excludes`.
- **Druid console**: Available at `/druid/` (default: `ruoyi` / `123456`). Restrict in production.
