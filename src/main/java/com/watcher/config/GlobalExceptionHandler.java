package com.watcher.config;

import com.watcher.enums.ErrorCode;
import com.watcher.util.ErrorResponse;
import io.jsonwebtoken.security.SignatureException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @ExceptionHandler(SignatureException.class)
    public ResponseEntity<ErrorResponse> handleException(Exception ex){
        logger.error("SignatureException",ex);

        ErrorResponse response = new ErrorResponse(ErrorCode.ERROR_2001);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }
}
