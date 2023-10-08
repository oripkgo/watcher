package com.watcher.business.board.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.watcher.business.board.service.BoardService;
import com.watcher.business.board.service.NoticeService;
import com.watcher.business.comm.dto.CommDto;
import com.watcher.business.board.param.NoticeParam;

import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

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


	@RequestMapping(value = {"/notice/delete"}, method = RequestMethod.DELETE)
	@ResponseBody
	public LinkedHashMap<String, Object> deleteNotice(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestBody NoticeParam noticeParam

	) throws Exception {
		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
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
		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		LinkedHashMap<String, Object> result = new LinkedHashMap<String, Object>();

		Map<String, Object> noticeInfo = noticeService.view(noticeParam);

		// 게시물 수정권한 여부 s
		if( RedisUtil.getSession(sessionId) == null
				|| !(((Map)noticeInfo.get("view")).get("REG_ID").equals(RedisUtil.getSession(sessionId).get("LOGIN_ID")))){
			noticeInfo.put("modify_authority_yn","N");
		}else{
			noticeInfo.put("modify_authority_yn","Y");
		}
		// 게시물 수정권한 여부 e

		result.putAll(noticeInfo);

		return result;
	}

	@RequestMapping(value = {"/notice/write","/notice/update"})
	@ResponseBody
	public LinkedHashMap showNoticeEditPage(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		LinkedHashMap result = new LinkedHashMap();
		LinkedHashMap param = new LinkedHashMap();

		param.put("showYn"  	,"Y");
		param.put("loginId"   	,RedisUtil.getSession(sessionId).get("LOGIN_ID"));

		result.put("code", "0000");
		result.put("message", "OK");
		if( !(noticeParam.getId() == null || noticeParam.getId().isEmpty()) ){
			result.putAll(noticeService.view(noticeParam));
		}

		return result;
	}

	@RequestMapping(value = {"/notice/insert"})
	@ResponseBody
	public LinkedHashMap<String, Object> insertStory(
			HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute("vo") NoticeParam noticeParam
	) throws Exception {
		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();


		Object loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");

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

		result.putAll(boardService.getLikeYn(contentsType, contentsId, loginId));
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
			@ModelAttribute("vo") CommDto commDto,
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

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("contentsType"		, param.get("contentsType") );
		commentParam.put("contentsId"  		, param.get("contentsId")   );
		commentParam.put("refContentsId"  	, param.get("refContentsId"));
		commentParam.put("coment"  			, param.get("coment")    	);
		commentParam.put("regId"  			, loginId					);
		commentParam.put("confirmId"  		, loginId    				);
		commentParam.put("nickName"  		, nickName					);
		commentParam.put("profile"  		, profile					);

		result.put("comment", boardService.insertComment(commentParam));
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

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("commentId"  	, param.get("commentId"));
		commentParam.put("coment"  		, param.get("coment")   );
		commentParam.put("uptId"  		, loginId 				);

		result.put("comment", boardService.updateComment(commentParam));
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

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("commentId"  		, param.get("commentId"));
		commentParam.put("uptId"  			, param.get("regId"));

		result.put("comment", boardService.deleteComment(commentParam));
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
		LinkedHashMap<String, Object> likeParam = new LinkedHashMap<>();

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));
		String loginId = "";

		if( RedisUtil.getSession(sessionId) != null ){
			loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
		}

		if( param.containsKey("likeId") && param.get("likeId") != null ){
			likeParam.put("likeId"	, param.get("likeId")	);
			likeParam.put("uptId"	, loginId				);

			boardService.updateLike(likeParam);
		}else{
			likeParam.put("contentsType"	, param.get("contentsType")	);
			likeParam.put("contentsId"		, param.get("contentsId")	);
			likeParam.put("loginId"			, loginId					);
			likeParam.put("likeType"		, param.get("likeType")		);
			likeParam.put("regId"			, loginId					);

			boardService.insertLike(likeParam);
			result.putAll(likeParam);
		}

		result.put("code", "0000");
		result.put("message", "OK");

		return result;
	}
}