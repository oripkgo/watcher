package com.watcher.business.management.service.implementation;

import com.watcher.business.management.mapper.ManagementMapper;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.member.mapper.MemberMapper;
import com.watcher.business.management.param.ManagementParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
public class ManagementServiceImpl implements ManagementService {

    @Autowired
    ManagementMapper managementMapper;

    @Autowired
    MemberMapper memberMapper;

    @Override
    public Map<String, Object> getStorySettingInfo(String contentType, String contentId) throws Exception {
        ManagementParam managementParam = new ManagementParam();
        managementParam.setSearchContentType(contentType);
        managementParam.setSearchContentId(contentId);
        return managementMapper.getStorySettingInfo(managementParam);
    }


    @Override
    public Map<String, Object> getStorySettingInfo(ManagementParam managementParam) throws Exception {
        return managementMapper.getStorySettingInfo(managementParam);
    }


    @Transactional
    @Override
    public void updateStorySettingInfo(ManagementParam managementParam) throws Exception {
        managementMapper.updateStorySettingInfo(managementParam);
    }

}
