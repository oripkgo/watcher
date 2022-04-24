package com.watcher.mapper;

import com.watcher.dto.NoticeDto;
import com.watcher.vo.NoticeVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface NoticeMapper {
	public NoticeDto view(NoticeVo noticeVo);
	public List<NoticeDto> list(NoticeVo noticeVo);
	public int listCnt(NoticeVo noticeVo);

}
