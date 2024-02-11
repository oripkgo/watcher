package com.watcher.business.management.controller;

import com.watcher.business.board.param.NoticeParam;
import com.watcher.business.board.service.NoticeService;
import com.watcher.business.category.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.business.management.param.MemberCategoryParam;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.member.service.MemberService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
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
public class MyStoryManagementController {
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

    @Autowired
    SignService signService;


    @RequestMapping(value = {"/main"}, method = RequestMethod.GET)
    public ModelAndView moveMain() throws Exception {
        ModelAndView mv = new ModelAndView("management/index");
        return mv;
    }

    @RequestMapping(value = {"/board/popularity/storys"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularityStorys(
        HttpServletRequest request,
        HttpServletResponse response,
        StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        storyParam.setSearch_memId(String.valueOf(signService.getSessionUser(sessionId).get("ID")));

        result.put("list", storyService.getListManagemenPopular(storyParam));
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/storys"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getStorys(
        HttpServletRequest request,
        HttpServletResponse response,
        StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        storyParam.setSearch_memId(String.valueOf(signService.getSessionUser(sessionId).get("ID")));

        result.putAll(storyService.getListManagement(storyParam));
        result.put("dto", storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/storys"}, method = RequestMethod.DELETE)
    @ResponseBody
    public LinkedHashMap<String, Object> deleteStorys(
        HttpServletRequest request,
        HttpServletResponse response,
        StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));

        result.putAll(storyService.deleteStorys(storyParam));

        return result;
    }

    @RequestMapping(value = {"/board/storys/private"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updateStorysPrivate(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));
        storyService.updateStorysPrivate(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/storys/public"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updateStorysPublic(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        storyParam.setRegId(String.valueOf(loginId));
        storyParam.setUptId(String.valueOf(loginId));
        storyService.updateStorysPublic(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/notices"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getNotices(
        HttpServletRequest request,
        HttpServletResponse response,
        NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        noticeParam.setSearchMemId(String.valueOf(signService.getSessionUser(sessionId).get("ID")));

        if( noticeParam.getSearchSecretYn() == null || noticeParam.getSearchSecretYn().isEmpty() ){
            noticeParam.setSearchSecretYn("ALL");
        }

        result.putAll(noticeService.getListNotice(noticeParam));
        result.put("dto", noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/notices"}, method = RequestMethod.DELETE)
    @ResponseBody
    public LinkedHashMap<String, Object> deleteNotices(
        HttpServletRequest request,
        HttpServletResponse response,
        NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        noticeParam.setRegId(String.valueOf(loginId));
        noticeParam.setUptId(String.valueOf(loginId));

        noticeService.deletes(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/notices/public"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updateNoticesPublic(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        noticeParam.setRegId(String.valueOf(loginId));
        noticeParam.setUptId(String.valueOf(loginId));
        noticeService.updateNoticesPublic(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/board/notices/private"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updateNoticesPrivate(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody NoticeParam noticeParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        noticeParam.setRegId(String.valueOf(loginId));
        noticeParam.setUptId(String.valueOf(loginId));
        noticeService.updateNoticesPrivate(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @RequestMapping(value = {"/category"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> insertCategory(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody MemberCategoryParam memberCategoryParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        memberCategoryParam.setRegId(String.valueOf(loginId));
        memberCategoryParam.setUptId(String.valueOf(loginId));
        memberCategoryParam.setLoginId(String.valueOf(loginId));

        result.putAll(categoryService.insertOrUpdate(memberCategoryParam));

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/setting/story"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStorySettingInfo(
        HttpServletRequest request,
        HttpServletResponse response,
        ManagementParam managementParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        managementParam.setLoginId(String.valueOf(signService.getSessionUser(sessionId).get("LOGIN_ID")));
        JSONObject managementDatas = new JSONObject(managementService.getStorySettingInfo(managementParam));
        result.put("info", managementDatas.toString());

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/setting/story"}, method = RequestMethod.PUT)
    @ResponseBody
    public LinkedHashMap<String, Object> updateMyStorySettingInfo(
        HttpServletRequest request,
        HttpServletResponse response,
        @RequestBody ManagementParam managementParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(signService.validation(request.getHeader("Authorization").replace("Bearer ", "")));

        Object loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");
        managementParam.setRegId(String.valueOf(loginId));
        managementParam.setUptId(String.valueOf(loginId));
        managementParam.setLoginId(String.valueOf(loginId));

        result.putAll(managementService.updateStorySettingInfo(managementParam));

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}
