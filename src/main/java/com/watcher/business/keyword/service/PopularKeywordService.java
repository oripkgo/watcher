package com.watcher.business.keyword.service;

import com.watcher.business.keyword.param.PopularKeywordParam;

import java.util.Map;

public interface PopularKeywordService {
    public void validation(PopularKeywordParam popularKeywordParam) throws Exception;
    public Map<String, Object> getList();
    public Map<String, Object> getList(PopularKeywordParam popularKeywordParam);
    public Map<String, Object> insert(PopularKeywordParam popularKeywordParam) ;
}
