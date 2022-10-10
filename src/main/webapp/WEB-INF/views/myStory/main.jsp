<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">

    const myStory_search_memberId   = '${memId}';
    const notice_show_cnt           = 4;
    const pageNo                    = '${vo.pageNo}' || '1';
    const listNo                    = '${vo.listNo}' || '1';
    const pagigRange                = '${vo.pagigRange}' || '1';
    const categoryId                = '${vo.categoryId}';
    const member_category_list      = JSON.parse('${member_category_list}');

    $(document).on("ready", function () {

        // 회원 카테고리 세팅
        initCategory(member_category_list);

        // 공지사항 세팅
        initNotice(myStory_search_memberId);

        // 나의 스토리 세팅
        initMyStory(myStory_search_memberId, categoryId);

    })

    function initCategory(list){

        if( list &&  list.length > 0 ){
            list.forEach(function(obj){
                const a = $('<a></a>');
                $(a).text(obj.CATEGORY_NM);
                $(a).attr('href', "/myStory/"+myStory_search_memberId+"/"+ obj.DEFALUT_CATEG_ID+"?category_nm="+encodeURIComponent(obj.CATEGORY_NM));
                $(".mystory_menu, .mystory_menu_mobile").append(a);
            })
        }

        /* <a href="javascript:;">IT</a>
         <a href="javascript:;">정치</a>
         <a href="javascript:;">가족</a>
         <a href="javascript:;">요리</a>*/

    }

    function initMyStory(uid,categId){

        comm.appendInput('#myStoryForm', "search_memId"         , uid       );
        comm.appendInput('#myStoryForm', "search_category_id"   , categId   );


        comm.list('#myStoryForm', '/myStory/listAsync',function(data){

            $("#myStoryList").empty();

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];
                let listHtml = '';
                let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

                listHtml += '<li>';
                listHtml += '    <a href="'+ getStoryViewUrl(obj.ID) + '">';
                listHtml += '        <em>'+obj.CATEGORY_NM+'</em>';
                listHtml += '        <strong>'+obj.TITLE+'</strong>';

                listHtml += '        <span>';
                if( !obj.SUMMARY ){
                    obj.SUMMARY = '';
                }

                if( obj.SUMMARY.length < 100 ){
                    listHtml += obj.SUMMARY;
                }else{
                    listHtml += (obj.SUMMARY || '').substring(0,100)+' ...';
                }

                listHtml += '</span>';

                if( obj.THUMBNAIL_IMG_PATH ){
                    listHtml += '        <img src="'+obj.THUMBNAIL_IMG_PATH+'">';
                }

                listHtml += '    </a>';
                listHtml += '    <div class="story_key">';

                if( obj.TAGS ){
                    let tag_arr = obj.TAGS.split(',');

                    tag_arr.forEach(function(tag,index){
                        listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                    })
                }

                listHtml += '    </div>';
                listHtml += '    <div class="story_key">';
                // listHtml += '        <a href="javascript:;">#컬처</a>';
                // listHtml += '        <a href="javascript:;">#영화</a>';
                // listHtml += '        <a href="javascript:;">#영화컬처</a>';
                listHtml += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>';
                listHtml += '        <span>공감 ' + obj.LIKE_CNT + '</span>';
                listHtml += '        <em>by ' + obj.NICKNAME + '</em>';
                listHtml += '    </div>';
                listHtml += '</li>';
                listHtml += '';

                listHtml = $(listHtml);

                $(listHtml).data(obj);

                $("#myStoryList").append(listHtml);

            }


        }, pageNo, listNo, pagigRange);


    }

    function initNotice(id){
        comm.request({
            url: "/notice/listAsync?search_memId="+id
            , method: "GET"
            , headers: {"Content-type": "application/x-www-form-urlencoded"}
        }, function (data) {

            if( data.code == '0000' && ( data.list && data.list.length > 0 ) ){

                $(".notice_list").empty();
                for( let i=0;i<notice_show_cnt;i++ ){
                    const obj = data.list[i];
                    let li = $('<li></li>');

                    li.append('<a href="/notice/view?id='+obj.ID+'">'+obj['TITLE']+'</a>');
                    li.append('<em>'+(obj['UPT_DATE'] || obj['REG_DATE'])+'</em>');
                    $(".notice_list").append(li);
                }

            }

        });

        $("#notice_more").on("click", function(){
            location.href="/notice/member/list?search_memId="+id;
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
            <%--<a href="javascript:;">IT</a>
            <a href="javascript:;">정치</a>
            <a href="javascript:;">가족</a>
            <a href="javascript:;">요리</a>--%>
        </div>

        <div class="conts_wrap2 ani_y delay2">
            <div class="mystory_menu_mobile">
                <div class="board_title">카테고리 전체보기</div>
                <%--<a href="javascript:;">IT</a>
                <a href="javascript:;">정치</a>
                <a href="javascript:;">가족</a>
                <a href="javascript:;">요리</a>--%>
            </div>

            <c:if test="${categoryListYn != 'Y'}">
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
            </c:if>

            <div class="board_title">
                <c:choose>
                    <c:when test="${!(empty vo.category_nm)}">
                        ${vo.category_nm}
                    </c:when>
                    <c:otherwise>
                        전체글
                    </c:otherwise>
                </c:choose>
            </div>


            <form id="myStoryForm">
                <input type="hidden" name="search_memId" id="search_memId">
                <input type="hidden" name="search_category_id" id="search_category_id">

                <ul class="board_list" id="myStoryList">
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

                <div class="pagging_wrap"></div>

            </form>

        </div>

    </div>
</div>
