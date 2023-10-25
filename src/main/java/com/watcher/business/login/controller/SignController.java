package com.watcher.business.login.controller;

import com.watcher.business.login.service.SignService;
import com.watcher.business.member.dto.MemberDto;
import com.watcher.business.member.param.MemberParam;
import com.watcher.business.member.service.MemberService;
import com.watcher.util.HttpUtil;
import com.watcher.business.login.param.SignParam;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Controller
@RequestMapping(value="/sign")
public class SignController {
	@Autowired
	SignService signService;

	@Autowired
	MemberService memberService;

	@Value("${naver.client.id}")
	String naverClientId;

	@Value("${naver.client.secret}")
	String naverClientSecret;

	@RequestMapping(value = {"/in"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> getLoginSuccessData(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody SignParam loginVo
	) throws Exception {
		Map<String,String> result = new HashMap<String,String>();

		MemberParam memberParam = new MemberParam();

		memberParam.setLoginId(loginVo.getId());
		memberParam.setMemType(( "naver".equals(loginVo.getType())?"00":"01" ));
		memberParam.setNickname(loginVo.getNickname());
		memberParam.setName(loginVo.getName());
		memberParam.setEmail(loginVo.getEmail());
		memberParam.setGender(loginVo.getGender());
		memberParam.setMemProfileImg(loginVo.getProfile());

		Map<String,Object> userData = memberService.select(memberParam);

		if( userData == null || userData.size() == 0 ){
			Cookie cookie = new Cookie("userId", loginVo.getId());
			response.addCookie(cookie);

			memberService.insertUpdate(memberParam);
		}

		if ( !(loginVo.getId() == null || loginVo.getId().isEmpty())){
			String jwt = JwtTokenUtil.createJWT(request.getSession().getId());

			userData = memberService.select(memberParam);

			result.put("loginId", String.valueOf(userData.get("LOGIN_ID")));
			result.put("loginType", ("00".equals(userData.get("MEM_TYPE")) ? "naver" : "kakao"));
			result.put("memberId", String.valueOf(userData.get("ID")));
			result.put("memProfileImg", String.valueOf(userData.get("MEM_PROFILE_IMG")));
			result.put("commentPermStatus", String.valueOf(userData.get("COMMENT_PERM_STATUS")));
			result.put("storyRegPermStatus", String.valueOf(userData.get("STORY_REG_PERM_STATUS")));
			result.put("storyCommentPublicStatus", String.valueOf(userData.get("STORY_COMMENT_PUBLIC_STATUS")));
			result.put("storyTitle", String.valueOf(userData.get("STORY_TITLE")));
			result.put("apiToken", jwt);

			userData.put("apiToken", jwt);
			RedisUtil.setSession(request.getSession().getId(), userData);
		}

		result.put("sessionId", request.getSession().getId());
		result.put("code","0000");
		result.put("message", "OK");

		return result;
	}


	@RequestMapping(value = {"out"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> logOut(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody SignParam loginVo

	) throws Exception {
		Map<String,String> result = new HashMap<String,String>();

		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

		String logOutUrl = "";
		Map<String, String> logOutHeaders = new LinkedHashMap<String,String>();
		Map<String, String> logOutParam = new LinkedHashMap<String,String>();

		if( "naver".equals(loginVo.getType()) ){
			logOutUrl = "https://nid.naver.com/oauth2.0/token";

			logOutParam.put("grant_type"		,"delete");
			logOutParam.put("client_id"			,naverClientId);
			logOutParam.put("client_secret"		,naverClientSecret);
			logOutParam.put("access_token"		,loginVo.getAccess_token());
			logOutParam.put("service_provider"	,"NAVER");
		}else{
			logOutUrl = "https://kapi.kakao.com/v1/user/unlink";

			logOutParam.put("target_id_type"	, "user_id");
			logOutParam.put("target_id"			, RedisUtil.getSession(sessionId).get("LOGIN_ID"));

			logOutHeaders.put("Authorization","KakaoAK 8266a4360fae60a41a106674a81dddeb");
		}

		HttpUtil.httpRequest(logOutUrl, logOutParam, logOutHeaders);

		RedisUtil.remove(sessionId);
		Cookie cookie = new Cookie("userId",null);
		cookie.setMaxAge(0);
		response.addCookie(cookie);
		result.put("code","0000");

		return result;
	}
}
