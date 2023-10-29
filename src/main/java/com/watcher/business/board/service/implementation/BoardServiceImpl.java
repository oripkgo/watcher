package com.watcher.business.board.service.implementation;

import com.watcher.business.board.mapper.BoardMapper;
import com.watcher.business.board.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    BoardMapper boardMapper;

    @Override
    public void getViewsCount(String contentsType, String contentsId, String loginId) throws Exception {
        LinkedHashMap param = new LinkedHashMap();

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );

        boardMapper.selectViewsCount(param);
    }

    @Override
    public int getCommentListCnt(LinkedHashMap param) throws Exception {
        return boardMapper.selectCommentCnt(param);
    }

    @Override
    public Map<String, Object> getCommentList(LinkedHashMap param) throws Exception {
        Map<String, Object> result = new LinkedHashMap<>();

        List<Map<String,String>> list = boardMapper.selectComment(param);
        if( result == null ){
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
        boardMapper.deleteComment(param);

        return result;
    }

    @Override
    public Map<String, String> getTagDatas(String contentsType, String contentsId) throws Exception {
        LinkedHashMap param = new LinkedHashMap();
        Map<String, String> result = null;

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );

        result = boardMapper.selectTagDatas(param);

        if( result == null ){
            result = new LinkedHashMap<>();
            result.put("tags","");

        }

        return result;
    }

    @Override
    public Map<String, String> getLikeYn(String contentsType, String contentsId, String loginId) throws Exception {
        LinkedHashMap param = new LinkedHashMap();
        Map<String, String> result = null;

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );
        param.put("loginId"     , loginId       );

        result = boardMapper.selectLikeYn(param);

        if( result == null ){
            result = new LinkedHashMap<>();
        }

        return result;
    }

    @Override
    public void insertLike(Map<String, Object> param) throws Exception {
        boardMapper.insertLike(param);
    }

    @Override
    public void updateLike(Map<String, Object> param) throws Exception {
        boardMapper.updateLike(param);
    }
}
