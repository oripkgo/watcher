package com.watcher.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.watcher.service.BoardService;
import com.watcher.service.NoticeService;
import com.watcher.dto.CommDto;
import com.watcher.param.NoticeParam;

import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
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

	@RequestMapping(value = {"/{memId}/notice/list"})
	@ResponseBody
	public LinkedHashMap<String, Object> showMemberNoticeListPage(
			@PathVariable("memId") String memId,
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		noticeParam.setSearch_memId(memId);
		result.put("vo", noticeParam);
		result.put("noticeListUrl", "/notice/list/data?search_memId=" + memId);
		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}

	@RequestMapping(value={"/notice/list"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> showNoticeListPage(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();
		result.put("noticeListUrl", "/notice/list/data");
		result.put("vo", new ObjectMapper().convertValue(noticeParam, Map.class));

		result.put("code","0000");
		result.put("message", "OK");

		return result;
	}

	@RequestMapping(value={"/notice/list/data"}, method = RequestMethod.GET)
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

		Object loginId = (RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID"));
		noticeParam.setRegId(String.valueOf(loginId));
		noticeParam.setUptId(String.valueOf(loginId));

		result.putAll(noticeService.delete(noticeParam));

		return result;
	}

	@RequestMapping(value = {"/notice/view",}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> noticeView(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		return noticeView(null, request, response, noticeParam);
	}

	@RequestMapping(value={"/{memId}/notice/view"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> noticeView(
			@PathVariable("memId") String memId,
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<String, Object>();

		Map<String, Object> noticeInfo = noticeService.view(noticeParam);

		// 게시물 수정권한 여부 s
		if( RedisUtil.getSession(request.getSession().getId()) == null
				|| !(((Map)noticeInfo.get("view")).get("REG_ID").equals(RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID")))){
			noticeInfo.put("modify_authority_yn","N");
		}else{
			noticeInfo.put("modify_authority_yn","Y");
		}
		// 게시물 수정권한 여부 e

		result.putAll(noticeInfo);

		return result;
	}

	@RequestMapping(value = {"/notice/write","/notice/update"})
	public ModelAndView showNoticeEditPage(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/write");

		LinkedHashMap param = new LinkedHashMap();

		param.put("showYn"  	,"Y");
		param.put("loginId"   	,RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID"));

		if( !(noticeParam.getId() == null || noticeParam.getId().isEmpty()) ){
			mav.addAllObjects(noticeService.view(noticeParam));
		}

		return mav;
	}

	@RequestMapping(value = {"/notice/insert"})
	@ResponseBody
	public LinkedHashMap<String, Object> insertStory(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {

		LinkedHashMap<String, Object> result = new LinkedHashMap<>();


		Object loginId = RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID");

		noticeParam.setRegId(String.valueOf(loginId));
		noticeParam.setUptId(String.valueOf(loginId));

		result.putAll(noticeService.insert(noticeParam));

		return result;
	}

	@RequestMapping(value={"/board/view/init"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap getBoardViewInitData(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";

		if( RedisUtil.getSession(sessionId) != null ){
			loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
		}

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.view_like_yn_select(contentsType, contentsId, loginId));
		result.putAll(boardService.view_tags_select(contentsType, contentsId));

		result.put("loginYn","Y");
		if( loginId.isEmpty() ){
			result.put("loginYn","N");
		}

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}


	@RequestMapping(value={"/board/comment/select"}, method = RequestMethod.GET)
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

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}


	@RequestMapping(value={"/board/comment/insert"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap insertComment(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";
		String nickName = "";
		String profile = "";

		if( RedisUtil.getSession(sessionId) != null ){
			Map<String, String> userData = RedisUtil.getSession(sessionId);

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

	@RequestMapping(value={"/board/comment/update"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap updateComment(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";

		if( RedisUtil.getSession(sessionId) != null ){
			loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
		}

		LinkedHashMap comment_param = new LinkedHashMap();

		comment_param.put("commentId"  		, param.get("commentId"));
		comment_param.put("coment"  		, param.get("coment")   );
		comment_param.put("uptId"  			, loginId 				);

		result.put("comment", boardService.comment_update(comment_param));
		result.put("code"	,"0000"	);

		return result;
	}


	@RequestMapping(value={"/board/comment/delete"}, method = RequestMethod.POST)
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



	@RequestMapping(value={"/board/like/modify"}, method = RequestMethod.POST)
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

		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";

		if( RedisUtil.getSession(sessionId) != null ){
			loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
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

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}
}