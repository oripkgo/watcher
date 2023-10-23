package com.watcher.business.keyword.controller;

import com.watcher.business.keyword.param.PopularKeywordParam;
import com.watcher.business.keyword.service.PopularKeywordService;
import com.watcher.util.CookieUtil;
import com.watcher.util.RequestUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;


@Controller
@RequestMapping(value = "/keyword")
public class PopularKeywordController {

    @Autowired
    PopularKeywordService popularKeywordService;

    @RequestMapping(value = {"/popular"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getPopularKeywords(@ModelAttribute("vo") PopularKeywordParam popularKeywordParam) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        result.putAll(popularKeywordService.search(popularKeywordParam));
        return result;
    }

    @RequestMapping(value = {"/popular"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> setPopularKeywords(
        HttpServletRequest request,
        @RequestBody PopularKeywordParam popularKeywordParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        popularKeywordParam.setClientIp(RequestUtil.getClientIp(request));
        popularKeywordParam.setClientId(new CookieUtil(request).getValue("JSESSIONID"));

        result.putAll(popularKeywordService.insert(popularKeywordParam));

        return result;
    }
}
