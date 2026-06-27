-- 请假测试表
DROP TABLE IF EXISTS `leave_test`;
CREATE TABLE `leave_test` (
  `id` varchar(32) NOT NULL COMMENT '主键',
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
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='请假测试';

-- 菜单：请假测试（放到流程管理下面）
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`) 
VALUES (2001, '请假测试', 2000, 6, 'leave', 'workflow/leave/index', NULL, 1, 0, 'C', '0', '0', 'workflow:leave:list', 'documentation', 'admin', sysdate());

-- 按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2002, '请假测试查询', 2001, 1, NULL, NULL, NULL, 1, 0, 'F', '0', '0', 'workflow:leave:query', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2003, '请假测试新增', 2001, 2, NULL, NULL, NULL, 1, 0, 'F', '0', '0', 'workflow:leave:add', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2004, '请假测试修改', 2001, 3, NULL, NULL, NULL, 1, 0, 'F', '0', '0', 'workflow:leave:edit', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2005, '请假测试删除', 2001, 4, NULL, NULL, NULL, 1, 0, 'F', '0', '0', 'workflow:leave:remove', '#', 'admin', sysdate());
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time) 
VALUES (2006, '请假测试提交审批', 2001, 5, NULL, NULL, NULL, 1, 0, 'F', '0', '0', 'workflow:leave:submit', '#', 'admin', sysdate());
