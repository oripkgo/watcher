package com.watcher.controller;

import java.util.List;

import com.watcher.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.watcher.service.MainService;



@Controller
@RequestMapping(value="/")
public class MainController {

	@Autowired
	MainService mainSv;


	@Autowired
	CategoryService categoryService;


	@RequestMapping(value={"main","/"})
	public ModelAndView testMethod() throws Exception {
		
		ModelAndView mav = new ModelAndView("main/main");


		return mav;
	}


}
