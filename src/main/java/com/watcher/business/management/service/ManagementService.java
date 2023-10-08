package com.watcher.business.management.service;

import com.watcher.business.management.param.ManagementParam;
import java.util.Map;

public interface ManagementService {
    public Map<String, Object> getManagementDatas(ManagementParam managementParam) throws Exception;

    public Map<String, String> updateMyStorySettingInfo(ManagementParam managementParam) throws Exception;

    /*
    public Map<String, String> updateStory(StoryParam storyParam) throws Exception;

    public Map<String, Object> list(StoryParam storyParam) throws Exception;

    public Map<String, Object> view(StoryParam storyParam) throws Exception;
    */
}
