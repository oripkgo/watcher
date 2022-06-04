package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.StoryMapper;
import com.watcher.param.NoticeParam;
import com.watcher.param.StoryParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class StoryService {

    @Autowired
    StoryMapper storyMapper;


    public Map<String, Object> list(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setTotalCnt( storyMapper.listCnt(storyParam) );
        result.put("list", storyMapper.list(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }


}
