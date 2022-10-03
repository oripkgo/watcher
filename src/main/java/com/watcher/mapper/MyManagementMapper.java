package com.watcher.mapper;

import com.watcher.param.ManagementParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;


@Mapper
public interface MyManagementMapper {
    public Map<String, Object> getVisitorCnt(ManagementParam managementParam);
}
