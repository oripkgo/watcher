package com.watcher.business.management.dto;


import com.watcher.business.member.dto.MemberDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ManagementDto extends MemberDto {

    private String id;
    private String loginId;
    private String commentPermStatus;
    private String storyRegPermStatus;
    private String storyCommentPublicStatus;
    private String storyTitle;

}