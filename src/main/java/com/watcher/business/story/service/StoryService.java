package com.watcher.business.story.service;

import com.watcher.business.story.param.StoryParam;
import java.util.List;
import java.util.Map;

public interface StoryService {
    public void validation(StoryParam storyParam) throws Exception;

    public String insertStory(StoryParam storyParam) throws Exception;

    public void updateStory(StoryParam storyParam) throws Exception;

    public void updateStorys(StoryParam storyParam) throws Exception;

    public void updateStorysPublic(StoryParam storyParam) throws Exception;

    public void updateStorysPrivate(StoryParam storyParam) throws Exception;

    public void deleteStory(StoryParam storyParam) throws Exception;

    public void deleteStorys(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getListManagemenPopular(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getListManagement(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getListStoryPublic(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getListMyStory(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getList(StoryParam storyParam) throws Exception;

    public Map<String, Object> getData(StoryParam storyParam) throws Exception;

    public List<Map<String, Object>> getPopularStoryMain(StoryParam storyParam) throws Exception;

    public void insertViewsCount(StoryParam storyParam) throws Exception;

    public void updateLikeCountUp(int id) throws Exception;

    public void updateLikeCountDown(int id) throws Exception;

    public List<Map<String, Object>> getFeaturedRelatedPostList(String memId, String targetContent, List<Map<String, Object>> storyList) throws Exception;

}
