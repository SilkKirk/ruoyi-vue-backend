-- 流程管理菜单SQL（适用于若依Vue3版本）
-- 菜单ID范围：2000-2099
-- 父菜单：流程管理（parent_id = 2000）

-- 1. 流程管理目录（顶级菜单，挂在根节点0下）
INSERT INTO sys_menu VALUES('2000', '流程管理', '0', '5', 'workflow', null, '', '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', sysdate(), '', null, '流程管理目录');

-- 2. 子菜单：流程模型
INSERT INTO sys_menu VALUES('2010', '流程模型', '2000', '1', 'model', 'workflow/model/index', '', '', 1, 0, 'C', '0', '0', 'workflow:model:list', 'tree-table', 'admin', sysdate(), '', null, '流程模型菜单');

-- 3. 子菜单：流程定义
INSERT INTO sys_menu VALUES('2020', '流程定义', '2000', '2', 'definition', 'workflow/definition/index', '', '', 1, 0, 'C', '0', '0', 'workflow:definition:list', 'example', 'admin', sysdate(), '', null, '流程定义菜单');

-- 4. 子菜单：流程实例
INSERT INTO sys_menu VALUES('2030', '流程实例', '2000', '3', 'instance', 'workflow/instance/index', '', '', 1, 0, 'C', '0', '0', 'workflow:instance:list', 'list', 'admin', sysdate(), '', null, '流程实例菜单');

-- 5. 子菜单：我的任务
INSERT INTO sys_menu VALUES('2040', '我的任务', '2000', '4', 'task', 'workflow/task/index', '', '', 1, 0, 'C', '0', '0', 'workflow:task:list', 'user', 'admin', sysdate(), '', null, '我的任务菜单');

-- ==================== 流程模型按钮权限 ====================
INSERT INTO sys_menu VALUES('2011', '模型查询', '2010', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:query',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2012', '模型新增', '2010', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:add',      '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2013', '模型修改', '2010', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:edit',     '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2014', '模型删除', '2010', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:remove',   '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2015', '模型部署', '2010', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:deploy',   '#', 'admin', sysdate(), '', null, '');

-- ==================== 流程定义按钮权限 ====================
INSERT INTO sys_menu VALUES('2021', '定义查询', '2020', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2022', '定义编辑', '2020', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:edit',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2023', '定义删除', '2020', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:remove','#', 'admin', sysdate(), '', null, '');

-- ==================== 流程实例按钮权限 ====================
INSERT INTO sys_menu VALUES('2031', '实例查询', '2030', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2032', '实例启动', '2030', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:start', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2033', '实例编辑', '2030', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:edit',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2034', '实例终止', '2030', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:stop',  '#', 'admin', sysdate(), '', null, '');

-- ==================== 任务按钮权限 ====================
INSERT INTO sys_menu VALUES('2041', '任务查询', '2040', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:query',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2042', '任务执行', '2040', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:execute',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2043', '任务转办', '2040', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:transfer', '#', 'admin', sysdate(), '', null, '');
