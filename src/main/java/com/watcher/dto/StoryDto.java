package com.watcher.dto;


public class StoryDto extends CommDto {

    String id;
    String categoryId;
    String memberCategoryId;
    String title;
    String contents;
    String thumbnailImgPath;
    String summary;

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

    public String getThumbnailImgPath() {
        return thumbnailImgPath;
    }

    public void setThumbnailImgPath(String thumbnailImgPath) {
        this.thumbnailImgPath = thumbnailImgPath;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }
}
