package com.watcher.business.management.service;

import com.watcher.business.management.param.ManagementParam;
import java.util.Map;

public interface ManagementService {

    public Map<String, Object> getStorySettingInfo(String loginId) throws Exception;

    public Map<String, Object> getStorySettingInfo(ManagementParam managementParam) throws Exception;

    public void updateStorySettingInfo(ManagementParam managementParam) throws Exception;

}
