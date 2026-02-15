<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/managerment-main.css"/>

<div class="layout">
    <!-- 사이드바 -->
    <%@include file="include/menus.jsp" %>

    <!-- 메인 컨텐츠 -->
    <main class="main">
        <!-- 상단 통계 카드 -->
        <%@include file="include/visitorInfo.jsp" %>

        <!-- 그래프 -->
        <div class="chart-box">
            <h3>한 달간 방문자 추이</h3>
            <%@include file="include/charts.jsp" %>
        </div>

        <!-- 인기 게시글 -->
        <%@include file="include/popularArticles.jsp" %>
    </main>
</div>

