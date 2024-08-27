package com.watcher.business.story.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.enums.ResponseCode;
import com.watcher.util.AESUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;

@Controller
@RequestMapping(value = "/my-story")
public class MyStoryController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @Autowired
    ManagementService managementService;

    @Autowired
    SignService signService;

    @RequestMapping(value = {"/{storyAdminId}/{categoryId}"})
    public ModelAndView getMyStoryCategory(
            HttpServletRequest request,
            @PathVariable("storyAdminId") String storyAdminId,
            @PathVariable("categoryId") String categoryId,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mv = new ModelAndView("myStory/index");

        String sessionId = request.getSession().getId();
        String loginId = signService.getSessionUser(sessionId).get("LOGIN_ID");

        // story의 세팅된 사용권한 및 정책 조회
        ManagementParam managementParam = new ManagementParam();
        managementParam.setId(storyAdminId);
        Map<String, Object> storyInfo = managementService.getStorySettingInfo(managementParam);


        mv.addObject("editPermYn" , "N");
        if(Objects.equals(storyInfo.get("STORY_REG_PERM_STATUS"), "02") && StringUtils.hasText(loginId)){
            mv.addObject("editPermYn"   , "Y");
            mv.addObject("editPermId"   , AESUtil.encrypt(storyAdminId + "/" + loginId));
        }


        storyParam.setListNo(10);
        storyParam.setCategoryId(categoryId);

        mv.addObject("dto"          , storyParam);
        mv.addObject("boardTitle"   , storyParam.getCategoryNm());
        mv.addObject("storyAdminId" , storyAdminId);
        mv.addObject("storyInfo"    , storyInfo);
        mv.addObject("noticeListYn" , "Y");

        return mv;
    }


    @RequestMapping(value = {"/{storyAdminId}"})
    public ModelAndView getMyStory(
            HttpServletRequest request,
            @PathVariable("storyAdminId") String storyAdminId,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mv = new ModelAndView("myStory/index");

        String sessionId    = request.getSession().getId();
        String loginId      = signService.getSessionUser(sessionId).get("LOGIN_ID");

        // story의 세팅된 사용권한 및 정책 조회
        ManagementParam managementParam = new ManagementParam();
        managementParam.setId(storyAdminId);
        Map<String, Object> storyInfo = managementService.getStorySettingInfo(managementParam);


        mv.addObject("editPermYn" , "N");
        if(Objects.equals(storyInfo.get("STORY_REG_PERM_STATUS"), "02") && StringUtils.hasText(loginId)){
            mv.addObject("editPermYn"  , "Y");
            mv.addObject("editPermId"  , AESUtil.encrypt(storyAdminId + "/" + loginId));
        }


        storyParam.setListNo(10);

        mv.addObject("dto"          , storyParam);
        mv.addObject("storyAdminId" , storyAdminId);
        mv.addObject("storyInfo"    , storyInfo);
        mv.addObject("boardTitle"   , "전체글");

        return mv;
    }

    @RequestMapping(value = {"/{storyAdminId}/list"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStorylistData(
            HttpServletRequest request,
            HttpServletResponse response,
            @PathVariable("storyAdminId") String storyAdminId,
            StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        storyParam.setListNo(10);

        storyParam.setSearchAdminId(storyAdminId);
        result.put("list"   , storyService.getListMyStory(storyParam)       );
        result.put("dto"    , storyParam                                    );
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()           );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage()        );

        return result;
    }
}
