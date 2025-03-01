package com.watcher.business.board.mapper;

import com.watcher.business.board.param.BoardParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface BoardMapper {

	// 좋아요, 공감
	public Map<String, String> selectLikeYn(BoardParam boardParam);
	public void insertLike(BoardParam boardParam);
	public void updateLike(BoardParam boardParam);


	// 댓글
	public int selectCommentCnt(Map<String,Object> param);
	public List<Map<String, String>> selectComment(Map<String,Object> param);
	public void insertComment(Map<String,Object> param);
	public void updateComment(Map<String,Object> param);
	public void deleteComment(Map<String,Object> param);


	//  게시글 태그
	public Map<String, String> selectTagDatas(BoardParam boardParam);
	public void insertTag(Map<String,Object> param);
	public void updateTag(Map<String,Object> param);
	public void deleteTag(Map<String,Object> param);

}
