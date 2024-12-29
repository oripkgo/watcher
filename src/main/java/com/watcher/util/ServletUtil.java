package com.watcher.util;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ServletUtil {

    /**
     * 현재 요청의 HttpServletResponse 반환
     *
     * @return HttpServletResponse 객체
     */
    public static HttpServletResponse getCurrentResponse() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            throw new IllegalStateException("No request attributes found. Is this being called outside of a web request?");
        }
        return attributes.getResponse();
    }

    /**
     * 현재 요청의 HttpServletRequest 반환
     *
     * @return HttpServletRequest 객체
     */
    public static HttpServletRequest getCurrentRequest() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            throw new IllegalStateException("No request attributes found. Is this being called outside of a web request?");
        }
        return attributes.getRequest();
    }

}
