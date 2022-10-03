<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2022-10-01
  Time: 오후 4:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<div class="manage_box_top">
    <div>
        <span>오늘 방문수</span>
        <strong class="tDayVisitCnt"><%--52--%></strong>
    </div>
    <div>
        <span>어제 방문수</span>
        <strong class="yDayVisitCnt"><%--10--%></strong>
    </div>
    <div>
        <span>누적 방문수</span>
        <strong class="cumulativeVisitCnt"><%--1520--%></strong>
    </div>
    <div class="manage_box_btn">
        <em class="visitStatisCriteria"><%--2021-11-26 15:40 기준--%></em>
        <a href="${globalVar['myManagementStatistics']}">방문 통계</a>
    </div>
</div>

<script>

    comm.request({url:"/myManagement/visitor/cnt", data : "{}"},function(resp){
        // 삭제 성공
        if( resp.code == '0000'){

            $(".tDayVisitCnt").text(resp.visitInfo['TODAY_VISIT_CNT']);
            $(".yDayVisitCnt").text(resp.visitInfo['YESTERDAY_VISIT_CNT']);
            $(".cumulativeVisitCnt").text(resp.visitInfo['CUMULATIVE_VISIT_CNT']);
            $(".visitStatisCriteria").text(resp.visitInfo['VISIT_STATIS_CRITERIA'] + ' 기준');
        }
    })

</script>
