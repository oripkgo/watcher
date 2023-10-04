package com.watcher.business.board.dto;


import com.watcher.business.comm.dto.CommDto;

public class NoticeDto extends CommDto {
    private String id;
    private String title;
    private String contents;
    private String thumbnailImgPath;
    private String deleteYn;
    private String secretYn;

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

    public String getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(String deleteYn) {
        this.deleteYn = deleteYn;
    }

    public String getSecretYn() {
        return secretYn;
    }

    public void setSecretYn(String secretYn) {
        this.secretYn = secretYn;
    }
}
