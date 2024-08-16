package com.watcher.business.visitor.dto;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class VisitorDto extends CommDto {
    String id;
    String accessPath;
    String accessTarget;
    String accPageUrl;
    String clientIp;
    String clientId;
    String callService;
    String visitStoryMemId;
    String regMonthInquiry;
    String regDateInquiry;
    String regDate;

}
