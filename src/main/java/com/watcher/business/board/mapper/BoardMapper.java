package com.watcher.business.board.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface BoardMapper {

	// 좋아요, 공감
	public Map<String, String> getLikeYn(Map<String,Object> param);
	public void insertLike(Map<String,Object> param);
	public void updateLike(Map<String,Object> param);


	// 댓글
	public int comment_select_cnt(Map<String,Object> param);
	public List<Map<String, String>> comment_select(Map<String,Object> param);
	public void insertComment(Map<String,Object> param);
	public void updateComment(Map<String,Object> param);
	public void deleteComment(Map<String,Object> param);


	// 게시글 상세
	public void views_count(Map<String,Object> param);

	//  게시글 태그
	public Map<String, String> getTagDatas(Map<String,Object> param);
	public void tag_insert(Map<String,Object> param);
	public void tag_update(Map<String,Object> param);


}
