const fs = require('fs');
const path = require('path');

// Fix ModelController
let mc = fs.readFileSync('E:/home/ruoyi-vue-backend/ruoyi-workflow/src/main/java/com/ruoyi/workflow/controller/WorkflowModelController.java', 'utf8');
mc = mc.replace(
  `AjaxResult result = success();
        result.put("data", workflowModelService.getModelBpmnXml(modelId));
        return result;`,
  `return AjaxResult.success("操作成功", workflowModelService.getModelBpmnXml(modelId));`
);
fs.writeFileSync('E:/home/ruoyi-vue-backend/ruoyi-workflow/src/main/java/com/ruoyi/workflow/controller/WorkflowModelController.java', mc);
console.log('ModelController done');

// Fix DefinitionController
let dc = fs.readFileSync('E:/home/ruoyi-vue-backend/ruoyi-workflow/src/main/java/com/ruoyi/workflow/controller/WorkflowDefinitionController.java', 'utf8');
dc = dc.replace(
  `AjaxResult result = success();
        result.put("data", workflowDefinitionService.getDefinitionBpmnXml(definitionId));
        return result;`,
  `return AjaxResult.success("操作成功", workflowDefinitionService.getDefinitionBpmnXml(definitionId));`
);
fs.writeFileSync('E:/home/ruoyi-vue-backend/ruoyi-workflow/src/main/java/com/ruoyi/workflow/controller/WorkflowDefinitionController.java', dc);
console.log('DefinitionController done');
