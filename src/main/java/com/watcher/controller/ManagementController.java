package com.watcher.controller;

import com.watcher.param.*;
import com.watcher.service.*;
import com.watcher.util.JwtTokenUtil;
import com.watcher.util.RedisUtil;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/management")
public class ManagementController {
    @Autowired
    NoticeService noticeService;

    @Autowired
    CategoryService categoryService;

    @Autowired
    ManagementService managementService;

    @Autowired
    StoryService storyService;

    @Autowired
    MemberService memberService;

    @RequestMapping(value = {"/{menu}"})
    @ResponseBody
    public LinkedHashMap getManagementMainPage(
            @PathVariable("menu") String menu,
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") ManagementParam managementParam
    ) throws Exception {
        ModelAndView mav = null;
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        if( "main".equals(menu) ){

        }else if( "board".equals(menu) ){
            JSONArray jsonArray = new JSONArray().putAll(categoryService.story_category_serarch());
            result.put("category_list", jsonArray);
        }else if( "category".equals(menu) ){
            LinkedHashMap param = new LinkedHashMap();

            param.put("memId"     , RedisUtil.getSession(sessionId).get("ID") );
            //param.put("showYn"    , "Y"       );

            JSONArray member_category_list = new JSONArray().putAll(categoryService.member_category_list(param));
            result.put("member_category_list", member_category_list);

            JSONArray jsonArray = new JSONArray().putAll(categoryService.story_category_serarch());
            result.put("category_list", jsonArray);
        }else if( "notice".equals(menu) ){

        }else if( "setting".equals(menu) ){
            managementParam.setLoginId(RedisUtil.getSession(sessionId).get("LOGIN_ID"));
            JSONObject managementDatas = new JSONObject(managementService.getManagementDatas(managementParam));
            result.put("managementInfo", managementDatas);
        }else if( "statistics".equals(menu) ){

        }

        return result;
    }

    @RequestMapping(value = {"/board/popularity/storys"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularityStorys(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object memId = (RedisUtil.getSession(sessionId).get("ID"));
        storyParam.setSearch_memId(String.valueOf(memId));
        storyParam.setSearch_secret_yn("ALL");
        storyParam.setSortByRecommendationYn("YY");
        storyParam.setLimitNum("4");

        result.putAll(storyService.list(storyParam));
        result.put("vo", storyParam);

        return result;
    }

    @RequestMapping(value = {"/board/storys"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getStorys(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object memId = (RedisUtil.getSession(sessionId).get("ID"));
        storyParam.setSearch_memId(String.valueOf(memId));
        storyParam.setSearch_secret_yn("ALL");

        result.putAll(storyService.list(storyParam));
        result.put("vo", storyParam);

        return result;
    }

    @RequestMapping(value = {"/board/storys"}, method = RequestMethod.DELETE)
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStorys(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));

        storyService.deleteStorys(storyParam);

        return result;
    }

    @RequestMapping(value = {"/board/storys/private"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updatePrivate(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));
        storyParam.setSecretYn("Y");

        storyService.updateStorys(storyParam);

        return result;
    }

    @RequestMapping(value = {"/board/storys/public"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updatePublic(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));
        storyParam.setSecretYn("N");

        storyService.updateStorys(storyParam);

        return result;
    }

    @RequestMapping(value = {"/board/notices"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getNotices(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object memId = (RedisUtil.getSession(sessionId).get("ID"));

        noticeParam.setSearch_memId(String.valueOf(memId));

        if( noticeParam.getSearch_secret_yn() == null || noticeParam.getSearch_secret_yn().isEmpty() ){
            noticeParam.setSearch_secret_yn("ALL");
        }

        result.putAll(noticeService.list(noticeParam));
        result.put("vo", noticeParam);

        return result;
    }

    @RequestMapping(value = {"/board/notices"}, method = RequestMethod.DELETE)
    @ResponseBody
    public LinkedHashMap<String, Object> deleteNotices(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        noticeParam.setRegId(String.valueOf(loginId));
        noticeParam.setUptId(String.valueOf(loginId));

        result.putAll(noticeService.deletes(noticeParam));
        result.put("vo", noticeParam);

        return result;
    }

    @RequestMapping(value = {"/board/notices/public"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updatePublic(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        noticeParam.setRegId(String.valueOf(loginId));
        noticeParam.setUptId(String.valueOf(loginId));
        noticeParam.setSecretYn("N");

        result.putAll(noticeService.updates(noticeParam));
        result.put("vo", noticeParam);

        return result;
    }

    @RequestMapping(value = {"/board/notices/private"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updatePrivate(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        noticeParam.setRegId(String.valueOf(loginId));
        noticeParam.setUptId(String.valueOf(loginId));
        noticeParam.setSecretYn("Y");

        result.putAll(noticeService.updates(noticeParam));
        result.put("vo", noticeParam);

        return result;
    }


    @RequestMapping(value = {"/category/insert"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> insertCategory(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody MemberCategoryParam memberCategoryParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        memberCategoryParam.setRegId(String.valueOf(loginId));
        memberCategoryParam.setUptId(String.valueOf(loginId));
        memberCategoryParam.setLoginId(String.valueOf(loginId));

        result.putAll(categoryService.insertOrUpdate(memberCategoryParam));
        result.put("vo", memberCategoryParam);

        return result;
    }

    @RequestMapping(value = {"/setting/update"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updateSetting(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") ManagementParam managementParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = JwtTokenUtil.getId(request.getHeader("Authorization").replace("Bearer ", ""));

        Object loginId = (RedisUtil.getSession(sessionId).get("LOGIN_ID"));
        managementParam.setRegId(String.valueOf(loginId));
        managementParam.setUptId(String.valueOf(loginId));
        managementParam.setLoginId(String.valueOf(loginId));

        result.putAll(managementService.updateStorySetting(managementParam));
        result.put("vo", managementParam);

        return result;
    }
}
