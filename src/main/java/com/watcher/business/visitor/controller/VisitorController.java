package com.watcher.business.visitor.controller;

import com.watcher.business.login.service.SignService;
import com.watcher.business.visitor.param.VisitorParam;
import com.watcher.business.visitor.service.VisitorService;
import com.watcher.enums.ResponseCode;
import com.watcher.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/visitor")
public class VisitorController {
    @Autowired
    VisitorService visitorService;

    @Autowired
    SignService signService;

    @Autowired
    RedisUtil redisUtil;

    @RequestMapping(value = {"/count/inflow/source"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getVisitorInflowSourceCount(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String token        = request.getHeader("Authorization").replace("Bearer ", "");
        String sessionId    = signService.getSessionId(signService.validation(token));
        Object memId        = redisUtil.getSession(sessionId).get("ID");

        visitorParam.setMemId(String.valueOf(memId));

        result.put("visitInfo"  , visitorService.getVisitorInflowSourceCount(visitorParam)  );
        result.put("code"       , ResponseCode.SUCCESS_0000.getCode()                       );
        result.put("message"    , ResponseCode.SUCCESS_0000.getMessage()                    );

        return result;
    }

    @RequestMapping(value = {"/count"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getVisitorCount(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String token        = request.getHeader("Authorization").replace("Bearer ", "");
        String sessionId    = signService.getSessionId(signService.validation(token));
        Object memId        = redisUtil.getSession(sessionId).get("ID");

        visitorParam.setMemId(String.valueOf(memId));

        result.put("visitInfo"  , visitorService.getVisitorCount(visitorParam)  );
        result.put("code"       , ResponseCode.SUCCESS_0000.getCode()           );
        result.put("message"    , ResponseCode.SUCCESS_0000.getMessage()        );

        return result;
    }

    @RequestMapping(value = {"/chart/count/daily"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getDailyChartVisitorCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String token        = request.getHeader("Authorization").replace("Bearer ", "");
        String sessionId    = signService.getSessionId(signService.validation(token));
        Object memId        = redisUtil.getSession(sessionId).get("ID");

        visitorParam.setMemId(String.valueOf(memId));

        result.put("visitInfoList"  , visitorService.getDailyChartVisitorCnt(visitorParam)  );
        result.put("code"           , ResponseCode.SUCCESS_0000.getCode()                   );
        result.put("message"        , ResponseCode.SUCCESS_0000.getMessage()                );

        return result;
    }

    @RequestMapping(value = {"/chart/count/month"}, method = RequestMethod.GET)
    @ResponseBody
    public LinkedHashMap<String, Object> getMonthChartVisitorCnt(
            HttpServletRequest request,
            HttpServletResponse response,
            VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        String token        = request.getHeader("Authorization").replace("Bearer ", "");
        String sessionId    = signService.getSessionId(signService.validation(token));
        Object memId        = redisUtil.getSession(sessionId).get("ID");

        visitorParam.setMemId(String.valueOf(memId));

        result.put("visitInfoList"  , visitorService.getChartMonthVisitorCnt(visitorParam));
        result.put("code"           , ResponseCode.SUCCESS_0000.getCode());
        result.put("message"        , ResponseCode.SUCCESS_0000.getMessage());

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

        visitorParam.setClientIp(RequestUtil.getClientIp());
        visitorParam.setClientId(CookieUtil.getValue("JSESSIONID"));
        visitorParam.setRegMonthInquiry(DateUtil.getCurrentDay("yyyyMM"));
        visitorParam.setRegDateInquiry(DateUtil.getCurrentDay("yyyyMMdd"));

        visitorService.insertVisitor(visitorParam);

        result.put("code"       , ResponseCode.SUCCESS_0000.getCode());
        result.put("message"    , ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }
}
