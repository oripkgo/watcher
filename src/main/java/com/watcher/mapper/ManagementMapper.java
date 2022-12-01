package com.watcher.mapper;

import com.watcher.param.ManagementParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface ManagementMapper {
    public Map<String, Object> getVisitorCnt(ManagementParam managementParam);
    public Map<String, Object> getManagerSettings(ManagementParam managementParam);
    public List<Map<String, Object>> getChartVisitorCntList(ManagementParam managementParam);
    public List<Map<String, Object>> getPopularityArticleList(ManagementParam managementParam);
    public void insertManagement(ManagementParam managementParam);
    public void updateManagement(ManagementParam managementParam);
}