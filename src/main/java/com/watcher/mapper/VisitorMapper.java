package com.watcher.mapper;

import com.watcher.param.ManagementParam;
import com.watcher.param.VisitorParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface VisitorMapper {
	public Map<String, Object> getVisitorSearchCnt(VisitorParam visitorParam);
	public Map<String, Object> getVisitorCnt(VisitorParam visitorParam);
	public List<Map<String, Object>> getChartVisitorCntList(VisitorParam visitorParam);
	public List<Map<String, Object>> getChartMonthVisitorCntList(VisitorParam visitorParam);

	public List<Map<String, String>> getChartVisitorCntList(Map<String,Object> param);
	public List<Map<String, String>> getVisitorCnt(Map<String,Object> param);
	public void insert(VisitorParam visitorParam);
}
