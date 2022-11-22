package com.watcher.dto;


public class ManagementDto extends MemberDto {

    private String id;
    private String loginId;
    private String comment_perm_status;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getComment_perm_status() {
        return comment_perm_status;
    }

    public void setComment_perm_status(String comment_perm_status) {
        this.comment_perm_status = comment_perm_status;
    }
}