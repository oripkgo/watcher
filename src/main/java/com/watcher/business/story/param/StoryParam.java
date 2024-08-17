package com.watcher.business.story.param;


import com.watcher.business.story.dto.StoryDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Setter
@Getter
@ToString
public class StoryParam extends StoryDto {
    private String          searchId;
    private String          searchKeyword;
    private String          searchCategoryId;
    private String          searchMemberCategoryId;
    private String          searchMemId;
    private String          searchAdminId;
    private String          searchSecretYn;
    private String          SortByRecommendationYn;
    private String          editPermId;
    private String          limitNum;
    private String          categoryNm;
    private String          tagsId;
    private String          tags;
    private String          isOneYearData;
    private String          paramJson;
    private String          token;
    private List            idList;
    private MultipartFile   thumbnailImgPathParam;

}
