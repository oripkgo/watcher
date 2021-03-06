package com.watcher.dto;


public class MemberDto extends CommDto {

    String id;              // key
    String password;        // 패스워드
    String memId;           // 회원 아이디
    String email;           // 이메일
    String phoneNum;        // 회원 휴대푠 번호
    String name;            // 회원 이름
    String nickname;        // 회원 유형별명
    String memType;         // 회원 유형
    String memProfileImg;   // 회원 프로필

    String level;           // 회원 등급
    String commentYn;       // 회원 댓글등록 여부

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMemId() {
        return memId;
    }

    public void setMemId(String memId) {
        this.memId = memId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getMemType() {
        return memType;
    }

    public void setMemType(String memType) {
        this.memType = memType;
    }

    public String getMemProfileImg() {
        return memProfileImg;
    }

    public void setMemProfileImg(String memProfileImg) {
        this.memProfileImg = memProfileImg;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getCommentYn() {
        return commentYn;
    }

    public void setCommentYn(String commentYn) {
        this.commentYn = commentYn;
    }
}
