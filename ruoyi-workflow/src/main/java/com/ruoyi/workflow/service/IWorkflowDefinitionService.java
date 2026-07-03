package com.ruoyi.workflow.service;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowDefinition;

import java.util.List;
import java.util.Map;

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
     * 获取流程定义BPMN XML
     */
    String getDefinitionBpmnXml(String definitionId);

    /**
     * 获取所有已部署流程定义的Key和名称列表（用于下拉选择）
     */
    List<Map<String, String>> getProcessDefinitionKeys();
}
