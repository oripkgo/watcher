package com.watcher.business.login.controller;

import com.watcher.business.login.param.SignParam;
import com.watcher.business.login.service.SignService;
import com.watcher.business.member.service.MemberService;
import com.watcher.enums.MemberType;
import com.watcher.enums.ResponseCode;
import com.watcher.util.CookieUtil;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.SessionUtil;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping(value = "/sign")
@Log4j2
public class SignController {

  @Autowired
  private SignService signService;

  @Autowired
  private MemberService memberService;

  @Autowired
  private SessionUtil sessionUtil;

  @Value("${spring.session.timeout}")
  private int SESSION_TIME;

  @RequestMapping(value = {"/session/data"}, method = RequestMethod.GET)
  @ResponseBody
  public Map<String, Object> getSession(
      HttpServletRequest request,
      HttpServletResponse response
  ) throws Exception {
    Map<String, Object> result = new HashMap<>();
    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String sessionId = signService.getSessionId(token);

    Map<String, String> userData = signService.getSessionUser(sessionId);

    if (userData != null) {
      result.put("loginId", userData.get("LOGIN_ID"));
      result.put("loginType", MemberType.fromCode(userData.get("MEM_TYPE")).getName());
      result.put("memberId", userData.get("ID"));
      result.put("memProfileImg", userData.get("MEM_PROFILE_IMG"));
      result.put("commentPermStatus", userData.get("COMMENT_PERM_STATUS"));
      result.put("storyRegPermStatus", userData.get("STORY_REG_PERM_STATUS"));
      result.put("storyCommentPublicStatus", userData.get("STORY_COMMENT_PUBLIC_STATUS"));
      result.put("storyTitle", userData.get("STORY_TITLE"));
      result.put("apiToken", userData.get("API_TOKEN"));
    }

    result.put("sessionId", sessionId);
    result.put("code", ResponseCode.SUCCESS_0000.getCode());
    result.put("message", ResponseCode.SUCCESS_0000.getMessage());

    return result;
  }


  @RequestMapping(value = {"/in"}, method = RequestMethod.POST)
  @ResponseBody
  public Map<String, Object> signIn(
      HttpServletRequest request,
      HttpServletResponse response,
      @RequestBody SignParam loginVo
  ) throws Exception {
    // 1. 유효성 검증
    signService.validation(loginVo);

    // 2. 로그인 유지 여부에 따른 세션 유효 시간 설정 (체크 시 30일, 아닐 경우 설정 시간 적용)
    Boolean keepLogin = loginVo.getKeepLogin();
    boolean isKeep = (keepLogin != null && keepLogin);
    int dynamicSessionTime = isKeep ? (30 * 24 * 60 * 60) : SESSION_TIME;
//    int dynamicSessionTime = 3 * 60;

    // 3. 세션 ID 확보 및 로그인 처리
    String sessionId = request.getSession().getId();
    Map<String, Object> userData = signService.handleIn(loginVo, sessionId);

    // 4. JWT 토큰 생성 (Claims 데이터 포함)
    Map<String, Object> claims = new HashMap<>();
    if (userData != null) {
      claims.put("memberId", userData.get("ID"));
      claims.put("loginId", userData.get("LOGIN_ID"));
    }
    String apiToken = JwtTokenUtil.createJWT(sessionId, dynamicSessionTime * 1000L, claims);

    // 5. 서버 세션 및 쿠키 등록
    sessionUtil.setSession(sessionId, userData, dynamicSessionTime);
    CookieUtil.addCookie("SESSION_TOKEN", apiToken, dynamicSessionTime);

    // 6. 결과 응답 데이터 구성
    Map<String, Object> result = new HashMap<>();
    if (userData != null) {
      String memberType = MemberType.fromCode(userData.get("MEM_TYPE").toString()).getName();

      result.put("loginId", userData.get("LOGIN_ID"));
      result.put("loginType", memberType);
      result.put("memberId", userData.get("ID"));
      result.put("memProfileImg", userData.get("MEM_PROFILE_IMG"));
      result.put("commentPermStatus", userData.get("COMMENT_PERM_STATUS"));
      result.put("storyRegPermStatus", userData.get("STORY_REG_PERM_STATUS"));
      result.put("storyCommentPublicStatus", userData.get("STORY_COMMENT_PUBLIC_STATUS"));
      result.put("storyTitle", userData.get("STORY_TITLE"));
      result.put("apiToken", apiToken);
    }

    result.put("dynamicSessionTime", dynamicSessionTime);
    result.put("sessionId", sessionId);
    result.put("code", ResponseCode.SUCCESS_0000.getCode());
    result.put("message", ResponseCode.SUCCESS_0000.getMessage());

    return result;
  }


  @RequestMapping(value = {"/out"}, method = RequestMethod.POST)
  @ResponseBody
  public Map<String, Object> signOut(
      HttpServletRequest request,
      HttpServletResponse response,
      @RequestBody(required = false) SignParam loginVo
  ) throws Exception {

    // 1. Authorization 헤더 검증 및 토큰 추출 (NPE 방지)
    String authHeader = request.getHeader("Authorization");
    String sessionId = null;

    if (authHeader != null && authHeader.startsWith("Bearer ")) {
      String token = authHeader.substring(7); // "Bearer " 이후의 토큰 추출
      sessionId = signService.getSessionId(token);
    }

    // 2. 유효성 검증 및 로그아웃 비즈니스 로직 처리
    if (loginVo != null) {
      signService.validation(loginVo);
      try {
        signService.handleOut(loginVo, sessionId);
      } catch (Exception e) {
        // 예외를 삼키지 않고 로그를 남겨 추후 원인 파악 가능하도록 개선
        log.warn("Failed to process handleOut during sign out: {}", e.getMessage(), e);
      }
    }

    // 3. 세션 및 쿠키 정리
    if (sessionId != null) {
      sessionUtil.set(sessionId, null);
    }
    CookieUtil.deleteCookie("SESSION_TOKEN");

    // 4. 성공 응답 반환
    Map<String, Object> result = new HashMap<>();
    result.put("code", ResponseCode.SUCCESS_0000.getCode());
    result.put("message", ResponseCode.SUCCESS_0000.getMessage());

    return result;
  }


  @RequestMapping(value = {"/naver/success"}, method = RequestMethod.GET)
  public ModelAndView signSuccess(
      HttpServletRequest request,
      HttpServletResponse response,
      @RequestParam Map<String, String> param
  ) throws Exception {
    ModelAndView mav = new ModelAndView("sign/naverSuccess");
    return mav;
  }

}
