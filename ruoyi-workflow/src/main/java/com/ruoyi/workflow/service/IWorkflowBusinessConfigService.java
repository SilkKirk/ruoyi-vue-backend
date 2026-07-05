package com.ruoyi.workflow.service;

import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.service.IService;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;

public interface IWorkflowBusinessConfigService extends IService<WorkflowBusinessConfig> {

    Page<WorkflowBusinessConfig> selectConfigList(Page<WorkflowBusinessConfig> page, WorkflowBusinessConfig config);

    boolean insertConfig(WorkflowBusinessConfig config);
}
