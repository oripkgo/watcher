package com.watcher.business.story.controller;

import com.watcher.business.comm.service.CategoryService;
import com.watcher.business.management.param.ManagementParam;
import com.watcher.business.management.service.ManagementService;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
public class MyStoryController {
    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @Autowired
    ManagementService managementService;


    @RequestMapping(value = {"/myStory/{memId}/{categoryId}"})
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStoryCategory(
            HttpServletRequest request,
            @PathVariable("memId") String memId,
            @PathVariable("categoryId") String categoryId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<String, Object>();

        LinkedHashMap param = new LinkedHashMap();

        param.put("showYn", "Y");
        param.put("memId", memId);

        JSONArray memberCategorys = new JSONArray().putAll(categoryService.getCategoryMember(param));

        storyParam.setListNo(10);
        storyParam.setCategoryId(categoryId);
        result.put("member_category_list", memberCategorys.toString());

        ManagementParam managementParam = new ManagementParam();
        managementParam.setId(memId);
        result.put("policy", managementService.getManagementDatas(managementParam));


        result.put("memId", memId);
        result.put("categoryListYn", "Y");
        result.put("vo", storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @RequestMapping(value = {"/myStory/{memId}"})
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStory(
            HttpServletRequest request,
            @PathVariable("memId") String memId,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<String, Object>();

        storyParam.setListNo(10);

        LinkedHashMap param = new LinkedHashMap();
        param.put("showYn"  , "Y"     );
        param.put("memId"   , memId   );

        result.put("member_category_list", (new JSONArray().putAll(categoryService.getCategoryMember(param))).toString() );


        ManagementParam managementParam = new ManagementParam();
        managementParam.setId(memId);

        result.put("policy", managementService.getManagementDatas(managementParam));


        result.put("memId",memId);
        result.put("vo",storyParam);
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @RequestMapping(value = {"/myStory/list"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMyStorylistData(
            HttpServletRequest request,
            HttpServletResponse response,
            @ModelAttribute("vo") StoryParam storyParam
    ) throws Exception {

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.putAll(storyService.list(storyParam));
        result.put("vo", storyParam);

        return result;
    }
}
