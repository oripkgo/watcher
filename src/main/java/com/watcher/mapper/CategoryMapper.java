package com.watcher.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface CategoryMapper {

	public List<Map<String, String>> category_list(Map<String,Object> param);



}
