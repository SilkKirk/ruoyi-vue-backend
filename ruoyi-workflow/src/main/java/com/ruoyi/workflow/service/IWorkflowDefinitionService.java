package com.ruoyi.workflow.service;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowDefinition;
import com.ruoyi.workflow.domain.vo.ProcessDiagramVo;
import com.ruoyi.workflow.domain.vo.ProcessDefinitionKey;

import java.util.List;

/**
 * 流程定义 服务层
 *
 * @author ruoyi
 */
public interface IWorkflowDefinitionService
{
    /**
     * 分页查询流程定义列表
     */
    Page<WorkflowDefinition> selectDefinitionList(Page<WorkflowDefinition> page, WorkflowDefinition definition);

    /**
     * 挂起或激活流程定义
     */
    int updateState(String definitionId, int state);

    /**
     * 删除流程定义
     */
    int deleteDefinitionById(String definitionId);

    /**
     * 获取流程图数据（BPMN XML + 可选活动状态）
     */
    ProcessDiagramVo getDiagramInfo(String definitionId, String instanceId);

    /**
     * 获取所有已部署流程定义的Key和名称列表（用于下拉选择）
     */
    List<ProcessDefinitionKey> getProcessDefinitionKeys();
}
