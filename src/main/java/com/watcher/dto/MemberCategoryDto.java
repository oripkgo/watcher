package com.watcher.dto;


import org.springframework.web.multipart.MultipartFile;

public class MemberCategoryDto extends CommDto {
    private String id;
    private String defalutCategId;
    private String loginId;
    private String categoryNm;
    private String categoryComents;
    private String categoryImgPath;
    private String showYn;
    private String deleteYn;

    private MultipartFile categoryImgFile;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDefalutCategId() {
        return defalutCategId;
    }

    public void setDefalutCategId(String defalutCategId) {
        this.defalutCategId = defalutCategId;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getCategoryNm() {
        return categoryNm;
    }

    public void setCategoryNm(String categoryNm) {
        this.categoryNm = categoryNm;
    }

    public String getCategoryComents() {
        return categoryComents;
    }

    public void setCategoryComents(String categoryComents) {
        this.categoryComents = categoryComents;
    }

    public String getCategoryImgPath() {
        return categoryImgPath;
    }

    public void setCategoryImgPath(String categoryImgPath) {
        this.categoryImgPath = categoryImgPath;
    }

    public String getShowYn() {
        return showYn;
    }

    public void setShowYn(String showYn) {
        this.showYn = showYn;
    }

    public String getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(String deleteYn) {
        this.deleteYn = deleteYn;
    }

    public MultipartFile getCategoryImgFile() {
        return categoryImgFile;
    }

    public void setCategoryImgFile(MultipartFile categoryImgFile) {
        this.categoryImgFile = categoryImgFile;
    }
}
