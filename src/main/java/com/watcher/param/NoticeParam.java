package com.watcher.param;


import com.watcher.dto.NoticeDto;

public class NoticeParam extends NoticeDto {
    String search_id;
    String search_keyword;
    String search_level;

    public String getSearch_id() {
        return search_id;
    }

    public void setSearch_id(String search_id) {
        this.search_id = search_id;
    }

    public String getSearch_keyword() {
        return search_keyword;
    }

    public void setSearch_keyword(String search_keyword) {
        this.search_keyword = search_keyword;
    }

    public String getSearch_level() {
        return search_level;
    }

    public void setSearch_level(String search_level) {
        this.search_level = search_level;
    }
}
