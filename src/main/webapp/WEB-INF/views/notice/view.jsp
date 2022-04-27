<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="vo" value="${result.view}"/>

<script>

    let type    = 'NOTICE';
    let id      = '${vo.id}';
    let regDate = '${vo.regDate}'

    $(document).ready(function(){

        // 지난 시간 세팅
        $("#last_time").html( comm.last_time_cal(regDate.split(" ")[0]) );

        comm.board_view_init(type, id, function(resp){


        },{"likeTarget":".like", "tagsTarget":".conts_tag"});

    })

</script>



<div class="section">
    <div class="ani-in sub_layout">

        <div class="detail_top ani_y delay1">
            <div class="detail_kind">공지사항</div>
            <strong>${vo.title}</strong>
            <div class="detail_memo">
                <em>by ${vo.regId}</em>
                <img src="/resources/img/line.png">
                <span id="last_time">1시간전</span>

                <c:if test="${result.modify_authority_yn eq 'Y'}">
                    <div class="btn_basic">
                        <a href="javascript:;">수정</a>
                        <img src="/resources/img/line.png">
                        <a href="javascript:;">삭제</a>
                    </div>
                </c:if>

            </div>
        </div>

    </div>
</div>


<form id="noticeForm" name="noticeForm" method="get">
    <div class="section uline2">
       <%-- <div class="black_line"></div>--%>

        <div class="ani-in sub_layout rline <%--uline--%>">

           <%--
           <div class="ad_banner_left">
                <span>AD</span>
            </div>

            <div class="ad_banner_right">
                <span>AD</span>
            </div>
            --%>

            <div class="conts_wrap ani_y delay2">

                ${vo.contents}

                <div class="conts_sns">
                    <a href="javascript:;" class="zimm like" data-likecnt="${vo.likeCnt}">공감 ${vo.likeCnt}</a>

                    <%--
                    <a href="javascript:;" class="sns_btn"></a>
                    <a href="javascript:;" class="read_btn">구독하기</a>
                    --%>
                    <%--
                    <div class="sns_view">
                        <div class="uptip"></div>
                        <span>해당 글 SNS에 공유하기</span>
                        <p>
                            <a href="javascript:;"><img src="/resources/img/sns01.png"></a>
                            <a href="javascript:;"><img src="/resources/img/sns02.png"></a>
                            <a href="javascript:;"><img src="/resources/img/sns03.png"></a>
                            <a href="javascript:;"><img src="/resources/img/sns04.png"></a>
                            <a href="javascript:;"><img src="/resources/img/sns05.png"></a>
                            <a href="javascript:;"><img src="/resources/img/sns06.png"></a>
                        </p>
                        <a href="javascript:;" class="btn_url">url 복사</a>
                    </div>
                    --%>
                </div>
                <script>
                    $(".sns_btn").click(function () {
                        $(".sns_view").slideToggle("fast");
                    });
                </script>

                <div class="conts_tag" style="display: none;">
                    <strong class="conts_tit">태그</strong>
                    <%--
                    <a href="javascript:;">#컬처</a>
                    <a href="javascript:;">#영화</a>
                    <a href="javascript:;">#영화컬처</a>
                    --%>
                </div>


                <div class="conts_review">
                    <strong class="conts_tit">댓글<em>2</em></strong>
                    <ul>
                        <li>
                            <div class="member_re"><img src="/resources/img/member_ico.png"></div>
                            <div class="review_info">
                                <em>gauni1229</em>
                                <img src="/resources/img/line.png">
                                <span>1시간</span>
                                <img src="/resources/img/line.png">
                                <span class="accuse">신고</span>
                                <strong>자신에게서 해답이 있겠지요.화이팅</strong>
                                <a href="javascript:;">답글달기</a>
                            </div>
                        </li>
                        <li>
                            <div class="member_re"><img src="/resources/img/member_ico.png"></div>
                            <div class="review_info">
                                <em>gauni1229</em>
                                <img src="/resources/img/line.png">
                                <span>1시간</span>
                                <img src="/resources/img/line.png">
                                <span class="accuse">신고</span>
                                <strong>자신에게서 해답이 있겠지요.화이팅</strong>
                                <a href="javascript:;">답글달기</a>
                            </div>
                        </li>
                    </ul>
                </div>

                <div class="write_wrap">
                    <textarea placeholder="로그인하고 댓글을 입력해보세요!"></textarea>
                    <a href="javascript:;">확인</a>
                </div>

             <%--
                <div class="ad_banner">
                    <span>AD</span>
                </div>
               --%>

            </div>

        </div>
    </div>

</form>