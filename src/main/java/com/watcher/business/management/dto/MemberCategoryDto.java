package com.watcher.business.management.dto;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

@Setter
@Getter
@ToString
public class MemberCategoryDto extends CommDto {

    private String          id;
    private String          defalutCategId;
    private String          loginId;
    private String          categoryNm;
    private String          categoryComents;
    private String          categoryImgPath;
    private String          showYn;
    private String          deleteYn;
    private MultipartFile   categoryImgFile;

}
