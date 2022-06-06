package com.watcher.controller;

import com.watcher.param.StoryParam;
import com.watcher.service.CategoryService;
import com.watcher.service.StoryService;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value="/story")

public class StoryController {


    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @RequestMapping(value={"list"})
    public ModelAndView list() throws Exception {
        ModelAndView mav = new ModelAndView("story/list");

        JSONArray jsonArray = new JSONArray().putAll(categoryService.category_list());
        mav.addObject("category_list", jsonArray);

        return mav;
    }

    @RequestMapping(value={"listAsync"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> listAsync(
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
