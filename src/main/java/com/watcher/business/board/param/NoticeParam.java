package com.watcher.business.board.param;


import com.watcher.business.board.dto.NoticeDto;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public class NoticeParam extends NoticeDto {
    private String searchId;
    private String searchKeyword;
    private String searchLevel;
    private String searchMemId;
    private String searchSecretYn;
    private String paramJson;
    private List idList;
    private MultipartFile[] attachFiles;

    public String getSearchId() {
        return searchId;
    }

    public void setSearchId(String searchId) {
        this.searchId = searchId;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public String getSearchLevel() {
        return searchLevel;
    }

    public void setSearchLevel(String searchLevel) {
        this.searchLevel = searchLevel;
    }

    public String getSearchMemId() {
        return searchMemId;
    }

    public void setSearchMemId(String searchMemId) {
        this.searchMemId = searchMemId;
    }

    public String getSearchSecretYn() {
        return searchSecretYn;
    }

    public void setSearchSecretYn(String searchSecretYn) {
        this.searchSecretYn = searchSecretYn;
    }

    @Override
    public String getParamJson() {
        return paramJson;
    }

    @Override
    public void setParamJson(String paramJson) {
        this.paramJson = paramJson;
    }

    public List getIdList() {
        return idList;
    }

    public void setIdList(List idList) {
        this.idList = idList;
    }

    public MultipartFile[] getAttachFiles() {
        return attachFiles;
    }

    public void setAttachFiles(MultipartFile[] attachFiles) {
        this.attachFiles = attachFiles;
    }
}
