package com.watcher.business.category.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.comm.dto.CommDto;
import com.watcher.business.login.service.SignService;
import com.watcher.util.RedisUtil;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/category")
public class CategoryController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    SignService signService;


    @ResponseBody
    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryList(@ModelAttribute("vo") CommDto commDto) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        JSONArray jsonArray = new JSONArray().putAll(categoryService.getCategorys());

        result.put("categoryList", jsonArray.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @ResponseBody
    @RequestMapping(value = {"/list/member"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryListMember(HttpServletRequest request) throws Exception {
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("memId", RedisUtil.getSession(sessionId).get("ID"));
        JSONArray jsonArray = new JSONArray().putAll(categoryService.getCategoryMember(param));

        result.put("memberCategoryList", jsonArray.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @ResponseBody
    @RequestMapping(value = {"/list/member/public"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryListMemberPublic(HttpServletRequest request) throws Exception {
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("memId", RedisUtil.getSession(sessionId).get("ID"));
        param.put("showYn", "Y");
        JSONArray jsonArray = new JSONArray().putAll(categoryService.getCategoryMember(param));

        result.put("memberCategoryList", jsonArray.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}
