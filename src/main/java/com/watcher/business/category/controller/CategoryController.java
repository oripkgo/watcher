package com.watcher.business.category.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.comm.dto.CommDto;
import com.watcher.business.login.service.SignService;
import com.watcher.enums.ResponseCode;
import com.watcher.util.RedisUtil;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/category")
public class CategoryController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    SignService signService;

    @Autowired
    RedisUtil redisUtil;


    @ResponseBody
    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getListCategory(@ModelAttribute("vo") CommDto commDto) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        JSONArray jsonArray = new JSONArray().putAll(categoryService.getListCategory());

        result.put("categoryList", jsonArray.toString());
        result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }


    @ResponseBody
    @RequestMapping(value = {"/list/member"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getListCategoryMember(HttpServletRequest request) throws Exception {
        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("memId", redisUtil.getSession(sessionId).get("ID"));
        JSONArray jsonArray = new JSONArray().putAll(categoryService.getListCategoryMember(param));

        result.put("memberCategoryList", jsonArray.toString());
        result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }

    @ResponseBody
    @RequestMapping(value = {"/list/member/public"}, method = RequestMethod.GET)
    public LinkedHashMap<String, Object> getCategoryListMemberPublic(@RequestParam("memId") String memId) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("memId", memId);
        param.put("showYn", "Y");
        JSONArray jsonArray = new JSONArray().putAll(categoryService.getListCategoryMember(param));

        result.put("memberCategoryList", jsonArray.toString());
        result.put("code"	, ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }
}
