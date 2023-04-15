package com.watcher.config;

import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class CommonIntercepter implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = (String)request.getSession().getAttribute("apiToken");

        if( StringUtils.hasText(token) ){
            // 클라이언트에서 보낸 토큰과 서버 세션에 저장된 토큰이 일치한지 검증
            if(
                    StringUtils.hasText(request.getHeader("Content-type")) &&
                            "application/json".equals(request.getHeader("Content-type"))
            ){
                String authorization = request.getHeader("Authorization").replace("Bearer ", "");

                if( !token.equals(authorization) ){
                    throw new SignatureException("api 토큰검증 실패");
                }
            }
        }

        return HandlerInterceptor.super.preHandle(request, response, handler);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        // redis 세션 저장
        request.setAttribute("loginInfo", RedisUtil.getSession(request.getSession().getId()));

        if( !StringUtils.hasText((String)request.getSession().getAttribute("apiToken")) ){
            request.getSession().setAttribute("apiToken",JwtTokenUtil.createJWT(request.getSession().getId()));
        }


        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }
}
