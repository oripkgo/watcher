package com.watcher.business.management.mapper;

import com.watcher.business.management.param.ManagementParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;


@Mapper
public interface ManagementMapper {
    public Map<String, Object> getManagerSettings(ManagementParam managementParam);
    public void insertManagement(ManagementParam managementParam);
    public void updateManagement(ManagementParam managementParam);
}