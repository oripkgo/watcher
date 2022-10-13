package com.watcher.controller;

import com.watcher.param.LoginParam;
import com.watcher.param.StoryParam;
import com.watcher.service.CategoryService;
import com.watcher.service.StoryService;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/story")

public class StoryController {


    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;


    @RequestMapping(value = {"/view"})
    public ModelAndView showStoryView(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("story/view");
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        result.putAll(storyService.view(storyParam));

        // 게시물 수정권한 여부 s
        if( request.getSession().getAttribute("loginInfo") == null
                || !(((Map)result.get("view")).get("REG_ID").equals(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID")))){
            result.put("modify_authority_yn","N");
        }else{
            result.put("modify_authority_yn","Y");
        }
        // 게시물 수정권한 여부 e

        mav.addObject("result"  ,result);

        return mav;
    }


    @RequestMapping(value = {"/delete"})
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStory(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String loginId = ((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID");
        storyParam.setRegId(loginId);
        storyParam.setUptId(loginId);

        result.putAll(storyService.deleteStory(storyParam));
        result.put("vo",storyParam);

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

        storyParam.setRegId(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID"));
        result.putAll(storyService.insertStory(storyParam));

        return result;
    }



    @RequestMapping(value = {"/write","/update"})
    public ModelAndView showStoryEditPage(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam

    ) throws Exception {
        ModelAndView mav = new ModelAndView("story/write");

        LinkedHashMap param = new LinkedHashMap();


        param.put("showYn"  ,"Y");
        param.put("loginId"   ,((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID"));

        JSONArray jsonArray = new JSONArray().putAll(categoryService.story_category_serarch());
        mav.addObject("category_list", jsonArray);


        if( !(storyParam.getId() == null || storyParam.getId().isEmpty()) ){
            mav.addAllObjects(storyService.view(storyParam));
        }


        return mav;
    }


    @RequestMapping(value = {"/list"})
    public ModelAndView showStoryListPage(@ModelAttribute("vo") StoryParam storyParam) throws Exception {
        ModelAndView mav = new ModelAndView("story/list");

        JSONArray jsonArray = new JSONArray().putAll(categoryService.category_list());
        mav.addObject("category_list", jsonArray);

        return mav;
    }

    @RequestMapping(value = {"/listAsync"}, method = RequestMethod.GET)
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

}
