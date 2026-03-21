<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 2:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-board.css"/>


<script type="text/javascript">
  const CATEGORY_LIST = comm.category.get();
  const storyExternalListUrl = '/management/board/external/storys';

  const getSelCheckBoxObjs = function () {
    return $(".check:checked:not(.all)");
  }

  const getStoryIds = function () {
    const checkObjs = getSelCheckBoxObjs();
    const storyIds = [];

    checkObjs.each(function (idx, checkObj) {
      const obj = $(checkObj).parents("li").data();
      storyIds.push(obj.id);
    })

    return storyIds;
  }

  const deleteStory = function () {
    if (!confirmCheckBox()) {
      comm.message.alert('스토리를 선택해주세요.');
      return;
    }

    comm.message.confirm("선택한 스토리를 삭제하시겠습니까?", function (result) {
      if (result) {
        const param = JSON.stringify({paramJson: JSON.stringify(getStoryIds())});
        comm.request({url: storyExternalListUrl, method: "DELETE", data: param}, function (resp) {
          // 수정 성공
          if (resp.code == '0000') {
            $(getSelCheckBoxObjs()).each(function (idx, checkObj) {
              $(checkObj).parents("li").remove();
            })
          }
        })
      }
    })
  }

  const confirmCheckBox = function () {
    return $(".check:checked:not(.all)").length == 0 ? false : true;
  }

  const search = function () {
    comm.paging.getList('#managementBoardExternalForm', storyExternalListUrl, listCallback, 1, 10,
        10, true);
  }

  const initCategory = function (obj) {
    const selObj = obj || '#seachCategory';

    $(selObj).empty();
    $(selObj).append('<option value="">카테고리</option>')


    CATEGORY_LIST.forEach(function (obj) {
      const id = obj['ID'];
      const nm = obj['CATEGORY_NM'];

      $(selObj).append('<option value="' + id + '">' + nm + '</option>')
    })
  }

  const initCheckBox = function () {
    $(".check").on("click", function () {
      let $this = this;

      if ($($this).hasClass("all")) {
        if ($($this).is(":checked")) {
          $(".check").prop("checked", true)
        } else {
          $(".check").prop("checked", false)
        }
      }

      if ($(".check:not(.all)").length == $(".check:checked:not(.all)").length) {
        $(".check.all").prop("checked", true)
      } else {
        $(".check.all").prop("checked", false)
      }
    })
  }

  const listCallback = function (data) {
    comm.paging.emptyList("#storyList");

    for (let i = 0; i < data.list.length; i++) {
      let obj = data.list[i];
      let listHtml = '';

      // 신규 UI 구조: <li class="post-item">
      listHtml += '<li class="post-item">';

      // 1. 체크박스
      listHtml += '    <input type="checkbox" class="check">';

      // 2. 게시글 정보 (제목 및 메타 데이터)
      listHtml += '    <div class="post-info">';
      listHtml += '        <a href="' + window.getStoryViewUrl(obj['memberId'], obj['id']) + '">'
          + obj['title'] + '</a>';

      // 메타 정보 (공개여부, 카테고리, 닉네임, 수치들, 날짜 등)
      // 데이터 구조에 따라 '공개'나 '회원등급' 등은 obj 속성명에 맞게 조정하세요.
      listHtml += '        <div class="post-meta">';
      listHtml += obj['blogName'] + ' · ';
      listHtml += obj['categoryNm'] + ' · ';
      listHtml += (obj['openYn'] === 'Y' ? '공개' : '비공개') + ' · ';
      listHtml += '조회수 ' + (obj['viewCnt'] || 0).toLocaleString() + ' · ';
      listHtml += '댓글 ' + (obj['commentCnt'] || 0) + ' · ';
      listHtml += '좋아요 ' + (obj['likeCnt'] || 0) + ' · ';
      listHtml += comm.date.getPastDate(obj['regDate']);
      listHtml += '        </div>';
      listHtml += '    </div>';

      // 3. 썸네일 영역
      listHtml += '    <div class="post-thumb">';
      if (obj['thumbnailImgPath']) {
        listHtml += window.getImgTagStr(obj['thumbnailImgPath'], "management-story-thumb");
      }
      listHtml += '    </div>';

      listHtml += '</li>';

      // 문자열을 jQuery 객체로 변환
      let $listObj = $(listHtml);

      // 기존 로직처럼 data 객체 바인딩 (삭제 등 기능 유지용)
      $listObj.data(obj);

      // 리스트 렌더링
      comm.paging.renderList("#storyList", $listObj);
    }

    // 체크박스 이벤트 재바인딩
    initCheckBox();
  }

  $(document).on("ready", function () {
    initCategory();
    search();

    $("#search").on("click", function () {
      search();
    });

    $("#searchKeyword").on("keypress", function (e) {
      if (e.keyCode == 13) {
        search();
        return false;
      }
    });

    $("#storyDelete").on("click", function () {
      deleteStory();
    });
  })

</script>


<form id="managementBoardExternalForm">
    <div class="layout">
        <!-- 사이드바 -->
        <%@include file="include/menus.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main">
            <!-- 검색/필터 -->
            <div class="filter-box">
                <select id="seachCategory" name="searchCategoryId">
                    <option>카테고리 전체</option>
                    <option>개발</option>
                    <option>여행</option>
                </select>
                <input type="text" placeholder="제목/내용 검색" name="searchKeyword" id="searchKeyword">
                <button type="button" id="search">검색</button>
            </div>

            <!-- 일괄 작업 -->
            <div class="bulk-actions">
                <label><input type="checkbox" class="check all"> 전체 선택</label>
                <button type="button" id="storyDelete">삭제</button>
            </div>

            <!-- 게시글 목록 -->
            <div class="posts">
                <h3>활동 게시글</h3>
                <ul class="post-list storyList" id="storyList">
                    <%--<li class="post-item">
                        <input type="checkbox">
                        <div class="post-info">
                            <a href="#">React 블로그 만들기</a>
                            <div class="post-meta">공개 · 개발 · 일반회원 · 조회수 1,230 · 댓글 15 · 좋아요 45 ·
                                2025-09-10
                            </div>
                        </div>
                        <div class="post-thumb"><img src="https://placekitten.com/80/60" alt="썸네일">
                        </div>
                    </li>
                    <li class="post-item">
                        <input type="checkbox">
                        <div class="post-info">
                            <a href="#">AWS 비용 최적화 경험담</a>
                            <div class="post-meta">비공개 · 개발 · 프리미엄회원 · 조회수 980 · 댓글 8 · 좋아요 30 ·
                                2025-09-05
                            </div>
                        </div>
                        <div class="post-thumb"></div>
                    </li>--%>
                </ul>
                <nav class="pagination"></nav>
            </div>
        </main>
    </div>
</form>

