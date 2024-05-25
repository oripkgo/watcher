package com.watcher.business.story.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.util.RedisUtil;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.Map;

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


    @RequestMapping(value = {"/view/{memId}"}, method = RequestMethod.GET)
    public ModelAndView getStoryView(
            HttpServletRequest request,
            HttpServletResponse response,
            @PathVariable("memId") String memId,
            StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        String sessionId = request.getSession().getId();

        ModelAndView mv = new ModelAndView("story/view");

        storyService.insertViewsCount(storyParam);
        result.putAll(storyService.getData(storyParam));

        // 게시물 수정권한 여부 s
        if( redisUtil.getSession(sessionId) == null
                || !(((Map)result.get("view")).get("REG_ID").equals(redisUtil.getSession(sessionId).get("LOGIN_ID")))){
            mv.addObject("modifyAuthorityYn","N");
        }else{
            mv.addObject("modifyAuthorityYn","Y");
        }
        // 게시물 수정권한 여부 e

        mv.addObject("memId",memId);
        mv.addAllObjects(result);

        return mv;
    }


    @RequestMapping(value = {"/delete"}, method = RequestMethod.DELETE)
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStory(
        HttpServletRequest request,
        HttpServletResponse response,
        StoryParam storyParam
    ) throws Exception {

        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");
        storyParam.setRegId(loginId);
        storyParam.setUptId(loginId);

        result.putAll(storyService.deleteStory(storyParam));
        result.put("dto",storyParam);

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
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = redisUtil.getSession(sessionId).get("LOGIN_ID");

        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));

        result.putAll(storyService.insertStory(storyParam));

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

        mv.addObject("searchKeyword", storyParam.getSearch_keyword());
        mv.addObject("searchCategoryId", storyParam.getSearch_category_id());

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

        result.putAll(storyService.getListStoryPublic(storyParam));
        result.put("dto", storyParam);

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

        result.putAll(storyService.getPopularStoryMain(storyParam));
        result.put("dto", storyParam);

        return result;
    }
}
