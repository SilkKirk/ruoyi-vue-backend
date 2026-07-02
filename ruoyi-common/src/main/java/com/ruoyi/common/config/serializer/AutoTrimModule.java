package com.ruoyi.common.config.serializer;

import java.io.IOException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.deser.ContextualDeserializer;
import com.fasterxml.jackson.databind.deser.std.StringDeserializer;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.ruoyi.common.annotation.AutoTrim;

/**
 * 自动 Trim 的 Jackson Module
 * <p>
 * 反序列化时，对标注了 {@link AutoTrim} 的类或字段的 String 属性自动执行 trim()
 *
 * @author ruoyi
 */
public class AutoTrimModule extends SimpleModule
{
    private static final long serialVersionUID = 1L;

    public AutoTrimModule()
    {
        addDeserializer(String.class, new AutoTrimStringDeserializer());
    }

    /**
     * ContextualDeserializer: 在创建上下文时判断是否需要 trim
     */
    private static class AutoTrimStringDeserializer extends JsonDeserializer<String>
            implements ContextualDeserializer
    {
        @Override
        public JsonDeserializer<?> createContextual(DeserializationContext ctxt, BeanProperty property)
        {
            if (property != null)
            {
                AnnotatedMember member = property.getMember();
                if (member != null)
                {
                    // 检查字段所在类是否有 @AutoTrim
                    boolean classAnnotated = member.getDeclaringClass().isAnnotationPresent(AutoTrim.class);
                    // 检查字段本身是否有 @AutoTrim
                    boolean fieldAnnotated = member.hasAnnotation(AutoTrim.class);
                    if (classAnnotated || fieldAnnotated)
                    {
                        return new TrimmingOnlyDeserializer();
                    }
                }
            }
            return StringDeserializer.instance;
        }

        @Override
        public String deserialize(JsonParser p, DeserializationContext ctxt) throws IOException
        {
            // 未经 createContextual 的兜底，走标准反序列化
            return StringDeserializer.instance.deserialize(p, ctxt);
        }
    }

    /**
     * 对 String 值执行 trim() 后返回
     */
    private static class TrimmingOnlyDeserializer extends JsonDeserializer<String>
    {
        @Override
        public String deserialize(JsonParser p, DeserializationContext ctxt) throws IOException
        {
            String value = StringDeserializer.instance.deserialize(p, ctxt);
            return value != null ? value.trim() : null;
        }
    }
}
