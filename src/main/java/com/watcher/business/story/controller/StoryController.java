package com.watcher.business.story.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

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

    @RequestMapping(value = {"/view/{memId}"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> showStoryView(
            HttpServletRequest request,
            HttpServletResponse response,
            @PathVariable("memId") String memId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        result.putAll(storyService.view(storyParam));

        // 게시물 수정권한 여부 s
        if( RedisUtil.getSession(sessionId) == null
                || !(((Map)result.get("view")).get("REG_ID").equals(RedisUtil.getSession(sessionId).get("LOGIN_ID")))){
            result.put("modify_authority_yn","N");
        }else{
            result.put("modify_authority_yn","Y");
        }
        // 게시물 수정권한 여부 e

        return result;
    }


    @RequestMapping(value = {"/delete"})
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStory(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody StoryParam storyParam
    ) throws Exception {

        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");
        storyParam.setRegId(loginId);
        storyParam.setUptId(loginId);

        result.putAll(storyService.deleteStory(storyParam));
        result.put("dto",storyParam);

        return result;
    }



    @RequestMapping(value = {"/insert"})
    @ResponseBody
    public LinkedHashMap<String, Object> insertStory(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = RedisUtil.getSession(sessionId).get("LOGIN_ID");

        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));

        result.putAll(storyService.insertStory(storyParam));

        return result;
    }

    @RequestMapping(value = {"/write","/update"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> showStoryEditPage(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        if( !(storyParam.getId() == null || storyParam.getId().isEmpty()) ){
            result.putAll(storyService.view(storyParam));
        }

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @RequestMapping(value = {"/list/data"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getStoryListAsync(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.putAll(storyService.getListStoryPublic(storyParam));
        result.put("dto", storyParam);

        return result;
    }


    @RequestMapping(value = {"/popular/main"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularStoryMain(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.putAll(storyService.getPopularStoryMain(storyParam));
        result.put("vo", storyParam);

        return result;
    }
}
