package com.ruoyi.workflow.common.utils;

import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FlowNode;
import org.flowable.bpmn.model.SequenceFlow;

import java.util.*;

public class FlowableDiagramUtils {

    public static List<String> computeCompletedFlowIds(
            List<String> completedActivityIds, List<String> activeActivityIds, BpmnModel bpmnModel) {
        Set<String> executed = new HashSet<>(completedActivityIds);
        executed.addAll(activeActivityIds);

        List<String> completedFlowIds = new ArrayList<>();
        for (String nodeId : executed) {
            FlowElement el = bpmnModel.getFlowElement(nodeId);
            if (el instanceof FlowNode fn) {
                for (SequenceFlow flow : fn.getIncomingFlows()) {
                    if (executed.contains(flow.getSourceRef())) {
                        completedFlowIds.add(flow.getId());
                    }
                }
            }
        }
        return completedFlowIds;
    }
}
