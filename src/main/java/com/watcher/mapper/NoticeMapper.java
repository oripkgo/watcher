package com.watcher.mapper;

import com.watcher.param.NoticeParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface NoticeMapper {
	public Map<String,Object> view(NoticeParam noticeParam);
	public List<Map<String,Object>> list(NoticeParam noticeParam);
	public int listCnt(NoticeParam noticeParam);
	public int insert(NoticeParam noticeParam);
	public int update(NoticeParam noticeParam);

}
