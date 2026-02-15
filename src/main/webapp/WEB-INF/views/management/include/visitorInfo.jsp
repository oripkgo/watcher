<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="stats">
    <div class="card">
        <h3>오늘 방문자</h3>
        <p class="todayVisitCount">0</p>
    </div>
    <div class="card">
        <h3>이번 주 방문자</h3>
        <p class="weeklyVisitCount">0</p>
    </div>
    <div class="card">
        <h3>이번 달 방문자</h3>
        <p class="monthlyVisitCount">0</p>
    </div>
</div>

<script>
  const apiUrlVisitorCnt = "/visitor/count";

  comm.request({url: apiUrlVisitorCnt, method: "GET"}, function (resp) {
    // 삭제 성공
    if (resp.code == '0000') {

      const criteriaStatisAt = resp.visitInfo['VISIT_STATIS_CRITERIA']
      const todayVisitCount = resp.visitInfo['TODAY_VISIT_CNT']
      const weeklyVisitCount = resp.visitInfo['WEEKLY_VISIT_CNT']
      const monthlyVisitCount = resp.visitInfo['MONTHLY_VISIT_CNT']
      const cumulativeVisitCount = resp.visitInfo['CUMULATIVE_VISIT_CNT']

      $(".todayVisitCount").text(todayVisitCount.toLocaleString());
      $(".weeklyVisitCount").text(weeklyVisitCount.toLocaleString());
      $(".monthlyVisitCount").text(monthlyVisitCount.toLocaleString());
    }
  })
</script>