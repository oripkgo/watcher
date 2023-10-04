package com.watcher.business.keyword.controller;

import com.watcher.business.keyword.param.KeywordParam;
import com.watcher.business.keyword.service.KeywordService;
import com.watcher.util.CookieUtil;
import com.watcher.util.RequestUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;


@Controller
@RequestMapping(value = "/keyword")
public class KeywordController {

    @Autowired
    KeywordService keywordService;

    @RequestMapping(value = {"/popular"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularKeywords(@ModelAttribute("vo") KeywordParam keywordParam) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        result.putAll(keywordService.getPopularKeywordList(keywordParam));
        return result;
    }

    @RequestMapping(value = {"/search"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> setKeywordSearch(
        HttpServletRequest request,
        @RequestBody KeywordParam keywordParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        keywordParam.setClientIp(RequestUtil.getClientIp(request));
        keywordParam.setClientId(new CookieUtil(request).getValue("JSESSIONID"));

        result.putAll(keywordService.insert(keywordParam));

        return result;
    }
}
