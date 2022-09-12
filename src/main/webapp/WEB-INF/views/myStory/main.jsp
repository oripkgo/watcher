<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    const notice_show_cnt = 4;

    $(document).on("ready", function () {

        // 공지사항 세팅
        initNotice(loginId);

        // 나의 스토리 세팅
        initMyStory(loginId);

    })

    function initMyStory(id){
        // /story/listAsync
    }

    function initNotice(id){
        comm.request({
            url: "/notice/listAsync?search_regId="+id
            , method: "GET"
            , headers: {"Content-type": "application/x-www-form-urlencoded"}
        }, function (data) {

            if( data.code == '0000' && data.list ){

                $(".notice_list").empty();
                for( let i=0;i<notice_show_cnt;i++ ){
                    const obj = data.list[i];
                    let li = $('<li></li>');

                    li.append('<a href="javascript:;">'+obj['TITLE']+'</a>');
                    li.append('<em>'+(obj['UPT_DATE'] || obj['REG_DATE'])+'</em>');
                    $(".notice_list").append(li);
                }

            }

        });

        $("#notice_more").on("click", function(){
            location.href="/notice/member/list?search_regId="+id;
        });


    }

</script>

<div class="section">
    <div class="ani-in my_layout">

        <div class="mystory_top ani_y delay1">

            <div class="mystory_title">태균스토리</div>
            <div class="storybox_search_wrap">
                <%--<div class="storybox_search">
                    <input type="text" placeholder="이 스토리에서 검색">
                    <a href="javascript:;"><img src="/resources/img/btn_search_b.png"></a>
                </div>
                <div class="member_box">
                    <a href="javascript:;" class="member_set"><img src="/resources/img/member_ico_b.png"></a>
                    <div class="member_app">
                        <a href="javascript:;">관리</a>
                        <a href="javascript:;">글쓰기</a>
                        <a href="javascript:;">로그인</a>
                    </div>
                </div>
                <script>
                    $(".member_set").click(function () {
                        $(".member_app").slideToggle("fast");
                    });
                </script>--%>
            </div>

        </div>

    </div>
</div>

<div class="section uline2">

    <div class="ani-in my_layout rline">
        <!--
        <div class="ad_banner_left">
            <span>AD</span>
        </div>

        <div class="ad_banner_right">
            <span>AD</span>
        </div>
        -->

        <div class="mystory_menu">
            <div class="title_line">카테고리 전체보기</div>
            <a href="javascript:;">IT</a>
            <a href="javascript:;">정치</a>
            <a href="javascript:;">가족</a>
            <a href="javascript:;">요리</a>
        </div>

        <div class="conts_wrap2 ani_y delay2">
            <div class="mystory_menu_mobile">
                <div class="board_title">카테고리 전체보기</div>
                <a href="javascript:;">IT</a>
                <a href="javascript:;">정치</a>
                <a href="javascript:;">가족</a>
                <a href="javascript:;">요리</a>
            </div>

            <div class="board_title">
                공지사항
                <a href="javascript:;" id="notice_more">더보기 <img src="/resources/img/down_arrow.png"></a>
            </div>
            <ul class="notice_list">
                <%--<li>
                    <a href="javascript:;">공지합니다. 내용내용내용~</a>
                    <em>2021.11.11</em>
                </li>--%>
            </ul>

            <div class="board_title">
                전체글
            </div>

            <ul class="board_list">
                <li>
                    <a href="story_detail.html">
                        <em>정치</em>
                        <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                        <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                        <img src="/resources/img/s_sample01.jpg">
                    </a>
                    <div class="story_key">
                        <a href="javascript:;">#컬처</a>
                        <a href="javascript:;">#영화</a>
                        <a href="javascript:;">#영화컬처</a>
                        <span>1시간전</span>
                        <span>공감21</span>
                        <em>by gauni1229</em>
                    </div>
                </li>
                <li>
                    <a href="story_detail.html">
                        <em>요리</em>
                        <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                        <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                        <img src="/resources/img/s_sample02.jpg">
                    </a>
                    <div class="story_key">
                        <a href="javascript:;">#컬처</a>
                        <a href="javascript:;">#영화</a>
                        <a href="javascript:;">#영화컬처</a>
                        <span>1시간전</span>
                        <span>공감21</span>
                        <em>by gauni1229</em>
                    </div>
                </li>
                <li>
                    <a href="story_detail.html">
                        <em>경제</em>
                        <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                        <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                        <img src="/resources/img/s_sample03.jpg">
                    </a>
                    <div class="story_key">
                        <a href="javascript:;">#컬처</a>
                        <a href="javascript:;">#영화</a>
                        <a href="javascript:;">#영화컬처</a>
                        <span>1시간전</span>
                        <span>공감21</span>
                        <em>by gauni1229</em>
                    </div>
                </li>
                <li>
                    <a href="story_detail.html">
                        <em>정치</em>
                        <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                        <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                        <img src="/resources/img/s_sample02.jpg">
                    </a>
                    <div class="story_key">
                        <a href="javascript:;">#컬처</a>
                        <a href="javascript:;">#영화</a>
                        <a href="javascript:;">#영화컬처</a>
                        <span>1시간전</span>
                        <span>공감21</span>
                        <em>by gauni1229</em>
                    </div>
                </li>
                <li>
                    <a href="story_detail.html">
                        <em>정치</em>
                        <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                        <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                        <img src="/resources/img/s_sample03.jpg">
                    </a>
                    <div class="story_key">
                        <a href="javascript:;">#컬처</a>
                        <a href="javascript:;">#영화</a>
                        <a href="javascript:;">#영화컬처</a>
                        <span>1시간전</span>
                        <span>공감21</span>
                        <em>by gauni1229</em>
                    </div>
                </li>
            </ul>

            <div class="pagging_wrap">
                <a href="javascript:;"><img src="/resources/img/prev_arrow.png"></a>
                <a href="javascript:;" class="on">1</a>
                <a href="javascript:;">2</a>
                <a href="javascript:;">3</a>
                <a href="javascript:;"><img src="/resources/img/next_arrow.png"></a>
            </div>

        </div>

    </div>
</div>
