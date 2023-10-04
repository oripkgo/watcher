package com.watcher.business.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.watcher.business.member.service.MemberService;


@Controller
public class MemberController {
	
	@Autowired
	MemberService memberSv;
	
}
