package com.watcher.business.comm.controller;

import com.watcher.business.login.service.SignService;
import com.watcher.business.member.param.MemberParam;
import com.watcher.business.member.service.MemberService;
import com.watcher.business.story.service.StoryService;
import com.watcher.enums.ResponseCode;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.SessionUtil;
import io.jsonwebtoken.Claims;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/comm")
public class CommController {


    @Autowired
    StoryService storyService;

    @Autowired
    SignService signService;

    @Autowired
    MemberService memberService;

    @Autowired
    private SessionUtil sessionUtil;


    @ResponseBody
    @PostMapping("/refresh-token")
    public LinkedHashMap<String, Object> refreshToken(
        HttpServletRequest request,
        @RequestBody Map<String, String> resultMap
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        String token = resultMap.get("token");

        // 1. 토큰이 없거나 유효하지 않은 경우 -> 신규 토큰 발급
        Claims claims = null;
        if (StringUtils.hasText(token)) {
            claims = JwtTokenUtil.getClaims(token);
        }

        if (!StringUtils.hasText(token) || claims == null) {
            String sessionId = request.getSession().getId();
            result.put("apiToken", JwtTokenUtil.createJWT(sessionId));
            result.put("code", ResponseCode.SUCCESS_0000.getCode());
            result.put("message", ResponseCode.SUCCESS_0000.getMessage());
            return result;
        }

        // 2. 토큰이 유효한 회원인 경우 처리
        String sessionId = claims.getId();
        String loginId = (String) claims.get("loginId");
        long remainingSeconds = JwtTokenUtil.getRemainingSeconds(token);

        try {
            Object sessionUser = signService.getSessionUser(sessionId);
            if (sessionUser == null || ((Map<?, ?>) sessionUser).isEmpty()) {
                MemberParam memberParam = new MemberParam();
                memberParam.setLoginId(loginId);
                Map<String, Object> userData = memberService.select(memberParam);

                sessionUtil.setSession(sessionId, userData, (int) remainingSeconds);
            }

            result.put("apiToken", token);
            result.put("code", ResponseCode.SUCCESS_0000.getCode());
            result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        } catch (Exception e) {
            throw new Exception("2102", e);
        }

        return result;
    }
}
