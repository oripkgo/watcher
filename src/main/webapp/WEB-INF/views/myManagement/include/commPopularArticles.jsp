<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2022-10-01
  Time: 오후 4:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<div class="manage_line">인기글</div>
<div class="conts_rel">
    <ul style="padding:20px 0px;">
        <li>
            <a href="story_detail.html">
                <img src="/resources/img/sample01.jpg">
                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
            </a>
            <p>
                <em>댓글 222</em>
                <img src="/resources/img/line.png">
                <em>공감 21</em>
            </p>
        </li>
        <li>
            <a href="story_detail.html">
                <img src="/resources/img/sample02.jpg">
                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
            </a>
            <p>
                <em>댓글 222</em>
                <img src="/resources/img/line.png">
                <em>공감 21</em>
            </p>
        </li>
        <li>
            <a href="story_detail.html">
                <img src="/resources/img/sample03.jpg">
                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
            </a>
            <p>
                <em>댓글 222</em>
                <img src="/resources/img/line.png">
                <em>공감 21</em>
            </p>
        </li>
        <li>
            <a href="story_detail.html">
                <img src="/resources/img/sample01.jpg">
                <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
            </a>
            <p>
                <em>댓글 222</em>
                <img src="/resources/img/line.png">
                <em>공감 21</em>
            </p>
        </li>
    </ul>
</div>


<script>

    comm.request({url:"/myManagement/popularity/articles", method : "GET"},function(resp){
        if( resp.code == '0000'){

            debugger;

            $(".tDayVisitCnt").text(resp.visitInfo['TODAY_VISIT_CNT']);
            $(".yDayVisitCnt").text(resp.visitInfo['YESTERDAY_VISIT_CNT']);
            $(".cumulativeVisitCnt").text(resp.visitInfo['CUMULATIVE_VISIT_CNT']);
            $(".visitStatisCriteria").text(resp.visitInfo['VISIT_STATIS_CRITERIA'] + ' 기준');
        }
    })

</script>
