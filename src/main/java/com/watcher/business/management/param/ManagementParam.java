package com.watcher.business.management.param;


import com.watcher.business.management.dto.ManagementDto;

public class ManagementParam extends ManagementDto {
    private String searchLoginId;
    private String searchContentType;
    private String searchContentId;

    public String getSearchLoginId() {
        return searchLoginId;
    }

    public void setSearchLoginId(String searchLoginId) {
        this.searchLoginId = searchLoginId;
    }

    public String getSearchContentType() {
        return searchContentType;
    }

    public void setSearchContentType(String searchContentType) {
        this.searchContentType = searchContentType;
    }

    public String getSearchContentId() {
        return searchContentId;
    }

    public void setSearchContentId(String searchContentId) {
        this.searchContentId = searchContentId;
    }
}
