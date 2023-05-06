package com.watcher.controller;

import com.watcher.param.StoryParam;
import com.watcher.service.CategoryService;
import com.watcher.service.StoryService;
import com.watcher.util.RedisUtil;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
public class StoryController {


    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;


    @RequestMapping(value = {"/{memId}/story/view"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> showStoryView(
            HttpServletRequest request,
            HttpServletResponse response,
            @PathVariable("memId") String memId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        result.putAll(storyService.view(storyParam));

        // 게시물 수정권한 여부 s
        if( RedisUtil.getSession(request.getSession().getId()) == null
                || !(((Map)result.get("view")).get("REG_ID").equals(RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID")))){
            result.put("modify_authority_yn","N");
        }else{
            result.put("modify_authority_yn","Y");
        }
        // 게시물 수정권한 여부 e

        return result;
    }


    @RequestMapping(value = {"/story/delete"})
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStory(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String loginId = RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID");
        storyParam.setRegId(loginId);
        storyParam.setUptId(loginId);

        result.putAll(storyService.deleteStory(storyParam));
        result.put("vo",storyParam);

        return result;
    }



    @RequestMapping(value = {"/story/insert"})
    @ResponseBody
    public LinkedHashMap<String, Object> insertStory(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();


        Object loginId = RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID");

        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));

        result.putAll(storyService.insertStory(storyParam));

        return result;
    }

    @RequestMapping(value = {"/story/write","/story/update"})
    public ModelAndView showStoryEditPage(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam

    ) throws Exception {
        ModelAndView mav = new ModelAndView("story/write");

        LinkedHashMap param = new LinkedHashMap();


        param.put("showYn"      ,"Y");
        param.put("loginId"     ,RedisUtil.getSession(request.getSession().getId()).get("LOGIN_ID"));

        JSONArray jsonArray = new JSONArray().putAll(categoryService.story_category_serarch());
        mav.addObject("category_list", jsonArray);


        if( !(storyParam.getId() == null || storyParam.getId().isEmpty()) ){
            mav.addAllObjects(storyService.view(storyParam));
        }


        return mav;
    }


    @RequestMapping(value = {"/story/list"})
    public ModelAndView showStoryListPage(@ModelAttribute("vo") StoryParam storyParam) throws Exception {
        ModelAndView mav = new ModelAndView("story/list");

        JSONArray jsonArray = new JSONArray().putAll(categoryService.category_list());
        mav.addObject("category_list", jsonArray);

        return mav;
    }

    @RequestMapping(value = {"/story/list/data"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getStoryListAsync(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.putAll(storyService.list(storyParam));
        result.put("vo", storyParam);

        return result;
    }


    @RequestMapping(value = {"/story/popular"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularStory(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.putAll(storyService.getPopularStory(storyParam));
        result.put("vo", storyParam);

        return result;
    }

}
