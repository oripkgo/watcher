package com.watcher.business.story.dto;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class StoryDto extends CommDto {

    private String id;
    private String categoryId;
    private String memberCategoryId;
    private String title;
    private String contents;
    private String thumbnailImgId;
    private String summary;
    private String deleteYn;
    private String secretYn;
    private String viewCnt;
    private String likeCnt;

}
