package com.ruoyi.workflow.service.impl;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;
import org.flowable.engine.RepositoryService;
import org.flowable.engine.repository.Deployment;
import org.flowable.engine.repository.ProcessDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowDefinition;
import com.ruoyi.workflow.service.IWorkflowDefinitionService;
import cn.hutool.core.util.StrUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * 流程定义 服务层实现
 *
 * @author ruoyi
 */
@Slf4j
@Service
public class WorkflowDefinitionServiceImpl implements IWorkflowDefinitionService
{
    private static final int SUSPEND_STATE = 1;
    private static final int ACTIVE_STATE = 2;

    @Autowired
    private RepositoryService repositoryService;

    @Override
    public Page<WorkflowDefinition> selectDefinitionList(Page<WorkflowDefinition> page, WorkflowDefinition definition)
    {
        org.flowable.engine.repository.ProcessDefinitionQuery pdQuery = repositoryService.createProcessDefinitionQuery();
        if (StrUtil.isNotBlank(definition.getName()))
        {
            pdQuery.processDefinitionNameLike("%" + definition.getName() + "%");
        }
        List<ProcessDefinition> definitionList = pdQuery
                .latestVersion()
                .orderByProcessDefinitionVersion().desc()
                .listPage(Math.toIntExact((page.getPageNumber() - 1) * page.getPageSize()),
                        Math.toIntExact(page.getPageSize()));

        org.flowable.engine.repository.ProcessDefinitionQuery countQuery = repositoryService.createProcessDefinitionQuery();
        if (StrUtil.isNotBlank(definition.getName()))
        {
            countQuery.processDefinitionNameLike("%" + definition.getName() + "%");
        }
        long count = countQuery
                .latestVersion()
                .count();

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
        // state: 1=挂起(suspend), 2=激活(activate)
        if (state == SUSPEND_STATE)
        {
            repositoryService.suspendProcessDefinitionById(definitionId);
        }
        else if (state == ACTIVE_STATE)
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
            // 级联删除（包括流程实例）
            repositoryService.deleteDeployment(deploymentId, true);
        }
        return 1;
    }

    @Override
    public String getDefinitionBpmnXml(String definitionId)
    {
        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(definitionId).singleResult();
        if (processDefinition != null)
        {
            String deploymentId = processDefinition.getDeploymentId();
            List<String> resourceNames = repositoryService.getDeploymentResourceNames(deploymentId);
            for (String resourceName : resourceNames)
            {
                if (resourceName.endsWith(".bpmn") || resourceName.endsWith(".bpmn20.xml"))
                {
                    try (InputStream is = repositoryService.getResourceAsStream(deploymentId, resourceName))
                    {
                        if (is != null)
                        {
                            byte[] bytes = is.readAllBytes();
                            return new String(bytes, StandardCharsets.UTF_8);
                        }
                    }
                    catch (Exception e)
                    {
                        throw new RuntimeException("读取BPMN XML失败", e);
                    }
                }
            }
        }
        return null;
    }

    @Override
    public List<Map<String, String>> getProcessDefinitionKeys() {
        List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery()
                .latestVersion()
                .list();
        return list.stream().map(pd -> {
            Map<String, String> item = new HashMap<>();
            item.put("key", pd.getKey());
            item.put("name", pd.getName());
            return item;
        }).collect(Collectors.toList());
    }

    /**
     * 将Flowable ProcessDefinition转换为WorkflowDefinition
     */
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
        // 查询部署时间
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
