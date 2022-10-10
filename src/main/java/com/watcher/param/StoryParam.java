package com.watcher.param;


import com.watcher.dto.StoryDto;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

public class StoryParam extends StoryDto {
    String search_id;
    String search_keyword;
    String SortByRecommendationYn;
    String limitNum;
    String category_id;
    String category_nm;
    String tags;
    String search_memId;
    String search_secret_yn;

    MultipartFile thumbnailImgPathParam;

    public String getSearch_id() {
        return search_id;
    }

    public void setSearch_id(String search_id) {
        this.search_id = search_id;
    }

    public String getSearch_keyword() {
        return search_keyword;
    }

    public void setSearch_keyword(String search_keyword) {
        this.search_keyword = search_keyword;
    }

    public String getSortByRecommendationYn() {
        return SortByRecommendationYn;
    }

    public void setSortByRecommendationYn(String sortByRecommendationYn) {
        SortByRecommendationYn = sortByRecommendationYn;
    }

    public String getLimitNum() {
        return limitNum;
    }

    public void setLimitNum(String limitNum) {
        this.limitNum = limitNum;
    }

    public String getCategory_id() {
        return category_id;
    }

    public void setCategory_id(String category_id) {
        this.category_id = category_id;
    }

    public String getCategory_nm() {
        return category_nm;
    }

    public void setCategory_nm(String category_nm) {
        this.category_nm = category_nm;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getSearch_memId() {
        return search_memId;
    }

    public void setSearch_memId(String search_memId) {
        this.search_memId = search_memId;
    }

    public String getSearch_secret_yn() {
        return search_secret_yn;
    }

    public void setSearch_secret_yn(String search_secret_yn) {
        this.search_secret_yn = search_secret_yn;
    }

    public MultipartFile getThumbnailImgPathParam() {
        return thumbnailImgPathParam;
    }

    public void setThumbnailImgPathParam(MultipartFile thumbnailImgPathParam) {
        this.thumbnailImgPathParam = thumbnailImgPathParam;
    }
}
