package com.watcher.business.member.service;

import com.watcher.business.member.param.MemberParam;

import java.util.Map;

public interface MemberService {
    public Map<String,Object> select(MemberParam memberParam) throws Exception;

    public void insertUpdate(MemberParam memberParam) throws Exception;
}
