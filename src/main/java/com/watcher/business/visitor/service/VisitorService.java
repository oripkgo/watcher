package com.watcher.business.visitor.service;

import com.watcher.business.visitor.param.VisitorParam;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

public interface VisitorService {
    @Transactional
    public Map<String, String> getVisitorSearchCnt(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> getVisitorCnt(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> getChartVisitorCnt(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> getChartMonthVisitorCnt(VisitorParam visitorParam) throws Exception;

    @Transactional
    public Map<String, String> insertVisitor(VisitorParam visitorParam) throws Exception;
}
