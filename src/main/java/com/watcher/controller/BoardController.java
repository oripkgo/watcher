package com.watcher.controller;

import com.sun.tracing.dtrace.Attributes;
import com.watcher.service.MainService;
import com.watcher.service.NoticeService;
import com.watcher.vo.LoginVo;
import com.watcher.vo.NoticeVo;
import org.json.JSONObject;
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


	@Autowired
	NoticeService noticeService;
	
	@RequestMapping(value={"notice/list"})
	public ModelAndView noticeList(
			HttpServletRequest request,
			@ModelAttribute("vo") NoticeVo noticeVo
	) throws Exception {

		ModelAndView mav = new ModelAndView("notice/list");


		//mav.addObject("list",noticeService.list(noticeVo));

		return mav;
	}

	@RequestMapping(value={"notice/listAsync"},method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> noticeListAsync(
			HttpServletRequest request,
			@ModelAttribute("vo") NoticeVo noticeVo
	) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		result.putAll(noticeService.list(noticeVo));
		result.put("vo",noticeVo);

		return result;
	}



	@RequestMapping(value={"notice/view"}, method = RequestMethod.GET)
	public ModelAndView noticeView(
			HttpServletRequest request,
			@ModelAttribute("vo") NoticeVo noticeVo
	) throws Exception {

		ModelAndView mav = new ModelAndView("notice/view");

		Map<String, Object> result = noticeService.view(noticeVo);


		// 게시물 수정권한 여부 s
		result.put("modify_authority_yn","N");
		// 게시물 수정권한 여부 e


		mav.addObject("result", result);




		return mav;
	}


}
