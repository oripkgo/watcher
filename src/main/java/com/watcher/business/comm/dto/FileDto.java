package com.watcher.business.comm.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class FileDto extends CommDto {

    private String id;
    private String regId;
    private String regDate;
    private String uptId;
    private String uptDate;
    private String contentsType;
    private String contentsId;
    private String realFileName;
    private String serverFileName;
    private String savePath;
    private String deleteYn;
    private String pathSeparator;

}
