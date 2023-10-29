package com.watcher.business.visitor.mapper;

import com.watcher.business.visitor.param.VisitorParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface VisitorMapper {
	public Map<String, Object> selectVisitorInflowSourceCount(VisitorParam visitorParam);
	public Map<String, Object> selectVisitorCount(VisitorParam visitorParam);
	public List<Map<String, Object>> selectChartDailyVisitorCntList(VisitorParam visitorParam);
	public List<Map<String, Object>> selectChartMonthVisitorCntList(VisitorParam visitorParam);
	public List<Map<String, String>> selectChartDailyVisitorCntList(Map<String,Object> param);
	public List<Map<String, String>> selectVisitorCount(Map<String,Object> param);
	public void insert(VisitorParam visitorParam);
}
