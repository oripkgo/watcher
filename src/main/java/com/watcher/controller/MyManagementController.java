package com.watcher.controller;

import com.watcher.param.ManagementParam;
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
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/myManagement")

public class MyManagementController {


//    @Autowired
//    CategoryService categoryService;

    @Autowired
    StoryService storyService;



    @RequestMapping(value = {"/{userId}/main"})
    @ResponseBody
    public ModelAndView getMyManagementInfo(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") ManagementParam managementParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("myManagement/main");

        return mav;
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
