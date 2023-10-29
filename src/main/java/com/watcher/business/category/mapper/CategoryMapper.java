package com.watcher.business.category.mapper;

import com.watcher.business.management.param.MemberCategoryParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface CategoryMapper {
	public List<Map<String, String>> getListCategory(Map<String,Object> param);
	public List<Map<String, String>> getListCategoryMember(Map<String,Object> param);
	public void insert(MemberCategoryParam memberCategoryParam);
	public void update(MemberCategoryParam memberCategoryParam);
}
