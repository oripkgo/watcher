package com.watcher.controller;

import com.sun.tracing.dtrace.Attributes;
import com.watcher.service.BoardService;
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
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value="/")
public class BoardController {


	@Autowired
	NoticeService noticeService;

	@Autowired
	BoardService boardService;
	
	@RequestMapping(value={"notice/list"})
	public ModelAndView noticeList(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeVo noticeVo
	) throws Exception {

		ModelAndView mav = new ModelAndView("notice/list");

		//mav.addObject("list",noticeService.list(noticeVo));

		return mav;
	}

	@RequestMapping(value={"notice/listAsync"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> noticeListAsync(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeVo noticeVo
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		result.putAll(noticeService.list(noticeVo));
		result.put("vo",noticeVo);

		return result;
	}



	@RequestMapping(value={"notice/view"}, method = RequestMethod.GET)
	public ModelAndView noticeView(
			HttpServletRequest request,
			HttpServletResponse response,
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

	@RequestMapping(value={"board/view/init"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap board_view_init(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String loginId = "";

		if( request.getSession().getAttribute("loginInfo") != null ){
			LoginVo loginVo = (LoginVo)request.getSession().getAttribute("loginInfo");

			loginId = loginVo.getId();

		}


		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.view_like_yn_select(contentsType, contentsId, loginId));
		result.putAll(boardService.view_tags_select(contentsType, contentsId));
		result.put("comment_list", boardService.comment_select(contentsType, contentsId));


		return result;
	}

	@RequestMapping(value={"board/like/modify"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap board_like_modify(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();
		LinkedHashMap<String, Object> svc_param = new LinkedHashMap<>();

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		String loginId = "";

		if( request.getSession().getAttribute("loginInfo") != null ){
			LoginVo loginVo = (LoginVo)request.getSession().getAttribute("loginInfo");

			loginId = loginVo.getId();

		}


		if( param.containsKey("likeId") && param.get("likeId") != null ){

			svc_param.put("likeId"	, param.get("likeId")	);
			svc_param.put("uptId"	, loginId				);

			boardService.like_update(svc_param);
		}else{

			svc_param.put("contentsType"	, param.get("contentsType")	);
			svc_param.put("contentsId"		, param.get("contentsId")	);
			svc_param.put("memberId"		, loginId					);
			svc_param.put("likeType"		, param.get("likeType")	);
			svc_param.put("regId"			, loginId					);

			boardService.like_insert(svc_param);

			if( svc_param.containsKey("like_id") ){
				result.put("like_id", svc_param.get("like_id"));
			}

		}

//		String loginId = "";
//
//		if( request.getSession().getAttribute("loginInfo") != null ){
//			LoginVo loginVo = (LoginVo)request.getSession().getAttribute("loginInfo");
//
//			loginId = loginVo.getId();
//
//		}
//
//
//		String contentsType = String.valueOf(param.get("contentsType"));
//		String contentsId = String.valueOf(param.get("contentsId"));
//
//		result.putAll(boardService.view_like_yn_select(contentsType, contentsId, loginId));
//		result.putAll(boardService.view_tags_select(contentsType, contentsId));
//		result.put("comment_list", boardService.comment_select(contentsType, contentsId));





		return result;
	}




}
