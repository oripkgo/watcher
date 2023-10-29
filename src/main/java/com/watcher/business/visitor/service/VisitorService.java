package com.watcher.business.visitor.service;

import com.watcher.business.visitor.param.VisitorParam;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public interface VisitorService {
    @Transactional
    public Map<String, String> getVisitorInflowSourceCount(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> getVisitorCount(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> getDailyChartVisitorCnt(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> getChartMonthVisitorCnt(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> insertVisitor(VisitorParam visitorParam) throws Exception;
}
