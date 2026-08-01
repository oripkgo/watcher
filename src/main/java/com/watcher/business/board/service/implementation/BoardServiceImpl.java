package com.watcher.business.board.service.implementation;

import com.watcher.business.board.mapper.BoardMapper;
import com.watcher.business.board.param.BoardParam;
import com.watcher.business.board.service.BoardService;
import com.watcher.business.story.mapper.StoryMapper;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class BoardServiceImpl implements BoardService {

  @Autowired
  BoardMapper boardMapper;

  @Autowired
  StoryMapper storyMapper;


  @Override
  public void insertLike(BoardParam boardParam) throws Exception {
    boardMapper.insertLike(boardParam);
  }


  @Override
  public void updateLike(BoardParam boardParam) throws Exception {
    boardMapper.updateLike(boardParam);
  }


  @Override
  public Map<String, String> getTagDatas(String contentsType, String contentsId) throws Exception {
    Map<String, String> result = null;

    BoardParam boardParam = new BoardParam();

    boardParam.setContentsId(contentsId);
    boardParam.setContentsType(contentsType);

    result = boardMapper.selectTagDatas(boardParam);

    if (result == null) {
      result = new LinkedHashMap<>();
      result.put("tags", "");

    }

    return result;
  }


  @Override
  public Map<String, String> getLikeYn(String contentsType, String contentsId, String loginId)
      throws Exception {
    Map<String, String> result = null;

    BoardParam boardParam = new BoardParam();
    boardParam.setContentsType(contentsType);
    boardParam.setContentsId(contentsId);
    boardParam.setLoginId(loginId);

    result = boardMapper.selectLikeYn(boardParam);

    if (result == null) {
      result = new LinkedHashMap<>();
    }

    return result;
  }

  // 댓글


  @Override
  public int getCommentListCnt(LinkedHashMap param) throws Exception {
    return boardMapper.selectCommentCnt(param);
  }

  @Override
  public Map<String, Object> getCommentList(LinkedHashMap param) throws Exception {
    Map<String, Object> result = new LinkedHashMap<>();

    List<Map<String, String>> list = boardMapper.selectComment(param);
    if (result == null) {
      list = new ArrayList<>();
    }

    result.put("list", list);

    return result;
  }

  @Override
  public Map<String, Object> getCommentInfo(LinkedHashMap param) throws Exception {
    Map<String, Object> result = new LinkedHashMap<>();

    result.put("cnt", getCommentListCnt(param));
    result.putAll(getCommentList(param));

    return result;
  }

  @Override
  public Map<String, String> insertComment(LinkedHashMap param) throws Exception {
    LinkedHashMap result = new LinkedHashMap();
    boardMapper.insertComment(param);
    result.putAll(param);

    storyMapper.updateCommentCountUp(Integer.valueOf(param.get("contentsId").toString()));

    return result;
  }

  @Override
  public Map<String, String> updateComment(LinkedHashMap param) throws Exception {
    LinkedHashMap result = new LinkedHashMap();
    boardMapper.updateComment(param);

    return result;
  }

  @Override
  public Map<String, String> deleteComment(LinkedHashMap param) throws Exception {
    LinkedHashMap result = new LinkedHashMap();

    int commentId = Integer.valueOf(param.get("commentId").toString());

    Map<String, Object> comment = boardMapper.selectCommentOne(commentId);

    boardMapper.deleteComment(param);

    int storyId = Integer.parseInt(comment.get("CONTENTS_ID").toString());
    storyMapper.updateCommentCountDown(storyId);

    return result;
  }


}
