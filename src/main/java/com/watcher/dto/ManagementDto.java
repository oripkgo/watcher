package com.watcher.dto;


public class ManagementDto extends MemberDto {

    private String id;
    private String loginId;
    private String commentPermStatus;

    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String getLoginId() {
        return loginId;
    }

    @Override
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getCommentPermStatus() {
        return commentPermStatus;
    }

    public void setCommentPermStatus(String commentPermStatus) {
        this.commentPermStatus = commentPermStatus;
    }
}