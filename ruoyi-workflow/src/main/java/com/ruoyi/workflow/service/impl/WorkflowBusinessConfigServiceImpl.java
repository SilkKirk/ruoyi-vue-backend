package com.ruoyi.workflow.service.impl;

import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.mybatisflex.spring.service.impl.ServiceImpl;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.mapper.WorkflowBusinessConfigMapper;
import com.ruoyi.workflow.common.FlowableProcessConstants;
import com.ruoyi.workflow.service.IWorkflowBusinessConfigService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;

@Service
public class WorkflowBusinessConfigServiceImpl
        extends ServiceImpl<WorkflowBusinessConfigMapper, WorkflowBusinessConfig>
        implements IWorkflowBusinessConfigService {

    @Override
    public Page<WorkflowBusinessConfig> selectConfigList(Page<WorkflowBusinessConfig> page, WorkflowBusinessConfig config) {
        QueryWrapper qw = QueryWrapper.create()
                .from(WorkflowBusinessConfig.class)
                .orderBy(WorkflowBusinessConfig::getCreateTime, true);
        if (StrUtil.isNotBlank(config.getBusinessName())) {
            qw.and(WorkflowBusinessConfig::getBusinessName).like(config.getBusinessName());
        }
        if (StrUtil.isNotBlank(config.getProcessDefinitionKey())) {
            qw.and(WorkflowBusinessConfig::getProcessDefinitionKey).like(config.getProcessDefinitionKey());
        }
        return page(page, qw);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insertConfig(WorkflowBusinessConfig config) {
        config.setId(IdUtil.simpleUUID());
        if (config.getStatus() == null) {
            config.setStatus(FlowableProcessConstants.CONFIG_STATUS_ENABLED);
        }
        return save(config);
    }
}
