package com.watcher.controller;

import com.watcher.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value="/story")

public class StoryController {


    @Autowired
    CategoryService categoryService;

    @RequestMapping(value={"list"})
    public ModelAndView testMethod() throws Exception {
        ModelAndView mav = new ModelAndView("story/list");

        mav.addObject("category_list",categoryService.category_list());

        return mav;
    }

}
