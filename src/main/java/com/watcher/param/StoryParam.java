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
    String tags;
    String search_regId;

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

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getSearch_regId() {
        return search_regId;
    }

    public void setSearch_regId(String search_regId) {
        this.search_regId = search_regId;
    }

    public MultipartFile getThumbnailImgPathParam() {
        return thumbnailImgPathParam;
    }

    public void setThumbnailImgPathParam(MultipartFile thumbnailImgPathParam) {
        this.thumbnailImgPathParam = thumbnailImgPathParam;
    }
}
