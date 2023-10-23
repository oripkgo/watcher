package com.watcher.business.keyword.mapper;

import com.watcher.business.keyword.param.PopularKeywordParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface PopularKeywordMapper {
    public List search(Map<String,Object> param);
    public void insert(PopularKeywordParam popularKeywordParam);
}
