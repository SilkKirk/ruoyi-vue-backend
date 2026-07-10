package com.ruoyi.common.exception;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public final class ServiceException extends RuntimeException
{
    private static final long serialVersionUID = 1L;

    private Integer code;

    private String message;

    private String detailMessage;

    public ServiceException()
    {
    }

    public ServiceException(String message)
    {
        this.message = message;
    }

    public ServiceException(String message, Integer code)
    {
        this.message = message;
        this.code = code;
    }

}
