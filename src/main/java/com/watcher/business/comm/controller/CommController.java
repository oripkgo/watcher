package com.watcher.business.comm.controller;

import com.watcher.business.login.service.SignService;
import com.watcher.business.story.service.StoryService;
import com.watcher.enums.ResponseCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping(value = "/comm")
public class CommController {


    @Autowired
    StoryService storyService;

    @Autowired
    SignService signService;


    @ResponseBody
    @RequestMapping(value = {"/token"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getTokenNonMember(
            @RequestParam Map<String, String> resultMap
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String token = resultMap.get("token");
        String apiToken = "";
        String loginYn = "N";
        String code = ResponseCode.SUCCESS_0000.getCode();
        String msg = ResponseCode.SUCCESS_0000.getMessage();
        String id = UUID.randomUUID().toString();

        if(StringUtils.hasText(token)){
            try{
                String sessionId = signService.getSessionId(token);

                if( signService.getSessionUser(sessionId) == null ){
                    apiToken = signService.getToken(id);
                }else{
                    loginYn = "Y";
                    apiToken = signService.getToken(sessionId);
                }
            }catch (Exception e){
                apiToken = signService.getToken(id);
            }
        }else{
            apiToken = signService.getToken(id);
        }

        result.put("loginYn", loginYn);
        result.put("apiToken", apiToken);
        result.put("code", code);
        result.put("message", msg);

        return result;
    }
}
