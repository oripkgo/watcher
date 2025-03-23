package com.watcher.business.story.resp;

import com.watcher.business.story.dto.StoryDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class StoryResp extends StoryDto {
    private String id;
    private String adminId;
    private String categoryId;
    private String memberCategoryId;
    private String memberCategoryNm;
    private String title;
    private String contents;
    private String realFileName;
    private String thumbnailImgPath;
    private String summary;
    private String secretYn;
    private String likeCnt;
    private String viewCnt;
    private String regId;
    private String regDate;
    private String uptId;
    private String uptDate;
    private String memberId;
    private String nickname;
    private String categoryNm;
    private String tags;
    private String commentCnt;
    private String blogName;
}
