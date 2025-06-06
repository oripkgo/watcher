package com.watcher.business.category.service;

import com.watcher.business.management.param.MemberCategoryParam;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface CategoryService {
    public List<Map<String, Object>> getListCategory() throws Exception;

    public List<Map<String, Object>> getListCategory(LinkedHashMap param) throws Exception;

    public List<Map<String, Object>> getListCategoryMember(LinkedHashMap param) throws Exception;

    public String insertOrUpdate(MemberCategoryParam memberCategoryParam) throws Exception;
}
