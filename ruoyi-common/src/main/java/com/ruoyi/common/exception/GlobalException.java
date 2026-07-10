package com.ruoyi.common.exception;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class GlobalException extends RuntimeException
{
    private static final long serialVersionUID = 1L;

    private String message;

    private String detailMessage;

    public GlobalException()
    {
    }

    public GlobalException(String message)
    {
        this.message = message;
    }

}
