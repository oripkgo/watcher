package com.watcher.dto;


public class NoticeDto {

    private String id;
    private String title;
    private String contents;
    private String thumbnailImgPath;
    private String regId;
    private String regDate;
    private String uptId;
    private String uptDate;

    private int viewCnt;
    private int likeCnt;

    private String tags;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContents() {
        return contents;
    }

    public void setContents(String contents) {
        this.contents = contents;
    }

    public String getThumbnailImgPath() {
        return thumbnailImgPath;
    }

    public void setThumbnailImgPath(String thumbnailImgPath) {
        this.thumbnailImgPath = thumbnailImgPath;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public String getUptId() {
        return uptId;
    }

    public void setUptId(String uptId) {
        this.uptId = uptId;
    }

    public String getUptDate() {
        return uptDate;
    }

    public void setUptDate(String uptDate) {
        this.uptDate = uptDate;
    }

    public int getViewCnt() {
        return viewCnt;
    }

    public void setViewCnt(int viewCnt) {
        this.viewCnt = viewCnt;
    }

    public int getLikeCnt() {
        return likeCnt;
    }

    public void setLikeCnt(int likeCnt) {
        this.likeCnt = likeCnt;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }
}
