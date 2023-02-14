<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    $(document).ready(function(){
        const d = new Date();
        $(".manager_statistics_today").text(comm.date.getDate(d, '.') + ' ' + comm.date.getDayOfTheWeek(d));

        $('a','.btn_sort').on("click", function(){
            IndicateButtonClicked(this);
        })
    })

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
                                <strong>0</strong>
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


                <%@include file="include/commPopularArticles.jsp"%>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>