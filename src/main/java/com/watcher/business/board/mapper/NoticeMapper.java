package com.watcher.business.board.mapper;

import com.watcher.business.board.param.NoticeParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;


@Mapper
public interface NoticeMapper {
	public Map<String,Object> view(NoticeParam noticeParam);
	public List<Map<String,Object>> selectNotice(NoticeParam noticeParam);
	public int selectNoticeCnt(NoticeParam noticeParam);
	public int insert(NoticeParam noticeParam);
	public int update(NoticeParam noticeParam);

}
