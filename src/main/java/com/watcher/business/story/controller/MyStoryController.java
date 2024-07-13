package com.watcher.business.story.controller;

import com.watcher.business.category.service.CategoryService;
import com.watcher.business.login.service.SignService;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.enums.ResponseCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/myStory")
public class MyStoryController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @Autowired
    ManagementService managementService;

    @Autowired
    SignService signService;

    @RequestMapping(value = {"/{memId}/{categoryId}"})
    public ModelAndView getMyStoryCategory(
            HttpServletRequest request,
            @PathVariable("memId") String memId,
            @PathVariable("categoryId") String categoryId,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mv = new ModelAndView("myStory/index");

        storyParam.setListNo(10);
        storyParam.setCategoryId(categoryId);
        mv.addObject("dto", storyParam);
        mv.addObject("boardTitle", storyParam.getCategory_nm());

        ManagementParam managementParam = new ManagementParam();
        managementParam.setId(memId);
        mv.addObject("storyInfo", managementService.getStorySettingInfo(managementParam));

        mv.addObject("memId", memId);
        mv.addObject("noticeListYn", "Y");

        return mv;
    }


    @RequestMapping(value = {"/{memId}"})
    public ModelAndView getMyStory(
            HttpServletRequest request,
            @PathVariable("memId") String memId,
            StoryParam storyParam
    ) throws Exception {
        ModelAndView mv = new ModelAndView("myStory/index");

        ManagementParam managementParam = new ManagementParam();
        managementParam.setId(memId);

        mv.addObject("storyInfo", managementService.getStorySettingInfo(managementParam));

        storyParam.setListNo(10);
        mv.addObject("dto",storyParam);

        mv.addObject("memId",memId);
        mv.addObject("boardTitle","전체글");

        return mv;
    }

    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStorylistData(
            HttpServletRequest request,
            HttpServletResponse response,
            StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String sessionId = signService.getSessionId(request.getHeader("Authorization").replace("Bearer ", ""));
        String memId = String.valueOf(signService.getSessionUser(sessionId).get("ID"));

        storyParam.setListNo(10);

        result.put("list"   , storyService.getListMyStory(memId, storyParam));
        result.put("dto"    , storyParam                                    );
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()           );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage()        );

        return result;
    }
}
