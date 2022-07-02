package com.watcher.dto;


public class StoryDto extends CommDto {

    String id;
    String categoryId;
    String memberCategoryId;
    String title;
    String contents;
    String thumbnailImgId;
    String summary;
    String deleteYn;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getMemberCategoryId() {
        return memberCategoryId;
    }

    public void setMemberCategoryId(String memberCategoryId) {
        this.memberCategoryId = memberCategoryId;
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

    public String getThumbnailImgId() {
        return thumbnailImgId;
    }

    public void setThumbnailImgId(String thumbnailImgId) {
        this.thumbnailImgId = thumbnailImgId;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(String deleteYn) {
        this.deleteYn = deleteYn;
    }
}
