package com.watcher.business.board.service;

import java.util.LinkedHashMap;
import java.util.Map;

public interface BoardService {
    public void views_count(String contentsType, String contentsId, String loginId) throws Exception;

    public int comment_select_cnt(LinkedHashMap param) throws Exception;

    public Map<String, Object> comment_select(LinkedHashMap param) throws Exception;

    public Map<String, Object> comment_select_info(LinkedHashMap param) throws Exception;

    public Map<String, String> comment_insert(LinkedHashMap param) throws Exception;

    public Map<String, String> comment_update(LinkedHashMap param) throws Exception;

    public Map<String, String> comment_delete(LinkedHashMap param) throws Exception;

    public Map<String, String> view_tags_select(String contentsType, String contentsId) throws Exception;

    public Map<String, String> view_like_yn_select(String contentsType, String contentsId, String loginId) throws Exception;

    public void like_insert(Map<String, Object> param) throws Exception;

    public void like_update(Map<String, Object> param) throws Exception;
}
