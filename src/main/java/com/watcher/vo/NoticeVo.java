package com.watcher.vo;


public class NoticeVo extends CommVo {

    private String id;
    private String title;
    private String contents;
    private String thumbnailImgPath;
    private String regId;
    private String regDate;
    private String uptId;
    private String uptDate;

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

    @Override
    public String getRegId() {
        return regId;
    }

    @Override
    public void setRegId(String regId) {
        this.regId = regId;
    }

    @Override
    public String getRegDate() {
        return regDate;
    }

    @Override
    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    @Override
    public String getUptId() {
        return uptId;
    }

    @Override
    public void setUptId(String uptId) {
        this.uptId = uptId;
    }

    @Override
    public String getUptDate() {
        return uptDate;
    }

    @Override
    public void setUptDate(String uptDate) {
        this.uptDate = uptDate;
    }
}
