package com.watcher.mapper;

import com.watcher.param.StoryParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface StoryMapper {
    public Map<String, Object> view(StoryParam storyParam);

    public List<Map<String, Object>> list(StoryParam storyParam);

    public int listCnt(StoryParam storyParam);

    public void insert(StoryParam storyParam);

    public void update(StoryParam storyParam);

}
