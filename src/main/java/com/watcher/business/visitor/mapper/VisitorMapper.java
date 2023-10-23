package com.watcher.business.visitor.mapper;

import com.watcher.business.visitor.param.VisitorParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface VisitorMapper {
	public Map<String, Object> getVisitorInflowSourceCount(VisitorParam visitorParam);
	public Map<String, Object> getVisitorCount(VisitorParam visitorParam);
	public List<Map<String, Object>> getChartDailyVisitorCntList(VisitorParam visitorParam);
	public List<Map<String, Object>> getChartMonthVisitorCntList(VisitorParam visitorParam);
	public List<Map<String, String>> getChartDailyVisitorCntList(Map<String,Object> param);
	public List<Map<String, String>> getVisitorCount(Map<String,Object> param);
	public void insert(VisitorParam visitorParam);
}
