package com.watcher.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.watcher.service.MemberService;


@Controller
public class MemberController {
	
	@Autowired
	MemberService memberSv;
	
}
