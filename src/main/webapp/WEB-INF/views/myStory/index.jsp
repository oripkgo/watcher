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

<link rel="stylesheet" type="text/css" href="/resources/css/my-story.css"/>


<div class="layout">
    <!-- 왼쪽 사이드바 -->
    <aside class="sidebar">
        <div class="profile">
            <h2 onclick="location.href='/my-story/${storyAdminId}'">${storyInfo['STORY_TITLE']}</h2>
            <img src="${storyInfo['MEM_PROFILE_IMG']}" alt="Profile"/>
        </div>

        <!-- 대표 글 -->
        <%--
        <div class="category">
             <h3>내 블로그 대표 글</h3>
             <p>
                 안녕하세요! 이 블로그는 제가 살아가면서 배우고 경험한 것들을 공유하는 공간입니다.
                 기술, 여행, 일상 이야기를 담고 있어요.
             </p>
         </div>
         --%>

        <!-- 카테고리 목록 (PC/태블릿 전용) -->
        <nav class="categories">
            <h3>카테고리</h3>
            <ul class="new_mystory_menu_list">
            </ul>
        </nav>
    </aside>

    <!-- 메인 컨텐츠 -->
    <main class="main">
        <!-- 모바일 전용 가로 스크롤 카테고리 -->
        <nav class="categories-mobile">
            <ul class="new_mystory_menu_list">
            </ul>
        </nav>

        <c:if test="${noticeListYn ne 'Y'}">
            <!-- 공지사항 -->
            <section class="notice">
                <div class="section-header">
                    <h3>공지사항</h3>
                    <a href="javascript:;" id="notice_more" class="more-btn">더보기 <i
                            class="fa fa-angle-right"></i></a>
                </div>
                <ul class="notice_list">
                </ul>

                <div class="empty-msg" style="display: none;">
                    <i class="fa fa-info-circle"></i>
                    <p>등록된 공지사항이 없습니다.</p>
                </div>
            </section>
        </c:if>


        <!-- 게시글 목록 -->
        <section class="posts">
            <div class="section-header">
                <h3>내 게시글</h3>
                <c:if test="${editPermYn eq 'Y'}">
                    <a href="javascript:;" onclick="moveEditPage('${editPermId}');"
                       class="more-btn">글쓰기 <i
                            class="fa fa-angle-right"></i></a>
                </c:if>
            </div>
            <form id="myStoryForm">
                <input type="hidden" name="searchAdminId" id="searchAdminId">
                <input type="hidden" name="searchCategoryId" id="searchCategoryId">
                <ul id="myStoryList">
                </ul>
                <nav class="pagination"></nav>
            </form>
        </section>
    </main>
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
        $(a).attr('href',
            "/my-story/" + myStoryMemberId + "/" + obj.ID + "?categorynm=" + encodeURIComponent(
            obj['CATEGORY_NM']));

        if (paramCategoryName == obj['CATEGORY_NM']) {
          $(a).addClass("on");
        }

        $(li).append(a)
        $(".new_mystory_menu_list").append(li);
      })
    }
  }

  const initMyStory = function (uid, categId) {
    comm.dom.appendInput('#myStoryForm', "searchMemberCategoryId", categId);

    comm.paging.getList('#myStoryForm', myStorylistDataUrl, function (data) {
      comm.paging.emptyList("#myStoryList");

      // 1. 데이터가 없을 때 표시
      if (!data.list || data.list.length === 0) {
        let emptyHtml = `
        <div class="empty-msg">
            <i class="fa fa-pencil-square-o"></i>
            <p>아직 작성된 게시글이 없습니다.</p>
        </div>`;
        $("#myStoryList").append(emptyHtml);
        return;
      }

      // 2. 리스트 렌더링
      for (let i = 0; i < data.list.length; i++) {
        let obj = data.list[i];
        let viewUrl = window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']);
        let regDate = comm.date.getPastDate(obj['REG_DATE']);

        // 썸네일 경로가 없을 경우 기본 이미지 처리
        let thumbImg = obj['THUMBNAIL_IMG_PATH'] ? obj['THUMBNAIL_IMG_PATH']
            : 'https://placehold.co/100x80?text=No+Image';

        let listHtml = '';
        listHtml += '<li class="post-item">';
        listHtml += '    <div class="content">';
        listHtml += '        <a href="' + viewUrl + '">' + obj['TITLE'] + '</a>';
        listHtml += '        <span>' + regDate + '</span>';
        listHtml += '    </div>';
        listHtml += '    <div class="thumb">';
        listHtml += '        <img src="' + thumbImg
            + '" alt="썸네일" onerror="this.src=\'https://placehold.co/100x80?text=No+Image\'">';
        listHtml += '    </div>';
        listHtml += '</li>';

        let $listObj = $(listHtml);
        $listObj.data(obj); // 오브젝트 데이터 바인딩

        comm.paging.renderList("#myStoryList", $listObj);
      }
    }, 1, 5, null, true);
  }

  const moveEditPage = function (editPermId) {
    $("body").append(comm.dom.appendForm("storyEditForm"));
    const form = $("#storyEditForm");
    $(form).attr("action", "/story/write")
    comm.dom.appendInput(form, 'referrerPage', location.pathname + location.search);
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
          let li = $('<li class="notice-item"></li>');

          li.append(
              '<div class="content"><a href="' + window.getNoticeViewUrl(obj.ID, id)
              + '">' + obj['TITLE'] + '</a><span>' + (obj['UPT_DATE'] || obj['REG_DATE'])
              + '</span></div>');

          // li.append('<div class="thumb"><img src="https://placehold.co/100x80" alt="공지 이미지"></div>');

          $(".notice_list").append(li);
        }
      } else {
        $(".empty-msg").show();
      }
    });

    $("#notice_more").on("click", function () {
      location.href = noticeMoreUrl;
    });
  }

  $(document).on("ready", function () {
    // 회원 카테고리 세팅
    initCategory(memberCategoryList);

    // 공지사항 세팅
    initNotice(myStoryMemberId);

    // 나의 스토리 세팅
    initMyStory(myStoryMemberId, paramCategoryId);

    $(".new_mystory_mobile_menu_btn").click(function () {
      $(".new_mystory_menu_box").toggleClass("on");
    });
  })
</script>