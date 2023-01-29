package com.watcher.controller;

import com.watcher.param.VisitorParam;
import com.watcher.service.CategoryService;
import com.watcher.service.VisitorService;
import com.watcher.util.CookieUtil;
import com.watcher.util.DateUtil;
import com.watcher.util.RequestUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

@Controller
@RequestMapping(value = "/visitant")
public class VisitorController {


    @Autowired
    VisitorService visitorService;

    @RequestMapping(value = {"/insert"}, method = RequestMethod.POST)
    @ResponseBody
    public LinkedHashMap<String, Object> insertVisitant(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestBody VisitorParam visitorParam
    ) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        visitorParam.setCustomerIp(RequestUtil.getClientIp(request));
        visitorParam.setClientId(new CookieUtil(request).getValue("JSESSIONID"));
        visitorParam.setRegMonthInquiry(DateUtil.getCurrentDay("yyyyMM"));
        visitorParam.setRegDateInquiry(DateUtil.getCurrentDay("yyyyMMdd"));

        visitorService.insertVisitor(visitorParam);

        return result;
    }


}
