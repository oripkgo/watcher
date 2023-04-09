package com.watcher.service;

import com.watcher.mapper.MemberMapper;
import com.watcher.param.LoginParam;
import com.watcher.param.MemberParam;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Service
public class LoginService {

    @Autowired
    MemberMapper memberMapper;

    public Map<String,String> loginSuccessCallback(HttpServletRequest request, LoginParam loginVo) throws Exception{
        Map<String,String> result = new HashMap<String,String>();

        if (!(loginVo.getId() == null || loginVo.getId().isEmpty())) {

            MemberParam memParam = new MemberParam();
            memParam.setLoginId(loginVo.getId());
            memParam.setMemType(("naver".equals(loginVo.getType()) ? "00" : "01"));

            Map<String, Object> userData = memberMapper.userSearch(memParam);

            RedisUtil.setSession(request.getSession().getId(), userData);
        }

        result.put("code","0000");
        result.put("message","OK");

        return result;
    }
}
