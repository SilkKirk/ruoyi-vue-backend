package com.ruoyi.common.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 自动 Trim 注解
 * <p>
 * 标注在类上：对该类所有 String 字段执行 trim()
 * 标注在字段上：仅对该字段执行 trim()
 * 同时标注时，字段级优先
 *
 * @author ruoyi
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.FIELD })
public @interface AutoTrim
{
}
