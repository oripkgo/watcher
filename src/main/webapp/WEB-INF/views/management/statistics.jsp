<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    $(document).ready(function(){
        setVisitorFromSearch();
        const d = new Date();
        $(".manager_statistics_today").text(comm.date.getDate(d, '.') + ' ' + comm.date.getDayOfTheWeek(d));

        $('a','.btn_sort').on("click", function(){
            IndicateButtonClicked(this);
        })
    })

    function getLocaleString(numStr){
        return (numStr*1).toLocaleString()
    }

    function setVisitorFromSearch(){
        comm.request({url: "/visitor/search/cnt", method: "GET"}, function (resp) {
            if (resp.code == '0000') {
                $(".all",".searchVisitor").text( getLocaleString(resp['visitInfo']['ALL_CNT']));
                $(".naver",".searchVisitor").text(getLocaleString(resp['visitInfo']['NAVER_CNT']));
                $(".daum",".searchVisitor").text(getLocaleString(resp['visitInfo']['DAUM_CNT']));
                $(".google",".searchVisitor").text(getLocaleString(resp['visitInfo']['GOOGLE_CNT']));
                $(".zoom",".searchVisitor").text(getLocaleString(resp['visitInfo']['ZOOM_CNT']));
                $(".yahoo",".searchVisitor").text(getLocaleString(resp['visitInfo']['YAHOO_CNT']));
                $(".etc",".searchVisitor").text(getLocaleString(resp['visitInfo']['ETC_CNT']));
            }
        })
    }

    function IndicateButtonClicked(obj){
        $('a','.btn_sort').removeClass('on')
        $(obj).addClass('on');
    }
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