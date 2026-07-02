-- ============================================
-- Database: ruoyi
-- Export Time: 2026-06-28T08:17:16.064Z
-- Total Tables: 77
-- ============================================

CREATE DATABASE IF NOT EXISTS ruoyi DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE ruoyi;

-- ----------------------------
-- Table structure for act_evt_log
-- ----------------------------
DROP TABLE IF EXISTS `act_evt_log`;
CREATE TABLE `act_evt_log` (
  `LOG_NR_` bigint NOT NULL AUTO_INCREMENT,
  `TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TIME_STAMP_` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DATA_` longblob,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `LOCK_TIME_` timestamp(3) NULL DEFAULT NULL,
  `IS_PROCESSED_` tinyint DEFAULT '0',
  PRIMARY KEY (`LOG_NR_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ge_bytearray
-- ----------------------------
DROP TABLE IF EXISTS `act_ge_bytearray`;
CREATE TABLE `act_ge_bytearray` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTES_` longblob,
  `GENERATED_` tinyint DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_BYTEARR_DEPL` (`DEPLOYMENT_ID_`),
  CONSTRAINT `ACT_FK_BYTEARR_DEPL` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ge_property
-- ----------------------------
DROP TABLE IF EXISTS `act_ge_property`;
CREATE TABLE `act_ge_property` (
  `NAME_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `VALUE_` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  PRIMARY KEY (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_actinst
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_actinst`;
CREATE TABLE `act_hi_actinst` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT '1',
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `ACT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CALL_PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `ASSIGNEE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime(3) NOT NULL,
  `END_TIME_` datetime(3) DEFAULT NULL,
  `TRANSACTION_ORDER_` int DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_ACT_INST_START` (`START_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_PROCINST` (`PROC_INST_ID_`,`ACT_ID_`),
  KEY `ACT_IDX_HI_ACT_INST_EXEC` (`EXECUTION_ID_`,`ACT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_attachment
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_attachment`;
CREATE TABLE `act_hi_attachment` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `URL_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CONTENT_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TIME_` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_comment
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_comment`;
CREATE TABLE `act_hi_comment` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TIME_` datetime(3) NOT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACTION_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `MESSAGE_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `FULL_MSG_` longblob,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_detail
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_detail`;
CREATE TABLE `act_hi_detail` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `VAR_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  `TIME_` datetime(3) NOT NULL,
  `BYTEARRAY_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DETAIL_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_ACT_INST` (`ACT_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_TIME` (`TIME_`),
  KEY `ACT_IDX_HI_DETAIL_NAME` (`NAME_`),
  KEY `ACT_IDX_HI_DETAIL_TASK_ID` (`TASK_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_entitylink
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_entitylink`;
CREATE TABLE `act_hi_entitylink` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `LINK_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime(3) DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REF_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REF_SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REF_SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HIERARCHY_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_ENT_LNK_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`,`LINK_TYPE_`),
  KEY `ACT_IDX_HI_ENT_LNK_REF_SCOPE` (`REF_SCOPE_ID_`,`REF_SCOPE_TYPE_`,`LINK_TYPE_`),
  KEY `ACT_IDX_HI_ENT_LNK_ROOT_SCOPE` (`ROOT_SCOPE_ID_`,`ROOT_SCOPE_TYPE_`,`LINK_TYPE_`),
  KEY `ACT_IDX_HI_ENT_LNK_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`,`LINK_TYPE_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_identitylink
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_identitylink`;
CREATE TABLE `act_hi_identitylink` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `GROUP_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime(3) DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_IDENT_LNK_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_IDENT_LNK_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_IDENT_LNK_TASK` (`TASK_ID_`),
  KEY `ACT_IDX_HI_IDENT_LNK_PROCINST` (`PROC_INST_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_procinst
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_procinst`;
CREATE TABLE `act_hi_procinst` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT '1',
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `BUSINESS_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `START_TIME_` datetime(3) NOT NULL,
  `END_TIME_` datetime(3) DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `START_USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `START_ACT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `END_ACT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_PROCESS_INSTANCE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CALLBACK_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CALLBACK_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REFERENCE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REFERENCE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROPAGATED_STAGE_INST_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BUSINESS_STATUS_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `PROC_INST_ID_` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PRO_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_PRO_I_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_IDX_HI_PRO_SUPER_PROCINST` (`SUPER_PROCESS_INSTANCE_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_taskinst
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_taskinst`;
CREATE TABLE `act_hi_taskinst` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT '1',
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROPAGATED_STAGE_INST_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `STATE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime(3) NOT NULL,
  `IN_PROGRESS_TIME_` datetime(3) DEFAULT NULL,
  `IN_PROGRESS_STARTED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CLAIM_TIME_` datetime(3) DEFAULT NULL,
  `CLAIMED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUSPENDED_TIME_` datetime(3) DEFAULT NULL,
  `SUSPENDED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `END_TIME_` datetime(3) DEFAULT NULL,
  `COMPLETED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` int DEFAULT NULL,
  `IN_PROGRESS_DUE_DATE_` datetime(3) DEFAULT NULL,
  `DUE_DATE_` datetime(3) DEFAULT NULL,
  `FORM_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  `LAST_UPDATED_TIME_` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_TASK_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_TASK_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_TASK_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_TASK_INST_PROCINST` (`PROC_INST_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_tsk_log
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_tsk_log`;
CREATE TABLE `act_hi_tsk_log` (
  `ID_` bigint NOT NULL AUTO_INCREMENT,
  `TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `TIME_STAMP_` timestamp(3) NOT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DATA_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_ACT_HI_TSK_LOG_TASK` (`TASK_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_hi_varinst
-- ----------------------------
DROP TABLE IF EXISTS `act_hi_varinst`;
CREATE TABLE `act_hi_varinst` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT '1',
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `VAR_TYPE_` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `META_INFO_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TIME_` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_PROCVAR_NAME_TYPE` (`NAME_`,`VAR_TYPE_`),
  KEY `ACT_IDX_HI_VAR_SCOPE_ID_TYPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_VAR_SUB_ID_TYPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_HI_PROCVAR_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PROCVAR_TASK_ID` (`TASK_ID_`),
  KEY `ACT_IDX_HI_PROCVAR_EXE` (`EXECUTION_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_bytearray
-- ----------------------------
DROP TABLE IF EXISTS `act_id_bytearray`;
CREATE TABLE `act_id_bytearray` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTES_` longblob,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_group
-- ----------------------------
DROP TABLE IF EXISTS `act_id_group`;
CREATE TABLE `act_id_group` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_info
-- ----------------------------
DROP TABLE IF EXISTS `act_id_info`;
CREATE TABLE `act_id_info` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `USER_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `VALUE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PASSWORD_` longblob,
  `PARENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_membership
-- ----------------------------
DROP TABLE IF EXISTS `act_id_membership`;
CREATE TABLE `act_id_membership` (
  `USER_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `GROUP_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`USER_ID_`,`GROUP_ID_`),
  KEY `ACT_FK_MEMB_GROUP` (`GROUP_ID_`),
  CONSTRAINT `ACT_FK_MEMB_GROUP` FOREIGN KEY (`GROUP_ID_`) REFERENCES `act_id_group` (`ID_`),
  CONSTRAINT `ACT_FK_MEMB_USER` FOREIGN KEY (`USER_ID_`) REFERENCES `act_id_user` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_priv
-- ----------------------------
DROP TABLE IF EXISTS `act_id_priv`;
CREATE TABLE `act_id_priv` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_PRIV_NAME` (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_priv_mapping
-- ----------------------------
DROP TABLE IF EXISTS `act_id_priv_mapping`;
CREATE TABLE `act_id_priv_mapping` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `PRIV_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `GROUP_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_PRIV_MAPPING` (`PRIV_ID_`),
  KEY `ACT_IDX_PRIV_USER` (`USER_ID_`),
  KEY `ACT_IDX_PRIV_GROUP` (`GROUP_ID_`),
  CONSTRAINT `ACT_FK_PRIV_MAPPING` FOREIGN KEY (`PRIV_ID_`) REFERENCES `act_id_priv` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_property
-- ----------------------------
DROP TABLE IF EXISTS `act_id_property`;
CREATE TABLE `act_id_property` (
  `NAME_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `VALUE_` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  PRIMARY KEY (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_token
-- ----------------------------
DROP TABLE IF EXISTS `act_id_token`;
CREATE TABLE `act_id_token` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `TOKEN_VALUE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TOKEN_DATE_` timestamp(3) NULL DEFAULT NULL,
  `IP_ADDRESS_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_AGENT_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TOKEN_DATA_` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_id_user
-- ----------------------------
DROP TABLE IF EXISTS `act_id_user`;
CREATE TABLE `act_id_user` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `FIRST_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `LAST_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DISPLAY_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EMAIL_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PWD_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PICTURE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_procdef_info
-- ----------------------------
DROP TABLE IF EXISTS `act_procdef_info`;
CREATE TABLE `act_procdef_info` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `INFO_JSON_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_INFO_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_IDX_INFO_PROCDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_INFO_JSON_BA` (`INFO_JSON_ID_`),
  CONSTRAINT `ACT_FK_INFO_JSON_BA` FOREIGN KEY (`INFO_JSON_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_INFO_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_re_deployment
-- ----------------------------
DROP TABLE IF EXISTS `act_re_deployment`;
CREATE TABLE `act_re_deployment` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  `DEPLOY_TIME_` timestamp(3) NULL DEFAULT NULL,
  `DERIVED_FROM_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DERIVED_FROM_ROOT_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_DEPLOYMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ENGINE_VERSION_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_re_model
-- ----------------------------
DROP TABLE IF EXISTS `act_re_model`;
CREATE TABLE `act_re_model` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LAST_UPDATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `VERSION_` int DEFAULT NULL,
  `META_INFO_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EDITOR_SOURCE_VALUE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EDITOR_SOURCE_EXTRA_VALUE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_MODEL_SOURCE` (`EDITOR_SOURCE_VALUE_ID_`),
  KEY `ACT_FK_MODEL_SOURCE_EXTRA` (`EDITOR_SOURCE_EXTRA_VALUE_ID_`),
  KEY `ACT_FK_MODEL_DEPLOYMENT` (`DEPLOYMENT_ID_`),
  CONSTRAINT `ACT_FK_MODEL_DEPLOYMENT` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`),
  CONSTRAINT `ACT_FK_MODEL_SOURCE` FOREIGN KEY (`EDITOR_SOURCE_VALUE_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_MODEL_SOURCE_EXTRA` FOREIGN KEY (`EDITOR_SOURCE_EXTRA_VALUE_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_re_procdef
-- ----------------------------
DROP TABLE IF EXISTS `act_re_procdef`;
CREATE TABLE `act_re_procdef` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `VERSION_` int NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HAS_START_FORM_KEY_` tinyint DEFAULT NULL,
  `HAS_GRAPHICAL_NOTATION_` tinyint DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  `ENGINE_VERSION_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DERIVED_FROM_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DERIVED_FROM_ROOT_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DERIVED_VERSION_` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_PROCDEF` (`KEY_`,`VERSION_`,`DERIVED_VERSION_`,`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_actinst
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_actinst`;
CREATE TABLE `act_ru_actinst` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT '1',
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `ACT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CALL_PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `ASSIGNEE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime(3) NOT NULL,
  `END_TIME_` datetime(3) DEFAULT NULL,
  `DURATION_` bigint DEFAULT NULL,
  `TRANSACTION_ORDER_` int DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_RU_ACTI_START` (`START_TIME_`),
  KEY `ACT_IDX_RU_ACTI_END` (`END_TIME_`),
  KEY `ACT_IDX_RU_ACTI_PROC` (`PROC_INST_ID_`),
  KEY `ACT_IDX_RU_ACTI_PROC_ACT` (`PROC_INST_ID_`,`ACT_ID_`),
  KEY `ACT_IDX_RU_ACTI_EXEC` (`EXECUTION_ID_`),
  KEY `ACT_IDX_RU_ACTI_EXEC_ACT` (`EXECUTION_ID_`,`ACT_ID_`),
  KEY `ACT_IDX_RU_ACTI_TASK` (`TASK_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_deadletter_job
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_deadletter_job`;
CREATE TABLE `act_ru_deadletter_job` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CORRELATION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DUEDATE_` timestamp(3) NULL DEFAULT NULL,
  `REPEAT_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CUSTOM_VALUES_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_DEADLETTER_JOB_EXCEPTION_STACK_ID` (`EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_DEADLETTER_JOB_CUSTOM_VALUES_ID` (`CUSTOM_VALUES_ID_`),
  KEY `ACT_IDX_DEADLETTER_JOB_CORRELATION_ID` (`CORRELATION_ID_`),
  KEY `ACT_IDX_DJOB_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_DJOB_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_DJOB_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_FK_DEADLETTER_JOB_EXECUTION` (`EXECUTION_ID_`),
  KEY `ACT_FK_DEADLETTER_JOB_PROCESS_INSTANCE` (`PROCESS_INSTANCE_ID_`),
  KEY `ACT_FK_DEADLETTER_JOB_PROC_DEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_DEADLETTER_JOB_CUSTOM_VALUES` FOREIGN KEY (`CUSTOM_VALUES_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_DEADLETTER_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_DEADLETTER_JOB_EXECUTION` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_DEADLETTER_JOB_PROC_DEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_DEADLETTER_JOB_PROCESS_INSTANCE` FOREIGN KEY (`PROCESS_INSTANCE_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_entitylink
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_entitylink`;
CREATE TABLE `act_ru_entitylink` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CREATE_TIME_` datetime(3) DEFAULT NULL,
  `LINK_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REF_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REF_SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REF_SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HIERARCHY_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_ENT_LNK_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`,`LINK_TYPE_`),
  KEY `ACT_IDX_ENT_LNK_REF_SCOPE` (`REF_SCOPE_ID_`,`REF_SCOPE_TYPE_`,`LINK_TYPE_`),
  KEY `ACT_IDX_ENT_LNK_ROOT_SCOPE` (`ROOT_SCOPE_ID_`,`ROOT_SCOPE_TYPE_`,`LINK_TYPE_`),
  KEY `ACT_IDX_ENT_LNK_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`,`LINK_TYPE_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_event_subscr
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_event_subscr`;
CREATE TABLE `act_ru_event_subscr` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `EVENT_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `EVENT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACTIVITY_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CONFIGURATION_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATED_` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `LOCK_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_CONFIG_` (`CONFIGURATION_`),
  KEY `ACT_IDX_EVENT_SUBSCR_EXEC_ID` (`EXECUTION_ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_PROC_ID` (`PROC_INST_ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_SCOPEREF_` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  CONSTRAINT `ACT_FK_EVENT_EXEC` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_execution
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_execution`;
CREATE TABLE `act_ru_execution` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BUSINESS_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUPER_EXEC_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ROOT_PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `IS_ACTIVE_` tinyint DEFAULT NULL,
  `IS_CONCURRENT_` tinyint DEFAULT NULL,
  `IS_SCOPE_` tinyint DEFAULT NULL,
  `IS_EVENT_SCOPE_` tinyint DEFAULT NULL,
  `IS_MI_ROOT_` tinyint DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `CACHED_ENT_STATE_` int DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `START_ACT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `START_TIME_` datetime(3) DEFAULT NULL,
  `START_USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `LOCK_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `IS_COUNT_ENABLED_` tinyint DEFAULT NULL,
  `EVT_SUBSCR_COUNT_` int DEFAULT NULL,
  `TASK_COUNT_` int DEFAULT NULL,
  `JOB_COUNT_` int DEFAULT NULL,
  `TIMER_JOB_COUNT_` int DEFAULT NULL,
  `SUSP_JOB_COUNT_` int DEFAULT NULL,
  `DEADLETTER_JOB_COUNT_` int DEFAULT NULL,
  `EXTERNAL_WORKER_JOB_COUNT_` int DEFAULT NULL,
  `VAR_COUNT_` int DEFAULT NULL,
  `ID_LINK_COUNT_` int DEFAULT NULL,
  `CALLBACK_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CALLBACK_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REFERENCE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `REFERENCE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROPAGATED_STAGE_INST_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BUSINESS_STATUS_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EXEC_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_IDC_EXEC_ROOT` (`ROOT_PROC_INST_ID_`),
  KEY `ACT_IDX_EXEC_REF_ID_` (`REFERENCE_ID_`),
  KEY `ACT_FK_EXE_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_EXE_PARENT` (`PARENT_ID_`),
  KEY `ACT_FK_EXE_SUPER` (`SUPER_EXEC_`),
  KEY `ACT_FK_EXE_PROCDEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_EXE_PARENT` FOREIGN KEY (`PARENT_ID_`) REFERENCES `act_ru_execution` (`ID_`) ON DELETE CASCADE,
  CONSTRAINT `ACT_FK_EXE_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_EXE_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ACT_FK_EXE_SUPER` FOREIGN KEY (`SUPER_EXEC_`) REFERENCES `act_ru_execution` (`ID_`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_external_job
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_external_job`;
CREATE TABLE `act_ru_external_job` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `LOCK_EXP_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CORRELATION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DUEDATE_` timestamp(3) NULL DEFAULT NULL,
  `REPEAT_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CUSTOM_VALUES_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EXTERNAL_JOB_EXCEPTION_STACK_ID` (`EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_EXTERNAL_JOB_CUSTOM_VALUES_ID` (`CUSTOM_VALUES_ID_`),
  KEY `ACT_IDX_EXTERNAL_JOB_CORRELATION_ID` (`CORRELATION_ID_`),
  KEY `ACT_IDX_EJOB_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_EJOB_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_EJOB_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  CONSTRAINT `ACT_FK_EXTERNAL_JOB_CUSTOM_VALUES` FOREIGN KEY (`CUSTOM_VALUES_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_EXTERNAL_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_history_job
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_history_job`;
CREATE TABLE `act_ru_history_job` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `LOCK_EXP_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CUSTOM_VALUES_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ADV_HANDLER_CFG_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_identitylink
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_identitylink`;
CREATE TABLE `act_ru_identitylink` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `GROUP_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `USER_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_IDENT_LNK_GROUP` (`GROUP_ID_`),
  KEY `ACT_IDX_IDENT_LNK_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_IDENT_LNK_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_IDENT_LNK_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_ATHRZ_PROCEDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_TSKASS_TASK` (`TASK_ID_`),
  KEY `ACT_FK_IDL_PROCINST` (`PROC_INST_ID_`),
  CONSTRAINT `ACT_FK_ATHRZ_PROCEDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_IDL_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TSKASS_TASK` FOREIGN KEY (`TASK_ID_`) REFERENCES `act_ru_task` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_job
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_job`;
CREATE TABLE `act_ru_job` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `LOCK_EXP_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CORRELATION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DUEDATE_` timestamp(3) NULL DEFAULT NULL,
  `REPEAT_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CUSTOM_VALUES_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_JOB_EXCEPTION_STACK_ID` (`EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_JOB_CUSTOM_VALUES_ID` (`CUSTOM_VALUES_ID_`),
  KEY `ACT_IDX_JOB_CORRELATION_ID` (`CORRELATION_ID_`),
  KEY `ACT_IDX_JOB_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_JOB_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_JOB_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_FK_JOB_EXECUTION` (`EXECUTION_ID_`),
  KEY `ACT_FK_JOB_PROCESS_INSTANCE` (`PROCESS_INSTANCE_ID_`),
  KEY `ACT_FK_JOB_PROC_DEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_JOB_CUSTOM_VALUES` FOREIGN KEY (`CUSTOM_VALUES_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_JOB_EXECUTION` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_JOB_PROC_DEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_JOB_PROCESS_INSTANCE` FOREIGN KEY (`PROCESS_INSTANCE_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_suspended_job
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_suspended_job`;
CREATE TABLE `act_ru_suspended_job` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CORRELATION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DUEDATE_` timestamp(3) NULL DEFAULT NULL,
  `REPEAT_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CUSTOM_VALUES_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_SUSPENDED_JOB_EXCEPTION_STACK_ID` (`EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_SUSPENDED_JOB_CUSTOM_VALUES_ID` (`CUSTOM_VALUES_ID_`),
  KEY `ACT_IDX_SUSPENDED_JOB_CORRELATION_ID` (`CORRELATION_ID_`),
  KEY `ACT_IDX_SJOB_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_SJOB_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_SJOB_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_FK_SUSPENDED_JOB_EXECUTION` (`EXECUTION_ID_`),
  KEY `ACT_FK_SUSPENDED_JOB_PROCESS_INSTANCE` (`PROCESS_INSTANCE_ID_`),
  KEY `ACT_FK_SUSPENDED_JOB_PROC_DEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_SUSPENDED_JOB_CUSTOM_VALUES` FOREIGN KEY (`CUSTOM_VALUES_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_SUSPENDED_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_SUSPENDED_JOB_EXECUTION` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_SUSPENDED_JOB_PROC_DEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_SUSPENDED_JOB_PROCESS_INSTANCE` FOREIGN KEY (`PROCESS_INSTANCE_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_task
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_task`;
CREATE TABLE `act_ru_task` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROPAGATED_STAGE_INST_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `STATE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DELEGATION_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PRIORITY_` int DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `IN_PROGRESS_TIME_` datetime(3) DEFAULT NULL,
  `IN_PROGRESS_STARTED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CLAIM_TIME_` datetime(3) DEFAULT NULL,
  `CLAIMED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUSPENDED_TIME_` datetime(3) DEFAULT NULL,
  `SUSPENDED_BY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `IN_PROGRESS_DUE_DATE_` datetime(3) DEFAULT NULL,
  `DUE_DATE_` datetime(3) DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUSPENSION_STATE_` int DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  `FORM_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `IS_COUNT_ENABLED_` tinyint DEFAULT NULL,
  `VAR_COUNT_` int DEFAULT NULL,
  `ID_LINK_COUNT_` int DEFAULT NULL,
  `SUB_TASK_COUNT_` int DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_TASK_CREATE` (`CREATE_TIME_`),
  KEY `ACT_IDX_TASK_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_TASK_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_TASK_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_FK_TASK_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_TASK_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_TASK_PROCDEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_TASK_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_timer_job
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_timer_job`;
CREATE TABLE `act_ru_timer_job` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `CATEGORY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `LOCK_EXP_TIME_` timestamp(3) NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ELEMENT_NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_DEFINITION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CORRELATION_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RETRIES_` int DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DUEDATE_` timestamp(3) NULL DEFAULT NULL,
  `REPEAT_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CUSTOM_VALUES_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp(3) NULL DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_TIMER_JOB_EXCEPTION_STACK_ID` (`EXCEPTION_STACK_ID_`),
  KEY `ACT_IDX_TIMER_JOB_CUSTOM_VALUES_ID` (`CUSTOM_VALUES_ID_`),
  KEY `ACT_IDX_TIMER_JOB_CORRELATION_ID` (`CORRELATION_ID_`),
  KEY `ACT_IDX_TIMER_JOB_DUEDATE` (`DUEDATE_`),
  KEY `ACT_IDX_TJOB_SCOPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_TJOB_SUB_SCOPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_TJOB_SCOPE_DEF` (`SCOPE_DEFINITION_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_FK_TIMER_JOB_EXECUTION` (`EXECUTION_ID_`),
  KEY `ACT_FK_TIMER_JOB_PROCESS_INSTANCE` (`PROCESS_INSTANCE_ID_`),
  KEY `ACT_FK_TIMER_JOB_PROC_DEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_TIMER_JOB_CUSTOM_VALUES` FOREIGN KEY (`CUSTOM_VALUES_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_TIMER_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_TIMER_JOB_EXECUTION` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TIMER_JOB_PROC_DEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_TIMER_JOB_PROCESS_INSTANCE` FOREIGN KEY (`PROCESS_INSTANCE_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for act_ru_variable
-- ----------------------------
DROP TABLE IF EXISTS `act_ru_variable`;
CREATE TABLE `act_ru_variable` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `NAME_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint DEFAULT NULL,
  `TEXT_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `META_INFO_` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_RU_VAR_SCOPE_ID_TYPE` (`SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_IDX_RU_VAR_SUB_ID_TYPE` (`SUB_SCOPE_ID_`,`SCOPE_TYPE_`),
  KEY `ACT_FK_VAR_BYTEARRAY` (`BYTEARRAY_ID_`),
  KEY `ACT_IDX_VARIABLE_TASK_ID` (`TASK_ID_`),
  KEY `ACT_FK_VAR_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_VAR_PROCINST` (`PROC_INST_ID_`),
  CONSTRAINT `ACT_FK_VAR_BYTEARRAY` FOREIGN KEY (`BYTEARRAY_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for flw_channel_definition
-- ----------------------------
DROP TABLE IF EXISTS `flw_channel_definition`;
CREATE TABLE `flw_channel_definition` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `VERSION_` int DEFAULT NULL,
  `KEY_` varchar(255) DEFAULT NULL,
  `CATEGORY_` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  `CREATE_TIME_` datetime(3) DEFAULT NULL,
  `TENANT_ID_` varchar(255) DEFAULT NULL,
  `RESOURCE_NAME_` varchar(255) DEFAULT NULL,
  `DESCRIPTION_` varchar(255) DEFAULT NULL,
  `TYPE_` varchar(255) DEFAULT NULL,
  `IMPLEMENTATION_` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_IDX_CHANNEL_DEF_UNIQ` (`KEY_`,`VERSION_`,`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flw_event_definition
-- ----------------------------
DROP TABLE IF EXISTS `flw_event_definition`;
CREATE TABLE `flw_event_definition` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `VERSION_` int DEFAULT NULL,
  `KEY_` varchar(255) DEFAULT NULL,
  `CATEGORY_` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  `TENANT_ID_` varchar(255) DEFAULT NULL,
  `RESOURCE_NAME_` varchar(255) DEFAULT NULL,
  `DESCRIPTION_` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_IDX_EVENT_DEF_UNIQ` (`KEY_`,`VERSION_`,`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flw_event_deployment
-- ----------------------------
DROP TABLE IF EXISTS `flw_event_deployment`;
CREATE TABLE `flw_event_deployment` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `CATEGORY_` varchar(255) DEFAULT NULL,
  `DEPLOY_TIME_` datetime(3) DEFAULT NULL,
  `TENANT_ID_` varchar(255) DEFAULT NULL,
  `PARENT_DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flw_event_resource
-- ----------------------------
DROP TABLE IF EXISTS `flw_event_resource`;
CREATE TABLE `flw_event_resource` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  `RESOURCE_BYTES_` longblob,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flw_ru_batch
-- ----------------------------
DROP TABLE IF EXISTS `flw_ru_batch`;
CREATE TABLE `flw_ru_batch` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `SEARCH_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SEARCH_KEY2_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime(3) NOT NULL,
  `COMPLETE_TIME_` datetime(3) DEFAULT NULL,
  `STATUS_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `BATCH_DOC_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for flw_ru_batch_part
-- ----------------------------
DROP TABLE IF EXISTS `flw_ru_batch_part`;
CREATE TABLE `flw_ru_batch_part` (
  `ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `BATCH_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `SCOPE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SUB_SCOPE_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SCOPE_TYPE_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SEARCH_KEY_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `SEARCH_KEY2_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATE_TIME_` datetime(3) NOT NULL,
  `COMPLETE_TIME_` datetime(3) DEFAULT NULL,
  `STATUS_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `RESULT_DOC_ID_` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TENANT_ID_` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '',
  PRIMARY KEY (`ID_`),
  KEY `FLW_IDX_BATCH_PART` (`BATCH_ID_`),
  CONSTRAINT `FLW_FK_BATCH_PART_PARENT` FOREIGN KEY (`BATCH_ID_`) REFERENCES `flw_ru_batch` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `tpl_web_type`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `form_col_num`, `gen_type`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(24, 'sys_config', '参数配置表', NULL, NULL, 'SysConfig', 'crud', 'element-plus', 'com.ruoyi.system', 'system', 'config', '参数配置', 'wy', 1, '0', '/', '{"genView":"0"}', 'admin', '2026-06-26 17:06:15', '', '2026-06-26 17:06:27', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=289 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(1, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(2, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(3, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(4, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(5, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(6, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(7, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(8, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(9, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(10, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(11, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(12, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(13, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(14, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(15, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(16, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(17, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(18, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(19, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(20, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(21, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(22, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(23, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(24, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(25, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(26, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(27, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(28, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(29, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(30, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(31, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(32, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(33, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(34, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(35, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(36, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(37, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(38, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(39, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(40, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(41, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(42, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(43, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(44, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(45, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(46, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(47, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(48, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(49, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(50, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(51, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(52, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(53, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(54, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(55, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(56, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(57, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(58, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(59, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(60, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(61, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 11, 'admin', NULL, '', NULL),
(62, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 12, 'admin', NULL, '', NULL),
(63, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 13, 'admin', NULL, '', NULL),
(64, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 14, 'admin', NULL, '', NULL),
(65, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(66, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(67, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(68, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(69, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(70, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(71, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(72, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(73, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(74, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(75, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(76, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(77, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(78, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(79, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(80, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(81, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(82, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(83, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(84, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(85, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(86, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(87, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(88, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(89, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(90, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(91, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(92, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(93, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(94, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(95, NULL, 'config_id', '参数主键', 'int', 'Long', 'configId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', NULL, '', NULL),
(96, NULL, 'config_name', '参数名称', 'varchar(100)', 'String', 'configName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', NULL, '', NULL),
(97, NULL, 'config_key', '参数键名', 'varchar(100)', 'String', 'configKey', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', NULL, '', NULL),
(98, NULL, 'config_value', '参数键值', 'varchar(500)', 'String', 'configValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', NULL, '', NULL),
(99, NULL, 'config_type', '系统内置（Y是 N否）', 'char(1)', 'String', 'configType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', NULL, '', NULL),
(100, NULL, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', NULL, '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(101, NULL, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', NULL, '', NULL),
(102, NULL, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 8, 'admin', NULL, '', NULL),
(103, NULL, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', NULL, '', NULL),
(104, NULL, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 10, 'admin', NULL, '', NULL),
(115, NULL, 'dict_code', '字典编码', 'bigint', 'Long', 'dictCode', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', NULL, '', NULL),
(116, NULL, 'dict_sort', '字典排序', 'int', 'Long', 'dictSort', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', NULL, '', NULL),
(117, NULL, 'dict_label', '字典标签', 'varchar(100)', 'String', 'dictLabel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', NULL, '', NULL),
(118, NULL, 'dict_value', '字典键值', 'varchar(100)', 'String', 'dictValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', NULL, '', NULL),
(119, NULL, 'dict_type', '字典类型', 'varchar(100)', 'String', 'dictType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', NULL, '', NULL),
(120, NULL, 'css_class', '样式属性（其他样式扩展）', 'varchar(100)', 'String', 'cssClass', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', NULL, '', NULL),
(121, NULL, 'list_class', '表格回显样式', 'varchar(100)', 'String', 'listClass', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', NULL, '', NULL),
(122, NULL, 'is_default', '是否默认（Y是 N否）', 'char(1)', 'String', 'isDefault', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', NULL, '', NULL),
(123, NULL, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 9, 'admin', NULL, '', NULL),
(124, NULL, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', NULL, '', NULL),
(125, NULL, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', NULL, '', NULL),
(126, NULL, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 12, 'admin', NULL, '', NULL),
(127, NULL, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', NULL, '', NULL),
(128, NULL, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 14, 'admin', NULL, '', NULL),
(177, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(178, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(179, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(180, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(181, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(182, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(183, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(184, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(185, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(186, NULL, NULL, NULL, NULL, 'String', NULL, NULL, NULL, NULL, '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(187, NULL, NULL, NULL, NULL, 'String', NULL, '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(188, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(189, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(190, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(191, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(192, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(193, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(194, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(195, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(196, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(207, NULL, NULL, NULL, NULL, 'String', NULL, '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', NULL, '', NULL),
(208, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 2, 'admin', NULL, '', NULL),
(209, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 3, 'admin', NULL, '', NULL),
(210, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 4, 'admin', NULL, '', NULL),
(211, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 5, 'admin', NULL, '', NULL),
(212, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 6, 'admin', NULL, '', NULL),
(213, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 7, 'admin', NULL, '', NULL),
(214, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 8, 'admin', NULL, '', NULL),
(215, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 9, 'admin', NULL, '', NULL),
(216, NULL, NULL, NULL, NULL, 'String', NULL, '0', '0', '0', '1', '1', '1', '1', 'EQ', NULL, '', 10, 'admin', NULL, '', NULL),
(279, 24, 'config_id', '参数主键', 'int', 'Long', 'configId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', NULL, '', NULL),
(280, 24, 'config_name', '参数名称', 'varchar(100)', 'String', 'configName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', NULL, '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(281, 24, 'config_key', '参数键名', 'varchar(100)', 'String', 'configKey', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', NULL, '', NULL),
(282, 24, 'config_value', '参数键值', 'varchar(500)', 'String', 'configValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', NULL, '', NULL),
(283, 24, 'config_type', '系统内置（Y是 N否）', 'char(1)', 'String', 'configType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', NULL, '', NULL),
(284, 24, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', NULL, '', NULL),
(285, 24, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', NULL, '', NULL),
(286, 24, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 8, 'admin', NULL, '', NULL),
(287, 24, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', NULL, '', NULL),
(288, 24, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 10, 'admin', NULL, '', NULL);

-- ----------------------------
-- Table structure for leave_test
-- ----------------------------
DROP TABLE IF EXISTS `leave_test`;
CREATE TABLE `leave_test` (
  `id` varchar(64) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='请假测试';

-- ----------------------------
-- Records of leave_test
-- ----------------------------
INSERT INTO `leave_test` (`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
('0fbd5c90-7fa2-4e6e-a4b9-919981bd9650', '放松放松', '事假', '2026-05-31 16:00:00', '2026-06-17 16:00:00', '监管机构', '2', 'e40652be-726c-11f1-8024-00e04c8228ec', NULL, NULL, NULL, NULL, NULL),
('44785232-59c8-4363-a70d-feca4d8e22b3', '����', '���', '2026-06-27 16:00:00', '2026-06-28 16:00:00', 'test', '1', '98c1d454-726c-11f1-8024-00e04c8228ec', NULL, NULL, NULL, NULL, NULL),
('aa9b33dd-231f-48c5-9141-2a77a64ae6a9', 'fhfhfhfhfhf', '病假', '2026-06-01 16:00:00', '2026-06-16 16:00:00', 'hhkhkh', '2', '33e750f2-72c4-11f1-af07-00e04c8228ec', NULL, NULL, NULL, NULL, NULL),
('bb00d904-e30b-433c-840f-1f7a03ebf4c9', 'admin', '���', '2026-06-27 16:00:00', '2026-06-28 16:00:00', '����', '1', '8d5a848a-726c-11f1-8024-00e04c8228ec', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Blob类型的触发器表';

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日历信息表';

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cron类型的触发器表';

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) NOT NULL COMMENT '状态',
  `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='已触发的触发器表';

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务组名',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务详细信息表';

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='存储的悲观锁信息表';

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='暂停的触发器表';

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='调度器状态表';

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='简单触发器的信息表';

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='同步机制的行锁表';

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='触发器详细信息表';

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),
(2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '初始化密码 123456'),
(3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '深色主题theme-dark，浅色主题theme-light'),
(4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2026-06-24 02:56:43', 'admin', NULL, '是否开启验证码功能（true开启，false关闭）'),
(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '是否开启注册用户功能（true开启，false关闭）'),
(6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),
(7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),
(8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框'),
(9, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-06-24 02:56:43', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL),
(109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '性别男'),
(2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '性别女'),
(3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '性别未知'),
(4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '显示菜单'),
(5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '隐藏菜单'),
(6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '正常状态'),
(7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '停用状态'),
(8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '正常状态'),
(9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '停用状态'),
(10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '默认分组'),
(11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '系统分组'),
(12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '系统默认是'),
(13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '系统默认否'),
(14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '通知'),
(15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '公告'),
(16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '正常状态'),
(17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '关闭状态'),
(18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '其他操作'),
(19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '新增操作'),
(20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '修改操作'),
(21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '删除操作'),
(22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '授权操作'),
(23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '导出操作'),
(24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '导入操作'),
(25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '强退操作'),
(26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '生成操作'),
(27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '清空操作'),
(28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '正常状态'),
(29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '用户性别列表'),
(2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '菜单状态列表'),
(3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '系统开关列表'),
(4, '任务状态', 'sys_job_status', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '任务状态列表'),
(5, '任务分组', 'sys_job_group', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '任务分组列表'),
(6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '系统是否列表'),
(7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '通知类型列表'),
(8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '通知状态列表'),
(9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '操作类型列表'),
(10, '系统状态', 'sys_common_status', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度表';

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '0', '1', 'admin', '2026-06-24 02:56:43', 'admin', NULL, ''),
(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-06-24 02:56:43', '', NULL, ''),
(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-06-24 02:56:43', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度日志表';

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=330 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES
(100, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', NULL),
(101, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', NULL),
(102, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-24 04:37:14'),
(103, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 04:37:18'),
(104, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-24 04:41:40'),
(105, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 04:41:41'),
(106, 'admin', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '1', '验证码已失效', '2026-06-24 04:48:58'),
(107, 'admin', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '1', '验证码已失效', '2026-06-24 04:49:03'),
(108, 'admin', '127.0.0.1', '内网IP', 'Hacker', 'Hacker', '1', '验证码错误', '2026-06-24 04:49:25'),
(109, 'admin', '127.0.0.1', '内网IP', 'Hacker', 'Hacker', '1', '验证码已失效', '2026-06-24 05:02:52'),
(110, 'admin', '127.0.0.1', '内网IP', 'Hacker', 'Hacker', '1', '验证码错误', '2026-06-24 05:02:52'),
(111, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 05:05:45'),
(112, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-24 05:05:45'),
(113, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 06:09:26'),
(114, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-24 06:14:51'),
(115, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '验证码错误', '2026-06-24 06:14:51'),
(116, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 06:14:55'),
(117, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 08:56:43'),
(118, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-24 10:09:43'),
(119, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 03:13:36'),
(120, 'admin', '127.0.0.1', '内网IP', 'PowerShell 7.6.3', 'Windows 10.0', '1', '验证码已失效', '2026-06-26 03:14:51'),
(121, 'admin', '127.0.0.1', '内网IP', 'PowerShell 7.6.3', 'Windows 10.0', '1', '验证码已失效', '2026-06-26 03:28:22'),
(122, 'admin', '127.0.0.1', '内网IP', 'PowerShell 7.6.3', 'Windows 10.0', '1', '验证码已失效', '2026-06-26 03:28:48'),
(123, 'admin', '127.0.0.1', '内网IP', 'PowerShell 7.6.3', 'Windows 10.0', '1', '验证码已失效', '2026-06-26 03:37:54'),
(124, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 04:40:42'),
(125, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 08:17:37'),
(126, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 08:52:04'),
(127, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-26 08:52:04'),
(128, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 08:52:05'),
(129, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 09:33:02'),
(130, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 09:33:02'),
(131, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 11:36:43'),
(132, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 17:04:16'),
(133, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-26 17:04:17'),
(134, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 15:49:11'),
(135, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 15:57:56'),
(136, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 15:58:00'),
(137, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 15:58:05'),
(138, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 15:58:08'),
(139, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 15:58:13'),
(140, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 15:58:20'),
(141, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 15:58:23'),
(142, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 15:59:50'),
(143, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 16:00:21'),
(144, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 16:01:23'),
(145, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 16:07:06'),
(146, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:14:23'),
(147, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:17:57'),
(148, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:18:00'),
(149, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:18:45');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES
(150, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:19:04'),
(151, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:19:41'),
(152, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:20:31'),
(153, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:20:57'),
(154, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:24:28'),
(155, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:24:41'),
(156, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:26:34'),
(157, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:27:06'),
(158, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:27:26'),
(159, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:27:39'),
(160, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:27:59'),
(161, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:28:40'),
(162, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 18:31:03'),
(163, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-27 18:31:07'),
(164, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-27 18:31:11'),
(165, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 18:31:21'),
(166, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 18:31:35'),
(167, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 18:31:42'),
(168, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 18:32:45'),
(169, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 18:32:47'),
(170, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 18:32:57'),
(171, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 18:33:04'),
(172, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:39:55'),
(173, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:40:00'),
(174, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:40:50'),
(175, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:40:55'),
(176, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:41:02'),
(177, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:41:11'),
(178, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:41:56'),
(179, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:42:39'),
(180, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:43:02'),
(181, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:43:37'),
(182, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:50:04'),
(183, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:50:37'),
(184, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:51:27'),
(185, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:51:54'),
(186, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:52:17'),
(187, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 18:56:02'),
(188, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 19:04:29'),
(189, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 19:04:37'),
(190, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 19:04:44'),
(191, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:24:32'),
(192, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:24:36'),
(193, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:25:04'),
(194, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:25:20'),
(195, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:25:36'),
(196, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:25:43'),
(197, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:26:12'),
(198, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:27:24'),
(199, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:27:30');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES
(200, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:27:53'),
(201, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:28:18'),
(202, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:28:37'),
(203, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:28:59'),
(204, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:29:04'),
(205, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:29:08'),
(206, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:29:50'),
(207, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:30:21'),
(208, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:30:41'),
(209, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 19:37:05'),
(210, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-27 19:37:11'),
(211, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-27 19:37:17'),
(212, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:40:48'),
(213, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:44:14'),
(214, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:47:44'),
(215, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:53:44'),
(216, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:54:08'),
(217, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:56:21'),
(218, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 19:56:25'),
(219, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:00:53'),
(220, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:01:16'),
(221, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:01:28'),
(222, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:01:31'),
(223, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:02:00'),
(224, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:04:24'),
(225, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:05:48'),
(226, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:23:11'),
(227, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:25:29'),
(228, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:25:36'),
(229, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:27:12'),
(230, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:28:00'),
(231, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:36:10'),
(232, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:36:14'),
(233, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-27 20:36:18'),
(234, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 04:31:20'),
(235, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 04:32:01'),
(236, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 04:34:24'),
(237, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 04:36:19'),
(238, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 04:36:27'),
(239, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 05:04:47'),
(240, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:04:47'),
(241, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:06:38'),
(242, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 05:21:25'),
(243, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:21:31'),
(244, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 05:23:49'),
(245, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:23:51'),
(246, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 05:24:13'),
(247, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:24:21'),
(248, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:36:49'),
(249, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:36:54');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES
(250, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:46:55'),
(251, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:47:00'),
(252, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:47:16'),
(253, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:49:31'),
(254, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:49:38'),
(255, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:50:15'),
(256, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:52:11'),
(257, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 05:53:38'),
(258, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:03:57'),
(259, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:12:12'),
(260, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:13:05'),
(261, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:17:39'),
(262, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:17:42'),
(263, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:18:01'),
(264, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:19:39'),
(265, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:20:19'),
(266, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 06:20:45'),
(267, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:20:53'),
(268, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:22:11'),
(269, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:22:14'),
(270, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:22:17'),
(271, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:22:54'),
(272, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:23:24'),
(273, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:23:27'),
(274, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:24:22'),
(275, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:25:28'),
(276, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:26:19'),
(277, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:28:48'),
(278, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:28:51'),
(279, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:28:55'),
(280, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:29:22'),
(281, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:31:44'),
(282, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:34:00'),
(283, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:34:00'),
(284, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:34:49'),
(285, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:34:56'),
(286, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 06:38:08'),
(287, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:38:10'),
(288, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 06:38:24'),
(289, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-28 06:38:30'),
(290, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-28 06:38:35'),
(291, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-28 06:38:47'),
(292, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-28 06:38:56'),
(293, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:39:03'),
(294, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '用户不存在/密码错误', '2026-06-28 06:41:37'),
(295, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-06-28 06:41:51'),
(296, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:41:59'),
(297, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:42:04'),
(298, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-06-28 06:42:04'),
(299, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:42:09');
INSERT INTO `sys_logininfor` (`info_id`, `user_name`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES
(300, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:42:13'),
(301, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-06-28 06:42:16'),
(302, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:42:19'),
(303, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-06-28 06:42:19'),
(304, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-06-28 06:42:31'),
(305, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-06-28 06:43:19'),
(306, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:43:37'),
(307, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '用户不存在/密码错误', '2026-06-28 06:43:37'),
(308, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:43:41'),
(309, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:43:46'),
(310, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:43:47'),
(311, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:43:51'),
(312, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:44:03'),
(313, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 06:44:18'),
(314, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 06:44:22'),
(315, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '用户不存在/密码错误', '2026-06-28 06:56:29'),
(316, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:56:36'),
(317, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:56:36'),
(318, 'ry', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '0', '登录成功', '2026-06-28 06:56:41'),
(319, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 07:30:06'),
(320, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 07:30:37'),
(321, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-28 07:30:43'),
(322, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '1', '用户不存在/密码错误', '2026-06-28 07:30:48'),
(323, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 07:30:59'),
(324, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 07:31:14'),
(325, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 07:31:19'),
(326, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 07:36:39'),
(327, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 07:36:41'),
(328, 'admin', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '退出成功', '2026-06-28 07:37:02'),
(329, 'ry', '127.0.0.1', '内网IP', 'Edge 149', 'Windows >=10', '0', '登录成功', '2026-06-28 07:37:06');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2048 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-06-24 02:56:42', '', NULL, '系统管理目录'),
(2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-06-24 02:56:42', '', NULL, '系统监控目录'),
(3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-06-24 02:56:42', '', NULL, '系统工具目录'),
(4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '1', '', 'guide', 'admin', '2026-06-24 02:56:42', 'admin', NULL, '若依官网地址'),
(100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-06-24 02:56:42', '', NULL, '用户管理菜单'),
(101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-06-24 02:56:42', '', NULL, '角色管理菜单'),
(102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-06-24 02:56:42', '', NULL, '菜单管理菜单'),
(103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-06-24 02:56:42', '', NULL, '部门管理菜单'),
(104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-06-24 02:56:42', '', NULL, '岗位管理菜单'),
(105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-06-24 02:56:42', '', NULL, '字典管理菜单'),
(106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-06-24 02:56:42', '', NULL, '参数设置菜单'),
(107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-06-24 02:56:42', '', NULL, '通知公告菜单'),
(108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-06-24 02:56:42', '', NULL, '日志管理菜单'),
(109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-06-24 02:56:42', '', NULL, '在线用户菜单'),
(110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-06-24 02:56:42', '', NULL, '定时任务菜单'),
(111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-06-24 02:56:42', '', NULL, '数据监控菜单'),
(112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-06-24 02:56:42', '', NULL, '服务监控菜单'),
(113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-06-24 02:56:42', '', NULL, '缓存监控菜单'),
(114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-06-24 02:56:42', '', NULL, '缓存列表菜单'),
(115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-06-24 02:56:42', '', NULL, '表单构建菜单'),
(116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-06-24 02:56:42', '', NULL, '代码生成菜单'),
(117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-06-24 02:56:42', '', NULL, '系统接口菜单'),
(500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-06-24 02:56:42', '', NULL, '操作日志菜单'),
(501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-06-24 02:56:42', '', NULL, '登录日志菜单'),
(1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(2000, '流程管理', 0, 5, 'workflow', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', '2026-06-27 15:38:43', '', NULL, '流程管理目录'),
(2001, '请假测试', 2000, 6, 'leave', 'workflow/leave/index', NULL, '', 1, 0, 'C', '0', '0', 'workflow:leave:list', 'documentation', 'admin', '2026-06-27 18:06:52', '', NULL, ''),
(2002, '请假测试查询', 2001, 1, NULL, NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:leave:query', '#', 'admin', '2026-06-27 18:06:52', '', NULL, ''),
(2003, '请假测试新增', 2001, 2, NULL, NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:leave:add', '#', 'admin', '2026-06-27 18:06:52', '', NULL, ''),
(2004, '请假测试修改', 2001, 3, NULL, NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:leave:edit', '#', 'admin', '2026-06-27 18:06:52', '', NULL, ''),
(2005, '请假测试删除', 2001, 4, NULL, NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:leave:remove', '#', 'admin', '2026-06-27 18:06:52', '', NULL, ''),
(2006, '请假测试提交审批', 2001, 5, NULL, NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:leave:submit', '#', 'admin', '2026-06-27 18:06:52', '', NULL, ''),
(2010, '流程模型', 2000, 1, 'model', 'workflow/model/index', '', '', 1, 0, 'C', '0', '0', 'workflow:model:list', 'tree-table', 'admin', '2026-06-27 15:38:43', '', NULL, '流程模型菜单'),
(2011, '模型查询', 2010, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:query', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2012, '模型新增', 2010, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:add', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2013, '模型修改', 2010, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:edit', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2014, '模型删除', 2010, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:remove', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2015, '模型部署', 2010, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:deploy', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2020, '流程定义', 2000, 2, 'definition', 'workflow/definition/index', '', '', 1, 0, 'C', '0', '0', 'workflow:definition:list', 'example', 'admin', '2026-06-27 15:38:43', '', NULL, '流程定义菜单'),
(2021, '定义查询', 2020, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:query', '#', 'admin', '2026-06-27 15:38:43', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(2022, '定义编辑', 2020, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:edit', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2023, '定义删除', 2020, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:definition:remove', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2030, '流程实例', 2000, 3, 'instance', 'workflow/instance/index', '', '', 1, 0, 'C', '0', '0', 'workflow:instance:list', 'list', 'admin', '2026-06-27 15:38:43', '', NULL, '流程实例菜单'),
(2031, '实例查询', 2030, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:query', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2032, '实例启动', 2030, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:start', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2033, '实例编辑', 2030, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:edit', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2034, '实例终止', 2030, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:instance:stop', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2040, '待办任务', 2000, 4, 'task/todo', 'workflow/task/todo', '', '', 1, 0, 'C', '0', '0', 'workflow:task:todoList', 'todo-list', 'admin', '2026-06-27 15:38:43', '', NULL, '我的任务菜单'),
(2041, '任务查询', 2040, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:query', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2042, '任务执行', 2040, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:execute', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2043, '任务转办', 2040, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:task:transfer', '#', 'admin', '2026-06-27 15:38:43', '', NULL, ''),
(2044, '已办任务', 2000, 5, 'task/done', 'workflow/task/done', '', '', 1, 0, 'C', '0', '0', 'workflow:task:doneList', 'finished', 'admin', '2026-06-28 05:14:30', 'admin', '2026-06-28 05:14:30', ''),
(2045, '已办查询', 2044, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:task:doneQuery', '#', 'admin', '2026-06-28 05:14:30', 'admin', '2026-06-28 05:14:30', ''),
(2046, '已办详情', 2044, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:task:doneDetail', '#', 'admin', '2026-06-28 05:14:30', 'admin', '2026-06-28 05:14:30', ''),
(2047, '历史查询', 2044, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'workflow:task:query', '#', 'admin', '2026-06-28 05:22:48', 'admin', '2026-06-28 05:22:48', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` (`notice_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', '新版本内容', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '管理员'),
(2, '维护通知：2018-07-01 若依系统凌晨维护', '1', '维护内容', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '管理员'),
(3, '若依开源框架介绍', '1', '<p><span style="color: rgb(230, 0, 0);">项目介绍</span></p><p><font color="#333333">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style="color: rgb(51, 51, 51);">岗位管理</span><span style="color: rgb(51, 51, 51);">、定时任务</span><span style="color: rgb(51, 51, 51);">、</span><span style="color: rgb(51, 51, 51);">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color="#333333">分布式文件存储</font><span style="color: rgb(51, 51, 51);">、分库分表处理等技术特点。</span></p><p><img src="https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png" style="width: 64px;"><br></p><p><span style="color: rgb(230, 0, 0);">官网及演示</span></p><p><span style="color: rgb(51, 51, 51);">若依官网地址：&nbsp;</span><a href="http://ruoyi.vip" target="_blank">http://ruoyi.vip</a><a href="http://ruoyi.vip" target="_blank"></a></p><p><span style="color: rgb(51, 51, 51);">若依文档地址：&nbsp;</span><a href="http://doc.ruoyi.vip" target="_blank">http://doc.ruoyi.vip</a><br></p><p><span style="color: rgb(51, 51, 51);">演示地址【不分离版】：&nbsp;</span><a href="http://demo.ruoyi.vip" target="_blank">http://demo.ruoyi.vip</a></p><p><span style="color: rgb(51, 51, 51);">演示地址【分离版本】：&nbsp;</span><a href="http://vue.ruoyi.vip" target="_blank">http://vue.ruoyi.vip</a></p><p><span style="color: rgb(51, 51, 51);">演示地址【微服务版】：&nbsp;</span><a href="http://cloud.ruoyi.vip" target="_blank">http://cloud.ruoyi.vip</a></p><p><span style="color: rgb(51, 51, 51);">演示地址【移动端版】：&nbsp;</span><a href="http://h5.ruoyi.vip" target="_blank">http://h5.ruoyi.vip</a></p><p><br style="color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;"></p>', '0', 'admin', '2026-06-24 02:56:43', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公告已读记录表';

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES
(100, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '', '/system/role', '127.0.0.1', '内网IP', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"2","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', NULL, 592),
(101, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '', '/system/role/dataScope', '127.0.0.1', '内网IP', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"deptIds":[],"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', NULL, 46),
(102, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.cancelAuthUser()', 'PUT', 1, 'admin', '', '/system/role/authUser/cancel', '127.0.0.1', '内网IP', '{"roleId":2,"userId":2} ', '{"msg":"操作成功","code":200}', 0, '', NULL, 13),
(103, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()', 'PUT', 1, 'admin', '', '/system/role/authUser/selectAll', '127.0.0.1', '内网IP', '{"roleId":"2","userIds":"2"}', '{"msg":"操作成功","code":200}', 0, '', NULL, 16),
(104, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '', '/system/menu', '127.0.0.1', '内网IP', '{"children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","icon":"guide","isCache":"0","isFrame":"0","menuId":4,"menuName":"若依官网","menuType":"M","orderNum":4,"params":{},"parentId":0,"path":"http://ruoyi.vip","perms":"","query":"","remark":"若依官网地址","routeName":"","status":"1","updateBy":"admin","visible":"0"} ', '{"msg":"操作成功","code":200}', 0, '', NULL, 43),
(105, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '', '/system/post', '127.0.0.1', '内网IP', '{"createBy":"admin","createTime":"2026-06-24 10:56:42","flag":false,"params":{},"postCode":"user","postId":4,"postName":"普通员工","postSort":4,"remark":"","status":"1","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', NULL, 75),
(106, '岗位管理', 2, 'com.ruoyi.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '', '/system/post', '127.0.0.1', '内网IP', '{"createBy":"admin","createTime":"2026-06-24 10:56:42","flag":false,"params":{},"postCode":"user","postId":4,"postName":"普通员工","postSort":4,"remark":"","status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', NULL, 25),
(107, '字典类型', 5, 'com.ruoyi.web.controller.system.SysDictTypeController.export()', 'POST', 1, 'admin', '', '/system/dict/type/export', '127.0.0.1', '内网IP', '{"pageSize":"10","pageNum":"1"}', '', 0, '', NULL, 1188),
(108, '操作日志', 5, 'com.ruoyi.web.controller.monitor.SysOperlogController.export()', 'POST', 1, 'admin', '', '/monitor/operlog/export', '127.0.0.1', '内网IP', '{"pageSize":"10","pageNum":"1"}', '', 0, '', '2026-06-24 04:37:32', 1029),
(109, '定时任务', 2, 'com.ruoyi.quartz.controller.SysJobController.edit()', 'PUT', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{"concurrent":"0","createBy":"admin","createTime":"2026-06-24 10:56:43","cronExpression":"0/10 * * * * ?","invokeTarget":"ryTask.ryNoParams","jobGroup":"DEFAULT","jobId":1,"jobName":"系统默认（无参）","misfirePolicy":"3","nextValidTime":"2026-06-24 12:42:30","params":{},"remark":"","status":"1","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 04:42:27', 65),
(110, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 05:12:20', 583),
(111, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1] ', '', 1, '\r\n### Error updating database.  Cause: org.apache.ibatis.binding.BindingException: Parameter \'tableId\' not found. Available parameters are [array, tableIds]\r\n### The error may exist in com/ruoyi/generator/mapper/GenTableColumnMapper.java (best guess)\r\n### The error may involve com.ruoyi.generator.mapper.GenTableColumnMapper.deleteGenTableColumnByIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from gen_table_column where table_id in <foreach collection=\'array\' item=\'tableId\' open=\'(\' separator=\',\' close=\')\'>?</foreach>\r\n### Cause: org.apache.ibatis.binding.BindingException: Parameter \'tableId\' not found. Available parameters are [array, tableIds]', '2026-06-24 06:18:43', 97),
(112, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1] ', '', 1, '\r\n### Error updating database.  Cause: org.apache.ibatis.binding.BindingException: Parameter \'tableId\' not found. Available parameters are [array, tableIds]\r\n### The error may exist in com/ruoyi/generator/mapper/GenTableColumnMapper.java (best guess)\r\n### The error may involve com.ruoyi.generator.mapper.GenTableColumnMapper.deleteGenTableColumnByIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from gen_table_column where table_id in <foreach collection=\'array\' item=\'tableId\' open=\'(\' separator=\',\' close=\')\'>?</foreach>\r\n### Cause: org.apache.ibatis.binding.BindingException: Parameter \'tableId\' not found. Available parameters are [array, tableIds]', '2026-06-24 06:22:26', 91),
(113, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 06:42:22', 87),
(114, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 06:42:29', 103),
(115, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/2', '127.0.0.1', '内网IP', '[2] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 06:46:01', 72),
(116, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 06:46:05', 116),
(117, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/3', '127.0.0.1', '内网IP', '[3] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:16:22', 66),
(118, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:16:26', 109),
(119, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "com.ruoyi.generator.domain.GenTable.getColumns()" because "table" is null', '2026-06-24 07:16:30', 16),
(120, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "com.ruoyi.generator.domain.GenTable.getColumns()" because "table" is null', '2026-06-24 07:19:46', 51),
(121, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "com.ruoyi.generator.domain.GenTable.getColumns()" because "table" is null', '2026-06-24 07:20:03', 12),
(122, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/4', '127.0.0.1', '内网IP', '[4] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:32:03', 66),
(123, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:32:06', 92),
(124, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "com.ruoyi.generator.domain.GenTable.getColumns()" because "table" is null', '2026-06-24 07:32:16', 16),
(125, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_dict_data","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:32:52', 94),
(126, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/5', '127.0.0.1', '内网IP', '[5] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:36:23', 82),
(127, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/6', '127.0.0.1', '内网IP', '[6] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:36:24', 21),
(128, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:36:30', 102),
(129, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/7', '127.0.0.1', '内网IP', '[7] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:42:05', 66),
(130, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:42:09', 91),
(131, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/8', '127.0.0.1', '内网IP', '[8] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:46:21', 63),
(132, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:46:24', 98),
(133, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/9', '127.0.0.1', '内网IP', '[9] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:49:14', 71),
(134, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:49:19', 105),
(135, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "java.util.List.stream()" because "tableColumns" is null', '2026-06-24 07:49:34', 23),
(136, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:52:09', 621),
(137, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_dict_data","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:52:30', 113),
(138, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_dict_data', '127.0.0.1', '内网IP', '{}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:52:44', 117),
(139, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/11', '127.0.0.1', '内网IP', '[11] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:56:34', 66),
(140, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/10', '127.0.0.1', '内网IP', '[10] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:56:37', 25),
(141, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 07:56:41', 125),
(142, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/12', '127.0.0.1', '内网IP', '[12] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 08:08:32', 59),
(143, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 08:08:35', 117),
(144, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 08:56:57', 103),
(145, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_dict_data","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:00:07', 123),
(146, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/14', '127.0.0.1', '内网IP', '[14] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:05:25', 77),
(147, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/13', '127.0.0.1', '内网IP', '[13] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:18:32', 66),
(148, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:44:30', 613),
(149, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "java.util.List.stream()" because "tableColumns" is null', '2026-06-24 09:53:57', 71);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES
(150, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/15', '127.0.0.1', '内网IP', '[15] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:54:01', 29),
(151, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:54:03', 101),
(152, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Cannot invoke "java.util.List.stream()" because "tableColumns" is null', '2026-06-24 09:54:11', 16),
(153, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:56:42', 614),
(154, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/16', '127.0.0.1', '内网IP', '[16] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:56:55', 30),
(155, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 09:56:58', 91),
(156, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/17', '127.0.0.1', '内网IP', '[17] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:09:56', 72),
(157, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:09:58', 99),
(158, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '', 1, 'Duplicate key null (attempted merging values com.ruoyi.generator.domain.GenTableColumn@6a507bb3 and com.ruoyi.generator.domain.GenTableColumn@68838968)', '2026-06-24 10:15:17', 70),
(159, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/18', '127.0.0.1', '内网IP', '[18] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:15:19', 37),
(160, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:15:22', 100),
(161, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:15:32', 117),
(162, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/19', '127.0.0.1', '内网IP', '[19] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:21:14', 59),
(163, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:21:19', 107),
(164, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{"businessName":"config","className":"SysConfig","columns":[{"capJavaField":"ConfigId","columnComment":"参数主键","columnId":237,"columnName":"config_id","columnType":"int","createBy":"admin","dictType":"","edit":false,"htmlType":"input","increment":true,"insert":true,"isIncrement":"1","isInsert":"1","isPk":"1","isRequired":"0","javaField":"configId","javaType":"Long","list":false,"params":{},"pk":true,"query":false,"queryType":"EQ","required":false,"sort":1,"superColumn":false,"tableId":20,"updateBy":"","usableColumn":false},{"capJavaField":"ConfigName","columnComment":"参数名称","columnId":238,"columnName":"config_name","columnType":"varchar(100)","createBy":"admin","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"0","javaField":"configName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":false,"sort":2,"superColumn":false,"tableId":20,"updateBy":"","usableColumn":false},{"capJavaField":"ConfigKey","columnComment":"参数键名","columnId":239,"columnName":"config_key","columnType":"varchar(100)","createBy":"admin","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"0","javaField":"configKey","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"EQ","required":false,"sort":3,"superColumn":false,"tableId":20,"updateBy":"","usableColumn":false},{"capJavaField":"ConfigValue","columnComment":"参数键值","columnId":240,"columnName":"config_value","columnType":"varchar(500)","createBy":"admin","dictType":"","edit":true,"htmlType":"textarea","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"0","javaField":"configValue","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryT', '{"msg":"操作成功","code":200}', 0, '', '2026-06-24 10:24:56', 186),
(165, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.cancelAuthUser()', 'PUT', 1, 'admin', '研发部门', '/system/role/authUser/cancel', '127.0.0.1', '内网IP', '{"roleId":2,"userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 03:40:12', 29),
(166, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()', 'PUT', 1, 'admin', '研发部门', '/system/role/authUser/selectAll', '127.0.0.1', '内网IP', '{"roleId":"2","userIds":"2"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 03:40:16', 16),
(167, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 03:40:26', 38),
(168, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{"configId":4,"configKey":"sys.account.captchaEnabled","configName":"账号自助-验证码开关","configType":"Y","configValue":"false","createBy":"admin","createTime":"2026-06-24 10:56:43","params":{},"remark":"是否开启验证码功能（true开启，false关闭）","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 03:41:08', 39),
(169, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_dict_data","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 03:41:50', 137),
(170, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_dict_type","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 08:21:37', 142),
(171, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/22', '127.0.0.1', '内网IP', '[22] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:07:41', 62),
(172, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_dict_type","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:07:44', 104),
(173, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:46:05', 74),
(174, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:46:13', 31),
(175, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:46:21', 29),
(176, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:46:27', 29),
(177, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":3,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:46:49', 75),
(178, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 09:46:54', 29),
(179, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 11:37:05', 49),
(180, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"1","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 11:41:19', 98),
(181, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 11:42:02', 34),
(182, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 11:47:25', 67),
(183, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,3],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[],"roles":[],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 11:47:30', 29),
(184, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[2,1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 11:49:37', 662),
(185, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:04:26', 114),
(186, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.cancelAuthUser()', 'PUT', 1, 'admin', '研发部门', '/system/role/authUser/cancel', '127.0.0.1', '内网IP', '{"roleId":2,"userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:04:48', 12),
(187, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()', 'PUT', 1, 'admin', '研发部门', '/system/role/authUser/selectAll', '127.0.0.1', '内网IP', '{"roleId":"2","userIds":"2"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:04:52', 17),
(188, '定时任务', 5, 'com.ruoyi.quartz.controller.SysJobController.export()', 'POST', 1, 'admin', '研发部门', '/monitor/job/export', '127.0.0.1', '内网IP', '{"pageSize":"10","pageNum":"1"}', '', 0, '', '2026-06-26 17:05:41', 1471),
(189, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/23', '127.0.0.1', '内网IP', '[23] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:06:08', 21),
(190, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/21', '127.0.0.1', '内网IP', '[21] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:06:10', 16),
(191, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/20', '127.0.0.1', '内网IP', '[20] ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:06:11', 13),
(192, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{"tables":"sys_config","tplWebType":"element-plus"}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:06:16', 79),
(193, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{"businessName":"config","className":"SysConfig","columns":[{"capJavaField":"ConfigId","columnComment":"参数主键","columnId":279,"columnName":"config_id","columnType":"int","createBy":"admin","dictType":"","edit":false,"htmlType":"input","increment":true,"insert":true,"isIncrement":"1","isInsert":"1","isPk":"1","isRequired":"0","javaField":"configId","javaType":"Long","list":false,"params":{},"pk":true,"query":false,"queryType":"EQ","required":false,"sort":1,"superColumn":false,"tableId":24,"updateBy":"","usableColumn":false},{"capJavaField":"ConfigName","columnComment":"参数名称","columnId":280,"columnName":"config_name","columnType":"varchar(100)","createBy":"admin","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"0","javaField":"configName","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"LIKE","required":false,"sort":2,"superColumn":false,"tableId":24,"updateBy":"","usableColumn":false},{"capJavaField":"ConfigKey","columnComment":"参数键名","columnId":281,"columnName":"config_key","columnType":"varchar(100)","createBy":"admin","dictType":"","edit":true,"htmlType":"input","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"0","javaField":"configKey","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryType":"EQ","required":false,"sort":3,"superColumn":false,"tableId":24,"updateBy":"","usableColumn":false},{"capJavaField":"ConfigValue","columnComment":"参数键值","columnId":282,"columnName":"config_value","columnType":"varchar(500)","createBy":"admin","dictType":"","edit":true,"htmlType":"textarea","increment":false,"insert":true,"isEdit":"1","isIncrement":"0","isInsert":"1","isList":"1","isPk":"0","isQuery":"1","isRequired":"0","javaField":"configValue","javaType":"String","list":true,"params":{},"pk":false,"query":true,"queryT', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:06:27', 142),
(194, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sys_config', '127.0.0.1', '内网IP', '{}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:07:12', 77),
(195, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-24 10:56:42","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1,2],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-26 17:36:45', 572),
(196, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-10 00:00:00","id":"37e92920-77f1-48fb-b93c-ecda49587f2c","leaveType":"年假","params":{},"reason":"cessfs","startDate":"2026-06-02 00:00:00","status":"0","userName":"ce"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:15:36', 295),
(197, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-09 00:00:00","id":"db2c8656-b04e-4db8-b78f-623cc6d18179","leaveType":"年假","params":{},"reason":"fsf","startDate":"2026-06-03 00:00:00","status":"0","userName":"fsf"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:17:12', 12),
(198, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"8dcc536d-363e-4609-b23e-dea8d99ecbfa","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:18:00', 5),
(199, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"cb612693-e032-49ad-be2d-5805bbc030af","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:18:45', 6);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES
(200, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"58bd9979-dd1d-453b-beca-6762dd143047","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:19:04', 6),
(201, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"edb410e2-244a-4bd5-a73c-d30e6964ad84","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:19:41', 11),
(202, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"784476dc-ba2d-4708-a1ad-423caea701cb","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:20:31', 5),
(203, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"dd0337cb-7689-481b-9076-5bb2201f67fb","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\n; bad SQL grammar []', '2026-06-27 18:20:57', 6),
(204, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"5b7d68ff-8bce-4b85-870d-561e487049f4","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '', 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'id\' at row 1\r\n### The error may exist in com/ruoyi/workflow/mapper/LeaveTestMapper.java (best guess)\r\n### The error may involve com.ruoyi.workflow.mapper.LeaveTestMapper.insert\r\n### The error occurred while executing an update\r\n### SQL: INSERT INTO `leave_test`(`id`, `user_name`, `leave_type`, `start_date`, `end_date`, `reason`, `status`, `process_instance_id`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'id\' at row 1\n; Data truncation: Data too long for column \'id\' at row 1', '2026-06-27 18:24:28', 7),
(205, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"11ce4c76-1261-4978-b451-4997068e2128","leaveType":"���","params":{},"reason":"�������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:24:41', 8),
(206, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-16 00:00:00","id":"ea573b08-cbac-4a7f-9e77-2f829e29a986","leaveType":"事假","params":{},"reason":"fsfsf","startDate":"2026-06-02 00:00:00","status":"0","userName":"fsfs"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:25:06', 12),
(207, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'admin', '研发部门', '/workflow/leave/11ce4c76-1261-4978-b451-4997068e2128', '127.0.0.1', '内网IP', '"11ce4c76-1261-4978-b451-4997068e2128" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:30:15', 42),
(208, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.edit()', 'PUT', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-16 00:00:00","id":"ea573b08-cbac-4a7f-9e77-2f829e29a986","leaveType":"年假","params":{},"reason":"fsfsf","startDate":"2026-06-02 00:00:00","status":"0","userName":"fsfs"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:30:24', 29),
(209, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"ea573b08-cbac-4a7f-9e77-2f829e29a986","definitionId":"test:1:ac75fdc7-7250-11f1-9886-00e04c8228ec"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:30:44', 266),
(210, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{"admin":false,"params":{},"updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:31:32', 192),
(211, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,2000,2010,2011,2012,2013,2014,2015,2020,2021,2022,2023,2030,2031,2032,2033,2034,2040,2041,2042,2043,2001,2002,2003,2004,2005,2006],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:32:54', 96),
(212, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.complete()', 'POST', 1, 'ry', '测试部门', '/workflow/task/complete', '127.0.0.1', '内网IP', '{"comment":"sfsf","params":{},"taskId":"4ebc195e-7256-11f1-9680-00e04c8228ec","variables":{"approved":true,"comment":"sfsf"}} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:34:11', 274),
(213, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"e488e8c8-22d1-4f74-8265-132bb1bc060f","leaveType":"���","params":{},"reason":"������������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:41:02', 6),
(214, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"e488e8c8-22d1-4f74-8265-132bb1bc060f","definitionId":"test:1:ac75fdc7-7250-11f1-9886-00e04c8228ec"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 18:41:02', 38),
(215, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.complete()', 'POST', 1, 'ry', '测试部门', '/workflow/task/complete', '127.0.0.1', '内网IP', '{"comment":"","params":{},"taskId":"bf605a4b-7257-11f1-9680-00e04c8228ec","variables":{"approved":true}} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:08:39', 370),
(216, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.edit()', 'PUT', 1, 'ry', '测试部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"e488e8c8-22d1-4f74-8265-132bb1bc060f","leaveType":"年假","params":{},"processInstanceId":"bf603336-7257-11f1-9680-00e04c8228ec","reason":"fsfs","startDate":"2026-07-01 00:00:00","status":"2","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:09:07', 21),
(217, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1","leaveType":"���","params":{},"reason":"����������","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:24:32', 28),
(218, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:24:32', 8),
(219, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-03 00:00:00","id":"aa8e90af-800c-4266-9abc-47cf2a97f836","leaveType":"���","params":{},"reason":"���Բ��Խӿ�","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:25:04', 6),
(220, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:25:04', 5),
(221, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:25:36', 5),
(222, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:26:12', 4),
(223, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:27:24', 5),
(224, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:27:53', 4),
(225, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-07-05 00:00:00","id":"e7466fdf-c685-42cb-ad40-b580f7e91d02","leaveType":"���","params":{},"reason":"���Խ����","startDate":"2026-07-01 00:00:00","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:28:18', 7),
(226, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:28:19', 6),
(227, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:28:59', 5),
(228, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:29:04', 4),
(229, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"75e233e2-8095-439c-bf90-e6c3b2eeddc1"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:29:08', 5),
(230, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"id":"558fdc1f-2cf9-4aa1-ba04-e8a9fa7861a7","leaveType":"���","params":{},"reason":"�¼ܹ�����","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:29:50', 6),
(231, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'admin', '研发部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"558fdc1f-2cf9-4aa1-ba04-e8a9fa7861a7"} ', '', 1, 'processDefinitionKey and processDefinitionId are null', '2026-06-27 19:29:50', 5),
(232, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'ry', '测试部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-18 00:00:00","id":"20ef7477-6bd9-46e7-98a1-cfbce039383e","leaveType":"事假","params":{},"reason":"hkhkkhkh","startDate":"2026-06-10 00:00:00","status":"0","userName":"fsfsf"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:39:45', 50),
(233, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'ry', '测试部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{} ', '', 1, '\r\n### Error querying database.  Cause: org.apache.ibatis.builder.BuilderException: Error invoking SqlProvider method \'public static java.lang.String com.mybatisflex.core.provider.EntitySqlProvider.selectOneById(java.util.Map,org.apache.ibatis.builder.annotation.ProviderContext)\' with specify parameter \'class org.apache.ibatis.binding.MapperMethod$ParamMap\'.  Cause: com.mybatisflex.core.exception.MybatisFlexException: primaryValues 数组不能为 null 值或者空元素。\r\n### Cause: org.apache.ibatis.builder.BuilderException: Error invoking SqlProvider method \'public static java.lang.String com.mybatisflex.core.provider.EntitySqlProvider.selectOneById(java.util.Map,org.apache.ibatis.builder.annotation.ProviderContext)\' with specify parameter \'class org.apache.ibatis.binding.MapperMethod$ParamMap\'.  Cause: com.mybatisflex.core.exception.MybatisFlexException: primaryValues 数组不能为 null 值或者空元素。', '2026-06-27 19:39:46', 258),
(234, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"id":"388d1cd8-2816-4cc6-af27-3f972fcaeda1","leaveType":"���","params":{},"reason":"�Զ��ύ����","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:40:48', 6),
(235, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"id":"c6675017-0b6d-4940-972b-e223e9e2e8e7","leaveType":"���","params":{},"reason":"����ϲ���","status":"0","userName":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:44:14', 6),
(236, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'admin', '研发部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"id":"259f0405-448f-483a-a29d-9c67e90940a5","leaveType":"���","params":{},"reason":"�Զ��ύ����","status":"0","userName":"admin"} ', '{"msg":"259f0405-448f-483a-a29d-9c67e90940a5","code":200}', 0, '', '2026-06-27 19:47:44', 471),
(237, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/20ef7477-6bd9-46e7-98a1-cfbce039383e', '127.0.0.1', '内网IP', '"20ef7477-6bd9-46e7-98a1-cfbce039383e" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:03', 16),
(238, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/388d1cd8-2816-4cc6-af27-3f972fcaeda1', '127.0.0.1', '内网IP', '"388d1cd8-2816-4cc6-af27-3f972fcaeda1" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:08', 16),
(239, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/558fdc1f-2cf9-4aa1-ba04-e8a9fa7861a7', '127.0.0.1', '内网IP', '"558fdc1f-2cf9-4aa1-ba04-e8a9fa7861a7" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:10', 12),
(240, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/75e233e2-8095-439c-bf90-e6c3b2eeddc1', '127.0.0.1', '内网IP', '"75e233e2-8095-439c-bf90-e6c3b2eeddc1" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:11', 12),
(241, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/aa8e90af-800c-4266-9abc-47cf2a97f836', '127.0.0.1', '内网IP', '"aa8e90af-800c-4266-9abc-47cf2a97f836" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:13', 12),
(242, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/c6675017-0b6d-4940-972b-e223e9e2e8e7', '127.0.0.1', '内网IP', '"c6675017-0b6d-4940-972b-e223e9e2e8e7" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:15', 16),
(243, '请假测试', 3, 'com.ruoyi.workflow.controller.LeaveTestController.remove()', 'DELETE', 1, 'ry', '测试部门', '/workflow/leave/e7466fdf-c685-42cb-ad40-b580f7e91d02', '127.0.0.1', '内网IP', '"e7466fdf-c685-42cb-ad40-b580f7e91d02" ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:16', 17),
(244, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'ry', '测试部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-03 00:00:00","id":"2411134c-caef-4af0-a9fc-66da1df8a67f","leaveType":"事假","params":{},"reason":"好烦好烦","startDate":"2026-06-01 00:00:00","status":"0","userName":"好烦好烦"} ', '{"msg":"2411134c-caef-4af0-a9fc-66da1df8a67f","code":200}', 0, '', '2026-06-27 19:48:31', 100),
(245, '请假测试', 2, 'com.ruoyi.workflow.controller.LeaveTestController.submitApproval()', 'POST', 1, 'ry', '测试部门', '/workflow/leave/submit', '127.0.0.1', '内网IP', '{"id":"2411134c-caef-4af0-a9fc-66da1df8a67f"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:48:31', 87),
(246, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'ry', '测试部门', '/workflow/leave', '127.0.0.1', '内网IP', '{"endDate":"2026-06-17 00:00:00","id":"216b66e6-2b56-43f4-bfef-ac5ec8b4b0ac","leaveType":"病假","params":{},"reason":"好看好看","startDate":"2026-06-02 00:00:00","status":"0","userName":"客户客户看"} ', '{"msg":"216b66e6-2b56-43f4-bfef-ac5ec8b4b0ac","code":200}', 0, '', '2026-06-27 19:51:03', 87),
(247, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.complete()', 'POST', 1, 'ry', '测试部门', '/workflow/task/complete', '127.0.0.1', '内网IP', '{"comment":"的观点","params":{},"taskId":"873cf8e2-7261-11f1-ab3d-00e04c8228ec","variables":{"approved":true,"comment":"的观点"}} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-27 19:51:28', 234),
(248, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,2000,2010,2011,2012,2013,2014,2015,2020,2021,2022,2023,2030,2031,2032,2033,2034,2040,2041,2042,2043,2044,2047,2045,2046,2001,2002,2003,2004,2005,2006],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 05:24:10', 116),
(249, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'ry', '测试部门', '/system/user', '127.0.0.1', '', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":101,"email":"ry@qq.com","loginDate":"2026-06-28 14:34:56","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1,2],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"ry","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:37:16', 104);
INSERT INTO `sys_oper_log` (`oper_id`, `title`, `business_type`, `method`, `request_method`, `operator_type`, `oper_name`, `dept_name`, `oper_url`, `oper_ip`, `oper_location`, `oper_param`, `json_result`, `status`, `error_msg`, `oper_time`, `cost_time`) VALUES
(250, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":101,"deptName":"深圳总公司","email":"ry@qq.com","leader":"若依","orderNum":1,"params":{},"parentId":100,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-28 14:34:56","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1,2],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:38:20', 45),
(251, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '', '{"admin":false,"params":{},"updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:39:15', 149),
(252, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '', '{"admin":false,"params":{},"updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:42:04', 49),
(253, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/system/user/changeStatus', '127.0.0.1', '', '{"admin":false,"params":{},"status":"0","updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:42:13', 2),
(254, '账户解锁', 0, 'com.ruoyi.web.controller.monitor.SysLogininforController.unlock()', 'GET', 1, 'admin', '研发部门', '/monitor/logininfor/unlock/ry', '127.0.0.1', '', '{}', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:43:37', 3),
(255, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '', '{"admin":false,"params":{},"updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:43:46', 46),
(256, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'ry', '测试部门', '/system/user', '127.0.0.1', '', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-28 14:44:22","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"ry","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:44:35', 92),
(257, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '', '{"admin":false,"params":{},"updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 06:56:36', 55),
(258, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.transfer()', 'POST', 1, 'ry', '测试部门', '/workflow/task/transfer', '127.0.0.1', '', '{"params":{},"taskId":"98c1d45a-726c-11f1-8024-00e04c8228ec","transferUserId":"2"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:00:29', 125),
(259, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.transfer()', 'POST', 1, 'ry', '测试部门', '/workflow/task/transfer', '127.0.0.1', '', '{"params":{},"taskId":"8d5c0b30-726c-11f1-8024-00e04c8228ec","transferUserId":"2"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:00:39', 49),
(260, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.transfer()', 'POST', 1, 'ry', '测试部门', '/workflow/task/transfer', '127.0.0.1', '', '{"params":{},"taskId":"10b64264-7261-11f1-ab3d-00e04c8228ec","transferUserId":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:02:49', 4),
(261, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'POST', 1, 'admin', '研发部门', '/system/user/edit', '127.0.0.1', '', '{"admin":false,"avatar":"","createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","dept":{"ancestors":"0,100,101","children":[],"createBy":"admin","createTime":"2026-06-24 10:56:42","delFlag":"0","deptId":105,"deptName":"测试部门","email":"ry@qq.com","leader":"若依","orderNum":3,"params":{},"parentId":101,"phone":"15888888888","status":"0","updateBy":""},"deptId":105,"email":"ry@qq.com","loginDate":"2026-06-28 14:56:41","loginIp":"127.0.0.1","nickName":"若依","params":{},"phonenumber":"15666666666","postIds":[1,2],"pwdUpdateDate":"2026-06-24 10:56:42","remark":"测试员","roleIds":[2],"roles":[{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":2,"status":"0","updateBy":"admin"}],"sex":"0","status":"0","updateBy":"admin","userId":2,"userName":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:30:14', 89),
(262, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'POST', 1, 'admin', '研发部门', '/system/role/edit', '127.0.0.1', '', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,2000,2010,2011,2012,2013,2014,2015,2020,2021,2022,2023,2030,2031,2032,2033,2034,2040,2041,2042,2043,2044,2047,2045,2046,2001,2002,2003,2004,2005,2006],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":3,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:30:23', 66),
(263, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'POST', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '', '{"admin":false,"params":{},"updateBy":"admin","userId":2} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:31:11', 171),
(264, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'POST', 1, 'ry', '测试部门', '/system/role/edit', '127.0.0.1', '', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[2000,1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,2001,2002,2003,2004,2005,2006],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":3,"status":"0","updateBy":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:36:15', 50),
(265, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'POST', 1, 'admin', '研发部门', '/system/role/edit', '127.0.0.1', '', '{"admin":false,"createBy":"admin","createTime":"2026-06-24 10:56:42","dataScope":"3","delFlag":"0","deptCheckStrictly":true,"flag":false,"menuCheckStrictly":true,"menuIds":[2000,1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,2040,2041,2042,2043,2044,2047,2045,2046,2001,2002,2003,2004,2005,2006],"params":{},"permissions":[],"remark":"普通角色","roleId":2,"roleKey":"common","roleName":"普通角色","roleSort":3,"status":"0","updateBy":"admin"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:36:58', 30),
(266, '请假测试', 1, 'com.ruoyi.workflow.controller.LeaveTestController.add()', 'POST', 1, 'ry', '测试部门', '/workflow/leave', '127.0.0.1', '', '{"endDate":"2026-06-17 00:00:00","id":"aa9b33dd-231f-48c5-9141-2a77a64ae6a9","leaveType":"病假","params":{},"reason":"hhkhkh","startDate":"2026-06-02 00:00:00","status":"0","userName":"fhfhfhfhfhf"} ', '{"msg":"aa9b33dd-231f-48c5-9141-2a77a64ae6a9","code":200}', 0, '', '2026-06-28 07:37:24', 188),
(267, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.transfer()', 'POST', 1, 'ry', '测试部门', '/workflow/task/transfer', '127.0.0.1', '', '{"params":{},"taskId":"33ef8e58-72c4-11f1-af07-00e04c8228ec","transferUserId":"ry"} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:37:42', 25),
(268, '流程任务', 2, 'com.ruoyi.workflow.controller.WorkflowTaskController.complete()', 'POST', 1, 'ry', '测试部门', '/workflow/task/complete', '127.0.0.1', '', '{"comment":"手术方式","params":{},"taskId":"33ef8e58-72c4-11f1-af07-00e04c8228ec","variables":{"approved":true,"comment":"手术方式"}} ', '{"msg":"操作成功","code":200}', 0, '', '2026-06-28 07:37:51', 221),
(269, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'ry', '测试部门', '/system/user/profile/avatar', '127.0.0.1', '', '', '{"msg":"操作成功","imgUrl":"/profile/avatar/2026/06/28/ca7b2c84476144599f1512783387d94b.png","code":200}', 0, '', '2026-06-28 07:39:10', 67);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` (`post_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, 'ceo', '董事长', 1, '0', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(2, 'se', '项目经理', 2, '0', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(3, 'hr', '人力资源', 3, '0', 'admin', '2026-06-24 02:56:42', '', NULL, ''),
(4, 'user', '普通员工', 4, '0', 'admin', '2026-06-24 02:56:42', 'admin', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-06-24 02:56:42', '', NULL, '超级管理员'),
(2, '普通角色', 'common', 3, '3', 1, 1, '0', '0', 'admin', '2026-06-24 02:56:42', 'admin', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(2, 1),
(2, 2),
(2, 3),
(2, 100),
(2, 101),
(2, 102),
(2, 103),
(2, 104),
(2, 105),
(2, 106),
(2, 107),
(2, 108),
(2, 109),
(2, 110),
(2, 111),
(2, 112),
(2, 113),
(2, 114),
(2, 115),
(2, 116),
(2, 117),
(2, 500),
(2, 501),
(2, 1000),
(2, 1001),
(2, 1002),
(2, 1003),
(2, 1004),
(2, 1005),
(2, 1006),
(2, 1007),
(2, 1008),
(2, 1009),
(2, 1010),
(2, 1011),
(2, 1012),
(2, 1013),
(2, 1014),
(2, 1015),
(2, 1016),
(2, 1017),
(2, 1018),
(2, 1019),
(2, 1020),
(2, 1021),
(2, 1022),
(2, 1023),
(2, 1024),
(2, 1025),
(2, 1026);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(2, 1027),
(2, 1028),
(2, 1029),
(2, 1030),
(2, 1031),
(2, 1032),
(2, 1033),
(2, 1034),
(2, 1035),
(2, 1036),
(2, 1037),
(2, 1038),
(2, 1039),
(2, 1040),
(2, 1041),
(2, 1042),
(2, 1043),
(2, 1044),
(2, 1045),
(2, 1046),
(2, 1047),
(2, 1048),
(2, 1049),
(2, 1050),
(2, 1051),
(2, 1052),
(2, 1053),
(2, 1054),
(2, 1055),
(2, 1056),
(2, 1057),
(2, 1058),
(2, 1059),
(2, 1060),
(2, 2000),
(2, 2001),
(2, 2002),
(2, 2003),
(2, 2004),
(2, 2005),
(2, 2006),
(2, 2040),
(2, 2041),
(2, 2042),
(2, 2043),
(2, 2044),
(2, 2045),
(2, 2046),
(2, 2047);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES
(1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-28 07:36:41', '2026-06-24 02:56:42', 'admin', '2026-06-24 02:56:42', '', NULL, '管理员'),
(2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '0', '/profile/avatar/2026/06/28/ca7b2c84476144599f1512783387d94b.png', '$2a$10$zoxrXgQe66YxPhjh0AFjyOtZ3wpHABrkG5OAHbQwPR3EwOjkJ6bMe', '0', '0', '127.0.0.1', '2026-06-28 07:37:06', '2026-06-24 02:56:42', 'admin', '2026-06-24 02:56:42', 'admin', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` (`user_id`, `post_id`) VALUES
(1, 1),
(2, 1),
(2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);
