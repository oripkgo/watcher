package com.watcher.controller;

import com.watcher.dto.CommDto;
import com.watcher.param.VisitorParam;
import com.watcher.service.CategoryService;
import com.watcher.service.StoryService;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/comm")
public class CommController {


    @Autowired
    CategoryService categoryService;

    @Autowired
    StoryService storyService;

    @RequestMapping(value = {"/category/list"})

    public LinkedHashMap<String, Object> showStoryListPage(@ModelAttribute("vo") CommDto commDto) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        JSONArray jsonArray = new JSONArray().putAll(categoryService.category_list());
        result.put("category_list", jsonArray);

        return result;
    }

    @RequestMapping(value = {"/visitant/insert"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> insertVisitant(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();


        return result;
    }


}
