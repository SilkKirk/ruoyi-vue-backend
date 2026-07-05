package com.ruoyi.workflow.domain.vo;

import java.util.List;
import lombok.Data;

@Data
public class ProcessDiagramVo {
    private String bpmnXml;
    private List<String> completedActivityIds;
    private List<String> activeActivityIds;
    private List<String> completedFlowIds;
}
