package com.ruoyi.workflow.service;

import java.util.List;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowModel;

/**
 * 流程模型 服务层
 *
 * @author ruoyi
 */
public interface IWorkflowModelService
{
    /**
     * 分页查询模型列表
     */
    Page<WorkflowModel> selectModelList(Page<WorkflowModel> page, WorkflowModel model);

    /**
     * 查询模型详情
     */
    WorkflowModel selectModelById(String modelId);

    /**
     * 新建空模型
     */
    String insertModel(WorkflowModel model);

    /**
     * 保存模型BPMN XML
     */
    void saveModel(String modelId, String bpmnXml);

    /**
     * 获取模型BPMN XML
     */
    String getModelBpmnXml(String modelId);

    /**
     * 删除模型
     */
    int deleteModelById(String modelId);

    /**
     * 部署模型为流程定义
     */
    String deployModel(String modelId);
}
