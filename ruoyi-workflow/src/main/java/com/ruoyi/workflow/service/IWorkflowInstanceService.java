package com.ruoyi.workflow.service;

import java.util.Map;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowInstance;

/**
 * 流程实例 服务层
 *
 * @author ruoyi
 */
public interface IWorkflowInstanceService
{
    /**
     * 分页查询流程实例列表
     */
    Page<WorkflowInstance> selectInstanceList(Page<WorkflowInstance> page, WorkflowInstance instance);

    /**
     * 启动流程实例
     */
    String startProcessInstance(String definitionId, String businessKey, Map<String, Object> variables);

    /**
     * 终止流程实例
     */
    void stopProcessInstance(String instanceId, String reason);

    /**
     * 挂起或激活流程实例
     */
    void updateState(String instanceId, int state);

    /**
     * 获取流程图高亮跟踪（Base64 PNG）
     */
    String getInstanceDiagram(String instanceId);

    /**
     * 根据流程实例ID查询
     */
    WorkflowInstance selectInstanceById(String instanceId);
}
