package com.ruoyi.common.utils.http;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import com.ruoyi.common.constant.Constants;
import cn.hutool.core.util.StrUtil;

/**
 * 通用http发送方法
 * 
 * @author ruoyi
 */
public class HttpUtils
{
    private static final Logger log = LoggerFactory.getLogger(HttpUtils.class);

    /**
     * 向指定 URL 发送GET方法的请求
     *
     * @param url 发送请求的 URL
     * @return 所代表远程资源的响应结果
     */
    public static String sendGet(String url)
    {
        return sendGet(url, StrUtil.EMPTY);
    }

    /**
     * 向指定 URL 发送GET方法的请求
     *
     * @param url 发送请求的 URL
     * @param param 请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
     */
    public static String sendGet(String url, String param)
    {
        return sendGet(url, param, Constants.UTF8);
    }

    /**
     * 向指定 URL 发送GET方法的请求
     *
     * @param url 发送请求的 URL
     * @param param 请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @param contentType 编码类型
     * @return 所代表远程资源的响应结果
     */
    public static String sendGet(String url, String param, String contentType)
    {
        String urlNameString = StrUtil.isNotBlank(param) ? url + "?" + param : url;
        try
        {
            log.info("sendGet - {}", urlNameString);
            String result = HttpRequest.get(urlNameString)
                    .charset(contentType)
                    .execute()
                    .body();
            log.info("recv - {}", result);
            return result;
        }
        catch (Exception e)
        {
            log.error("调用HttpUtils.sendGet Exception, url=" + url + ",param=" + param, e);
        }
        return "";
    }

    /**
     * 向指定 URL 发送POST方法的请求
     *
     * @param url 发送请求的 URL
     * @param param 请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
     */
    public static String sendPost(String url, String param)
    {
        return sendPost(url, param, MediaType.APPLICATION_FORM_URLENCODED_VALUE);
    }

    /**
     * 向指定 URL 发送POST方法的请求
     * 
     * @param url 发送请求的 URL
     * @param param 请求参数
     * @param contentType 内容类型
     * @return 所代表远程资源的响应结果
     */
    public static String sendPost(String url, String param, String contentType)
    {
        try
        {
            log.info("sendPost - {}", url);
            String result = HttpRequest.post(url)
                    .contentType(contentType)
                    .body(param)
                    .execute()
                    .body();
            log.info("recv - {}", result);
            return result;
        }
        catch (Exception e)
        {
            log.error("调用HttpUtils.sendPost Exception, url=" + url + ",param=" + param, e);
        }
        return "";
    }

    public static String sendSSLPost(String url, String param)
    {
        return sendSSLPost(url, param, MediaType.APPLICATION_FORM_URLENCODED_VALUE);
    }

    public static String sendSSLPost(String url, String param, String contentType)
    {
        String urlNameString = url + "?" + param;
        try
        {
            log.info("sendSSLPost - {}", urlNameString);
            String result = HttpRequest.post(urlNameString)
                    .setSSLProtocol("SSL")
                    .contentType(contentType)
                    .execute()
                    .body();
            log.info("recv - {}", result);
            return result;
        }
        catch (Exception e)
        {
            log.error("调用HttpUtils.sendSSLPost Exception, url=" + url + ",param=" + param, e);
        }
        return "";
    }
}
