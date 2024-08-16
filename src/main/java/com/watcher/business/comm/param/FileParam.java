package com.watcher.business.comm.param;


import com.watcher.business.comm.dto.FileDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class FileParam extends FileDto {

    private String board_id;
    private String board_type;
    private String whereId;
    private String whereContentsType;
    private String whereContentsId;

}
