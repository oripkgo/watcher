package com.watcher.controller;

import com.fasterxml.jackson.databind.util.JSONPObject;
import com.watcher.service.LoginService;
import com.watcher.service.MainService;
import com.watcher.service.MemberService;
import com.watcher.util.HttpUtil;
import com.watcher.vo.LoginVo;
import com.watcher.vo.MemberVo;
import org.apache.tomcat.util.json.JSONParser;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Controller
@RequestMapping(value="/login")
public class LoginController {


	@Autowired
	LoginService loginService;


	@Autowired
	MemberService memberService;

	@RequestMapping(value={"loginSuccess"})
	public ModelAndView loginSuccess() throws Exception {

		ModelAndView mav = new ModelAndView("login/loginSuccess");


		return mav;
	}

	@RequestMapping(value = {"loginSuccessCallback"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> loginSuccessCallback(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody LoginVo loginVo

	) throws Exception {

		Map<String,String> result = new HashMap<String,String>();

		boolean userId_check = true;
		for(Cookie cookie : request.getCookies()){
			if( "userId".equals(cookie.getName()) ){
				userId_check = false;
				break;
			}
		}

		if( userId_check ){
			Cookie cookie = new Cookie("userId",loginVo.getId());
			response.addCookie(cookie);

			MemberVo memberVo = new MemberVo();

			memberVo.setMemId(loginVo.getId());
			memberVo.setMemType(( "naver".equals(loginVo.getType())?"00":"01" ));
			memberVo.setNickname(loginVo.getNickname());
			memberVo.setName(loginVo.getName());
			memberVo.setEmail(loginVo.getEmail());

			memberService.insertUpdate(memberVo);

		}

		result.putAll(loginService.loginSuccessCallback(request, loginVo));

		return result;
	}


	@RequestMapping(value = {"logOut"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> logOut(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody LoginVo loginVo

	) throws Exception {
		Map<String,String> result = new HashMap<String,String>();

		String logOutUrl = "";
		Map<String, String> logOutHeaders = new LinkedHashMap<String,String>();
		Map<String, String> logOutParam = new LinkedHashMap<String,String>();

		if( "naver".equals(loginVo.getType()) ){

			logOutUrl = "https://nid.naver.com/oauth2.0/token";

			logOutParam.put("grant_type"		,"delete");
			logOutParam.put("client_id"			,"ThouS3nsCEwGnhkMwI1I");
			logOutParam.put("client_secret"		,"nWJxzTmxwr");
			logOutParam.put("access_token"		,loginVo.getAccess_token());
			logOutParam.put("service_provider"	,"NAVER");


		}else{

			logOutUrl = "https://kapi.kakao.com/v1/user/unlink";

			logOutParam.put("target_id_type"	, "user_id");
			logOutParam.put("target_id"			, ((LoginVo)request.getSession().getAttribute("loginInfo")).getId());

			logOutHeaders.put("Authorization","KakaoAK 8266a4360fae60a41a106674a81dddeb");

		}


		HttpUtil.httpRequest(logOutUrl, logOutParam, logOutHeaders);
		request.getSession().removeAttribute("loginInfo");
		Cookie cookie = new Cookie("userId",null);
		cookie.setMaxAge(0);
		response.addCookie(cookie);
		result.put("code","0000");

		return result;
	}

	
}
