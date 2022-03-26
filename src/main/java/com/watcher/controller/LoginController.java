package com.watcher.controller;

import com.fasterxml.jackson.databind.util.JSONPObject;
import com.watcher.service.LoginService;
import com.watcher.service.MainService;
import com.watcher.util.HttpUtil;
import com.watcher.vo.LoginVo;
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

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping(value="/login")
public class LoginController {


	@Autowired
	LoginService loginService;

	@RequestMapping(value={"loginSuccess"})
	public ModelAndView loginSuccess() throws Exception {

		ModelAndView mav = new ModelAndView("login/loginSuccess");


		return mav;
	}

	@RequestMapping(value = {"loginSuccessCallback"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> loginSuccessCallback(
			HttpServletRequest request,
			@RequestBody LoginVo loginVo

	) throws Exception {

		Map<String,String> result = new HashMap<String,String>();

		result.putAll(loginService.loginSuccessCallback(request, loginVo));

		return result;
	}


	@RequestMapping(value = {"logOut"}, method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> logOut(
			HttpServletRequest request,
			@RequestBody LoginVo loginVo

	) throws Exception {
		Map<String,String> result = new HashMap<String,String>();
		request.getSession().removeAttribute("loginInfo");


		//HttpUtil.httpRequest("https://nid.naver.com/nidlogin.logout","");
		result.put("code","0000");

		return result;
	}

	
}
