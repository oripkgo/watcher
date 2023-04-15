package com.watcher.util;

import com.watcher.enums.ErrorCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ErrorResponse {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private int status;
    private String message;
    private String code;

    public ErrorResponse(ErrorCode errorCode){
        this.status = errorCode.getStatus();
        this.message = errorCode.getMessage();
        this.code = errorCode.getErrorCode();

        logger.debug(this.toString());
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public String toString() {
        return "ErrorResponse{" +
                "status=" + status +
                ", message='" + message + '\'' +
                ", code='" + code + '\'' +
                '}';
    }
}
