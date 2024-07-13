package com.watcher.business.keyword.service;

import com.watcher.business.keyword.param.PopularKeywordParam;

import java.util.List;
import java.util.Map;

public interface PopularKeywordService {
    public void validation(PopularKeywordParam popularKeywordParam) throws Exception;
    public List getList();
    public List getList(PopularKeywordParam popularKeywordParam);
    public void insert(PopularKeywordParam popularKeywordParam) ;
}
