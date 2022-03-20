package com.watcher.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value="/story")

public class StoryController {

    @RequestMapping(value={"list"})
    public ModelAndView testMethod() throws Exception {

        ModelAndView mav = new ModelAndView("story/list");


        return mav;
    }

}
