-- ============================================================================
-- 流程管理模块 SQL（菜单 + 示例业务表）
-- 适用于若依 Vue3 版本，Flowable 自动建表无需手动创建
-- 菜单ID范围：2000-2099
-- ============================================================================

-- ==================== 1. 流程管理目录 ====================
INSERT INTO sys_menu VALUES('2000', '流程管理', '0', '5', 'workflow', null, '', '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', sysdate(), '', null, '流程管理目录');

-- ==================== 2. 子菜单 ====================
INSERT INTO sys_menu VALUES('2010', '流程模型', '2000', '1', 'model', 'workflow/model/index', '', '', 1, 0, 'C', '0', '0', 'workflow:model:list', 'tree-table', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2020', '流程定义', '2000', '2', 'definition', 'workflow/definition/index', '', '', 1, 0, 'C', '0', '0', 'workflow:definition:list', 'example', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2030', '流程实例', '2000', '3', 'instance', 'workflow/instance/index', '', '', 1, 0, 'C', '0', '0', 'workflow:instance:list', 'list', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2040', '待办任务', '2000', '4', 'task/todo', 'workflow/task/todo', '', '', 1, 0, 'C', '0', '0', 'workflow:task:todoList', 'todo-list', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2044', '已办任务', '2000', '5', 'task/done', 'workflow/task/done', '', '', 1, 0, 'C', '0', '0', 'workflow:task:doneList', 'finished', 'admin', sysdate(), '', null, '');

-- ==================== 3. 按钮权限 ====================

-- 流程模型
INSERT INTO sys_menu VALUES('2011', '模型查询', '2010', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:query',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2012', '模型新增', '2010', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:add',      '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2013', '模型修改', '2010', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:edit',     '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2014', '模型删除', '2010', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:remove',   '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2015', '模型部署', '2010', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:deploy',   '#', 'admin', sysdate(), '', null, '');

-- 流程定义
INSERT INTO sys_menu VALUES('2021', '定义查询', '2020', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2022', '定义编辑', '2020', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:edit',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2023', '定义删除', '2020', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:remove','#', 'admin', sysdate(), '', null, '');

-- 流程实例
INSERT INTO sys_menu VALUES('2031', '实例查询', '2030', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2032', '实例启动', '2030', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:start', '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2033', '实例编辑', '2030', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:edit',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2034', '实例终止', '2030', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:stop',  '#', 'admin', sysdate(), '', null, '');

-- 待办任务
INSERT INTO sys_menu VALUES('2041', '任务查询', '2040', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:query',    '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2042', '任务执行', '2040', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:execute',  '#', 'admin', sysdate(), '', null, '');
INSERT INTO sys_menu VALUES('2043', '任务转办', '2040', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:transfer', '#', 'admin', sysdate(), '', null, '');

-- 已办任务
INSERT INTO sys_menu (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES ('2047', '历史查询', '2044', '1', '', 1, 0, 'F', '0', '0', 'workflow:task:query', '#', 'admin', sysdate());
INSERT INTO sys_menu (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES ('2045', '已办查询', '2044', '2', '', 1, 0, 'F', '0', '0', 'workflow:task:doneQuery', '#', 'admin', sysdate());
INSERT INTO sys_menu (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES ('2046', '已办详情', '2044', '3', '', 1, 0, 'F', '0', '0', 'workflow:task:doneDetail', '#', 'admin', sysdate());

-- ==================== 4. 示例业务表：请假测试 ====================
DROP TABLE IF EXISTS `leave_test`;
CREATE TABLE `leave_test` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `user_name` varchar(50) DEFAULT NULL COMMENT '申请人',
  `leave_type` varchar(20) DEFAULT NULL COMMENT '请假类型(年假/事假/病假)',
  `start_date` datetime DEFAULT NULL COMMENT '开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '结束时间',
  `reason` varchar(500) DEFAULT NULL COMMENT '请假原因',
  `status` char(1) DEFAULT '0' COMMENT '状态(0=草稿,1=审批中,2=通过,3=驳回)',
  `process_instance_id` varchar(64) DEFAULT NULL COMMENT '流程实例ID',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='请假测试';

-- ==================== 5. 请假测试菜单及权限 ====================
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2001, '请假测试', 2000, 6, 'leave', 'workflow/leave/index', 1, 0, 'C', '0', '0', 'workflow:leave:list', 'documentation', 'admin', sysdate());

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2051, '请假查询', 2001, 1, '', 1, 0, 'F', '0', '0', 'workflow:leave:query', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2052, '请假新增', 2001, 2, '', 1, 0, 'F', '0', '0', 'workflow:leave:add', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2053, '请假修改', 2001, 3, '', 1, 0, 'F', '0', '0', 'workflow:leave:edit', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2054, '请假删除', 2001, 4, '', 1, 0, 'F', '0', '0', 'workflow:leave:remove', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2055, '请假提交审批', 2001, 5, '', 1, 0, 'F', '0', '0', 'workflow:leave:submit', '#', 'admin', sysdate());
