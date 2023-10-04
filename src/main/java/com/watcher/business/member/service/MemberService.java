package com.watcher.business.member.service;

import java.util.HashMap;
import java.util.Map;

import com.watcher.business.management.mapper.ManagementMapper;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.business.member.param.MemberParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.watcher.business.member.mapper.MemberMapper;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberService {
    @Autowired
    MemberMapper memberMapper;

    @Autowired
    ManagementMapper managementMapper;

    public Map<String,Object> getUserData(String id, String type) throws Exception{
        MemberParam memParam = new MemberParam();
        memParam.setLoginId(id);
        memParam.setMemType(("naver".equals(type) ? "00" : "01"));

        return memberMapper.userSearch(memParam);
    }

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
