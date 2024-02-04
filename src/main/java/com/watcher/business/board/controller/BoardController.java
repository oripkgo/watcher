package com.watcher.business.board.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.watcher.business.board.service.BoardService;
import com.watcher.business.board.service.NoticeService;
import com.watcher.business.comm.dto.CommDto;
import com.watcher.business.board.param.NoticeParam;

import com.watcher.business.login.service.SignService;
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

	@Autowired
	SignService signService;

	@RequestMapping(value = {"/{memId}/notice/list"})
	public ModelAndView showMemberNoticeListPage(
			@PathVariable("memId") String memId,
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/list");
		noticeParam.setSearchMemId(memId);

		mav.addObject("dto", noticeParam);
		mav.addObject("noticeListUrl", "/"+memId+"/notice/list/data");
		mav.addObject("code", "0000");
		mav.addObject("message", "OK");

		return mav;
	}

	@RequestMapping(value={"/notice/list"}, method = RequestMethod.GET)
	public ModelAndView showNoticeListPage(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/list");

		mav.addObject("noticeListUrl"	, "/notice/list/data");
		mav.addObject("dto"				, noticeParam);

		return mav;
	}

	@RequestMapping(value={"/notice/list/data"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> getNoticeListAsync(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();
		String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		String memId = String.valueOf(signService.getSessionUser(sessionId).get("ID"));
		result.putAll(noticeService.getListNotice(memId, noticeParam));
		result.put("dto", noticeParam);

		return result;
	}


	@RequestMapping(value={"/{memId}/notice/list/data"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> getNoticeListAsync(
			@PathVariable("memId") String memId,
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();
		String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		String sessionMemId = String.valueOf(signService.getSessionUser(sessionId).get("ID"));
		noticeParam.setSearchMemId(memId);

		result.putAll(noticeService.getListNotice(sessionMemId, noticeParam));
		result.put("dto", noticeParam);

		return result;
	}


	@RequestMapping(value = {"/notice/delete"}, method = RequestMethod.DELETE)
	@ResponseBody
	public LinkedHashMap<String, Object> deleteNotice(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
		noticeParam.setRegId(String.valueOf(loginId));
		noticeParam.setUptId(String.valueOf(loginId));

		noticeService.delete(noticeParam);

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}

	@RequestMapping(value = {"/notice/view"}, method = RequestMethod.GET)
	public ModelAndView noticeView(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/view");

		String sessionId = request.getSession().getId();

		Map<String, Object> noticeInfo = noticeService.getData(noticeParam);

		// 게시물 수정권한 여부 s
		if( RedisUtil.getSession(sessionId) == null
				|| !(((Map)noticeInfo.get("view")).get("REG_ID").equals(RedisUtil.getSession(sessionId).get("LOGIN_ID")))){
			noticeInfo.put("modify_authority_yn","N");
		}else{
			noticeInfo.put("modify_authority_yn","Y");
		}
		// 게시물 수정권한 여부 e

		mav.addAllObjects(noticeInfo);

		return mav;
	}


	@RequestMapping(value = {"/notice/write","/notice/update"})
	public ModelAndView showNoticeEditPage(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/edit");

		String sessionId = request.getSession().getId();
		LinkedHashMap<String, Object> result = new LinkedHashMap<String, Object>();

		Map<String, Object> noticeInfo = noticeService.getData(noticeParam);

		// 게시물 수정권한 여부 s
		if(
			RedisUtil.getSession(sessionId) == null
			|| !(((Map)noticeInfo.get("view")).get("REG_ID").equals(RedisUtil.getSession(sessionId).get("LOGIN_ID")))
		){
			noticeInfo.put("modify_authority_yn","N");
		}else{
			noticeInfo.put("modify_authority_yn","Y");
		}
		// 게시물 수정권한 여부 e

		mav.addAllObjects(noticeInfo);

		return mav;
	}



	@RequestMapping(value = {"/notice/insert"})
	@ResponseBody
	public LinkedHashMap<String, Object> insertStory(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		Object loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");

		noticeParam.setRegId(String.valueOf(loginId));
		noticeParam.setUptId(String.valueOf(loginId));

		result.putAll(noticeService.insert(noticeParam));

		return result;
	}


	@RequestMapping(value={"/board/like"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap getBoardLikeData(
			HttpServletRequest request,
			@RequestParam Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String sessionId = "";
		String loginId = "";

		try{
			sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
			if( RedisUtil.getSession(sessionId) != null ){
				loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
			}
		}catch (Exception e){}

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.getLikeYn(contentsType, contentsId, loginId));

		result.put("loginYn","Y");
		if( loginId.isEmpty() ){
			result.put("loginYn","N");
		}

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}


	@RequestMapping(value={"/board/like"}, method = RequestMethod.POST)
	@ResponseBody
	public LinkedHashMap modifyBoardLike(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();
		LinkedHashMap<String, Object> likeParam = new LinkedHashMap<>();

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		String loginId = "";
		String sessionId = "";

		try{
			sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
			if( RedisUtil.getSession(sessionId) != null ){
				loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
			}
		}catch (Exception e){}


		if( param.containsKey("likeId") && param.get("likeId") != null ){
			likeParam.put("likeId"	, param.get("likeId")	);
			likeParam.put("uptId"	, loginId				);

			boardService.updateLike(likeParam);
		}else{
			likeParam.put("contentsType"	, param.get("contentsType")	);
			likeParam.put("contentsId"		, param.get("contentsId")	);
			likeParam.put("loginId"			, loginId					);
			likeParam.put("likeType"		, "01"						);
			likeParam.put("regId"			, loginId					);

			boardService.insertLike(likeParam);
			result.putAll(likeParam);
		}

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}


	@RequestMapping(value={"/board/tags"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap getBoardTagsData(
			HttpServletRequest request,
			@RequestParam Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String sessionId = "";

		try{
			sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		}catch (Exception e){}

		String loginId = "";

		if( RedisUtil.getSession(sessionId) != null ){
			loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
		}

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.getTagDatas(contentsType, contentsId));

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
			CommDto commDto,
			@RequestParam Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("contentsType"	, contentsType  		);
		commentParam.put("contentsId"  	, contentsId    		);
		commentParam.put("pageNo"  		, commDto.getPageNo()    );
		commentParam.put("listNo"  		, commDto.getListNo()	);

		Map<String, Object> commentObj = boardService.getCommentInfo(commentParam);
		result.put("comment", commentObj);

		commDto.setTotalCnt((int)commentObj.get("cnt"));
		result.put("dto", commDto);

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

		String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";
		String nickName = "";
		String profile = "";

		if( RedisUtil.getSession(sessionId) != null ){
			Map<String, String> userData = RedisUtil.getSession(sessionId);

			loginId = userData.get("LOGIN_ID");
			nickName = userData.get("NICKNAME");
			profile = userData.get("MEM_PROFILE_IMG");
		}


		if( !param.containsKey("comment") || param.get("comment") == null || param.get("comment").equals("") ){
			throw new Exception("2005");
		}

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("contentsType"		, param.get("contentsType") );
		commentParam.put("contentsId"  		, param.get("contentsId")   );
		commentParam.put("refContentsId"  	, param.get("refContentsId"));
		commentParam.put("comment"  		, param.get("comment")    	);
		commentParam.put("regId"  			, loginId					);
		commentParam.put("confirmId"  		, loginId    				);
		commentParam.put("nickName"  		, nickName					);
		commentParam.put("profile"  		, profile					);

		result.put("comment", boardService.insertComment(commentParam));
		result.put("code","0000");

		return result;
	}

	@RequestMapping(value={"/board/comment/update"}, method = RequestMethod.PUT)
	@ResponseBody
	public LinkedHashMap updateComment(
			HttpServletRequest request,
			HttpServletResponse response,
			CommDto commDto,
			@RequestBody Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";

		if( RedisUtil.getSession(sessionId) != null ){
			loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
		}

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("commentId"  	, param.get("commentId")	);
		commentParam.put("comment"  	, param.get("comment")   	);
		commentParam.put("uptId"  		, loginId 					);

		boardService.updateComment(commentParam);

		result.put("comment"	, param.get("comment"));
		result.put("code"		,"0000"	);
		result.put("message"	,"OK"	);

		return result;
	}


	@RequestMapping(value={"/board/comment/delete"}, method = RequestMethod.DELETE)
	@ResponseBody
	public LinkedHashMap deleteComment(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") CommDto commDto,
			@RequestParam Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("commentId"  		, param.get("commentId"));
		commentParam.put("uptId"  			, param.get("regId"));

		result.put("comment", boardService.deleteComment(commentParam));
		result.put("code"	,"0000"	);

		return result;
	}
}