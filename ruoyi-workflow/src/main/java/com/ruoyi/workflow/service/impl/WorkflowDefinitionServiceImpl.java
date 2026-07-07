package com.ruoyi.workflow.service.impl;

import java.io.InputStream;
import java.util.*;
import java.util.stream.Collectors;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.engine.HistoryService;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.history.HistoricActivityInstance;
import org.flowable.engine.history.HistoricProcessInstance;
import org.flowable.engine.repository.Deployment;
import org.flowable.engine.repository.ProcessDefinition;
import org.flowable.engine.runtime.ProcessInstance;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.domain.WorkflowDefinition;
import com.ruoyi.workflow.domain.vo.ProcessDiagramVo;
import com.ruoyi.workflow.domain.vo.ProcessDefinitionKey;
import com.ruoyi.workflow.service.IWorkflowDefinitionService;
import com.ruoyi.workflow.common.utils.FlowableDiagramUtils;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class WorkflowDefinitionServiceImpl implements IWorkflowDefinitionService
{
    private final RepositoryService repositoryService;

    private final RuntimeService runtimeService;

    private final HistoryService historyService;

    @Override
    public Page<WorkflowDefinition> selectDefinitionList(Page<WorkflowDefinition> page, WorkflowDefinition definition)
    {
        org.flowable.engine.repository.ProcessDefinitionQuery query = createDefinitionQuery(definition.getName())
                .latestVersion()
                .orderByProcessDefinitionVersion().desc();
        List<ProcessDefinition> definitionList = query
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        long count = query.count();

        List<WorkflowDefinition> resultList = definitionList.stream()
                .map(this::convertToWorkflowDefinition)
                .collect(Collectors.toList());

        page.setRecords(resultList);
        page.setTotalRow(count);
        return page;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateState(String definitionId, int state)
    {
        if (state == FlowableProcessConstants.SUSPEND_STATE)
        {
            repositoryService.suspendProcessDefinitionById(definitionId);
        }
        else if (state == FlowableProcessConstants.ACTIVE_STATE)
        {
            repositoryService.activateProcessDefinitionById(definitionId);
        }
        return 1;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteDefinitionById(String definitionId)
    {
        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(definitionId).singleResult();
        if (processDefinition != null)
        {
            String deploymentId = processDefinition.getDeploymentId();
            repositoryService.deleteDeployment(deploymentId, true);
        }
        return 1;
    }

    @Override
    public ProcessDiagramVo getDiagramInfo(String definitionId, String instanceId)
    {
        if (StrUtil.isNotBlank(instanceId)) {
            return buildDiagramForInstance(instanceId);
        }
        if (StrUtil.isNotBlank(definitionId)) {
            return buildDiagramForDefinition(definitionId);
        }
        return null;
    }

    private ProcessDiagramVo buildDiagramForInstance(String instanceId)
    {
        ProcessInstance pi = runtimeService.createProcessInstanceQuery()
                .processInstanceId(instanceId).singleResult();

        String defId;
        if (pi != null) {
            defId = pi.getProcessDefinitionId();
        } else {
            HistoricProcessInstance hpi = historyService.createHistoricProcessInstanceQuery()
                    .processInstanceId(instanceId).singleResult();
            if (hpi == null) return null;
            defId = hpi.getProcessDefinitionId();
        }

        BpmnModel bpmnModel = repositoryService.getBpmnModel(defId);
        if (bpmnModel == null) return null;

        List<HistoricActivityInstance> completedActInstList = historyService.createHistoricActivityInstanceQuery()
                .processInstanceId(instanceId)
                .finished()
                .orderByHistoricActivityInstanceEndTime().asc()
                .list();

        List<String> completedActivityIds = completedActInstList.stream()
                .map(HistoricActivityInstance::getActivityId)
                .collect(Collectors.toList());

        List<String> activeActivityIds = pi != null
                ? runtimeService.getActiveActivityIds(instanceId)
                : Collections.emptyList();

        List<String> completedFlowIds = FlowableDiagramUtils.computeCompletedFlowIds(
                completedActivityIds, activeActivityIds, bpmnModel);

        String bpmnXml = readBpmnXml(defId);

        ProcessDiagramVo vo = new ProcessDiagramVo();
        vo.setBpmnXml(bpmnXml);
        vo.setCompletedActivityIds(completedActivityIds);
        vo.setActiveActivityIds(activeActivityIds);
        vo.setCompletedFlowIds(completedFlowIds);
        return vo;
    }

    private ProcessDiagramVo buildDiagramForDefinition(String definitionId)
    {
        String bpmnXml = readBpmnXml(definitionId);
        if (bpmnXml == null) return null;
        ProcessDiagramVo vo = new ProcessDiagramVo();
        vo.setBpmnXml(bpmnXml);
        vo.setCompletedActivityIds(Collections.emptyList());
        vo.setActiveActivityIds(Collections.emptyList());
        vo.setCompletedFlowIds(Collections.emptyList());
        return vo;
    }

    private String readBpmnXml(String definitionId)
    {
        ProcessDefinition pd = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(definitionId).singleResult();
        if (pd == null) return null;
        String deploymentId = pd.getDeploymentId();
        String resourceName = repositoryService.getDeploymentResourceNames(deploymentId).stream()
                .filter(n -> n.endsWith(".bpmn") || n.endsWith(".bpmn20.xml"))
                .findFirst().orElse(null);
        if (resourceName == null) return null;
        try (InputStream is = repositoryService.getResourceAsStream(deploymentId, resourceName))
        {
            if (is != null) return IoUtil.readUtf8(is);
        }
        catch (Exception e)
        {
            log.error("读取BPMN XML失败", e);
        }
        return null;
    }

    @Override
    public List<ProcessDefinitionKey> getProcessDefinitionKeys() {
        List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery()
                .latestVersion()
                .list();
        return list.stream().map(pd -> new ProcessDefinitionKey(pd.getKey(), pd.getName()))
                .collect(Collectors.toList());
    }

    private org.flowable.engine.repository.ProcessDefinitionQuery createDefinitionQuery(String name) {
        org.flowable.engine.repository.ProcessDefinitionQuery q = repositoryService.createProcessDefinitionQuery();
        if (StrUtil.isNotBlank(name)) {
            q.processDefinitionNameLike("%" + name + "%");
        }
        return q;
    }

    private WorkflowDefinition convertToWorkflowDefinition(ProcessDefinition pd)
    {
        WorkflowDefinition def = new WorkflowDefinition();
        def.setDefinitionId(pd.getId());
        def.setName(pd.getName());
        def.setKey(pd.getKey());
        def.setCategory(pd.getCategory());
        def.setVersion(pd.getVersion());
        def.setDescription(pd.getDescription());
        def.setDeploymentId(pd.getDeploymentId());
        def.setSuspended(pd.isSuspended() ? 1 : 0);
        try
        {
            Deployment deployment = repositoryService.createDeploymentQuery()
                    .deploymentId(pd.getDeploymentId()).singleResult();
            if (deployment != null)
            {
                def.setDeployTime(deployment.getDeploymentTime());
            }
        }
        catch (Exception e)
        {
            log.warn("部署时间查询失败", e);
        }
        return def;
    }
}
