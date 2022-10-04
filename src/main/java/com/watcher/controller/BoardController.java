package com.watcher.controller;

import com.watcher.param.StoryParam;
import com.watcher.service.BoardService;
import com.watcher.service.NoticeService;
import com.watcher.dto.CommDto;
import com.watcher.param.LoginParam;
import com.watcher.param.NoticeParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.Map;


@Controller
@RequestMapping(value="/")
public class BoardController {


	@Autowired
	NoticeService noticeService;

	@Autowired
	BoardService boardService;

	@RequestMapping(value={"/notice/member/list"})
	public ModelAndView showMemberNoticeListPage(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {

		ModelAndView mav = new ModelAndView("notice/list");
		mav.addObject("noticeListUrl", "/notice/listAsync?search_memId="+noticeParam.getSearch_memId());

		return mav;
	}


	@RequestMapping(value={"notice/list"})
	public ModelAndView showNoticeListPage(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {

		ModelAndView mav = new ModelAndView("notice/list");
		mav.addObject("noticeListUrl", "/notice/listAsync");

		return mav;
	}

	@RequestMapping(value={"notice/listAsync"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> getNoticeListAsync(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		result.putAll(noticeService.list(noticeParam));
		result.put("vo", noticeParam);

		return result;
	}


	@RequestMapping(value = {"/notice/delete"})
	@ResponseBody
	public LinkedHashMap<String, Object> deleteNotice(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody NoticeParam noticeParam

	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		noticeParam.setRegId(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID"));
		noticeParam.setDeleteYn("Y");

		result.putAll(noticeService.delete(noticeParam));

		return result;
	}


	@RequestMapping(value={"notice/view"}, method = RequestMethod.GET)
	public ModelAndView showNoticeViewPage(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {


		ModelAndView mav = new ModelAndView("notice/view");
		Map<String, Object> result = noticeService.view(noticeParam);

		// 게시물 수정권한 여부 s
		if( request.getSession().getAttribute("loginInfo") == null
				|| !(((Map)result.get("view")).get("REG_ID").equals(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID")))){
			result.put("modify_authority_yn","N");
		}else{
			result.put("modify_authority_yn","Y");
		}
		// 게시물 수정권한 여부 e


		mav.addObject("result", result);

		return mav;
	}

	@RequestMapping(value={"board/view/init"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap getBoardViewInitData(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String loginId = "";

		if( request.getSession().getAttribute("loginInfo") != null ){

			loginId = ((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID");

		}

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.view_like_yn_select(contentsType, contentsId, loginId));
		result.putAll(boardService.view_tags_select(contentsType, contentsId));

		result.put("loginYn","Y");
		if( loginId.isEmpty() ){
			result.put("loginYn","N");
		}


		return result;
	}


	@RequestMapping(value={"board/select/comment"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap getCommentList(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestParam Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));


		LinkedHashMap comment_select_param = new LinkedHashMap();

		comment_select_param.put("contentsType"	, contentsType  		);
		comment_select_param.put("contentsId"  	, contentsId    		);
		comment_select_param.put("pageNo"  		, commDto.getPageNo()    );
		comment_select_param.put("listNo"  		, commDto.getListNo()	);


		Map<String, Object> comment_obj = boardService.comment_select_info(comment_select_param);
		result.put("comment", comment_obj);

		commDto.setTotalCnt((int)comment_obj.get("cnt"));
		result.put("vo", commDto);

		return result;
	}


	@RequestMapping(value={"board/insert/comment"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap insertComment(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String loginId = "";
		String nickName = "";
		String profile = "";

		if( request.getSession().getAttribute("loginInfo") != null ){

			Map<String, String> userData = ((Map<String, String>)request.getSession().getAttribute("loginInfo"));

			loginId = userData.get("LOGIN_ID");
			nickName = userData.get("NICKNAME");
			profile = userData.get("MEM_PROFILE_IMG");

		}

		LinkedHashMap comment_param = new LinkedHashMap();

		comment_param.put("contentsType"	, param.get("contentsType") );
		comment_param.put("contentsId"  	, param.get("contentsId")   );
		comment_param.put("refContentsId"  	, param.get("refContentsId"));
		comment_param.put("coment"  		, param.get("coment")    	);
		comment_param.put("regId"  			, loginId					);
		comment_param.put("confirmId"  		, loginId    				);
		comment_param.put("nickName"  		, nickName					);
		comment_param.put("profile"  		, profile					);

		result.put("comment", boardService.comment_insert(comment_param));
		result.put("code","0000");

		return result;
	}

	@RequestMapping(value={"board/update/comment"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap updateComment(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();


		String loginId = "";

		if( request.getSession().getAttribute("loginInfo") != null ){
			loginId = ((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID");

		}

		LinkedHashMap comment_param = new LinkedHashMap();

		comment_param.put("commentId"  		, param.get("commentId"));
		comment_param.put("coment"  		, param.get("coment")   );
		comment_param.put("uptId"  			, loginId 				);

		result.put("comment", boardService.comment_update(comment_param));
		result.put("code"	,"0000"	);

		return result;
	}


	@RequestMapping(value={"board/delete/comment"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap deleteComment(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		LinkedHashMap comment_param = new LinkedHashMap();

		comment_param.put("commentId"  		, param.get("commentId"));
		comment_param.put("uptId"  			, param.get("regId"));

		result.put("comment", boardService.comment_delete(comment_param));
		result.put("code"	,"0000"	);

		return result;
	}



	@RequestMapping(value={"board/like/modify"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap modifyBoardLike(
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

			loginId = ((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID");

		}


		if( param.containsKey("likeId") && param.get("likeId") != null ){

			svc_param.put("likeId"	, param.get("likeId")	);
			svc_param.put("uptId"	, loginId				);

			boardService.like_update(svc_param);
		}else{

			svc_param.put("contentsType"	, param.get("contentsType")	);
			svc_param.put("contentsId"		, param.get("contentsId")	);
			svc_param.put("loginId"			, loginId					);
			svc_param.put("likeType"		, param.get("likeType")		);
			svc_param.put("regId"			, loginId					);

			boardService.like_insert(svc_param);
			result.putAll(svc_param);
		}

		return result;
	}




}