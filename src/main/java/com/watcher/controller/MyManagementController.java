package com.watcher.controller;

import com.watcher.param.ManagementParam;
import com.watcher.param.StoryParam;
import com.watcher.service.CategoryService;
import com.watcher.service.MyManagementService;
import com.watcher.service.StoryService;
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
@RequestMapping(value = "/myManagement")

public class MyManagementController {


//    @Autowired
//    CategoryService categoryService;

    @Autowired
    MyManagementService myManagementService;

    @Autowired
    StoryService storyService;

    @RequestMapping(value = {"/{menu}"})
    public ModelAndView getMyManagementMainPage(
            @PathVariable("menu") String menu,
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") ManagementParam managementParam
    ) throws Exception {
        ModelAndView mav = null;

        if( "main".equals(menu) ){
            mav = new ModelAndView("myManagement/main");
        }else if( "board".equals(menu) ){
            mav = new ModelAndView("myManagement/board");
        }else if( "category".equals(menu) ){
            mav = new ModelAndView("myManagement/category");
        }else if( "notice".equals(menu) ){
            mav = new ModelAndView("myManagement/notice");
        }else if( "comment".equals(menu) ){
            mav = new ModelAndView("myManagement/comment");
        }else if( "setting".equals(menu) ){
            mav = new ModelAndView("myManagement/setting");
        }else if( "statistics".equals(menu) ){
            mav = new ModelAndView("myManagement/statistics");
        }

        return mav;
    }

    @RequestMapping(value = {"/visitor/cnt"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getVisitorCnt(
        HttpServletRequest request,
        HttpServletResponse response,
        ManagementParam managementParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        managementParam.setSearch_login_id(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID"));
        result.putAll(myManagementService.getVisitorCnt(managementParam));

        return result;
    }

    @RequestMapping(value = {"/visitor/chart/cnts"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getChartVisitorCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            ManagementParam managementParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        managementParam.setSearch_login_id(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID"));
        result.putAll(myManagementService.getChartVisitorCnt(managementParam));

        return result;
    }


    @RequestMapping(value = {"/popularity/articles"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularityArticles(
            HttpServletRequest request,
            HttpServletResponse response,
            ManagementParam managementParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        StoryParam storyParam = new StoryParam();

        Object memId = (((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("ID"));
        storyParam.setSearch_memId(String.valueOf(memId));
        storyParam.setSortByRecommendationYn("YY");
        storyParam.setLimitNum("4");

        result.putAll(storyService.list(storyParam));

        return result;
    }



//    @RequestMapping(value = {"/delete"})
//    @ResponseBody
//    public LinkedHashMap<String, Object> storyRemove(
//        HttpServletRequest request,
//        HttpServletResponse response,
//        @RequestBody StoryParam storyParam
//    ) throws Exception {
//
//        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
//
//        storyParam.setRegId(((Map<String, String>)request.getSession().getAttribute("loginInfo")).get("LOGIN_ID"));
//        storyParam.setDeleteYn("Y");
//
//        result.putAll(storyService.story_update(storyParam));
//        result.put("vo",storyParam);
//
//        return result;
//    }


}
