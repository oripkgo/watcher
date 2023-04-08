<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="/resources/task/js/business/management/statistics.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $(".manager_statistics_today").text(statisticsObj.getTodayDateAndWeekday());

        statisticsObj.setVisitorFromSearch(function(visitInfo){
            $(".all",".searchVisitor").text( statisticsObj.getLocaleString(visitInfo['ALL_CNT']));
            $(".naver",".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['NAVER_CNT']));
            $(".daum",".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['DAUM_CNT']));
            $(".google",".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['GOOGLE_CNT']));
            $(".zoom",".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['ZOOM_CNT']));
            $(".yahoo",".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['YAHOO_CNT']));
            $(".etc",".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['ETC_CNT']));

        });

        $('a','.btn_sort').on("click", function(){
            $('a','.btn_sort').removeClass('on')
            $(this).addClass('on');
        })
    })
</script>

<div class="section uline2">
    <div class="ani-in manage_layout">
        <div class="manage_conts">
            <%@include file="include/commMenu.jsp"%>
            <div class="manage_box_wrap">
                <div class="title_box">방문 통계</div>
                <%@include file="include/commVisitorInfo.jsp"%>
                <br><br>
                <div class="title_box">
                    <p class="manager_statistics_today">2021.11.30 목</p>
                    <div class="btn_sort">
                        <a href="javascript:;" class="on" onclick="getDailyVisitors();">일간</a>
                        <%--<a href="javascript:;">주간</a>--%>
                        <a href="javascript:;" onclick="getMonthVisitors();">월간</a>
                    </div>
                </div>
                <div class="graph_wrap02">
                    <%--<img src="/resources/img/graph.jpg">--%>
                    <%@include file="include/commCharts.jsp"%>
                    <ul class="keys_wrap">
                        <li class="searchVisitor">
                            <div class="keys_txt">
                                <span>검색</span>
                                <strong class="all">0</strong>
                            </div>
                            <div class="keys_sub">
                                <span>네이버</span><em class="naver">0</em>
                                <span>다음</span><em class="daum">0</em>
                                <span>구글</span><em class="google">0</em>
                                <span>줌</span><em class="zoom">0</em>
                                <span>야후</span><em class="yahoo">0</em>
                                <span>기타</span><em class="etc">0</em>
                            </div>
                        </li>
                        <li>
                            <div class="keys_txt">
                                <span>SNS</span>
                                <strong>0</strong>
                            </div>
                            <div class="keys_sub">
                                <span>네이버</span><em>0</em>
                                <span>다음</span><em>0</em>
                                <span>구글</span><em>0</em>
                                <span>줌</span><em>0</em>
                                <span>야후</span><em>0</em>
                                <span>기타</span><em>0</em>
                            </div>
                        </li>
                    </ul>
                </div>
                <%@include file="include/commPopularArticles.jsp"%>
            </div><!-------------//manage_box_wrap------------->
        </div>
    </div>
</div>