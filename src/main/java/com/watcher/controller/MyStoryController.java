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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/myStory")

public class MyStoryController {


    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;


    @RequestMapping(value = {"/{userId}/{categoryId}"})
    public ModelAndView showMyStoryCategoryListPage(
            HttpServletRequest request,
            @PathVariable("userId") String userId,
            @PathVariable("categoryId") String categoryId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("myStory/main");

        LinkedHashMap param = new LinkedHashMap();

        param.put("showYn"    , "Y"       );
        param.put("memId"     , userId    );


        JSONArray member_category_list = new JSONArray().putAll(categoryService.member_category_list(param));

        storyParam.setListNo(10);
        mav.addObject("member_category_list", member_category_list);
        storyParam.setCategoryId(categoryId);
        mav.addObject("memId",userId);
        mav.addObject("categoryListYn","Y");

        return mav;
    }


    @RequestMapping(value = {"/{userId}"})
    public ModelAndView showMyStoryPage(
            HttpServletRequest request,
            @PathVariable("userId") String userId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("myStory/main");

        LinkedHashMap param = new LinkedHashMap();

        param.put("showYn"      , "Y"       );
        param.put("memId"     , userId    );


        JSONArray member_category_list = new JSONArray().putAll(categoryService.member_category_list(param));

        storyParam.setListNo(10);
        mav.addObject("member_category_list", member_category_list);
        mav.addObject("memId",userId);

        return mav;
    }

    @RequestMapping(value = {"/listAsync"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStorylistAsync(
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
