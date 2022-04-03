package com.watcher.mapper;

import com.watcher.vo.NoticeVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface NoticeMapper {
	
	public List<NoticeVo> list(NoticeVo noticeVo) throws Exception;
	public int listCnt(NoticeVo noticeVo) throws Exception;

}
