package com.watcher.business.keyword.dto;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class PopularKeywordDto extends CommDto {

    private String id;
    private String clientIp;
    private String clientId;
    private String keyword;

}
