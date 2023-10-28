package com.watcher.business.board.service;

import com.watcher.business.board.param.NoticeParam;

import java.util.Map;

public interface NoticeService {
    public Map<String, Object> getNoticeList(NoticeParam noticeParam) throws Exception;

    public Map<String, Object> view(NoticeParam noticeParam) throws Exception;

    public void updateNoticesPublic(NoticeParam noticeParam) throws Exception;

    public void updateNoticesPrivate(NoticeParam noticeParam) throws Exception;

    public Map<String, Object> updates(NoticeParam noticeParam) throws Exception;

    public void delete(NoticeParam noticeParam) throws Exception;

    public void deletes(NoticeParam noticeParam) throws Exception;

    public Map<String, String> insert(NoticeParam noticeParam) throws Exception;
}
