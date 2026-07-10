package com.ruoyi.common.utils.http;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletRequest;
import cn.hutool.core.io.IoUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * 通用http工具封装
 * 
 * @author ruoyi
 */
@Slf4j
public class HttpHelper
{

    public static String getBodyString(ServletRequest request)
    {
        try (InputStream inputStream = request.getInputStream())
        {
            return IoUtil.read(inputStream, StandardCharsets.UTF_8);
        }
        catch (IOException e)
        {
            log.warn("getBodyString出现问题！");
            return "";
        }
    }
}
