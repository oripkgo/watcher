package com.watcher.business.comm.controller;

import com.watcher.business.comm.dto.CommDto;
import com.watcher.business.comm.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.story.service.StoryService;
import com.watcher.util.RedisUtil;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping(value = "/comm")
public class CommController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @Autowired
    SignService signService;

    @ResponseBody
    @RequestMapping(value = {"/category/list"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryList(@ModelAttribute("vo") CommDto commDto) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        JSONArray jsonArray = new JSONArray().putAll(categoryService.getCategorys());

        result.put("category_list", jsonArray.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @ResponseBody
    @RequestMapping(value = {"/category/list/member"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryListMember(HttpServletRequest request) throws Exception {
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("memId", RedisUtil.getSession(sessionId).get("ID"));
        JSONArray jsonArray = new JSONArray().putAll(categoryService.getCategoryMember(param));

        result.put("member_category_list", jsonArray.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @ResponseBody
    @RequestMapping(value = {"/category/list/member/public"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryListMemberPublic(HttpServletRequest request) throws Exception {
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("memId", RedisUtil.getSession(sessionId).get("ID"));
        param.put("showYn", "Y");
        JSONArray jsonArray = new JSONArray().putAll(categoryService.getCategoryMember(param));

        result.put("member_category_list", jsonArray.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @ResponseBody
    @RequestMapping(value = {"/token"}, method = RequestMethod.POST)
    public LinkedHashMap<String, Object> getTokenNonMember(
            @RequestBody Map<String, String> resultMap
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String token = resultMap.get("token");
        String apiToken = "";
        String loginYn = "N";
        String code = "0000";
        String msg = "OK";
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
