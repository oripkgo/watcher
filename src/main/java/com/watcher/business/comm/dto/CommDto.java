package com.watcher.business.comm.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class CommDto {

    /**
     * 페이징처리 관련 변수
     * */
    private int     pageNo = 1;			// 현재 페이지 번호
    private int     listNo = 10;		// 한 페이지에 보여지는 목록 갯수
    private int     pagigRange = 10;	// 한페이지에 보여지는 페이징처리 범위

    private int     startPageNo;		// 시작 페이지
    private int     endPageNo;			// 끝 페이지
    private int     totalCnt;			// 총 데이터 수

    private String  adminId;            // 등록 아이디
    private String  regId;              // 등록 아이디
    private String  regDate;            // 등록 일자
    private String  uptId;              // 수정 아이디
    private String  uptDate;            // 수정 일자
    private String  paramJson;          // json string형태에 파라미터

}
