package com.watcher.controller;

import com.watcher.dto.CommDto;
import com.watcher.service.CategoryService;
import com.watcher.service.StoryService;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;

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
}
