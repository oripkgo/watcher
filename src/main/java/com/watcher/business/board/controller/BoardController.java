package com.watcher.business.board.controller;

import com.watcher.business.board.service.BoardService;
import com.watcher.business.board.service.NoticeService;
import com.watcher.business.comm.dto.CommDto;
import com.watcher.business.board.param.NoticeParam;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.story.service.StoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.enums.ResponseCode;
import com.watcher.util.AESUtil;
import com.watcher.util.CookieUtil;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;

@Controller
@RequestMapping(value="/")
public class BoardController {
	@Autowired
	NoticeService noticeService;

	@Autowired
	BoardService boardService;

	@Autowired
	StoryService storyService;

	@Autowired
	SignService signService;

	@Autowired
	RedisUtil redisUtil;

	@Autowired
	ManagementService managementService;


	@RequestMapping(value = {"/my-story/{memId}/notice/list"})
	public ModelAndView showMemberNoticeListPage(
			@PathVariable("memId") String memId,
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/list");
		noticeParam.setSearchMemId(memId);

		mav.addObject("dto", noticeParam);
		mav.addObject("noticeListUrl", "/my-story/"+memId+"/notice/list/data");
		mav.addObject("code"	, ResponseCode.SUCCESS_0000.getCode());
		mav.addObject("message" , ResponseCode.SUCCESS_0000.getMessage());

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
		String token 		= request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId 	= signService.getSessionId(token);
		String memId 		= String.valueOf(signService.getSessionUser(sessionId).get("ID"));

		result.put("list"	, noticeService.getListNotice(memId, noticeParam)	);
		result.put("dto"	, noticeParam										);
		result.put("code"	, ResponseCode.SUCCESS_0000.getCode()				);
		result.put("message", ResponseCode.SUCCESS_0000.getMessage()			);

		return result;
	}


	@RequestMapping(value={"/my-story/{memId}/notice/list/data"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap<String, Object> getNoticeListAsync(
			@PathVariable("memId") String memId,
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();
		String token 		= request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId 	= signService.getSessionId(token);
		String sessionMemId = String.valueOf(signService.getSessionUser(sessionId).get("ID"));

		noticeParam.setSearchMemId(memId);

		result.put("list"	, noticeService.getListNotice(sessionMemId, noticeParam));
		result.put("dto"	, noticeParam											);
		result.put("code"	, ResponseCode.SUCCESS_0000.getCode()					);
		result.put("message", ResponseCode.SUCCESS_0000.getMessage()				);

		return result;
	}


	@RequestMapping(value = {"/notice/delete"}, method = RequestMethod.DELETE)
	@ResponseBody
	public LinkedHashMap<String, Object> deleteNotice(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		String token = request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId = signService.getSessionId(token);
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
		noticeParam.setRegId(String.valueOf(loginId));
		noticeParam.setUptId(String.valueOf(loginId));

		noticeService.delete(noticeParam);

		result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
		result.put("message", ResponseCode.SUCCESS_0000.getMessage());

		return result;
	}


	@RequestMapping(value = {"/notice/view", "/my-story/{memId}/notice/view"}, method = RequestMethod.GET)
	public ModelAndView noticeView(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/view");

		String sessionId 	= JwtTokenUtil.getId(CookieUtil.getValue("SESSION_TOKEN"));
		String loginId 		= signService.getSessionUser(sessionId).get("LOGIN_ID");

		Map<String, Object> noticeInfo = noticeService.getData(noticeParam);
		noticeService.insertViewsCount(noticeParam);

		// 게시물 수정권한 여부 s
		mav.addObject("modifyAuthorityYn", "Y");
		if (!Objects.equals(noticeInfo.get("REG_ID"), loginId)) {
			mav.addObject("modifyAuthorityYn", "N");
		}
		// 게시물 수정권한 여부 e


		mav.addObject("view"	, noticeInfo								);
		mav.addObject("code"	, ResponseCode.SUCCESS_0000.getCode()		);
		mav.addObject("message"	, ResponseCode.SUCCESS_0000.getMessage()	);

		return mav;
	}


	@RequestMapping(value = {"/notice/write","/notice/update"})
	public ModelAndView showNoticeEditPage(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		ModelAndView mav = new ModelAndView("notice/edit");

		LinkedHashMap<String, Object> result = new LinkedHashMap<String, Object>();
		String sessionId 	= JwtTokenUtil.getId(CookieUtil.getValue("SESSION_TOKEN"));
		String loginId 		= signService.getSessionUser(sessionId).get("LOGIN_ID");
		String memId 		= String.valueOf(signService.getSessionUser(sessionId).get("ID"));

		if( !StringUtils.hasText(noticeParam.getEditPermId()) ){
			noticeParam.setEditPermId(AESUtil.encrypt(memId + "/" + loginId));
		}

		Map<String, Object> noticeInfo = new HashMap<>();

		if(StringUtils.hasText(noticeParam.getId())){
			noticeInfo = noticeService.getData(noticeParam);
		}

		// 게시물 수정권한 여부 체크
		mav.addObject("modifyAuthorityYn", "N");
		if (Objects.equals(noticeInfo.get("REG_ID"), loginId)) {
			mav.addObject("modifyAuthorityYn", "Y");
		}

		mav.addObject("noticeParam"	, noticeParam							);
		mav.addObject("view"		, noticeInfo							);
		mav.addObject("code"		, ResponseCode.SUCCESS_0000.getCode()	);
		mav.addObject("message"		, ResponseCode.SUCCESS_0000.getMessage());

		return mav;
	}



	@RequestMapping(value = {"/notice/insert"})
	@ResponseBody
	public LinkedHashMap<String, Object> insertStory(
			HttpServletRequest request,
			HttpServletResponse response,
			NoticeParam noticeParam
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		try{
			String editPermId = AESUtil.decrypt(noticeParam.getEditPermId());
			noticeParam.setAdminId(String.valueOf(editPermId.split("/")[0]));
			noticeParam.setRegId(String.valueOf(editPermId.split("/")[1]));
			noticeParam.setUptId(String.valueOf(editPermId.split("/")[1]));
		}catch (Exception e){
			throw new Exception("2302");
		}

		noticeService.insert(noticeParam);

		result.put("code"		, ResponseCode.SUCCESS_0000.getCode()	);
		result.put("message"	, ResponseCode.SUCCESS_0000.getMessage());

		return result;
	}


	@RequestMapping(value={"/board/like"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap getBoardLikeData(
			HttpServletRequest request,
			@RequestParam Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String token 		= request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId 	= signService.getSessionId(token);
		String loginId 		= redisUtil.getSession(sessionId).get("LOGIN_ID");

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.getLikeYn(contentsType, contentsId, loginId));

		result.put("loginYn","Y");
		if( !StringUtils.hasText(loginId) ){
			result.put("loginYn","N");
		}

		result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
		result.put("message", ResponseCode.SUCCESS_0000.getMessage());

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
		String token = request.getHeader("Authorization").replace("Bearer ", "");
		try{
			sessionId = signService.getSessionId(token);
			if( redisUtil.getSession(sessionId) != null ){
				loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");
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

		int id = Integer.valueOf(contentsId);
		if( "STORY".equals(contentsType) ){
			if( "Y".equals(param.get("likeYn")) ){
				storyService.updateLikeCountUp(id);
			}else{
				storyService.updateLikeCountDown(id);
			}
		}else if( "NOTICE".equals(contentsType) ){
			if( "Y".equals(param.get("likeYn")) ){
				noticeService.updateLikeCountUp(id);
			}else{
				noticeService.updateLikeCountDown(id);
			}
		}

		result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
		result.put("message", ResponseCode.SUCCESS_0000.getMessage());

		return result;
	}


	@RequestMapping(value={"/board/tags"}, method = RequestMethod.GET)
	@ResponseBody
	public LinkedHashMap getBoardTagsData(
			HttpServletRequest request,
			@RequestParam Map<String,Object> param
	) throws Exception {
		LinkedHashMap<String, Object> result = new LinkedHashMap<>();

		String token = request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId = signService.getSessionId(token);
		String loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");

		String contentsType = String.valueOf(param.get("contentsType"));
		String contentsId = String.valueOf(param.get("contentsId"));

		result.putAll(boardService.getTagDatas(contentsType, contentsId));

		result.put("loginYn","Y");
		if( !StringUtils.hasText(loginId) ){
			result.put("loginYn","N");
		}

		result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
		result.put("message", ResponseCode.SUCCESS_0000.getMessage());

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

		commDto.setTotalCnt((int)commentObj.get("cnt"));

		result.put("dto"		, commDto								);
		result.put("comment"	, commentObj							);
		result.put("code"		, ResponseCode.SUCCESS_0000.getCode()	);
		result.put("message"	, ResponseCode.SUCCESS_0000.getMessage());

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

		String token	 = request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId = signService.getSessionId(token);
		String loginId 	 = "";
		String nickName  = "";
		String profile   = "";

		if( redisUtil.getSession(sessionId) != null ){
			Map<String, String> userData = redisUtil.getSession(sessionId);

			loginId 	= userData.get("LOGIN_ID");
			nickName 	= userData.get("NICKNAME");
			profile 	= userData.get("MEM_PROFILE_IMG");
		}

		// 댓글 공백인지 입력여부 체크
		if( !param.containsKey("comment") || param.get("comment") == null || param.get("comment").equals("") ){
			throw new Exception("2201");
		}

		// 댓글 입력 권한 체크
		String type = param.get("contentsType").toString();
		String id 	= param.get("contentsId").toString();
		Map<String, Object> storySettingInfo = managementService.getStorySettingInfo(type, id);
		if( "02".equals(storySettingInfo.get("COMMENT_PERM_STATUS")) ){
			if( !Objects.equals(storySettingInfo.get("LOGIN_ID"), loginId)){
				throw new Exception("2202");
			}
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

		result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
		result.put("message", ResponseCode.SUCCESS_0000.getMessage());

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
		String token = request.getHeader("Authorization").replace("Bearer ", "");
		String sessionId = signService.getSessionId(token);
		String loginId = "";

		if( redisUtil.getSession(sessionId) != null ){
			loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");
		}

		LinkedHashMap commentParam = new LinkedHashMap();

		commentParam.put("commentId"  	, param.get("commentId")	);
		commentParam.put("comment"  	, param.get("comment")   	);
		commentParam.put("uptId"  		, loginId 					);

		boardService.updateComment(commentParam);

		result.put("comment"	, param.get("comment")					);
		result.put("code"		, ResponseCode.SUCCESS_0000.getCode()	);
		result.put("message"	, ResponseCode.SUCCESS_0000.getMessage());

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
		result.put("code", ResponseCode.SUCCESS_0000.getCode());
		result.put("message", ResponseCode.SUCCESS_0000.getMessage());

		return result;
	}
}