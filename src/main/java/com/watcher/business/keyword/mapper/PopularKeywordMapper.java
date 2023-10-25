package com.watcher.business.keyword.mapper;

import com.watcher.business.keyword.param.PopularKeywordParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface PopularKeywordMapper {
    public List select(PopularKeywordParam popularKeywordParam);
    public void insert(PopularKeywordParam popularKeywordParam);
}
