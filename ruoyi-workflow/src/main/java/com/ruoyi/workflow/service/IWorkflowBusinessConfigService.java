package com.ruoyi.workflow.service;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;

import java.util.List;

public interface IWorkflowBusinessConfigService {

    Page<WorkflowBusinessConfig> selectConfigList(Page<WorkflowBusinessConfig> page, WorkflowBusinessConfig config);

    WorkflowBusinessConfig selectConfigById(String id);

    int insertConfig(WorkflowBusinessConfig config);

    int updateConfig(WorkflowBusinessConfig config);

    int deleteConfigById(String id);

    List<WorkflowBusinessConfig> listAll();
}
