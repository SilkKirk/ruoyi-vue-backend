<p align="center">
	<img alt="logo" src="https://oscimg.oschina.net/oscnet/up-d3d0a9303e11d522a06cd263f3079027715.png">
</p>
<h1 align="center" style="margin: 30px 0 30px; font-weight: bold;">RuoYi v3.9.2</h1>
<h4 align="center">基于SpringBoot+Vue前后端分离的Java快速开发框架</h4>
<p align="center">
	<a href="https://github.com/SilkKirk/ruoyi-vue-backend/stargazers"><img src="https://img.shields.io/github/stars/SilkKirk/ruoyi-vue-backend?style=social"></a>
	<a href="https://github.com/SilkKirk/ruoyi-vue-backend"><img src="https://img.shields.io/badge/RuoYi-v3.9.2-brightgreen.svg"></a>
	<a href="https://github.com/SilkKirk/ruoyi-vue-backend/blob/master/LICENSE"><img src="https://img.shields.io/github/license/mashape/apistatus.svg"></a>
</p>

## 平台简介

若依是一套全部开源的快速开发平台，毫无保留给个人及企业免费使用。

* 本仓库为基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 的定制分支，在官方基础上进行了以下改进：
* **ORM 框架**：MyBatis → **MyBatis-Flex**（v1.11.8），更轻量、更灵活。
* **工作流引擎**：新增 **ruoyi-workflow** 模块，集成 **Flowable 7.1.0** 工作流引擎，支持流程设计、审批流转等。
* **Spring Boot**：升级至 **4.1.0**，基于 JDK 17。
* **API 文档**：Swagger → **SpringDoc**（v3.0.3），更贴合 Spring Boot 4 生态。
* **Docker 部署**：提供 Dockerfile 及 docker-compose.yml，一键启动前后端 + MySQL + Redis。
* 权限认证使用 Jwt，支持多终端认证系统。
* 支持加载动态权限菜单，多方式轻松权限控制。
* 高效率开发，使用代码生成器可以一键生成前后端代码。

## 技术栈对比（与上游）

| 维度          | 上游 RuoYi-Vue      | 本分支（自定义）                       |
| :------------ | :----------------- | :----------------------------------- |
| ORM           | MyBatis            | **MyBatis-Flex**                     |
| Spring Boot   | 3.x                | **4.1.0**                           |
| JDK           | 17+                | **17**                               |
| 工作流        | 无                 | **Flowable 7.1.0（ruoyi-workflow）** |
| API 文档      | Swagger            | **SpringDoc**                        |
| 工具库        | -                  | **Hutool, Lombok**                   |
| 容器部署      | -                  | **Docker + docker-compose**          |

## 内置功能

1.  用户管理：用户是系统操作者，该功能主要完成系统用户配置。
2.  部门管理：配置系统组织机构（公司、部门、小组），树结构展现支持数据权限。
3.  岗位管理：配置系统用户所属担任职务。
4.  菜单管理：配置系统菜单，操作权限，按钮权限标识等。
5.  角色管理：角色菜单权限分配、设置角色按机构进行数据范围权限划分。
6.  字典管理：对系统中经常使用的一些较为固定的数据进行维护。
7.  参数管理：对系统动态配置常用参数。
8.  通知公告：系统通知公告信息发布维护。
9.  操作日志：系统正常操作日志记录和查询；系统异常信息日志记录和查询。
10. 登录日志：系统登录日志记录查询包含登录异常。
11. 在线用户：当前系统中活跃用户状态监控。
12. 定时任务：在线（添加、修改、删除）任务调度包含执行结果日志。
13. 代码生成：前后端代码的生成（java、html、xml、sql）支持 CRUD 下载。
14. 系统接口：根据业务代码自动生成相关的 api 接口文档。
15. 服务监控：监视当前系统 CPU、内存、磁盘、堆栈等相关信息。
16. 缓存监控：对系统的缓存信息查询，命令统计等。
17. 在线构建器：拖动表单元素生成相应的 HTML 代码。
18. 连接池监视：监视当前系统数据库连接池状态，可进行分析 SQL 找出系统性能瓶颈。

## 项目模块

```
ruoyi-vue-backend
├── ruoyi-admin        — 系统启动入口
├── ruoyi-common       — 通用工具与公共组件
├── ruoyi-framework    — 核心框架配置（安全、拦截器、跨域等）
├── ruoyi-generator    — 代码生成器
├── ruoyi-quartz       — 定时任务
├── ruoyi-system       — 系统业务模块
└── ruoyi-workflow     — 工作流引擎（Flowable）
```

## 本地开发

### 环境要求

- JDK 17+
- Maven 3.8+
- MySQL 8.0+
- Redis 7+

### 快速启动

```bash
# 1. 克隆项目
git clone https://github.com/SilkKirk/ruoyi-vue-backend.git

# 2. 导入数据库
#    在 MySQL 中创建数据库 ruoyi，执行 sql/ 目录下的建表脚本

# 3. 修改配置
#    编辑 ruoyi-admin/src/main/resources/application-druid.yml
#    配置数据库连接信息
#    编辑 ruoyi-admin/src/main/resources/application.yml
#    配置 Redis 连接信息

# 4. 启动项目
cd ruoyi-vue-backend
mvn clean package -DskipTests
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

## Docker 一键部署

项目提供了完整的 Docker 化部署方案，包含 MySQL、Redis、后端、前端四个服务。

```bash
# 在 ruoyi-vue-backend 目录下执行
docker compose up -d
```

启动后访问：

| 服务     | 地址                     |
| :------- | :----------------------- |
| 前端     | http://localhost         |
| 后端 API | http://localhost:8080    |

> 前端项目源码见 [ruoyi-vue3](https://github.com/SilkKirk/ruoyi-vue3)，docker-compose 会自动构建。

## 在线体验

- admin/admin123
- 演示地址：http://vue.ruoyi.vip
- 文档地址：http://doc.ruoyi.vip

## 演示图

<table>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/cd1f90be5f2684f4560c9519c0f2a232ee8.jpg"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/1cbcf0e6f257c7d3a063c0e3f2ff989e4b3.jpg"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-8074972883b5ba0622e13246738ebba237a.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-9f88719cdfca9af2e58b352a20e23d43b12.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-39bf2584ec3a529b0d5a3b70d15c9b37646.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-936ec82d1f4872e1bc980927654b6007307.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-b2d62ceb95d2dd9b3fbe157bb70d26001e9.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-d67451d308b7a79ad6819723396f7c3d77a.png"/></td>
    </tr>	 
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/5e8c387724954459291aafd5eb52b456f53.jpg"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/644e78da53c2e92a95dfda4f76e6d117c4b.jpg"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-8370a0d02977eebf6dbf854c8450293c937.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-49003ed83f60f633e7153609a53a2b644f7.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-d4fe726319ece268d4746602c39cffc0621.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-c195234bbcd30be6927f037a6755e6ab69c.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/b6115bc8c31de52951982e509930b20684a.jpg"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-5e4daac0bb59612c5038448acbcef235e3a.png"/></td>
    </tr>
</table>
</table>

## 若依官方交流群

QQ 群： [![加入QQ群](https://img.shields.io/badge/已满-937441-blue.svg)](https://jq.qq.com/?_wv=1027&k=5bVB1og) [![加入QQ群](https://img.shields.io/badge/已满-887144332-blue.svg)](https://jq.qq.com/?_wv=1027&k=5eiA4DH) [![加入QQ群](https://img.shields.io/badge/已满-180251782-blue.svg)](https://jq.qq.com/?_wv=1027&k=5AxMKlC) [![加入QQ群](https://img.shields.io/badge/已满-104180207-blue.svg)](https://jq.qq.com/?_wv=1027&k=51G72yr) [![加入QQ群](https://img.shields.io/badge/已满-186866453-blue.svg)](https://jq.qq.com/?_wv=1027&k=VvjN2nvu)
