package com.watcher.business.board.result;


import com.watcher.business.board.dto.NoticeDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Setter
@Getter
@ToString
public class BoardResult extends NoticeDto {
    private String searchId;
    private String searchKeyword;
    private String searchLevel;
    private String searchMemId;
    private String searchSecretYn;
    private String paramJson;
    private String editPermId;


    private List idList;
    private MultipartFile[] attachFiles;

}
