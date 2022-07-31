package com.watcher.dto;


public class CommDto {

    /**
     * 페이징처리 관련 변수
     * */
    private int pageNo = 1;			// 현재 페이지 번호
    private int listNo = 20;		// 한 페이지에 보여지는 목록 갯수
    private int pagigRange = 10;	// 한페이지에 보여지는 페이징처리 범위

    private int startPageNo;		// 시작 페이지
    private int endPageNo;			// 끝 페이지
    private int totalCnt;			// 총 데이터 수

    private String regId;       // 등록 아이디
    private String regDate;     // 등록 일자
    private String uptId;       // 수정 아이디
    private String uptDate;     // 수정 일자

    public int getPageNo() {
        return pageNo;
    }

    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }

    public int getListNo() {
        return listNo;
    }

    public void setListNo(int listNo) {
        this.listNo = listNo;
    }

    public int getPagigRange() {
        return pagigRange;
    }

    public void setPagigRange(int pagigRange) {
        this.pagigRange = pagigRange;
    }

    public int getStartPageNo() {
        return this.startPageNo;
    }

    public void setStartPageNo(int startPageNo) {
        this.startPageNo = startPageNo;
    }

    public int getEndPageNo() {
        return this.endPageNo;
    }

    public void setEndPageNo(int endPageNo) {
        this.endPageNo = endPageNo;
    }

    public int getTotalCnt() {
        return totalCnt;
    }

    public void setTotalCnt(int totalCnt) {
        this.totalCnt = totalCnt;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public String getUptId() {
        return uptId;
    }

    public void setUptId(String uptId) {
        this.uptId = uptId;
    }

    public String getUptDate() {
        return uptDate;
    }

    public void setUptDate(String uptDate) {
        this.uptDate = uptDate;
    }
}
