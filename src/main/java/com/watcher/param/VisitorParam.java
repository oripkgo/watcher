package com.watcher.param;


import com.watcher.dto.VisitorDto;

import java.util.List;

public class VisitorParam extends VisitorDto {
    String memId;
    List searchTargetList;

    public String getMemId() {
        return memId;
    }

    public void setMemId(String memId) {
        this.memId = memId;
    }

    public List getSearchTargetList() {
        return searchTargetList;
    }

    public void setSearchTargetList(List searchTargetList) {
        this.searchTargetList = searchTargetList;
    }
}
