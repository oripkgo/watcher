package com.watcher.mapper;

import com.watcher.vo.MemberVo;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface MemberMapper {
	
	public void insert(MemberVo memberVo);

}
