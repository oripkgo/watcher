package com.watcher.service;

import java.util.HashMap;
import java.util.Map;

import com.watcher.mapper.ManagementMapper;
import com.watcher.param.ManagementParam;
import com.watcher.param.MemberParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.watcher.mapper.MemberMapper;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberService {
    @Autowired
    MemberMapper memberMapper;

    @Autowired
    ManagementMapper managementMapper;

    @Transactional
    public Map<String, String> insertUpdate(MemberParam memberParam) throws Exception {
        Map<String, String> result = new HashMap<String, String>();

        memberMapper.insert(memberParam);
        memberMapper.insertDetail(memberParam);

        ManagementParam managementParam = new ManagementParam();
        managementParam.setLoginId(memberParam.getLoginId());
        managementParam.setCommentPermStatus("01");
        managementMapper.insertManagement(managementParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}
