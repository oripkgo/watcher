<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 5:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-common.css"/>
<link rel="stylesheet" type="text/css" href="/resources/css/management-statistics.css"/>

<div class="layout">
    <!-- 사이드바 -->
    <%@include file="include/menus.jsp" %>


    <!-- 메인 컨텐츠 -->
    <main class="main">
        <!-- 상단 통계 카드 -->
        <%@include file="include/visitorInfo.jsp" %>


        <!-- 그래프 -->
        <div class="chart-box">
            <h3>방문자 추이</h3>
            <div class="chart-buttons">
                <button class="active" onclick="updateChart('day')">일간</button>
                <button onclick="updateChart('month')">월간</button>
            </div>
            <%@include file="include/charts.jsp" %>
        </div>


        <!-- 검색 유입 -->
        <div class="search-referrals">
            <h3>검색 유입</h3>
            <ul class="searchVisitor">
                <li><span>네이버</span><span class="naver">0</span></li>
                <li><span>다음</span><span class="daum">0</span></li>
                <li><span>구글</span><span class="google">0</span></li>
                <li><span>줌</span><span class="zoom">0</span></li>
                <li><span>야후</span><span class="yahoo">0</span></li>
                <li><span>기타</span><span class="etc">0</span></li>
            </ul>
        </div>

        <%@include file="include/popularArticles.jsp" %>
    </main>
</div>


<script>
  const visitorCntSearchUrl = "/visitor/count/inflow/source";

  const statisticsObj = {
    getTodayDateAndWeekday: function () {
      const d = new Date();
      return comm.date.getDate(d, '.') + ' ' + comm.date.getDayOfTheWeek(d);
    },

    getLocaleString: function (numStr) {
      return (numStr * 1).toLocaleString();
    },

    setVisitorFromSearch: function (callback) {
      comm.request({url: visitorCntSearchUrl, method: "GET"}, function (resp) {
        if (resp.code == '0000' && callback) {
          callback(resp['visitInfo']);
        }
      })
    },
  }

  function updateChart(type) {
    document.querySelectorAll(".chart-buttons button").forEach(
        btn => btn.classList.remove("active"));
    event.target.classList.add("active");

    if (type === 'day') {
      chartVisitor.renderDailyVisitor()
    } else if (type === 'month') {
      chartVisitor.renderMonthVisitor();
    }
  }

  $(document).on("ready", function () {
    $(".manager_statistics_today").text(statisticsObj.getTodayDateAndWeekday());

    statisticsObj.setVisitorFromSearch(function (visitInfo) {
      $(".all", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['ALL_CNT'] * 1));
      $(".naver", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['NAVER_CNT'] * 1));
      $(".daum", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['DAUM_CNT'] * 1));
      $(".google", ".searchVisitor").text(
          statisticsObj.getLocaleString(visitInfo['GOOGLE_CNT'] * 1));
      $(".zoom", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['ZOOM_CNT'] * 1));
      $(".yahoo", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['YAHOO_CNT'] * 1));
      $(".etc", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['ETC_CNT'] * 1));

    });

    $('a', '.btn_sort').on("click", function () {
      $('a', '.btn_sort').removeClass('on')
      $(this).addClass('on');
    })
  })
</script>