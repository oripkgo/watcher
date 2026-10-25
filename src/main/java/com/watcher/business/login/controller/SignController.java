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
    signService.validation(loginVo);

    // 1. 로그인 유지 여부에 따른 세션 유효 시간 설정 (체크 시 30일, 아닐 경우 기본 SESSION_TIME)
    Boolean keepLogin = loginVo.getKeepLogin();
    boolean isKeep = (keepLogin != null && keepLogin);
    int dynamicSessionTime = isKeep ? (30 * 24 * 60 * 60) : SESSION_TIME;

    Map<String, Object> result = new HashMap<>();
    String sessionId = request.getSession().getId();
    String apiToken = JwtTokenUtil.createJWT(sessionId,dynamicSessionTime * 1000L);


    Map<String, Object> userData = signService.handleIn(loginVo, sessionId);

    // 2. 고정된 SESSION_TIME 대신 동적으로 계산된 dynamicSessionTime 적용
    sessionUtil.setSession(sessionId, userData, dynamicSessionTime);
    CookieUtil.addCookie("SESSION_TOKEN", apiToken, dynamicSessionTime);

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

    // 3. 프론트엔드로 실제 적용된 유효 시간 전달
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
      @RequestBody SignParam loginVo
  ) throws Exception {
    Map<String, Object> result = new HashMap<>();

    String token = request.getHeader("Authorization").replace("Bearer ", "");
    String sessionId = signService.getSessionId(token);

    signService.validation(loginVo);
    signService.handleOut(loginVo, sessionId);

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
