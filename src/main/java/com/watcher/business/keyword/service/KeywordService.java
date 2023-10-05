package com.watcher.business.keyword.service;

import com.watcher.business.keyword.param.KeywordParam;
import java.util.Map;

public interface KeywordService {
    public Map<String, Object> getPopularKeywordList();

    public Map<String, Object> getPopularKeywordList(KeywordParam keywordParam);

    public Map<String, Object> insert(KeywordParam keywordParam) ;
}
