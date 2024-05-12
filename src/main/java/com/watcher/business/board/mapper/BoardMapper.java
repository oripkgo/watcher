package com.watcher.business.board.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface BoardMapper {

	// 좋아요, 공감
	public Map<String, String> selectLikeYn(Map<String,Object> param);
	public void insertLike(Map<String,Object> param);
	public void updateLike(Map<String,Object> param);


	// 댓글
	public int selectCommentCnt(Map<String,Object> param);
	public List<Map<String, String>> selectComment(Map<String,Object> param);
	public void insertComment(Map<String,Object> param);
	public void updateComment(Map<String,Object> param);
	public void deleteComment(Map<String,Object> param);


	// 게시글 상세
	public void insertViewsCount(Map<String,Object> param);

	//  게시글 태그
	public Map<String, String> selectTagDatas(Map<String,Object> param);
	public void insertTag(Map<String,Object> param);
	public void updateTag(Map<String,Object> param);
	public void deleteTag(Map<String,Object> param);

}
