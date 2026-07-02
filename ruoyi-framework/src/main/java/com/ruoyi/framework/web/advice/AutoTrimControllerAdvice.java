package com.ruoyi.framework.web.advice;

import java.beans.PropertyEditorSupport;
import java.lang.reflect.Field;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.InitBinder;
import com.ruoyi.common.annotation.AutoTrim;

/**
 * @AutoTrim 的 ControllerAdvice
 * <p>
 * 处理非 JSON 的数据绑定场景（form-data、query参数、@ModelAttribute），
 * 对标注了 @AutoTrim 的类或字段的 String 属性在 set 时自动执行 trim()
 * <p>
 * JSON 反序列化由 {@link com.ruoyi.common.config.serializer.AutoTrimModule} 处理
 *
 * @author ruoyi
 */
@ControllerAdvice
public class AutoTrimControllerAdvice
{
    @InitBinder
    public void initBinder(WebDataBinder binder)
    {
        Object target = binder.getTarget();
        if (target == null)
        {
            return;
        }

        Class<?> clazz = target.getClass();
        boolean classAnnotated = clazz.isAnnotationPresent(AutoTrim.class);

        // 遍历所有字段（包括父类），为需要 trim 的 String 字段注册 PropertyEditor
        Class<?> current = clazz;
        while (current != null && current != Object.class)
        {
            for (Field field : current.getDeclaredFields())
            {
                if (field.getType() != String.class)
                {
                    continue;
                }
                // 字段级 @AutoTrim 或类级 @AutoTrim
                if (field.isAnnotationPresent(AutoTrim.class) || classAnnotated)
                {
                    binder.registerCustomEditor(String.class, field.getName(), new StringTrimEditor());
                }
            }
            current = current.getSuperclass();
        }
    }

    /**
     * 自定义 PropertyEditor：set 时仅对非 null 值执行 trim()
     */
    private static class StringTrimEditor extends PropertyEditorSupport
    {
        @Override
        public void setAsText(String text)
        {
            setValue(text != null ? text.trim() : null);
        }

        @Override
        public String getAsText()
        {
            Object value = getValue();
            return value != null ? value.toString() : "";
        }
    }
}
