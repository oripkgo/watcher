package com.watcher.business.keyword.service;

import com.watcher.business.keyword.param.PopularKeywordParam;

import java.util.Map;

public interface PopularKeywordService {
    public Map<String, Object> select();

    public Map<String, Object> select(PopularKeywordParam popularKeywordParam);

    public Map<String, Object> insert(PopularKeywordParam popularKeywordParam) ;
}
