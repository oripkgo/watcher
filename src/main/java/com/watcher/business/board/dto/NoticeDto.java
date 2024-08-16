package com.watcher.business.board.dto;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class NoticeDto extends CommDto {
    private String id;
    private String title;
    private String contents;
    private String thumbnailImgPath;
    private String deleteYn;
    private String secretYn;
    private String viewsCnt;
    private String likeCnt;

}
