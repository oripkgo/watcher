package com.watcher.business.story.mapper;

import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.resp.StoryResp;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface StoryMapper {
    public StoryResp view(StoryParam storyParam);

    public List<Map<String, Object>> getPopularStoryMain(StoryParam storyParam);

    public List<Map<String, Object>> selectStory(StoryParam storyParam);

    public int selectStoryCnt(StoryParam storyParam);

    public void insert(StoryParam storyParam);

    public void update(StoryParam storyParam);

    public void updateViewCountUp(int id);

    public void updateLikeCountUp(int id);

    public void updateLikeCountDown(int id);

}
