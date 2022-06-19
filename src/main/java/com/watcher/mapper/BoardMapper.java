package com.watcher.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface BoardMapper {

	public void like_insert(Map<String,Object> param);
	public void like_update(Map<String,Object> param);

	public int comment_select_cnt(Map<String,Object> param);
	public List<Map<String, String>> comment_select(Map<String,Object> param);
	public void comment_insert(Map<String,Object> param);

	public void views_count(Map<String,Object> param);
	public Map<String, String> view_like_yn_select(Map<String,Object> param);
	public Map<String, String> view_tags_select(Map<String,Object> param);

	public void tag_insert(Map<String,Object> param);
	public void tag_update(Map<String,Object> param);


}
