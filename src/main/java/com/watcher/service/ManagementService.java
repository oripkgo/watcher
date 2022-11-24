package com.watcher.service;

import com.watcher.mapper.ManagementMapper;
import com.watcher.param.ManagementParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class ManagementService {

    @Autowired
    ManagementMapper managementMapper;


    @Transactional
    public Map<String, String> getVisitorCnt(ManagementParam managementParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        Map<String, Object> visitInfo = managementMapper.getVisitorCnt(managementParam);
        result.put("visitInfo", visitInfo);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Transactional
    public Map<String, String> getChartVisitorCnt(ManagementParam managementParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = managementMapper.getChartVisitorCntList(managementParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Transactional
    public Map<String, String> getPopularityArticles(ManagementParam managementParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = managementMapper.getPopularityArticleList(managementParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    public Map<String, Object> getManagementDatas(ManagementParam managementParam) throws Exception {
        return managementMapper.getManagerSettings(managementParam);
    }

    /*@Transactional
    public Map<String, String> updateStory(StoryParam storyParam) throws Exception {
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
