package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.StoryMapper;
import com.watcher.param.NoticeParam;
import com.watcher.param.StoryParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class StoryService {

    @Autowired
    StoryMapper storyMapper;

    @Autowired
    BoardMapper boardMapper;

    @Transactional
    public Map<String, String> story_insert(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        storyMapper.insert(storyParam);

        Map<String,Object> tag_insert_param = new LinkedHashMap<String,Object>();
        tag_insert_param.put("contentsType" , "STORY"                   );
        tag_insert_param.put("contentsId"   , storyParam.getId()        );
        tag_insert_param.put("tags"         , storyParam.getTags()      );
        tag_insert_param.put("regId"        , storyParam.getRegId()     );
        tag_insert_param.put("uptId"        , storyParam.getUptId()     );

        boardMapper.tag_insert(tag_insert_param);


        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, String> story_update(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        storyMapper.update(storyParam);


        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    public Map<String, Object> list(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setTotalCnt( storyMapper.listCnt(storyParam) );
        result.put("list", storyMapper.list(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }


}
