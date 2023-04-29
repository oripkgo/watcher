package com.watcher.controller;

import com.watcher.param.VisitorParam;
import com.watcher.service.VisitorService;
import com.watcher.util.CookieUtil;
import com.watcher.util.DateUtil;
import com.watcher.util.RedisUtil;
import com.watcher.util.RequestUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/visitor")
public class VisitorController {


    @Autowired
    VisitorService visitorService;

    @RequestMapping(value = {"/search/cnt"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getVisitorSearchCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        Object memId = (RedisUtil.getSession(request.getSession().getId()).get("ID"));
        visitorParam.setMemId(String.valueOf(memId));
        result.putAll(visitorService.getVisitorSearchCnt(visitorParam));

        return result;
    }

    @RequestMapping(value = {"/cnt"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getVisitorCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        Object memId = (RedisUtil.getSession(request.getSession().getId()).get("ID"));
        visitorParam.setMemId(String.valueOf(memId));
        result.putAll(visitorService.getVisitorCnt(visitorParam));

        return result;
    }

    @RequestMapping(value = {"/chart/cnts"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getChartVisitorCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        Object memId = (RedisUtil.getSession(request.getSession().getId()).get("ID"));
        visitorParam.setMemId(String.valueOf(memId));
        result.putAll(visitorService.getChartVisitorCnt(visitorParam));

        return result;
    }

    @RequestMapping(value = {"/chart/cnts/month"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMonthChartVisitorCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();
        Object memId = (RedisUtil.getSession(request.getSession().getId()).get("ID"));
        visitorParam.setMemId(String.valueOf(memId));
        result.putAll(visitorService.getChartMonthVisitorCnt(visitorParam));

        return result;
    }

    @RequestMapping(value = {"/insert"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> insertvisitor(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        visitorParam.setCustomerIp(RequestUtil.getClientIp(request));
        visitorParam.setClientId(new CookieUtil(request).getValue("JSESSIONID"));
        visitorParam.setRegMonthInquiry(DateUtil.getCurrentDay("yyyyMM"));
        visitorParam.setRegDateInquiry(DateUtil.getCurrentDay("yyyyMMdd"));

        result.putAll(visitorService.insertVisitor(visitorParam));

        return result;
    }


}
