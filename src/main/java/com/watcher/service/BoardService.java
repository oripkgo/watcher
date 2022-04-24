package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;


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

}
