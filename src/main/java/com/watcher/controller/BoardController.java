package com.watcher.controller;

import com.watcher.service.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping(value="/")
public class BoardController {

	@Autowired
	MainService mainSv;
	

	
	@RequestMapping(value={"notice/list"})
	public ModelAndView testMethod() throws Exception {
		
		ModelAndView mav = new ModelAndView("notice/list");

		
		return mav;
	}

	
	
}
