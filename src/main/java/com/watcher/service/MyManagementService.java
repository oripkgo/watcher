package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.MyManagementMapper;
import com.watcher.mapper.StoryMapper;
import com.watcher.param.FileParam;
import com.watcher.param.ManagementParam;
import com.watcher.param.StoryParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class MyManagementService {

    @Autowired
    MyManagementMapper myManagementMapper;


    @Transactional
    public Map<String, String> getVisitorCnt(ManagementParam managementParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        Map<String, Object> visitInfo = myManagementMapper.getVisitorCnt(managementParam);
        result.put("visitInfo", visitInfo);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Transactional
    public Map<String, String> getChartVisitorCnt(ManagementParam managementParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = myManagementMapper.getChartVisitorCntList(managementParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Transactional
    public Map<String, String> getPopularityArticles(ManagementParam managementParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = myManagementMapper.getPopularityArticleList(managementParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }




    /*@Transactional
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

    public Map<String, Object> view(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", storyMapper.view(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }*/


}
