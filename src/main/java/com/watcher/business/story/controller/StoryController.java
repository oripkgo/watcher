package com.watcher.business.story.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.enums.ResponseCode;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
@RequestMapping(value = "/story")
public class StoryController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @Autowired
    SignService signService;

    @Autowired
    RedisUtil redisUtil;

    @Autowired
    ManagementService managementService;


    @RequestMapping(value = {"/view/{memId}"}, method = RequestMethod.GET)
    public ModelAndView getStoryView(
            HttpServletRequest request,
            HttpServletResponse response,
            @PathVariable("memId") String memId,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mv = new ModelAndView("story/view");

        String sessionId = request.getSession().getId();
        String loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");

        storyService.insertViewsCount(storyParam);

        Map<String, Object> storyInfo = storyService.getData(storyParam);

        // 게시물 수정권한 여부
        mv.addObject("modifyAuthorityYn","Y");
        if( !Objects.equals(storyInfo.get("REG_ID"), loginId)){
            mv.addObject("modifyAuthorityYn","N");
        }


        // 댓글 작성 권한 체크
        Map<String, Object> storySettingInfo = managementService.getStorySettingInfo(storyInfo.get("REG_ID").toString());
        mv.addObject("commentRegYn","N");

        if( "01".equals(storySettingInfo.get("COMMENT_PERM_STATUS")) ){
            mv.addObject("commentRegYn","Y");
        }else if( "02".equals(storySettingInfo.get("COMMENT_PERM_STATUS")) ){
            if( Objects.equals(storySettingInfo.get("LOGIN_ID"), loginId)){
                mv.addObject("commentRegYn","Y");
            }
        }

        mv.addObject("memId"    , memId                                 );
        mv.addObject("view"     , storyInfo                             );
        mv.addObject("code"     , ResponseCode.SUCCESS_0000.getCode()   );
        mv.addObject("message"  , ResponseCode.SUCCESS_0000.getMessage());

        return mv;
    }


    @RequestMapping(value = {"/delete"}, method = RequestMethod.DELETE)
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStory(
        HttpServletRequest request,
        HttpServletResponse response,
        StoryParam storyParam
    ) throws Exception {

        String token = request.getHeader("Authorization").replace("Bearer ", "");
        String sessionId = signService.getSessionId(token);

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");
        storyParam.setRegId(loginId);
        storyParam.setUptId(loginId);

        storyService.deleteStory(storyParam);

        result.put("dto"    , storyParam                            );
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()   );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }



    @RequestMapping(value = {"/insert"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> insertStory(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        String token = request.getHeader("Authorization").replace("Bearer ", "");
        String sessionId = signService.getSessionId(token);

        Object loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");

        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));

        result.put("storyId", storyService.insertStory(storyParam)  );
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()   );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }

    @RequestMapping(value = {"/write","/update"}, method = RequestMethod.GET)
    public ModelAndView getStoryEditData(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("story/edit");

        if( !(storyParam.getId() == null || storyParam.getId().isEmpty()) ){
            mav.addAllObjects(storyService.getData(storyParam));
        }

        return mav;
    }


    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    public ModelAndView getStoryListPage(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mv = new ModelAndView("story/list");

        mv.addObject("searchKeyword", storyParam.getSearchKeyword());
        mv.addObject("searchCategoryId", storyParam.getSearchCategoryId());

        return mv;
    }


    @RequestMapping(value = {"/list/data"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getStoryList(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        storyParam.setListNo(10);

        result.put("list"   , storyService.getListStoryPublic(storyParam)   );
        result.put("dto"    , storyParam                                    );
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()           );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage()        );

        return result;
    }


    @RequestMapping(value = {"/popular/main"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularStoryMain(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.put("popularStorys"  , storyService.getPopularStoryMain(storyParam)  );
        result.put("dto"            , storyParam                                    );
        result.put("code"           , ResponseCode.SUCCESS_0000.getCode()           );
        result.put("message"        , ResponseCode.SUCCESS_0000.getMessage()        );

        return result;
    }


    @RequestMapping(value = {"/related/posts"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> getRelatedPostList(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        if( !StringUtils.hasText(storyParam.getContents()) ){
            throw new Exception("2001");
        }

        String targetContents = storyParam.getContents();

        storyParam.setListNo(9999999);
        List<Map<String,Object>> storyList = storyService.getList(storyParam);

        List<Map<String,Object>> relatedPostList = storyService.getFeaturedRelatedPostList(storyParam.getSearchMemId(), targetContents, storyList);

        result.put("relatedPostList"    , relatedPostList                           );
        result.put("code"	            , ResponseCode.SUCCESS_0000.getCode()       );
        result.put("message"            , ResponseCode.SUCCESS_0000.getMessage()    );

        return result;
    }
}
