package com.watcher.mapper;

import com.watcher.param.VisitorParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface VisitorMapper {
	public List<Map<String, String>> getChartVisitorCntList(Map<String,Object> param);
	public List<Map<String, String>> getVisitorCnt(Map<String,Object> param);
	public void insert(VisitorParam visitorParam);
}
