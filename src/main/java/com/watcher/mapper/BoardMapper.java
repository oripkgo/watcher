package com.watcher.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.Map;


@Mapper
public interface BoardMapper {
	
	public void views_count(Map<String,Object> param);

}
