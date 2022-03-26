package com.watcher.vo;


public class CommVo {

    /**
     * 페이징처리 관련 변수
     * */
    private int pageNo =1;			// 현재 페이지 번호
    private int listNo = 20;		// 한 페이지에 보여지는 목록 갯수
    private int pagigRange = 10;		// 한페이지에 보여지는 페이징처리 범위

    private int startPageNo;		// 시작 페이지
    private int endPageNo;			// 끝 페이지
    private int totalCnt;			// 총 데이터 수


}
