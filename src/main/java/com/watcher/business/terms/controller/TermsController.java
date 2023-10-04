package com.watcher.business.terms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping(value="/terms")
public class TermsController {
	@RequestMapping(value="/use",method = RequestMethod.GET)
	public ModelAndView moveUsePage() throws Exception {
		ModelAndView mav = new ModelAndView("terms/use");
		return mav;
	}

	@RequestMapping(value="/privacy",method = RequestMethod.GET)
	public ModelAndView movePrivacyPage() throws Exception {
		ModelAndView mav = new ModelAndView("terms/privacy");
		return mav;
	}

	@RequestMapping(value="/copyright",method = RequestMethod.GET)
	public ModelAndView moveCopyrightPage() throws Exception {
		ModelAndView mav = new ModelAndView("terms/copyright");
		return mav;
	}

	@RequestMapping(value="/advertisement",method = RequestMethod.GET)
	public ModelAndView moveAdvertisementPage() throws Exception {
		ModelAndView mav = new ModelAndView("terms/advertisement");
		return mav;
	}

	@RequestMapping(value="/guide",method = RequestMethod.GET)
	public ModelAndView moveGuidePage() throws Exception {
		ModelAndView mav = new ModelAndView("terms/guide");
		return mav;
	}
}
