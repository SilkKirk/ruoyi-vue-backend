package com.ruoyi.workflow.domain.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record HistoryEvent(
    String taskName,
    String assignee,
    String assigneeName,
    String assigneeDeptName,
    Date startTime,
    Date endTime,
    Long duration,
    String type,
    String comment,
    Integer approved
) {}
