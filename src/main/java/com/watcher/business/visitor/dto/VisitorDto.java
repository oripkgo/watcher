package com.watcher.business.visitor.dto;


import com.watcher.business.comm.dto.CommDto;

public class VisitorDto extends CommDto {
    String id;
    String accessPath;
    String accessTarget;
    String accPageUrl;
    String clientIp;
    String clientId;
    String callService;
    String visitStoryMemId;
    String regMonthInquiry;
    String regDateInquiry;
    String regDate;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAccessPath() {
        return accessPath;
    }

    public void setAccessPath(String accessPath) {
        this.accessPath = accessPath;
    }

    public String getAccessTarget() {
        return accessTarget;
    }

    public void setAccessTarget(String accessTarget) {
        this.accessTarget = accessTarget;
    }

    public String getAccPageUrl() {
        return accPageUrl;
    }

    public void setAccPageUrl(String accPageUrl) {
        this.accPageUrl = accPageUrl;
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getCallService() {
        return callService;
    }

    public void setCallService(String callService) {
        this.callService = callService;
    }

    public String getVisitStoryMemId() {
        return visitStoryMemId;
    }

    public void setVisitStoryMemId(String visitStoryMemId) {
        this.visitStoryMemId = visitStoryMemId;
    }

    public String getRegMonthInquiry() {
        return regMonthInquiry;
    }

    public void setRegMonthInquiry(String regMonthInquiry) {
        this.regMonthInquiry = regMonthInquiry;
    }

    public String getRegDateInquiry() {
        return regDateInquiry;
    }

    public void setRegDateInquiry(String regDateInquiry) {
        this.regDateInquiry = regDateInquiry;
    }

    @Override
    public String getRegDate() {
        return regDate;
    }

    @Override
    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }
}
