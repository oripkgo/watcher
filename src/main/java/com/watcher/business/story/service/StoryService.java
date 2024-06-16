package com.watcher.business.story.service;

import com.watcher.business.story.param.StoryParam;
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

    public List<Map<String, Object>> getListManagemenPopular(StoryParam storyParam) throws Exception;

    public Map<String, Object> getListManagement(StoryParam storyParam) throws Exception;

    public Map<String, Object> getListStoryPublic(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getListMyStory(String sessionMemId, StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getList(StoryParam storyParam) throws Exception;

    public Map<String, Object> getData(StoryParam storyParam) throws Exception;

    public Map<String, Object> getPopularStoryMain(StoryParam storyParam) throws Exception;

    public void insertViewsCount(StoryParam storyParam) throws Exception;

    public void updateLikeCountUp(int id) throws Exception;

    public void updateLikeCountDown(int id) throws Exception;

    public List<Map<String, Object>> getFeaturedRelatedPostList(String memId, String targetContent, List<Map<String, Object>> storyList) throws Exception;

}
