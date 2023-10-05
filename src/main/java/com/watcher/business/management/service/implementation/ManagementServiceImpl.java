package com.watcher.business.management.service.implementation;

import com.watcher.business.management.mapper.ManagementMapper;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.member.mapper.MemberMapper;
import com.watcher.business.management.param.ManagementParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class ManagementServiceImpl implements ManagementService {

    @Autowired
    ManagementMapper managementMapper;

    @Autowired
    MemberMapper memberMapper;

    @Override
    public Map<String, Object> getManagementDatas(ManagementParam managementParam) throws Exception {
        return managementMapper.getManagerSettings(managementParam);
    }

    @Transactional
    @Override
    public Map<String, String> updateStorySetting(ManagementParam managementParam) throws Exception {
        Map<String, String> result = new HashMap<String, String>();

        managementMapper.updateManagement(managementParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    /*
    @Transactional
    @Override
    public Map<String, String> updateStory(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        storyMapper.update(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Override
    public Map<String, Object> list(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setTotalCnt( storyMapper.listCnt(storyParam) );
        result.put("list", storyMapper.list(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

    @Override
    public Map<String, Object> view(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", storyMapper.view(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }
    */
}
