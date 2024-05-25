package com.watcher.business.management.service.implementation;

import com.watcher.business.management.mapper.ManagementMapper;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.member.mapper.MemberMapper;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.enums.ResponseCode;
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
    public Map<String, Object> getStorySettingInfo(ManagementParam managementParam) throws Exception {
        return managementMapper.getStorySettingInfo(managementParam);
    }

    @Transactional
    @Override
    public Map<String, String> updateStorySettingInfo(ManagementParam managementParam) throws Exception {
        Map<String, String> result = new HashMap<String, String>();

        managementMapper.updateStorySettingInfo(managementParam);

        result.put("code", ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }
}
