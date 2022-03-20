package com.watcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.watcher.dto.MemberDto;
import com.watcher.service.MainService;



@Controller
@RequestMapping(value="/")
public class MainController {

	@Autowired
	MainService mainSv;
	

	
	@RequestMapping(value={"main","/"})
	public ModelAndView testMethod() throws Exception {
		
		ModelAndView mav = new ModelAndView("main/main");

		
		return mav;
	}



	@RequestMapping(value={"loginSuccess"})
	public ModelAndView loginSuccess() throws Exception {

		ModelAndView mav = new ModelAndView("main/main");


		return mav;
	}


	
	
}
