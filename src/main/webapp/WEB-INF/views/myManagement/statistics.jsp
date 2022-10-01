<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <%@include file="commMenu.jsp"%>

            <div class="manage_box_wrap">

                <div class="title_box">방문 통계</div>
                <div class="manage_box_top">
                    <div>
                        <span>오늘 방문수</span>
                        <strong>52</strong>
                    </div>
                    <div>
                        <span>어제 방문수</span>
                        <strong>10</strong>
                    </div>
                    <div>
                        <span>누적 방문수</span>
                        <strong>1520</strong>
                    </div>
                    <div class="manage_box_btn">
                        <em>2021-11-26 15:40 기준</em>
                        <a href="javascript:;">방문 통계</a>
                    </div>
                </div>

                <br><br>
                <div class="title_box">
                    2021.11.30 목
                    <div class="btn_sort">
                        <a href="javascript:;" class="on">일간</a>
                        <a href="javascript:;">주간</a>
                        <a href="javascript:;">월간</a>
                    </div>
                </div>
                <div class="graph_wrap02">
                    <img src="/resources/img/graph.jpg">
                    <ul class="keys_wrap">
                        <li>
                            <div class="keys_txt">
                                <span>검색</span>
                                <strong>1,222</strong>
                            </div>
                            <div class="keys_sub">
                                <span>네이버 검색</span><em>0</em>
                                <span>다음 검색</span><em>0</em>
                                <span>구글 검색</span><em>0</em>
                                <span>줌 검색</span><em>0</em>
                                <span>빙 검색</span><em>0</em>
                                <span>야후 검색</span><em>0</em>
                                <span>기타 검색</span><em>0</em>
                            </div>
                        </li>
                        <li>
                            <div class="keys_txt">
                                <span>SNS</span>
                                <strong>1,222</strong>
                            </div>
                            <div class="keys_sub">
                                <span>네이버 검색</span><em>0</em>
                                <span>다음 검색</span><em>0</em>
                                <span>구글 검색</span><em>0</em>
                                <span>줌 검색</span><em>0</em>
                                <span>빙 검색</span><em>0</em>
                                <span>야후 검색</span><em>0</em>
                                <span>기타 검색</span><em>0</em>
                            </div>
                        </li>
                    </ul>
                </div>


                <div class="manage_line">인기글</div>
                <div class="conts_rel">
                    <ul style="padding:20px 0px;">
                        <li>
                            <a href="story_detail.html">
                                <img src="/resources/img/sample01.jpg">
                                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                            </a>
                            <p>
                                <em>댓글 222</em>
                                <img src="/resources/img/line.png">
                                <em>공감 21</em>
                            </p>
                        </li>
                        <li>
                            <a href="story_detail.html">
                                <img src="/resources/img/sample02.jpg">
                                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                            </a>
                            <p>
                                <em>댓글 222</em>
                                <img src="/resources/img/line.png">
                                <em>공감 21</em>
                            </p>
                        </li>
                        <li>
                            <a href="story_detail.html">
                                <img src="/resources/img/sample03.jpg">
                                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                            </a>
                            <p>
                                <em>댓글 222</em>
                                <img src="/resources/img/line.png">
                                <em>공감 21</em>
                            </p>
                        </li>
                        <li>
                            <a href="story_detail.html">
                                <img src="/resources/img/sample01.jpg">
                                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                            </a>
                            <p>
                                <em>댓글 222</em>
                                <img src="/resources/img/line.png">
                                <em>공감 21</em>
                            </p>
                        </li>
                    </ul>
                </div>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>