package com.watcher.business.login.service;

import com.watcher.business.member.mapper.MemberMapper;
import com.watcher.business.login.param.LoginParam;
import com.watcher.business.member.param.MemberParam;
import com.watcher.util.JwtTokenUtil;
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

    public Map<String, String> loginSuccessCallback(HttpServletRequest request, LoginParam loginVo) throws Exception {
        Map<String, String> result = new HashMap<String, String>();

        if (!(loginVo.getId() == null || loginVo.getId().isEmpty())) {

            MemberParam memParam = new MemberParam();
            memParam.setLoginId(loginVo.getId());
            memParam.setMemType(("naver".equals(loginVo.getType()) ? "00" : "01"));

            Map<String, Object> userData = memberMapper.userSearch(memParam);


            result.put("loginId", String.valueOf(userData.get("LOGIN_ID")));
            result.put("loginType", ("00".equals(userData.get("MEM_TYPE")) ? "naver" : "kakao"));
            result.put("memberId", String.valueOf(userData.get("ID")));
            result.put("memProfileImg", String.valueOf(userData.get("MEM_PROFILE_IMG")));

            String jwt = JwtTokenUtil.createJWT(request.getSession().getId());
            result.put("apiToken", jwt);

            userData.put("apiToken", jwt);

            RedisUtil.setSession(request.getSession().getId(), userData);
        }

        result.put("sessionId", request.getSession().getId());

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}
