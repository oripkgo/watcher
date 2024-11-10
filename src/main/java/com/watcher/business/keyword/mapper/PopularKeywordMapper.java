package com.watcher.business.keyword.mapper;

import com.watcher.business.keyword.param.PopularKeywordParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PopularKeywordMapper {
    public List select(PopularKeywordParam popularKeywordParam);
    public void insert(PopularKeywordParam popularKeywordParam);
}
