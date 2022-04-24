package com.watcher.mapper;

import com.watcher.vo.MemberVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface BoardMapper {
	
	public void views_count(Map<String,Object> param);

}
