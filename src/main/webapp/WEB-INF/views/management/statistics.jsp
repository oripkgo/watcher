<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 5:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="include/header.jsp" %>
<div class="section uline2">
  <div class="ani-in manage_layout">
    <div class="manage_conts">
      <%@include file="include/menus.jsp" %>
      <div class="manage_box_wrap">
        <div class="title_box">방문 통계</div>
        <%@include file="include/visitorInfo.jsp"%>
        <br><br>
        <div class="title_box">
          <p class="manager_statistics_today"></p>
          <div class="btn_sort">
            <a href="javascript:;" class="on" onclick="chartVisitor.renderDailyVisitor();">일간</a>
            <a href="javascript:;" onclick="chartVisitor.renderMonthVisitor();">월간</a>
          </div>
        </div>
        <div class="graph_wrap02">
          <%@include file="include/charts.jsp"%>
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
        <%@include file="include/popularArticles.jsp"%>
      </div><!-------------//manage_box_wrap------------->
    </div>
  </div>
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

  $(document).on("ready", function(){
    $(".manager_statistics_today").text(statisticsObj.getTodayDateAndWeekday());

    statisticsObj.setVisitorFromSearch(function (visitInfo) {
      $(".all", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['ALL_CNT'] * 1));
      $(".naver", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['NAVER_CNT'] * 1));
      $(".daum", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['DAUM_CNT'] * 1));
      $(".google", ".searchVisitor").text(statisticsObj.getLocaleString(visitInfo['GOOGLE_CNT'] * 1));
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