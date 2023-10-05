package com.watcher.business.board.service;

import com.watcher.business.board.param.NoticeParam;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

public interface NoticeService {
    public Map<String, Object> list(NoticeParam noticeParam) throws Exception;

    public Map<String, Object> view(NoticeParam noticeParam) throws Exception;

    public Map<String, Object> updates(NoticeParam noticeParam) throws Exception;

    public Map<String, Object> delete(NoticeParam noticeParam) throws Exception;

    public Map<String, Object> deletes(NoticeParam noticeParam) throws Exception;

    public Map<String, String> insert(NoticeParam noticeParam) throws Exception;
}
