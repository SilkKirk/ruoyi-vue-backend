package com.ruoyi.common.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.map.MapUtil;
import org.springframework.util.AntPathMatcher;
import com.ruoyi.common.constant.Constants;

/**
 * 字符串工具类
 * 
 * @author ruoyi
 */
@SuppressWarnings("deprecation")
public class StringUtils
{
    /** 空字符串 */
    private static final String NULLSTR = "";

    /** 下划线 */
    private static final char SEPARATOR = '_';

    /** 星号 */
    private static final char ASTERISK = '*';

    public static final int INDEX_NOT_FOUND = -1;

    public static final String EMPTY = StrUtil.EMPTY;

    // ==================== 来自 commons-lang3 的核心方法（委托 StrUtil） ====================

    public static boolean isEmpty(CharSequence cs)
    {
        return StrUtil.isEmpty(cs);
    }

    public static boolean isNotEmpty(CharSequence cs)
    {
        return StrUtil.isNotEmpty(cs);
    }

    public static boolean isBlank(CharSequence cs)
    {
        return StrUtil.isBlank(cs);
    }

    public static boolean isNotBlank(CharSequence cs)
    {
        return StrUtil.isNotBlank(cs);
    }

    public static boolean equals(CharSequence cs1, CharSequence cs2)
    {
        return StrUtil.equals(cs1, cs2);
    }

    public static boolean equalsAny(CharSequence cs, CharSequence... searchCharSequences)
    {
        return StrUtil.equalsAny(cs, searchCharSequences);
    }

    public static boolean equalsAnyIgnoreCase(CharSequence str, CharSequence... searchStrings)
    {
        return StrUtil.equalsAnyIgnoreCase(str, searchStrings);
    }

    public static boolean equalsIgnoreCase(CharSequence cs1, CharSequence cs2)
    {
        return StrUtil.equalsIgnoreCase(cs1, cs2);
    }

    public static boolean contains(CharSequence seq, CharSequence searchSeq)
    {
        return StrUtil.contains(seq, searchSeq);
    }

    public static boolean containsIgnoreCase(CharSequence str, CharSequence searchStr)
    {
        return StrUtil.containsIgnoreCase(str, searchStr);
    }

    public static boolean containsAny(CharSequence cs, CharSequence... searchCharSequences)
    {
        return StrUtil.containsAny(cs, searchCharSequences);
    }

    public static boolean startsWithAny(CharSequence cs, CharSequence... searchStrings)
    {
        return StrUtil.startWithAny(cs, searchStrings);
    }

    public static boolean startsWithIgnoreCase(CharSequence str, CharSequence prefix)
    {
        return StrUtil.startWithIgnoreCase(str, prefix);
    }

    public static boolean startsWith(CharSequence str, CharSequence prefix)
    {
        return StrUtil.startWith(str, prefix);
    }

    public static boolean endsWith(CharSequence str, CharSequence suffix)
    {
        return StrUtil.endWith(str, suffix);
    }

    public static boolean endsWithIgnoreCase(CharSequence str, CharSequence suffix)
    {
        return StrUtil.endWithIgnoreCase(str, suffix);
    }

    public static String[] split(String str, String separatorChars)
    {
        return StrUtil.splitToArray(str, separatorChars);
    }

    public static String join(Object[] array)
    {
        return join(array, EMPTY);
    }

    public static String join(Object[] array, String separator)
    {
        return StrUtil.join(separator, array);
    }

    public static String join(Iterable<?> iterable, String separator)
    {
        return StrUtil.join(separator, iterable);
    }

    public static String replace(String text, String searchString, String replacement)
    {
        return StrUtil.replace(text, searchString, replacement);
    }

    public static String substringBefore(String str, String separator)
    {
        return StrUtil.subBefore(str, separator, false);
    }

    public static String substringBeforeLast(String str, String separator)
    {
        return StrUtil.subBefore(str, separator, true);
    }

    public static String substringAfter(String str, String separator)
    {
        return StrUtil.subAfter(str, separator, false);
    }

    public static String substringAfterLast(String str, String separator)
    {
        return StrUtil.subAfter(str, separator, true);
    }

    public static String substringBetween(String str, String tag)
    {
        return StrUtil.subBetween(str, tag);
    }

    public static String substringBetween(String str, String open, String close)
    {
        return StrUtil.subBetween(str, open, close);
    }

    public static String removeEnd(String str, String remove)
    {
        return StrUtil.removeSuffix(str, remove);
    }

    public static String removeStart(String str, String remove)
    {
        return StrUtil.removePrefix(str, remove);
    }

    public static String stripEnd(String str, String stripChars)
    {
        if (str == null || str.isEmpty())
        {
            return str;
        }
        int end = str.length();
        if (stripChars == null || stripChars.isEmpty())
        {
            while (end != 0 && Character.isWhitespace(str.charAt(end - 1)))
            {
                end--;
            }
        }
        else
        {
            while (end != 0 && stripChars.indexOf(str.charAt(end - 1)) != INDEX_NOT_FOUND)
            {
                end--;
            }
        }
        return str.substring(0, end);
    }

    public static String trimToEmpty(String str)
    {
        return StrUtil.trimToEmpty(str);
    }

    public static String capitalize(String str)
    {
        return StrUtil.upperFirst(str);
    }

    public static String uncapitalize(String str)
    {
        return StrUtil.lowerFirst(str);
    }

    public static String lowerCase(String str)
    {
        return str != null ? str.toLowerCase() : null;
    }

    public static int indexOf(CharSequence seq, CharSequence searchSeq)
    {
        if (seq == null || searchSeq == null)
        {
            return INDEX_NOT_FOUND;
        }
        return seq.toString().indexOf(searchSeq.toString());
    }

    public static int indexOfIgnoreCase(CharSequence str, CharSequence searchStr)
    {
        return StrUtil.indexOfIgnoreCase(str, searchStr);
    }

    public static int lastIndexOf(CharSequence seq, CharSequence searchSeq)
    {
        if (seq == null || searchSeq == null)
        {
            return INDEX_NOT_FOUND;
        }
        return seq.toString().lastIndexOf(searchSeq.toString());
    }

    public static int length(CharSequence cs)
    {
        return StrUtil.length(cs);
    }

    public static boolean isNumeric(CharSequence cs)
    {
        return StrUtil.isNumeric(cs);
    }

    public static int countMatches(CharSequence str, CharSequence sub)
    {
        return StrUtil.count(str, sub);
    }

    public static String repeat(char ch, int repeat)
    {
        return StrUtil.repeat(ch, repeat);
    }

    public static String replaceEach(String text, String[] searchList, String[] replacementList)
    {
        if (text == null || text.isEmpty() || searchList == null || searchList.length == 0
                || replacementList == null || replacementList.length == 0)
        {
            return text;
        }
        int searchLength = searchList.length;
        int replacementLength = replacementList.length;
        boolean noMoreMatchesForReplacementIndex = false;
        int textIndex = 0;
        int replaceIndex = -1;
        int tempIndex = -1;
        for (int i = 0; i < searchLength; i++)
        {
            if (searchList[i] == null || searchList[i].isEmpty() || replacementList[i] == null)
            {
                continue;
            }
            tempIndex = text.indexOf(searchList[i]);
            if (tempIndex == -1)
            {
                continue;
            }
            if (replaceIndex == -1 || tempIndex < replaceIndex)
            {
                textIndex = i;
                replaceIndex = tempIndex;
                noMoreMatchesForReplacementIndex = false;
            }
        }
        if (replaceIndex == -1)
        {
            return text;
        }
        int start = 0;
        int increase = 0;
        for (int i = 0; i < searchList.length; i++)
        {
            if (searchList[i] == null)
            {
                continue;
            }
            int greater = replacementList[i].length() - searchList[i].length();
            if (greater > 0)
            {
                increase += 3 * greater;
            }
        }
        increase = Math.min(increase, text.length() / 5);
        StringBuilder buf = new StringBuilder(text.length() + increase);
        while (replaceIndex != -1)
        {
            while (start < replaceIndex)
            {
                buf.append(text.charAt(start));
                start++;
            }
            int idx = textIndex;
            buf.append(replacementList[idx]);
            start += searchList[idx].length();
            replaceIndex = -1;
            textIndex = -1;
            for (int i = 0; i < searchLength; i++)
            {
                if (searchList[i] == null || searchList[i].isEmpty() || replacementList[i] == null)
                {
                    continue;
                }
                tempIndex = text.indexOf(searchList[i], start);
                if (tempIndex == -1)
                {
                    continue;
                }
                if (replaceIndex == -1 || tempIndex < replaceIndex)
                {
                    textIndex = i;
                    replaceIndex = tempIndex;
                }
            }
        }
        buf.append(text.substring(start));
        return buf.toString();
    }

    public static String defaultString(String str)
    {
        return StrUtil.emptyToDefault(str, EMPTY);
    }

    public static String defaultIfEmpty(String str, String defaultStr)
    {
        return StrUtil.emptyToDefault(str, defaultStr);
    }

    // ==================== 自定义方法（保持原有 API） ====================

    /**
     * 获取参数不为空值
     */
    public static <T> T nvl(T value, T defaultValue)
    {
        return ObjectUtil.defaultIfNull(value, defaultValue);
    }

    /**
     * * 判断一个Collection是否为空， 包含List，Set，Queue
     */
    public static boolean isEmpty(Collection<?> coll)
    {
        return CollUtil.isEmpty(coll);
    }

    /**
     * * 判断一个Collection是否非空，包含List，Set，Queue
     */
    public static boolean isNotEmpty(Collection<?> coll)
    {
        return CollUtil.isNotEmpty(coll);
    }

    /**
     * * 判断一个对象数组是否为空
     */
    public static boolean isEmpty(Object[] objects)
    {
        return ArrayUtil.isEmpty(objects);
    }

    /**
     * * 判断一个对象数组是否非空
     */
    public static boolean isNotEmpty(Object[] objects)
    {
        return ArrayUtil.isNotEmpty(objects);
    }

    /**
     * * 判断一个Map是否为空
     */
    public static boolean isEmpty(Map<?, ?> map)
    {
        return MapUtil.isEmpty(map);
    }

    /**
     * * 判断一个Map是否为空
     */
    public static boolean isNotEmpty(Map<?, ?> map)
    {
        return MapUtil.isNotEmpty(map);
    }

    /**
     * * 判断一个字符串是否为空串<br>
     * 注意：与 commons-lang3 不同，此方法会将空白字符视为空
     */
    public static boolean isEmpty(String str)
    {
        return StrUtil.isEmpty(str);
    }

    /**
     * * 判断一个字符串是否为非空串
     */
    public static boolean isNotEmpty(String str)
    {
        return StrUtil.isNotEmpty(str);
    }

    /**
     * * 判断一个对象是否为空
     */
    public static boolean isNull(Object object)
    {
        return ObjectUtil.isNull(object);
    }

    /**
     * * 判断一个对象是否非空
     */
    public static boolean isNotNull(Object object)
    {
        return ObjectUtil.isNotNull(object);
    }

    /**
     * * 判断一个对象是否是数组类型（Java基本型别的数组）
     */
    public static boolean isArray(Object object)
    {
        return object != null && object.getClass().isArray();
    }

    /**
     * 去空格
     */
    public static String trim(String str)
    {
        return StrUtil.trim(str);
    }

    /**
     * 替换指定字符串的指定区间内字符为"*"
     */
    public static String hide(CharSequence str, int startInclude, int endExclude)
    {
        return StrUtil.hide(str, startInclude, endExclude);
    }

    /**
     * 截取字符串
     */
    public static String substring(final String str, int start)
    {
        if (str == null)
        {
            return NULLSTR;
        }
        if (start < 0)
        {
            start = str.length() + start;
        }
        if (start < 0)
        {
            start = 0;
        }
        if (start > str.length())
        {
            return NULLSTR;
        }
        return str.substring(start);
    }

    /**
     * 截取字符串
     */
    public static String substring(final String str, int start, int end)
    {
        if (str == null)
        {
            return NULLSTR;
        }
        if (end < 0)
        {
            end = str.length() + end;
        }
        if (start < 0)
        {
            start = str.length() + start;
        }
        if (end > str.length())
        {
            end = str.length();
        }
        if (start > end)
        {
            return NULLSTR;
        }
        if (start < 0)
        {
            start = 0;
        }
        if (end < 0)
        {
            end = 0;
        }
        return str.substring(start, end);
    }

    /**
     * 在字符串中查找第一个出现的 `open` 和最后一个出现的 `close` 之间的子字符串
     */
    public static String substringBetweenLast(final String str, final String open, final String close)
    {
        return StrUtil.subBetween(str, open, close);
    }

    /**
     * 判断是否为空，并且不是空白字符
     */
    public static boolean hasText(String str)
    {
        return StrUtil.isNotBlank(str);
    }

    /**
     * 格式化文本, {} 表示占位符
     */
    public static String format(String template, Object... params)
    {
        return StrUtil.format(template, params);
    }

    /**
     * 是否为http(s)://开头
     */
    public static boolean ishttp(String link)
    {
        return StrUtil.startWithAny(link, Constants.HTTP, Constants.HTTPS);
    }

    /**
     * 字符串转set
     */
    public static final Set<String> str2Set(String str, String sep)
    {
        return new HashSet<>(str2List(str, sep, true, false));
    }

    /**
     * 字符串转list
     */
    public static final List<String> str2List(String str, String sep)
    {
        return str2List(str, sep, true, false);
    }

    /**
     * 字符串转list
     */
    public static final List<String> str2List(String str, String sep, boolean filterBlank, boolean trim)
    {
        if (isEmpty(str))
        {
            return new ArrayList<>();
        }
        if (filterBlank && isBlank(str))
        {
            return new ArrayList<>();
        }
        String[] split = str.split(sep);
        List<String> list = new ArrayList<>();
        for (String string : split)
        {
            if (filterBlank && isBlank(string))
            {
                continue;
            }
            if (trim)
            {
                string = string.trim();
            }
            list.add(string);
        }
        return list;
    }

    /**
     * 判断给定的collection列表中是否包含数组array 判断给定的数组array中是否包含给定的元素value
     */
    public static boolean containsAny(Collection<String> collection, String... array)
    {
        return CollUtil.containsAny(collection, Arrays.asList(array));
    }

    /**
     * 查找指定字符串是否包含指定字符串列表中的任意一个字符串同时串忽略大小写
     */
    public static boolean containsAnyIgnoreCase(CharSequence cs, CharSequence... searchCharSequences)
    {
        return StrUtil.containsAnyIgnoreCase(cs, searchCharSequences);
    }

    /**
     * 驼峰转下划线命名
     */
    public static String toUnderScoreCase(String str)
    {
        return StrUtil.toUnderlineCase(str);
    }

    /**
     * 是否包含字符串
     */
    public static boolean inStringIgnoreCase(String str, String... strs)
    {
        return StrUtil.equalsAnyIgnoreCase(str, strs);
    }

    /**
     * 将下划线大写方式命名的字符串转换为驼峰式。如果转换前的下划线大写方式命名的字符串为空，则返回空字符串。 例如：HELLO_WORLD->HelloWorld
     */
    public static String convertToCamelCase(String name)
    {
        if (isEmpty(name))
        {
            return EMPTY;
        }
        if (!name.contains("_"))
        {
            return name.substring(0, 1).toUpperCase() + name.substring(1);
        }
        String[] camels = name.split("_");
        StringBuilder result = new StringBuilder();
        for (String camel : camels)
        {
            if (camel.isEmpty())
            {
                continue;
            }
            result.append(camel.substring(0, 1).toUpperCase());
            result.append(camel.substring(1).toLowerCase());
        }
        return result.toString();
    }

    /**
     * 驼峰式命名法 例如：user_name->userName
     */
    public static String toCamelCase(String s)
    {
        return StrUtil.toCamelCase(s);
    }

    /**
     * 查找指定字符串是否匹配指定字符串列表中的任意一个字符串
     */
    public static boolean matches(String str, List<String> strs)
    {
        if (isEmpty(str) || isEmpty(strs))
        {
            return false;
        }
        for (String pattern : strs)
        {
            if (isMatch(pattern, str))
            {
                return true;
            }
        }
        return false;
    }

    /**
     * 判断url是否与规则配置: 
     * ? 表示单个字符; 
     * * 表示一层路径内的任意字符串，不可跨层级; 
     * ** 表示任意层路径;
     */
    public static boolean isMatch(String pattern, String url)
    {
        AntPathMatcher matcher = new AntPathMatcher();
        return matcher.match(pattern, url);
    }

    @SuppressWarnings("unchecked")
    public static <T> T cast(Object obj)
    {
        return (T) obj;
    }

    /**
     * 数字左边补齐0，使之达到指定长度。注意，如果数字转换为字符串后，长度大于size，则只保留 最后size个字符。
     */
    public static final String padl(final Number num, final int size)
    {
        return padl(num.toString(), size, '0');
    }

    /**
     * 字符串左补齐。如果原始字符串s长度大于size，则只保留最后size个字符。
     */
    public static final String padl(final String s, final int size, final char c)
    {
        final StringBuilder sb = new StringBuilder(size);
        if (s != null)
        {
            final int len = s.length();
            if (s.length() <= size)
            {
                for (int i = size - len; i > 0; i--)
                {
                    sb.append(c);
                }
                sb.append(s);
            }
            else
            {
                return s.substring(len - size, len);
            }
        }
        else
        {
            for (int i = size; i > 0; i--)
            {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}
