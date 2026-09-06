package com.watcher.common;

import com.watcher.util.CookieUtil;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.SessionUtil;
import io.jsonwebtoken.security.SignatureException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
@Log4j2
public class CommonIntercepter implements HandlerInterceptor {

  @Autowired
  private SessionUtil sessionUtil;

  // 제네릭 타입 명시 (List<String>)
  private static final List<String> compareValuesContentType = Arrays.asList(
      "application/json",
      "application/x-www-form-urlencoded"
  );

  private static final List<String> compareValuesURL = Arrays.asList(
      "/my-story",
      "/story/write",
      "/management"
  );

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws Exception {

    // 1. 진입 URL 및 HTTP Method 디버그 로그 출력
    if (log.isDebugEnabled()) {
      log.debug("[Interceptor Check] [{}] {}", request.getMethod(), request.getRequestURI());
    }

    // 2. 쿠키 및 세션 Null Safe 체크
    String sessionCookie = CookieUtil.getValue("SESSION_TOKEN");
    if (StringUtils.hasText(sessionCookie)) {
      String sessionId = JwtTokenUtil.getId(sessionCookie);
      if (StringUtils.hasText(sessionId)) {
        Map<String, String> result = sessionUtil.getSession(sessionId);
        if (result == null || result.isEmpty()) {
          request.setAttribute("sessionExceededYn", "Y");
        }
      } else {
        request.setAttribute("sessionExceededYn", "Y");
      }
    } else {
      // 쿠키가 없어도 NPE 없이 속성 설정 후 안전하게 통과
      request.setAttribute("sessionExceededYn", "Y");
    }

    // 3. Content-type 및 Authorization 헤더 Null Safe 체크
    String contentType = request.getHeader("Content-type");
    if (StringUtils.hasText(contentType) && compareValuesContentType.contains(contentType)) {
      String authHeader = request.getHeader("Authorization");

      // Authorization 헤더가 존재하는 경우에만 토큰 검증 실행
      if (StringUtils.hasText(authHeader)) {
        String authorization = authHeader.replace("Bearer ", "");
        if (!JwtTokenUtil.verifyToken(authorization)) {
          throw new SignatureException("api 토큰검증 실패");
        }
      } else {
        // 헤더가 없는 비인증 요청 시 명확한 예외 처리
        throw new SignatureException("Authorization 헤더가 존재하지 않습니다.");
      }
    }

    return true;
  }

  @Override
  public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
      ModelAndView modelAndView) throws Exception {
    // 필요 시 비워두거나 구현, default 메서드이므로 super 호출 생략 가능
  }

  @Override
  public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
      Object handler, Exception ex) throws Exception {
    // 필요 시 비워두거나 구현, default 메서드이므로 super 호출 생략 가능
  }
}