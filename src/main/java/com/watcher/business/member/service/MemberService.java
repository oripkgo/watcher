package com.watcher.business.member.service;

import com.watcher.business.member.param.MemberParam;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

public interface MemberService {
    public Map<String,Object> getUserData(String id, String type) throws Exception;

    @Transactional
    public Map<String, String> insertUpdate(MemberParam memberParam) throws Exception;
}
