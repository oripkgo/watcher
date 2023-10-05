package com.watcher.business.comm.service;

import com.watcher.business.management.param.MemberCategoryParam;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface CategoryService {
    public List<Map<String, Object>> category_list() throws Exception;

    public List<Map<String, Object>> category_list(LinkedHashMap param) throws Exception;

    public List<Map<String, Object>> member_category_list(LinkedHashMap param) throws Exception;

    public List<Map<String, Object>> story_category_serarch() throws Exception;

    public Map<String, String> insertOrUpdate(MemberCategoryParam memberCategoryParam) throws Exception;
}
