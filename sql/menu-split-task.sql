-- ============================================================
-- 拆分"我的任务"菜单为"待办任务"和"已办任务"
-- 使用前请先查询确认当前菜单 ID（不同环境可能不同）
-- ============================================================

-- 1. 查询当前流程管理下的菜单结构
SELECT menu_id, parent_id, menu_name, `path`, component, order_num, perms, icon, `query`
FROM sys_menu
WHERE parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '流程管理')
ORDER BY order_num;

-- 2. 确认当前"我的任务"菜单（假设 menu_id = X，根据上一步结果替换）
--    记录下它的 menu_id，下面用 {TASK_MENU_ID} 替代

-- 3. 将原"我的任务"改为"待办任务"，增加 query 参数
UPDATE sys_menu
SET menu_name = '待办任务',
    `path` = 'task/todo',
    `query` = 'tab=todo',
    icon = 'todo-list',
    order_num = 4
WHERE menu_name = '我的任务' AND parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '流程管理');

-- 4. 新增"已办任务"菜单（作为同级新菜单）
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, `path`, component, `query`, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT
    (SELECT MAX(menu_id) + 1 FROM sys_menu) AS menu_id,
    '已办任务' AS menu_name,
    parent_id,
    5 AS order_num,
    'task/done' AS `path`,
    'workflow/task/index' AS component,
    'tab=done' AS `query`,
    is_frame, is_cache, menu_type, visible, status,
    'workflow:task:list' AS perms,
    'done' AS icon,
    create_by, create_time, update_by, update_time, remark
FROM sys_menu WHERE menu_name = '待办任务' AND parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '流程管理');

-- 5. 验证结果
SELECT menu_id, parent_id, menu_name, `path`, component, `query`, order_num, icon
FROM sys_menu
WHERE parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '流程管理')
ORDER BY order_num;
