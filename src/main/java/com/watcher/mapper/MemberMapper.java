package com.watcher.mapper;

import java.util.HashMap;
import java.util.List;

import com.watcher.vo.MemberVo;


public interface MemberMapper {
	
	public List<MemberVo> callMember() throws Exception;

}
