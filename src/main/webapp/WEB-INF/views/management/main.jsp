<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <%@include file="include/commMenu.jsp"%>

            <div class="manage_box_wrap">
                <%@include file="include/commVisitorInfo.jsp"%>

                <div  class="graph_wrap">
                    <%@include file="include/commCharts.jsp"%>
                    <%--<img src="/resources/img/graph.jpg">--%>
                </div>

                <%--<div class="manage_line">수익</div>
                <div class="revenue_wrap">

                    <div class="revenue_left">
                        <div class="revenue_title">내 스토리 수입 예상</div>
                        <div class="revenue_sub">스토리 방문수로 추정한 내 스토리의 예상 수익입니다.<br>연동 플랫폼, 광고 수에 따라 실제 수익과 차이가 날 수 있습니다.</div>
                        <div class="revenue_stick">
                            <div class="revenue_txt">
                                일 방문수<br>
                                <strong>7,075</strong><em>명</em>
                            </div>

                            <div class="revenue_bar">
                                <div class="revenue_tip" style="width:33%;">
                                    <div class="revenue_cir"></div>

                                    <div class="revenue_box">
                                        <img src="/resources/img/cir_w.png"><span>예상 연수익</span>
                                        <div>
                                            3,000,000원 ~<br>
                                            <strong>3,500,235</strong><em>원</em>
                                        </div>
                                        <div class="aw_tip"></div>
                                    </div>
                                    <script>
                                        $(".revenue_cir").mouseenter(function(){
                                            $(".revenue_box").fadeIn("fast");
                                        });
                                        $(".revenue_cir").mouseleave(function(){
                                            $(".revenue_box").fadeOut("fast");
                                        });
                                    </script>

                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="revenue_right">
                        <div class="revenue_title">이번달 수익</div>
                        <em>2021-11-26 15:40 기준</em>
                        <div class="revenue_total">
                            3,000,000<em>원</em> ~<br>
                            <strong>3,500,235</strong><em>원</em>
                        </div>
                    </div>

                </div>--%>
                <!-------------//revenue_wrap------------->

                <%@include file="include/commPopularArticles.jsp"%>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>