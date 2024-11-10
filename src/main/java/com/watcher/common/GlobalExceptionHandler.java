package com.watcher.common;

import com.watcher.enums.ResponseCode;
import com.watcher.util.ErrorResponse;
import io.jsonwebtoken.security.SignatureException;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Log4j2
public class GlobalExceptionHandler {

    @ExceptionHandler(SignatureException.class)
    public ResponseEntity<ErrorResponse> handleSignatureException(Exception ex){
        log.error("SignatureException",ex);

        ErrorResponse response = new ErrorResponse(ResponseCode.ERROR_2001);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception ex){
        log.error("Exception",ex);

        ErrorResponse response;

        try{
            response = new ErrorResponse(ResponseCode.valueOf("ERROR_"+ex.getMessage()));
        }catch (IllegalArgumentException ex2){
            response = new ErrorResponse(ResponseCode.valueOf("ERROR_9999"));
        }

        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }
}
