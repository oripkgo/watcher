<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-08
  Time: 오후 5:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section">
    <div class="ani-in new_mystory_layout">
        <div class="new_mystory_title_box ani_y">
            <a class="new_mystory_title" href="/my-story/${storyAdminId}">${storyInfo['STORY_TITLE']}</a>
            <a href="javascript:;" class="new_mystory_mobile_menu_btn"></a>
        </div>
    </div>
</div>


<div class="section uline2">
    <div class="ani-in new_mystory_layout">
        <div class="new_mystory_contents_box ani_y">
            <div class="new_mystory_menu_box">
                <div class="new_mystory_photo">
                    <img src="${storyInfo['MEM_PROFILE_IMG']}"/>
                </div>
                <div class="new_mystory_menu_list">
                    <ul></ul>
                </div>
            </div>
            <div class="new_mystory_contents">
                <div class="new_mystory_notice">

                    <c:if test="${noticeListYn ne 'Y'}">
                        <div class="board_title">
                            공지사항
                            <a href="javascript:;" id="notice_more">더보기 <img src="/resources/img/down_arrow.png"></a>
                        </div>
                        <ul class="notice_list"></ul>
                    </c:if>

                </div>

<%--                STORY_REG_PERM_STATUS--%>

                <c:if test="${editPermYn eq 'Y'}">
                    <div class="new_btn_right_box">
                        <div class="btn_tb">
                            <a href="javascript:;" onclick="moveEditPage('${editPermId}');">글쓰기</a>
                        </div>
                    </div>
                </c:if>

                <div class="new_mystory_list">
                    <div class="board_title">
<%--                        {{ boardTitle }}--%>
                    </div>

                    <form id="myStoryForm">
                        <input type="hidden" name="searchAdminId" id="searchAdminId">
                        <input type="hidden" name="searchCategoryId" id="searchCategoryId">

                        <ul class="board_list" id="myStoryList"></ul>
                        <div class="pagging_wrap"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<script>

    const memberCategoryList = comm.category.getMemberPublic('${storyAdminId}');
    const myStorylistDataUrl = '/my-story/${storyAdminId}/list';
    const noticeListDataUrl = '/notice/list/data?searchMemId=${storyAdminId}';
    const noticeMoreUrl = '/my-story/${storyAdminId}/notice/list?mystorytitle=${storyInfo['STORY_TITLE']}';
    const paramCategoryName = '${dto['categoryNm']}';
    const paramCategoryId = '${dto['categoryId']}';
    const myStoryMemberId = '${storyAdminId}';
    let noticeShowCnt = 5;

    const initCategory = function (list) {
        if (list && list.length > 0) {
            list.forEach(function (obj) {
                const li = $('<li></li>');
                const a = $('<a></a>');
                $(a).text(obj['CATEGORY_NM']);
                $(a).attr('href', "/my-story/" + myStoryMemberId + "/" + obj.ID + "?categorynm=" + encodeURIComponent(obj['CATEGORY_NM']));

                if( paramCategoryName == obj['CATEGORY_NM'] ){
                    $(a).addClass("on");
                }

                $(li).append(a)
                $(".new_mystory_menu_list ul").append(li);
            })
        }
    }

    const initMyStory = function (uid, categId) {
        comm.dom.appendInput('#myStoryForm', "searchMemberCategoryId", categId);

        comm.paging.getList('#myStoryForm', myStorylistDataUrl, function (data) {
            comm.paging.emptyList("#myStoryList")

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];
                let listHtml = '';

                listHtml += '<li>';
                listHtml += '    <a href="' + window.getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '">';
                listHtml += '        <em>' + obj['CATEGORY_NM'] + '</em>';
                listHtml += '        <strong>' + obj['TITLE'] + '</strong>';

                listHtml += '        <span>';
                if (!obj.SUMMARY) {
                    obj.SUMMARY = '';
                }

                if (obj.SUMMARY.length < 100) {
                    listHtml += obj.SUMMARY;
                } else {
                    listHtml += (obj.SUMMARY || '').substring(0, 100) + ' ...';
                }

                listHtml += '</span>';
                listHtml += window.getImgTagStr(obj['THUMBNAIL_IMG_PATH'])
                listHtml += '    </a>';
                listHtml += '    <div class="story_key">';

                if (obj['TAGS']) {
                    let tag_arr = obj.TAGS.split(',');

                    tag_arr.forEach(function (tag) {
                        listHtml += '        <a href="javascript:;">#' + tag.trim() + '</a>';
                    })
                }

                listHtml += '    </div>';
                listHtml += '    <div class="story_key">';
                // listHtml += '        <a href="javascript:;">#컬처</a>';
                // listHtml += '        <a href="javascript:;">#영화</a>';
                // listHtml += '        <a href="javascript:;">#영화컬처</a>';
                listHtml += '        <span>' + comm.date.getPastDate(obj['REG_DATE']) + '</span>';
                listHtml += '        <span>공감 ' + obj['LIKE_CNT'] + '</span>';
                listHtml += '        <em>by ' + obj['NICKNAME'] + '</em>';
                listHtml += '    </div>';
                listHtml += '</li>';
                listHtml += '';

                listHtml = $(listHtml);

                $(listHtml).data(obj);

                comm.paging.renderList("#myStoryList", listHtml);
            }

        });
    }

    const moveEditPage = function(editPermId){
        $("body").append(comm.dom.appendForm("storyEditForm"));
        const form = $("#storyEditForm");
        $(form).attr("action", "/story/write")
        comm.dom.appendInput(form, "editPermId", editPermId);
        $(form).submit();
    }

    const initNotice = function (id) {
        comm.request({
            url: noticeListDataUrl
            , method: "GET"
            , headers: {"Content-type": "application/x-www-form-urlencoded"}
        }, function (data) {
            if (data.code == '0000' && (data.list && data.list.length > 0)) {

                $(".notice_list").empty();

                if (noticeShowCnt > data.list.length) {
                    noticeShowCnt = data.list.length;
                }

                for (let i = 0; i < noticeShowCnt; i++) {
                    const obj = data.list[i];
                    let li = $('<li></li>');

                    li.append('<a href="' + window.getNoticeViewUrl(obj.ID, id) + '">' + obj['TITLE'] + '</a>');
                    li.append('<em>' + (obj['UPT_DATE'] || obj['REG_DATE']) + '</em>');
                    $(".notice_list").append(li);
                }
            }
        });

        $("#notice_more").on("click", function () {
            location.href = noticeMoreUrl;
        });
    }

    $(document).on("ready", function(){
        // 회원 카테고리 세팅
        initCategory(memberCategoryList);

        // 공지사항 세팅
        initNotice(myStoryMemberId);

        // 나의 스토리 세팅
        initMyStory(myStoryMemberId, paramCategoryId);

        $(".new_mystory_mobile_menu_btn").click(function(){
            $(".new_mystory_menu_box").toggleClass("on");
        });
    })
</script>