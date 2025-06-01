package com.watcher.business.login.service.implementation;

import com.watcher.business.login.param.SignParam;
import com.watcher.business.login.service.SignService;
import com.watcher.business.member.param.MemberParam;
import com.watcher.business.member.service.MemberService;
import com.watcher.enums.MemberType;
import com.watcher.util.HttpUtil;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Service
public class SignServiceImpl implements SignService {
    @Autowired
    SessionUtil sessionUtil;

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
            throw new Exception("2104");
        }

        try {
            sessionId = this.getSessionId(token);
            if (sessionId == null || sessionId.isEmpty()) {
                throw new Exception();
            }
        } catch (Exception e) {
            throw new Exception("2102");
        }

        try {
            if (this.getSessionUser(sessionId) == null || this.getSessionUser(sessionId).isEmpty()) {
                throw new Exception();
            }
        } catch (Exception e) {
            throw new Exception("2103");
        }

        return token;
    }

    @Override
    public void validation(SignParam signParam) throws Exception {

    }

    @Override
    public Map<String, Object> handleIn(SignParam signParam, String sessionId) throws Exception {
        MemberParam memberParam = new MemberParam();

        memberParam.setLoginId(signParam.getId());
        memberParam.setMemType(MemberType.fromName(signParam.getType()).getCode());
        memberParam.setNickname(signParam.getNickname());
        memberParam.setName(signParam.getName());
        memberParam.setEmail(signParam.getEmail());
        memberParam.setGender(signParam.getGender());
        memberParam.setMemProfileImg(signParam.getProfile());

        Map<String, Object> userData = memberService.select(memberParam);

        if (userData == null || userData.isEmpty()) {
            memberService.insertUpdate(memberParam);
            userData = memberService.select(memberParam);
        }

        return userData;
    }

    @Override
    public void handleOut(SignParam signParam, String sessionId) throws Exception {
        String logOutUrl = "";
        Map<String, String> logOutHeaders = new LinkedHashMap<String, String>();
        Map<String, String> logOutParam = new LinkedHashMap<String, String>();

        if ( MemberType.NAVER.getName().equals(signParam.getType())) {
            logOutUrl = naverSignOutApiUrl;

            logOutParam.put("grant_type"        , "delete"                   );
            logOutParam.put("client_id"         , naverClientId              );
            logOutParam.put("client_secret"     , naverClientSecret          );
            logOutParam.put("access_token"      , signParam.getAccessToken() );
            logOutParam.put("service_provider"  , MemberType.NAVER.toString());
        } else {
            logOutUrl = kakaoSignOutApiUrl;

            logOutParam.put("target_id_type"    , "user_id"         );
            logOutParam.put("target_id"         , signParam.getId() );

            logOutHeaders.put("Authorization", "KakaoAK " + kakaoLogoutToken);
        }

        HttpUtil.requestHttp(logOutUrl, logOutParam, logOutHeaders);

        if( sessionId != null ){
            sessionUtil.remove(sessionId);
        }
    }

    @Override
    public boolean isSessionUser(String sessionId) throws Exception {
        Map result = sessionUtil.getSession(sessionId);
        return result == null || result.isEmpty();
    }

    @Override
    public Map<String, String> getSessionUser(String sessionId) throws Exception {
        Map<String, String> result = sessionUtil.getSession(sessionId);
        return result == null || result.isEmpty() ? new HashMap<String, String>() : result;
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
