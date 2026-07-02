---
name: ruoyi-git-ops
description: 若依后端项目(ruoyi-vue-backend)的 Git 远程操作规范。拉取代码使用 origin 远程，推送代码同时推送到 github 和 cnb 远程。当用户说推送、拉取、同步、提交代码时使用此 Skill。
---

# RuoYi Backend Git 操作规范 (ruoyi-vue-backend)

本项目配置了三个 Git 远程仓库：

| 远程名 | URL | 用途 |
|--------|-----|------|
| `origin` | `https://gitee.com/y_project/RuoYi-Vue.git` | **拉取**上游更新 |
| `github` | `git@github.com:SilkKirk/ruoyi-vue-backend.git` | 推送个人分支 |
| `cnb` | `https://cnb.cool/sikekk/ruoyi-vue-backend.git` | 推送个人分支 |

## 规则

1. **拉取代码**：始终从 `origin` 远程拉取
   ```bash
   git pull origin <branch>
   ```

2. **推送代码**：始终同时推送到 `github` 和 `cnb` 两个远程
   ```bash
   git push github <branch>
   git push cnb <branch>
   ```

3. 当前工作分支为 `springboot3`

## 示例

```bash
# 拉取上游更新
git pull origin springboot3

# 推送到个人远程
git push github springboot3
git push cnb springboot3

# 或一次性推送到两个远程（如果已设置 upstream）
git push github
git push cnb
```
