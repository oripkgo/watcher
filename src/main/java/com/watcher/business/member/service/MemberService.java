package com.watcher.business.member.service;

import com.watcher.business.member.param.MemberParam;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

public interface MemberService {
    public Map<String,Object> select(MemberParam memberParam) throws Exception;

    @Transactional
    public Map<String, String> insertUpdate(MemberParam memberParam) throws Exception;
}
