package com.watcher.util;

import com.watcher.enums.ResponseCode;
import lombok.extern.log4j.Log4j2;

@Log4j2
public class ErrorResponse {

    private int status;
    private String message;
    private String code;

    public ErrorResponse(ResponseCode responseCode){
        this.status = responseCode.getStatus();
        this.message = responseCode.getMessage();
        this.code = responseCode.getCode();

        log.debug(this.toString());
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
        StringBuffer sbuf = new StringBuffer();

        sbuf.append("ErrorResponse{status=");
        sbuf.append(status);
        sbuf.append(", message='");
        sbuf.append(message);
        sbuf.append("'");
        sbuf.append(", code='");
        sbuf.append(code);
        sbuf.append("'}");

        return sbuf.toString();
    }
}
