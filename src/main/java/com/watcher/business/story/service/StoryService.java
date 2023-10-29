package com.watcher.business.story.service;

import com.watcher.business.story.param.StoryParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface StoryService {
    public void validation(StoryParam storyParam) throws Exception;

    public Map<String, String> insertStory(StoryParam storyParam) throws Exception;

    public Map<String, String> updateStory(StoryParam storyParam) throws Exception;

    public Map<String, String> updateStorys(StoryParam storyParam) throws Exception;

    public void updateStorysPublic(StoryParam storyParam) throws Exception;

    public void updateStorysPrivate(StoryParam storyParam) throws Exception;

    public Map<String, String> deleteStory(StoryParam storyParam) throws Exception;

    public Map<String, String> deleteStorys(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getManagemenListPopular(StoryParam storyParam) throws Exception;

    public Map<String, Object> getManagementList(StoryParam storyParam) throws Exception;

    public Map<String, Object> getListPublic(StoryParam storyParam) throws Exception;

    public Map<String, Object> getListMyStory(String sessionMemId, StoryParam storyParam) throws Exception;

    public Map<String, Object> getList(StoryParam storyParam) throws Exception;

    public Map<String, Object> view(StoryParam storyParam) throws Exception;

    public Map<String, Object> getPopularStoryMain(StoryParam storyParam) throws Exception;
}
