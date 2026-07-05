package com.ruoyi.workflow.controller;

import com.mybatisflex.core.paginate.Page;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.workflow.domain.LeaveTest;
import com.ruoyi.workflow.service.ILeaveTestService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/workflow/leave")
public class LeaveTestController extends BaseController {

    private final ILeaveTestService leaveTestService;

    @PreAuthorize("@ss.hasPermi('workflow:leave:list')")
    @GetMapping("/list")
    public TableDataInfo list(LeaveTest leaveTest) {
        Page<LeaveTest> page = leaveTestService.selectLeaveTestList(startPage(LeaveTest.class), leaveTest);
        return getDataTable(page);
    }

    @PreAuthorize("@ss.hasPermi('workflow:leave:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(leaveTestService.getById(id));
    }

    @PreAuthorize("@ss.hasPermi('workflow:leave:add')")
    @Log(title = "请假测试", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody LeaveTest leaveTest) {
        if (leaveTestService.insertLeaveTest(leaveTest)) {
            return success(leaveTest.getId());
        }
        return error();
    }

    @PreAuthorize("@ss.hasPermi('workflow:leave:edit')")
    @Log(title = "请假测试", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    public AjaxResult edit(@RequestBody LeaveTest leaveTest) {
        return toAjax(leaveTestService.updateById(leaveTest));
    }

    @PreAuthorize("@ss.hasPermi('workflow:leave:remove')")
    @Log(title = "请假测试", businessType = BusinessType.DELETE)
    @PostMapping("/{id}")
    public AjaxResult remove(@PathVariable Long id) {
        return toAjax(leaveTestService.removeById(id));
    }

}
