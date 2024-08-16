package com.watcher.business.management.param;


import com.watcher.business.management.dto.ManagementDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ManagementParam extends ManagementDto {

    private String searchLoginId;
    private String searchContentType;
    private String searchContentId;

}
