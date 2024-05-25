package com.watcher.enums;

import java.util.LinkedHashMap;
import java.util.Map;

public enum ResponseCode {
    SUCCESS_0000(200,"0000","OK"),

    /** 1xxx~5xxx : 클라이언트 오류, 6xxx~9xxx : 서버오류 */


    // 2xxx: 클라이언트 요청 값 오류
    ERROR_2001(400,"2001","API TOKEN 검증 오류"),
    ERROR_2002(400,"2002","TOKEN 무결성 검증 실패"),
    ERROR_2003(400,"2003","TOKEN과 매칭되는 세션조회 실패"),
    ERROR_2004(400,"2004","TOKEN 미존재"),
    ERROR_2005(400,"2005","댓글 내용 미입력"),

    // 3xxx: 세션오류
    ERROR_3001(400,"3001","세션유지시간을 초과했습니다."),

    // 4xxx: 업로드오류
    ERROR_4001(400,"4001","파일저장에 실패했습니다."),

    // 7xxx: 통신관련 오류

    // 8xxx: 암호화, 토큰 관련 오류

    // 9xxx: 서버 기본 오류
    ERROR_9999(500,"9999","정의되지 않은 서버 오류"),
    ;

    ResponseCode(int status, String code, String msg) {
        this.status = status;
        this.code = code;
        this.message = msg;
    }

    private int status;
    private String code;
    private String message;

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, String> getMap() {
        Map<String, String> result = new LinkedHashMap<>();
        result.put("code"   , this.getCode());
        result.put("message", this.getMessage());
        return result;
    }

}
