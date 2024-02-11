<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="manage_box_top">
    <div>
        <span>오늘 방문수</span>
        <strong class="tDayVisitCnt">0</strong>
    </div>
    <div>
        <span>어제 방문수</span>
        <strong class="yDayVisitCnt">0</strong>
    </div>
    <div>
        <span>누적 방문수</span>
        <strong class="cumulativeVisitCnt">0</strong>
    </div>
    <div class="manage_box_btn">
        <em class="visitStatisCriteria"></em>
        <a href="${globalVar.managementStatistics}">방문 통계</a>
    </div>
</div>

<script>
    const apiUrlVisitorCnt = "/visitor/count";

    comm.request({url:apiUrlVisitorCnt, method : "GET"},function(resp){
        // 삭제 성공
        if( resp.code == '0000'){

            $(".tDayVisitCnt").text(resp['visitInfo']['TODAY_VISIT_CNT']);
            $(".yDayVisitCnt").text(resp['visitInfo']['YESTERDAY_VISIT_CNT']);
            $(".cumulativeVisitCnt").text(resp['visitInfo']['CUMULATIVE_VISIT_CNT']);
            $(".visitStatisCriteria").text(resp['visitInfo']['VISIT_STATIS_CRITERIA'] + ' 기준');
        }
    })
</script>