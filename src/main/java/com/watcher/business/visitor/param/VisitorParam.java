package com.watcher.business.visitor.param;


import com.watcher.business.visitor.dto.VisitorDto;

import java.util.List;

public class VisitorParam extends VisitorDto {
    String memId;
    String searchDate;
    List searchTargetList;

    public String getMemId() {
        return memId;
    }

    public void setMemId(String memId) {
        this.memId = memId;
    }

    public String getSearchDate() {
        return searchDate;
    }

    public void setSearchDate(String searchDate) {
        this.searchDate = searchDate;
    }

    public List getSearchTargetList() {
        return searchTargetList;
    }

    public void setSearchTargetList(List searchTargetList) {
        this.searchTargetList = searchTargetList;
    }
}
