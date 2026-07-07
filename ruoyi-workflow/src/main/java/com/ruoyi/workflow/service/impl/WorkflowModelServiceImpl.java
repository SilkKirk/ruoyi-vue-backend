package com.ruoyi.workflow.service.impl;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.repository.Deployment;
import org.flowable.engine.repository.Model;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowModel;
import com.ruoyi.workflow.service.IWorkflowModelService;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import lombok.RequiredArgsConstructor;

/**
 * 流程模型 服务层实现
 *
 * @author ruoyi
 */
@RequiredArgsConstructor
@Service
public class WorkflowModelServiceImpl implements IWorkflowModelService
{
    private final RepositoryService repositoryService;

    private static final String EMPTY_BPMN_TEMPLATE = ""
            + "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + "<definitions xmlns=\"http://www.omg.org/spec/BPMN/20100524/MODEL\""
            + " xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
            + " xmlns:flowable=\"http://flowable.org/bpmn\""
            + " targetNamespace=\"http://www.flowable.org/processdef\">"
            + " <process id=\"{}\" name=\"{}\" isExecutable=\"true\">"
            + "   <startEvent id=\"startEvent\" name=\"开始\"></startEvent>"
            + "   <endEvent id=\"endEvent\" name=\"结束\"></endEvent>"
            + "   <sequenceFlow id=\"flow1\" sourceRef=\"startEvent\" targetRef=\"endEvent\"></sequenceFlow>"
            + " </process>"
            + "</definitions>";

    @Override
    public Page<WorkflowModel> selectModelList(Page<WorkflowModel> page, WorkflowModel model)
    {
        org.flowable.engine.repository.ModelQuery query = createModelQuery(model.getName());
        List<Model> modelList = query
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        long count = query.count();

        List<WorkflowModel> workflowModels = modelList.stream().map(this::convertToWorkflowModel)
                .collect(Collectors.toList());

        page.setRecords(workflowModels);
        page.setTotalRow(count);
        return page;
    }

    @Override
    public WorkflowModel selectModelById(String modelId)
    {
        Model model = repositoryService.getModel(modelId);
        if (model == null)
        {
            return null;
        }
        WorkflowModel workflowModel = convertToWorkflowModel(model);
        // 获取BPMN XML
        byte[] bpmnBytes = repositoryService.getModelEditorSource(modelId);
        if (bpmnBytes != null)
        {
            workflowModel.setBpmnXml(StrUtil.utf8Str(bpmnBytes));
        }
        return workflowModel;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String insertModel(WorkflowModel model)
    {
        Model newModel = repositoryService.newModel();
        newModel.setName(model.getName());
        newModel.setKey(model.getKey());
        newModel.setCategory(model.getCategory());
        newModel.setMetaInfo(JSONUtil.toJsonStr(JSONUtil.createObj().set("description",
                StrUtil.emptyIfNull(model.getDescription()))));

        repositoryService.saveModel(newModel);

        String emptyBpmnXml = StrUtil.format(EMPTY_BPMN_TEMPLATE, model.getKey(), model.getName());

        repositoryService.addModelEditorSource(newModel.getId(), emptyBpmnXml.getBytes(StandardCharsets.UTF_8));

        return newModel.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveModel(String modelId, String bpmnXml)
    {
        repositoryService.addModelEditorSource(modelId, bpmnXml.getBytes(StandardCharsets.UTF_8));
    }

    @Override
    public String getModelBpmnXml(String modelId)
    {
        byte[] bpmnBytes = repositoryService.getModelEditorSource(modelId);
        if (bpmnBytes != null)
        {
            return StrUtil.utf8Str(bpmnBytes);
        }
        return null;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteModelById(String modelId)
    {
        repositoryService.deleteModel(modelId);
        return 1;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String deployModel(String modelId)
    {
        Model model = repositoryService.getModel(modelId);
        if (model == null)
        {
            throw new RuntimeException("模型不存在");
        }

        byte[] bpmnBytes = repositoryService.getModelEditorSource(modelId);
        if (bpmnBytes == null)
        {
            throw new RuntimeException("模型BPMN XML为空，请先设计流程图");
        }

        String bpmnXml = StrUtil.utf8Str(bpmnBytes);

        // 直接部署XML字符串
        Deployment deployment = repositoryService.createDeployment()
                .name(model.getName())
                .category(model.getCategory())
                .addString(model.getKey() + ".bpmn20.xml", bpmnXml)
                .deploy();

        // 更新模型部署信息
        model.setDeploymentId(deployment.getId());
        repositoryService.saveModel(model);

        return deployment.getId();
    }

    private org.flowable.engine.repository.ModelQuery createModelQuery(String name) {
        org.flowable.engine.repository.ModelQuery query = repositoryService.createModelQuery();
        if (StrUtil.isNotBlank(name)) {
            query.modelNameLike("%" + name + "%");
        }
        return query;
    }

    /**
     * 将Flowable Model转换为WorkflowModel
     */
    private WorkflowModel convertToWorkflowModel(Model model)
    {
        WorkflowModel workflowModel = new WorkflowModel();
        workflowModel.setModelId(model.getId());
        workflowModel.setName(model.getName());
        workflowModel.setKey(model.getKey());
        workflowModel.setCategory(model.getCategory());
        workflowModel.setVersion(model.getVersion());
        workflowModel.setDescription(model.getMetaInfo());
        workflowModel.setDeploymentId(model.getDeploymentId());

        workflowModel.setCreateTime(model.getCreateTime());
        return workflowModel;
    }
}
