package com.watcher.service;

import java.util.HashMap;
import java.util.Map;

import com.watcher.vo.MemberVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.watcher.mapper.MemberMapper;

@Service
public class MemberService {


   @Autowired
   MemberMapper memberMapper;

    public Map<String,String> insertUpdate(MemberVo memberVo) throws Exception{
        Map<String,String> result = new HashMap<String,String>();

        memberMapper.insert(memberVo);


        result.put("code","0000");
        result.put("message","OK");


        return result;
    }

}
