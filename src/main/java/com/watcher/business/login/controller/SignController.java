package com.watcher.business.login.controller;

import com.watcher.business.login.service.SignService;
import com.watcher.business.member.service.MemberService;
import com.watcher.business.login.param.SignParam;
import com.watcher.enums.ResponseCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping(value="/sign")
public class SignController {
	@Autowired
	SignService signService;

	@Autowired
	MemberService memberService;


	@RequestMapping(value = {"/session/data"}, method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getSession(
			HttpServletRequest request,
			HttpServletResponse response
	) throws Exception {
		Map<String,Object> result = new HashMap<>();
		String token = request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId = signService.getSessionId(token);

		Map<String, String> userData = signService.getSessionUser(sessionId);

		if ( userData != null ){
			result.put("loginId", userData.get("LOGIN_ID"));
			result.put("loginType", ("00".equals(userData.get("MEM_TYPE")) ? "naver" : "kakao"));
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

		Map<String,Object> result = new HashMap<>();
		String sessionId = request.getSession().getId();

		signService.handleIn(loginVo, sessionId);
		Map<String, String> userData = signService.getSessionUser(sessionId);

		if ( userData != null ){
			result.put("loginId", userData.get("LOGIN_ID"));
			result.put("loginType", ("00".equals(userData.get("MEM_TYPE")) ? "naver" : "kakao"));
			result.put("memberId", userData.get("ID"));
			result.put("memProfileImg", userData.get("MEM_PROFILE_IMG"));
			result.put("commentPermStatus", userData.get("COMMENT_PERM_STATUS"));
			result.put("storyRegPermStatus", userData.get("STORY_REG_PERM_STATUS"));
			result.put("storyCommentPublicStatus", userData.get("STORY_COMMENT_PUBLIC_STATUS"));
			result.put("storyTitle", userData.get("STORY_TITLE"));
			result.put("apiToken", userData.get("API_TOKEN"));
		}

		result.put("sessionId"	, sessionId								);
		result.put("code"		, ResponseCode.SUCCESS_0000.getCode()	);
		result.put("message"	, ResponseCode.SUCCESS_0000.getMessage());
		return result;
	}


	@RequestMapping(value = {"/out"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> signOut(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody SignParam loginVo
	) throws Exception {
		Map<String,Object> result = new HashMap<>();

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
