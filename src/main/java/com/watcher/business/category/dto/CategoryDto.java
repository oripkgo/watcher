package com.watcher.business.category.dto;

import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class CategoryDto extends CommDto {
    private String id;
    private String regId;
    private String regDate;
    private String uptId;
    private String uptDate;
    private String categoryNm;
    private String categoryComents;
    private String categoryImgPath;
    private String showYn;
    private String sort;
}
