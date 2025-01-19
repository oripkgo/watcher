package com.watcher.business.member.dto;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class MemberDto extends CommDto {

    private String id;              // 회원 아이디
    private String password;        // 패스워드
    private String loginId;         // 로그인 아이디
    private String email;           // 이메일
    private String phoneNum;        // 회원 휴대푠 번호
    private String gender;          // 회원 성별
    private String birth;           // 회원 생년월일
    private String name;            // 회원 이름
    private String nickname;        // 회원 유형별명
    private String memType;         // 회원 유형
    private String memProfileImg;   // 회원 프로필
    private String level;           // 회원 등급

}
