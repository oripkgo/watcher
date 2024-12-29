package com.watcher.business.keyword.controller;

import com.watcher.business.keyword.param.PopularKeywordParam;
import com.watcher.business.keyword.service.PopularKeywordService;
import com.watcher.enums.ResponseCode;
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
    public LinkedHashMap<String, Object> getPopularKeywords(
        PopularKeywordParam popularKeywordParam
    ) throws Exception {
        popularKeywordService.validation(popularKeywordParam);

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        result.put("list"   , popularKeywordService.getList(popularKeywordParam));
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()               );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage()            );

        return result;
    }

    @RequestMapping(value = {"/popular"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> setPopularKeywords(
        HttpServletRequest request,
        @RequestBody PopularKeywordParam popularKeywordParam
    ) throws Exception {
        popularKeywordService.validation(popularKeywordParam);

        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        popularKeywordParam.setClientIp(RequestUtil.getClientIp());
        popularKeywordParam.setClientId(CookieUtil.getValue("JSESSIONID"));

        popularKeywordService.insert(popularKeywordParam);

        result.put("list"   , popularKeywordService.getList(popularKeywordParam));
        result.put("code"   , ResponseCode.SUCCESS_0000.getCode()               );
        result.put("message", ResponseCode.SUCCESS_0000.getMessage()            );

        return result;
    }
}
