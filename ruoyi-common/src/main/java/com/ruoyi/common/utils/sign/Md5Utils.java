package com.ruoyi.common.utils.sign;

import cn.hutool.crypto.digest.DigestUtil;

/**
 * Md5加密方法（委托 Hutool DigestUtil）
 * 
 * @author ruoyi
 */
public class Md5Utils
{
    /**
     * 计算 MD5 哈希值（返回 32 位小写十六进制字符串）
     */
    public static String hash(String s)
    {
        return DigestUtil.md5Hex(s);
    }
}
