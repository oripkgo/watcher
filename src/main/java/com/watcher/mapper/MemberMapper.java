package com.watcher.mapper;

import java.util.HashMap;
import java.util.List;

import com.watcher.vo.MemberVo;
import org.apache.ibatis.annotations.Mapper;

import javax.annotation.Resource;


@Mapper
public interface MemberMapper {
	
	public List<MemberVo> callMember() throws Exception;


	public void insert(MemberVo memberVo) throws Exception;

}
