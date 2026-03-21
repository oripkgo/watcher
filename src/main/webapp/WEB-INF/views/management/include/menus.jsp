<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<aside class="sidebar">
    <div class="profile" onclick="location.href='${globalVar.managementMain}'">
        <img src="https://i.pravatar.cc/100" alt="프로필">
        <h2 class="mystory_title"></h2>
    </div>
    <button class="menu-toggle" onclick="toggleMenu()">☰ 메뉴</button>
    <ul class="menu-area" id="menu">
        <li><a href="${globalVar.managementBoard}">게시글 관리</a></li>
        <li><a href="${globalVar.managementCategory}">카테고리 관리</a></li>
        <li><a href="${globalVar.managementNotice}">공지관리</a></li>
        <li><a href="${globalVar.managementBoardExternal}">내 활동 내역</a></li> <!-- ✅ 추가된 메뉴 -->
        <li><a href="${globalVar.managementSetting}">설정</a></li>
        <li><a href="${globalVar.managementStatistics}">방문 통계</a></li>
    </ul>
</aside>


<script>
  if (window.loginYn) {
    $("img", ".profile").attr("src", window.memProfileImg)
  }

  $(".mystory_title").text(window.storyTitle);

  // 메뉴 토글
  function toggleMenu() {
    document.getElementById('menu').classList.toggle('active');
  }
</script>
