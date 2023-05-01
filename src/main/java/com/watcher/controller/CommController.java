package com.watcher.controller;

import com.watcher.dto.CommDto;
import com.watcher.service.CategoryService;
import com.watcher.service.StoryService;
import com.watcher.util.JwtTokenUtil;
import org.json.JSONArray;
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
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @ResponseBody
    @RequestMapping(value = {"/category/list"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> showStoryListPage(@ModelAttribute("vo") CommDto commDto) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        JSONArray jsonArray = new JSONArray().putAll(categoryService.category_list());

        result.put("category_list", jsonArray.toString());
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

        if(StringUtils.hasText(token)){
            try{
                apiToken = JwtTokenUtil.extendExpirationTime(token);
            }catch (Exception e){
                result.put("code", "9999");
                result.put("message", "토큰 검증을 실패하였습니다.");
            }
        }else{
            String uuid = UUID.randomUUID().toString();
            apiToken = JwtTokenUtil.createJWT(uuid);
        }

        result.put("apiToken", apiToken);
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}
