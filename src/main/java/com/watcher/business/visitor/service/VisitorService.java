package com.watcher.business.visitor.service;

import com.watcher.business.visitor.param.VisitorParam;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface VisitorService {
    public Map<String, Object> getVisitorInflowSourceCount(VisitorParam visitorParam) throws Exception;

    public Map<String, Object> getVisitorCount(VisitorParam visitorParam) throws Exception;

    public List<Map<String, Object>> getDailyChartVisitorCnt(VisitorParam visitorParam) throws Exception;

    public List<Map<String, Object>> getChartMonthVisitorCnt(VisitorParam visitorParam) throws Exception;

    public void insertVisitor(VisitorParam visitorParam) throws Exception;
}
