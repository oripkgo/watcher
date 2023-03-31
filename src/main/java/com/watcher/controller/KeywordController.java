package com.watcher.controller;

import com.watcher.dto.CommDto;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.LinkedHashMap;


@Controller
@RequestMapping(value = "/keyword")
public class KeywordController {
    @RequestMapping(value = {"/popular"})
    public LinkedHashMap<String, Object> getPopularKeywords(@ModelAttribute("vo") CommDto commDto) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        return result;
    }
}
