package com.watcher.business.category.service;

import com.watcher.business.management.param.MemberCategoryParam;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface CategoryService {
    public List<Map<String, Object>> getCategorys() throws Exception;

    public List<Map<String, Object>> getCategorys(LinkedHashMap param) throws Exception;

    public List<Map<String, Object>> getCategoryMember(LinkedHashMap param) throws Exception;

    public List<Map<String, Object>> getCategoryStory() throws Exception;

    public Map<String, String> insertOrUpdate(MemberCategoryParam memberCategoryParam) throws Exception;
}
