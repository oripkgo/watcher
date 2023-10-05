package com.watcher.business.story.service;

import com.watcher.business.story.param.StoryParam;

import java.util.Map;

public interface StoryService {
    public Map<String, String> insertStory(StoryParam storyParam) throws Exception;

    public Map<String, String> updateStory(StoryParam storyParam) throws Exception;

    public Map<String, String> updateStorys(StoryParam storyParam) throws Exception;

    public Map<String, String> deleteStory(StoryParam storyParam) throws Exception;

    public Map<String, String> deleteStorys(StoryParam storyParam) throws Exception;

    public Map<String, Object> list(StoryParam storyParam) throws Exception;

    public Map<String, Object> view(StoryParam storyParam) throws Exception;

    public Map<String, Object> getPopularStory(StoryParam storyParam) throws Exception;
}
