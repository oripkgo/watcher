package com.watcher.common;

import com.watcher.util.CookieUtil;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.SessionUtil;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Component
public class CommonIntercepter implements HandlerInterceptor {

    @Autowired
    private SessionUtil sessionUtil;

    private static List compareValuesContentType = Arrays.asList(new String[]{
            "application/json",
            "application/x-www-form-urlencoded"
    });

    private static List compareValuesURL = Arrays.asList(new String[]{
            "/my-story",
            "/story/write",
            "/management"
    });

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // URL 체크
//        for(Object url : compareValuesURL){
//            if( url != null ){
//                if( request.getRequestURI().indexOf(String.valueOf(url)) == 0){
//                    String sessionId = JwtTokenUtil.getId(CookieUtil.getValue("SESSION_TOKEN"));
//
//                    Map result = redisUtil.getSession(sessionId);
//                    if( result == null || result.isEmpty() ){
//                        request.setAttribute("sessionExceededYn","Y");
//                    }
//                }
//            }
//        }

        // 세션유지 유무 체크
        String sessionId = JwtTokenUtil.getId(CookieUtil.getValue("SESSION_TOKEN"));

        Map result = sessionUtil.getSession(sessionId);
        if( result == null || result.isEmpty() ){
            request.setAttribute("sessionExceededYn","Y");
        }


        // Content-type 체크
        if(
            StringUtils.hasText(request.getHeader("Content-type")) &&
            compareValuesContentType.indexOf(request.getHeader("Content-type")) > -1
        ){
            String authorization = request.getHeader("Authorization").replace("Bearer ", "");

            if( !JwtTokenUtil.verifyToken(authorization) ){
                throw new SignatureException("api 토큰검증 실패");
            }
        }

        return HandlerInterceptor.super.preHandle(request, response, handler);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }
}
