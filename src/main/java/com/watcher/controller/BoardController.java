package com.watcher.controller;

import com.watcher.service.MainService;
import com.watcher.vo.LoginVo;
import com.watcher.vo.NoticeVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping(value="/")
public class BoardController {


	
	@RequestMapping(value={"notice/list"})
	public ModelAndView noticeList(
			HttpServletRequest request,
			NoticeVo noticeVo
	) throws Exception {

		ModelAndView mav = new ModelAndView("notice/list");

		return mav;
	}

	@RequestMapping(value={"notice/listAsync"})
	public Map<String,String> noticeListAsync(
			HttpServletRequest request,
			@RequestBody NoticeVo noticeVo
	) throws Exception {

		Map<String,String> result = new HashMap<String,String>();

		//result.putAll(loginService.loginSuccessCallback(request, loginVo));

		return result;
	}


}
