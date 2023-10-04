package com.watcher.business.keyword.mapper;

import com.watcher.business.keyword.param.KeywordParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface KeywordMapper {
    public List getPopularKeywordList(Map<String,Object> param);
    public void insert(KeywordParam keywordParam);
}
