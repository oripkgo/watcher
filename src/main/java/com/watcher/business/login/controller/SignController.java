package com.watcher.business.login.controller;

import com.watcher.business.login.service.SignService;
import com.watcher.business.member.service.MemberService;
import com.watcher.business.login.param.SignParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
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

		result.put("sessionId", sessionId);
		result.put("code","0000");
		result.put("message", "OK");

		return result;
	}


	@RequestMapping(value = {"out"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> signOut(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody SignParam loginVo
	) throws Exception {
		signService.validation(loginVo);

		Map<String,Object> result = new HashMap<>();

		String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

		signService.handleOut(loginVo, sessionId);

		result.put("code","0000");
		result.put("message", "OK");

		return result;
	}
}
