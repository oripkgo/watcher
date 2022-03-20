package com.watcher.mapper;

import java.util.HashMap;
import java.util.List;

import com.watcher.dto.MemberDto;


public interface MemberMapper {
	
	public List<MemberDto> callMember() throws Exception;

}
