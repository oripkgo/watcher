package com.watcher.business.login.service.implementation;

import com.watcher.business.login.param.SignParam;
import com.watcher.business.login.service.SignService;
import com.watcher.business.member.param.MemberParam;
import com.watcher.business.member.service.MemberService;
import com.watcher.util.HttpUtil;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Service
public class SignServiceImpl implements SignService {
    @Autowired
    MemberService memberService;

    @Value("${naver.client.id}")
    String naverClientId;

    @Value("${naver.client.secret}")
    String naverClientSecret;

    @Value("${kakao.logout.token}")
    String kakaoLogoutToken;

    String naverSignOutApiUrl = "https://nid.naver.com/oauth2.0/token";
    String kakaoSignOutApiUrl = "https://kapi.kakao.com/v1/user/unlink";


    @Override
    public String validation(String token) throws Exception {
        String sessionId;

        try {
            if (token == null || token.isEmpty()) {
                throw new Exception();
            }
        } catch (Exception e) {
            throw new Exception("2004");
        }

        try {
            sessionId = this.getSessionId(token);
            if (sessionId == null || sessionId.isEmpty()) {
                throw new Exception();
            }
        } catch (Exception e) {
            throw new Exception("2002");
        }

        try {
            if (this.getSessionUser(sessionId) == null || this.getSessionUser(sessionId).isEmpty()) {
                throw new Exception();
            }
        } catch (Exception e) {
            throw new Exception("2003");
        }

        return token;
    }

    @Override
    public void validation(SignParam signParam) throws Exception {

    }

    @Override
    public void handleIn(SignParam signParam, String sessionId) throws Exception {
        MemberParam memberParam = new MemberParam();

        memberParam.setLoginId(signParam.getId());
        memberParam.setMemType(("naver".equals(signParam.getType()) ? "00" : "01"));
        memberParam.setNickname(signParam.getNickname());
        memberParam.setName(signParam.getName());
        memberParam.setEmail(signParam.getEmail());
        memberParam.setGender(signParam.getGender());
        memberParam.setMemProfileImg(signParam.getProfile());

        Map<String, Object> userData = memberService.select(memberParam);

        if (userData == null || userData.size() == 0) {
            memberService.insertUpdate(memberParam);
        }

        if (!(signParam.getId() == null || signParam.getId().isEmpty())) {
            String jwt = JwtTokenUtil.createJWT(sessionId);

            userData = memberService.select(memberParam);

            userData.put("API_TOKEN", jwt);
            RedisUtil.setSession(sessionId, userData);
        }
    }

    @Override
    public void handleOut(SignParam signParam, String sessionId) throws Exception {
        String logOutUrl = "";
        Map<String, String> logOutHeaders = new LinkedHashMap<String, String>();
        Map<String, String> logOutParam = new LinkedHashMap<String, String>();

        if ("naver".equals(signParam.getType())) {
            logOutUrl = naverSignOutApiUrl;

            logOutParam.put("grant_type", "delete");
            logOutParam.put("client_id", naverClientId);
            logOutParam.put("client_secret", naverClientSecret);
            logOutParam.put("access_token", signParam.getAccess_token());
            logOutParam.put("service_provider", "NAVER");
        } else {
            logOutUrl = kakaoSignOutApiUrl;

            logOutParam.put("target_id_type", "user_id");
            logOutParam.put("target_id", String.valueOf(this.getSessionUser(sessionId).get("LOGIN_ID")));

            logOutHeaders.put("Authorization", "KakaoAK " + kakaoLogoutToken);
        }

        HttpUtil.httpRequest(logOutUrl, logOutParam, logOutHeaders);

        RedisUtil.remove(sessionId);
    }

    @Override
    public Map getSessionUser(String sessionId) throws Exception {
        Map result = RedisUtil.getSession(sessionId);
        return result == null || result.isEmpty() ? new HashMap() : result;
    }

    @Override
    public String getSessionToken(String sessionId) throws Exception {
        return RedisUtil.getSession(sessionId).get("API_TOKEN");
    }

    @Override
    public String getSessionId(String token) throws Exception {
        return JwtTokenUtil.getId(token);
    }

    @Override
    public String getToken(String sessionId) throws Exception {
        return JwtTokenUtil.createJWT(sessionId);
    }
}
