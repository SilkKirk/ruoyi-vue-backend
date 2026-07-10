package com.ruoyi.common.utils;

import java.util.ArrayList;
import java.util.List;
import org.springframework.util.AntPathMatcher;

public class StringUtils
{
    public static final String EMPTY = "";

    public static final int INDEX_NOT_FOUND = -1;

    private static final String NULLSTR = "";

    private static final char SEPARATOR = '_';

    private static final char ASTERISK = '*';

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

    public static boolean matches(String str, List<String> strs)
    {
        if (str == null || str.isEmpty() || strs == null || strs.isEmpty())
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

    public static boolean isMatch(String pattern, String url)
    {
        AntPathMatcher matcher = new AntPathMatcher();
        return matcher.match(pattern, url);
    }

    public static final List<String> str2List(String str, String sep)
    {
        return str2List(str, sep, true, false);
    }

    public static final List<String> str2List(String str, String sep, boolean filterBlank, boolean trim)
    {
        if (str == null || str.isEmpty())
        {
            return new ArrayList<>();
        }
        String[] split = str.split(sep);
        List<String> list = new ArrayList<>();
        for (String string : split)
        {
            if (filterBlank && string.isBlank())
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

    public static final java.util.Set<String> str2Set(String str, String sep)
    {
        return new java.util.HashSet<>(str2List(str, sep, true, false));
    }

    @SuppressWarnings("unchecked")
    public static <T> T cast(Object obj)
    {
        return (T) obj;
    }

    public static final String padl(final Number num, final int size)
    {
        return padl(num.toString(), size, '0');
    }

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