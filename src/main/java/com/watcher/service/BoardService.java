package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class BoardService {

    @Autowired
    BoardMapper boardMapper;


    public void views_count(String contentsType, String contentsId, String loginId) throws Exception {

        LinkedHashMap param = new LinkedHashMap();

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );

        boardMapper.views_count(param);

    }

    public int comment_select_cnt(LinkedHashMap param) throws Exception {
        return boardMapper.comment_select_cnt(param);

    }

    public Map<String, Object> comment_select(LinkedHashMap param) throws Exception {

        Map<String, Object> result = new LinkedHashMap<>();

        List<Map<String,String>> list = boardMapper.comment_select(param);
        if( result == null ){
            list = new ArrayList<>();
        }

        result.put("list", list);

        return result;

    }

    public Map<String, Object> comment_select_info(LinkedHashMap param) throws Exception {

        Map<String, Object> result = new LinkedHashMap<>();

        result.put("cnt", comment_select_cnt(param));
        result.putAll(comment_select(param));

        return result;

    }

    public Map<String, String> comment_insert(LinkedHashMap param) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        boardMapper.comment_insert(param);
        result.putAll(param);

        return result;
    }


    public Map<String, String> comment_update(LinkedHashMap param) throws Exception {

        LinkedHashMap result = new LinkedHashMap();
        boardMapper.comment_update(param);

        return result;
    }

    public Map<String, String> comment_delete(LinkedHashMap param) throws Exception {

        LinkedHashMap result = new LinkedHashMap();
        boardMapper.comment_delete(param);

        return result;
    }



    public Map<String, String> view_tags_select(String contentsType, String contentsId) throws Exception {

        LinkedHashMap param = new LinkedHashMap();
        Map<String, String> result = null;

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );

        result = boardMapper.view_tags_select(param);

        if( result == null ){
            result = new LinkedHashMap<>();
            result.put("tags","");

        }

        return result;

    }


    public Map<String, String> view_like_yn_select(String contentsType, String contentsId, String loginId) throws Exception {

        LinkedHashMap param = new LinkedHashMap();
        Map<String, String> result = null;

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );
        param.put("loginId"     , loginId       );

        result = boardMapper.view_like_yn_select(param);

        if( result == null ){
            result = new LinkedHashMap<>();
        }

        return result;

    }

    public void like_insert(Map<String, Object> param) throws Exception {
        boardMapper.like_insert(param);
    }

    public void like_update(Map<String, Object> param) throws Exception {
        boardMapper.like_update(param);

    }

}
