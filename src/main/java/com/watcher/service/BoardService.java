package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.vo.NoticeVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Service
public class BoardService {

    @Autowired
    BoardMapper boardMapper;


    public void views_count(String contentsType, String contentsId, String loginId){

        LinkedHashMap param = new LinkedHashMap();

        param.put("contentsType", contentsType  );
        param.put("contentsId"  , contentsId    );

        boardMapper.views_count(param);

    }

}
