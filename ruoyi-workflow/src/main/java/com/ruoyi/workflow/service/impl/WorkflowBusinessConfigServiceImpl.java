package com.ruoyi.workflow.service.impl;

import com.mybatisflex.core.paginate.Page;
import com.mybatisflex.core.query.QueryWrapper;
import com.ruoyi.workflow.domain.WorkflowBusinessConfig;
import com.ruoyi.workflow.mapper.WorkflowBusinessConfigMapper;
import com.ruoyi.workflow.service.IWorkflowBusinessConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;

@Service
public class WorkflowBusinessConfigServiceImpl implements IWorkflowBusinessConfigService {

    @Autowired
    private WorkflowBusinessConfigMapper configMapper;

    @Override
    public Page<WorkflowBusinessConfig> selectConfigList(Page<WorkflowBusinessConfig> page, WorkflowBusinessConfig config) {
        QueryWrapper qw = QueryWrapper.create()
                .select()
                .from(WorkflowBusinessConfig.class)
                .orderBy(WorkflowBusinessConfig::getCreateTime, true);
        if (StrUtil.isNotBlank(config.getBusinessName())) {
            qw.and("business_name like ?", "%" + config.getBusinessName() + "%");
        }
        if (StrUtil.isNotBlank(config.getProcessDefinitionKey())) {
            qw.and("process_definition_key like ?", "%" + config.getProcessDefinitionKey() + "%");
        }
        return configMapper.paginate(page.getPageNumber(), page.getPageSize(), qw);
    }

    @Override
    public WorkflowBusinessConfig selectConfigById(String id) {
        return configMapper.selectOneById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertConfig(WorkflowBusinessConfig config) {
        config.setId(IdUtil.simpleUUID());
        if (config.getStatus() == null) {
            config.setStatus("1");
        }
        return configMapper.insert(config);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateConfig(WorkflowBusinessConfig config) {
        return configMapper.update(config);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteConfigById(String id) {
        return configMapper.deleteById(id);
    }

    @Override
    public List<WorkflowBusinessConfig> listAll() {
        return configMapper.selectAll();
    }
}
