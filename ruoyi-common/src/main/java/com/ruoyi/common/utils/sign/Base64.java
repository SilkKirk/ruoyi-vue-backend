package com.ruoyi.common.utils.sign;

/**
 * Base64工具类（委托 Hutool 实现）
 * 
 * @author ruoyi
 */
public final class Base64
{
    /**
     * 编码
     */
    public static String encode(byte[] binaryData)
    {
        return cn.hutool.core.codec.Base64.encode(binaryData);
    }

    /**
     * 解码
     */
    public static byte[] decode(String encoded)
    {
        return cn.hutool.core.codec.Base64.decode(encoded);
    }
}
