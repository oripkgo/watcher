package com.watcher.mapper;

import com.watcher.param.MemberParam;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface MemberMapper {
	
	public void insert(MemberParam memberParam);

}
