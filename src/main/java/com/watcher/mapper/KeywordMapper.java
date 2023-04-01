package com.watcher.mapper;

import com.watcher.param.KeywordParam;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface KeywordMapper {
    public void insert(KeywordParam keywordParam);
}
