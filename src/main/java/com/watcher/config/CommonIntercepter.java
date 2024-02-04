package com.watcher.config;

import com.watcher.util.JwtTokenUtil;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;

@Component
public class CommonIntercepter implements HandlerInterceptor {
    private static List compareValues = Arrays.asList(new String[]{"application/json", "application/x-www-form-urlencoded"});
//    private static List<String> excludeUrls = Arrays.asList(new String[]{"/story/html/page/view"});

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        boolean checkValue = false;

        if(
            StringUtils.hasText(request.getHeader("Content-type")) &&
            compareValues.indexOf(request.getHeader("Content-type")) > -1
        ){
            checkValue = true;
        }

//        for( int i=0;i<excludeUrls.size();i++){
//            String url = excludeUrls.get(i);
//            if( request.getRequestURI().indexOf(url) > -1 ){
//                checkValue = false;
//                break;
//            }
//        }

        if( checkValue ){
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
