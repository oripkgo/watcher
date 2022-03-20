package com.watcher.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.watcher.dto.MemberDto;
import com.watcher.mapper.MemberMapper;


@Service
public class MemberService {

	@Autowired
	MemberMapper memMapper;
	
	public List<MemberDto> callMember() throws Exception{
		
		return memMapper.callMember();
	}
}
