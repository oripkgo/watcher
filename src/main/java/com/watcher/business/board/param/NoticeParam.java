package com.watcher.business.board.param;


import com.watcher.business.board.dto.NoticeDto;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public class NoticeParam extends NoticeDto {
    private String search_id;
    private String search_keyword;
    private String search_level;
    private String search_memId;
    private String search_secret_yn;

    private List id_list;

    MultipartFile[] attachFiles;

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

    public String getSearch_memId() {
        return search_memId;
    }

    public void setSearch_memId(String search_memId) {
        this.search_memId = search_memId;
    }

    public String getSearch_secret_yn() {
        return search_secret_yn;
    }

    public void setSearch_secret_yn(String search_secret_yn) {
        this.search_secret_yn = search_secret_yn;
    }

    public List getId_list() {
        return id_list;
    }

    public void setId_list(List id_list) {
        this.id_list = id_list;
    }

    public MultipartFile[] getAttachFiles() {
        return attachFiles;
    }

    public void setAttachFiles(MultipartFile[] attachFiles) {
        this.attachFiles = attachFiles;
    }
}
