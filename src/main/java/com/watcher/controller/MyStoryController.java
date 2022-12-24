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
public class MyStoryController {


    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;


    @RequestMapping(value = {"/{memId}/myStory/{categoryId}"})
    public ModelAndView showMyStoryCategoryListPage(
            HttpServletRequest request,
            @PathVariable("memId") String memId,
            @PathVariable("categoryId") String categoryId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("myStory/main");

        LinkedHashMap param = new LinkedHashMap();

        param.put("showYn"    , "Y"       );
        param.put("memId"     , memId    );


        JSONArray member_category_list = new JSONArray().putAll(categoryService.member_category_list(param));

        storyParam.setListNo(10);
        mav.addObject("member_category_list", member_category_list);
        storyParam.setCategoryId(categoryId);
        mav.addObject("memId",memId);
        mav.addObject("categoryListYn","Y");

        return mav;
    }


    @RequestMapping(value = {"/{memId}/myStory"})
    public ModelAndView showMyStoryPage(
            HttpServletRequest request,
            @PathVariable("memId") String memId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        ModelAndView mav = new ModelAndView("myStory/main");

        LinkedHashMap param = new LinkedHashMap();

        param.put("showYn"      , "Y"       );
        param.put("memId"     , memId    );


        JSONArray member_category_list = new JSONArray().putAll(categoryService.member_category_list(param));

        storyParam.setListNo(10);
        mav.addObject("member_category_list", member_category_list);
        mav.addObject("memId",memId);

        return mav;
    }

    @RequestMapping(value = {"/myStory/list/data"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStorylistData(
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
