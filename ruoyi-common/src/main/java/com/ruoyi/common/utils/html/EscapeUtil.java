package com.ruoyi.common.utils.html;

import cn.hutool.http.HtmlUtil;
import cn.hutool.core.util.StrUtil;

/**
 * 转义和反转义工具类
 * 
 * @author ruoyi
 */
public class EscapeUtil
{
    /**
     * 转义文本中的HTML字符为安全的字符
     * 
     * @param text 被转义的文本
     * @return 转义后的文本
     */
    public static String escape(String text)
    {
        return HtmlUtil.escape(text);
    }

    /**
     * 还原被转义的HTML特殊字符
     * 
     * @param content 包含转义符的HTML内容
     * @return 转换后的字符串
     */
    public static String unescape(String content)
    {
        return HtmlUtil.unescape(content);
    }

    /**
     * 清除所有HTML标签，但是不删除标签内的内容
     * 
     * @param content 文本
     * @return 清除标签后的文本
     */
    public static String clean(String content)
    {
        if (StrUtil.isEmpty(content))
        {
            return content;
        }
        return HtmlUtil.cleanHtmlTag(content);
    }
}
