package com.watcher.business.member.service.implementation;

import java.util.HashMap;
import java.util.Map;

import com.watcher.business.management.mapper.ManagementMapper;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.business.member.param.MemberParam;
import com.watcher.business.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.watcher.business.member.mapper.MemberMapper;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberServiceImpl implements MemberService {
    @Autowired
    MemberMapper memberMapper;

    @Autowired
    ManagementMapper managementMapper;

    @Override
    public Map<String,Object> search(String id, String type) throws Exception{
        MemberParam memParam = new MemberParam();
        memParam.setLoginId(id);
        memParam.setMemType(("naver".equals(type) ? "00" : "01"));

        return memberMapper.search(memParam);
    }

    @Transactional
    @Override
    public Map<String, String> insertUpdate(MemberParam memberParam) throws Exception {
        Map<String, String> result = new HashMap<String, String>();

        memberMapper.insert(memberParam);
        memberMapper.insertDetail(memberParam);

        ManagementParam managementParam = new ManagementParam();
        managementParam.setLoginId(memberParam.getLoginId());
        managementParam.setCommentPermStatus("01");
        managementParam.setStoryTitle(memberParam.getNickname() + "스토리");

        managementMapper.insertManagement(managementParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}
