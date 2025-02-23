<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="manage_menu">
    <%@include file="profile.jsp"%>
    <div class="manage_menu_link">
        <a href="${globalVar.managementMain}" class="menu_1st">홈</a>
        <a href="javascript:;" class="menu_1st">콘텐츠</a>
        <div class="menu_2st">
            <a href="${globalVar.managementBoard}">게시글 관리</a>
            <a href="${globalVar.managementCategory}">카테고리 관리</a>
            <a href="${globalVar.managementNotice}">공지관리</a>
            <a href="${globalVar.managementBoardExternal}">외부 게시글 관리</a>
        </div>
        <a href="javascript:;" class="menu_1st">스토리</a>
        <div class="menu_2st">
            <a href="${globalVar.managementSetting}">설정</a>
        </div>
        <a href="javascript:;" class="menu_1st">통계</a>
        <div class="menu_2st">
            <a href="${globalVar.managementStatistics}">방문 통계</a>
        </div>
    </div>
</div>

<script>
    $("[href='"+location.pathname+"']").addClass("on");
</script>