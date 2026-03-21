<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 2:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-board.css"/>

<form id="noticeForm">
    <div class="layout">
        <!-- 사이드바 -->
        <%@include file="include/menus.jsp" %>


        <!-- 메인 컨텐츠 -->
        <main class="main">
            <!-- 검색/필터 -->
            <div class="filter-box">
                <select name="searchSecretYn">
                    <option value="">공개 여부</option>
                    <option value="NN">공개</option>
                    <option value="YY">비공개</option>
                </select>
                <%--<select>
                    <option>카테고리 전체</option>
                    <option>개발</option>
                    <option>여행</option>
                </select>--%>
                <input type="text" placeholder="제목/내용 검색" name="searchKeyword" id="searchKeyword">
                <button type="button" id="search">검색</button>
            </div>


            <!-- 일괄 작업 -->
            <div class="bulk-actions">
                <label><input type="checkbox" class="check all"> 전체 선택</label>
                <button type="button" onclick="noticeObj.updatePublic();">공개</button>
                <button type="button" onclick="noticeObj.updatePrivate();">비공개</button>
                <button type="button" onclick="noticeObj.deleteNotices();">삭제</button>
                <button type="button" onclick="location.href='/notice/write'"
                        style="background:#286BB7;color:#fff;border:none;">+ 새 공지 작성
                </button>
            </div>

            <!-- 게시글 목록 -->
            <div class="posts">
                <h3>전체 게시글</h3>
                <ul class="post-list noticeList">
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


<script>
  const noticeWriteUrl = window.getNoticeWriteUrl();
  const noticeApiUrl = "/management/board/notices";
  const noticePublicUrl = "/management/board/notices/public";
  const noticePrivateUrl = "/management/board/notices/private";

  const noticeObj = {
    confirmCheckBox: function () {
      return $(".check:checked:not('.all')").length == 0 ? false : true;
    },

    getSelCheckBoxObjs: function () {
      return $(".check:checked:not('.all')");
    },

    getNoticeIds: function () {
      const checkObjs = noticeObj.getSelCheckBoxObjs();
      const storyIds = [];

      checkObjs.each(function (idx, checkObj) {
        const obj = $(checkObj).parents("li").data();
        storyIds.push(obj.ID);
      })

      return storyIds;
    },

    deleteNotice: function () {
      if (!noticeObj.confirmCheckBox()) {
        comm.message.alert('공지사항을 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 공지사항을 삭제하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
          comm.request({url: noticeApiUrl, method: "DELETE", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(noticeObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                $(checkObj).parents("li").remove();
              })
            }
          })
        }
      })
    },

    deleteNotices: function () {
      if (!noticeObj.confirmCheckBox()) {
        comm.message.alert('공지사항을 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 공지사항을 삭제하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
          comm.request({url: noticeApiUrl, method: "DELETE", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(noticeObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                $(checkObj).parents("li").remove();
              })
            }
          })
        }
      })
    },

    updatePublic: function () {
      const thisObj = this;
      if (!noticeObj.confirmCheckBox()) {
        comm.message.alert('공지사항을 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 공지사항을 공개하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
          comm.request({url: noticePublicUrl, method: "PUT", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                const trObj = $(checkObj).parents("li");
                $(".post-meta .post-status", trObj).text("공개");
              })

              $(".check").prop("checked", false);

            }
          })
        }
      })
    },

    updatePrivate: function () {
      const thisObj = this;
      if (!noticeObj.confirmCheckBox()) {
        comm.message.alert('공지사항을 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 공지사항을 비공개하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
          comm.request({url: noticePrivateUrl, method: "PUT", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                const trObj = $(checkObj).parents("li");
                $(".post-meta .post-status", trObj).text("비공개");
              })

              $(".check").prop("checked", false);
            }
          })
        }
      })
    },

    search: function () {
      comm.paging.getList('#noticeForm', noticeApiUrl, noticeObj.listCallback, 1, 10);
    },

    initCheckBox: function () {
      $(".check").off().on("click", function () {
        let $clickTarget = this;

        if ($($clickTarget).hasClass("all")) {
          if ($($clickTarget).is(":checked")) {
            $(".check").prop("checked", true)
          } else {
            $(".check").prop("checked", false)
          }
        }

        if ($(".check:not('.all')").length == $(".check:checked:not('.all')").length) {
          $(".check.all").prop("checked", true)
        } else {
          $(".check.all").prop("checked", false)
        }
      })
    },

    getMobileRecord: function (target, arr) {
      let tempDiv = $("<div></div>");
      let dataElement = $(document.createElement(target));
      let rowElement = $('<div class="mobile-data-row"></div>');
      $(dataElement).addClass("mobile-data");

      for (let obj of arr) {
        const col = $('<div class="mobile-data-col"></div>');
        if (obj.type == 'image') {
          $(col).addClass("image");
          const a = $('<a></a>');
          const img = $('<img></img>');
          $(a).attr("href", obj.href);
          $(img).attr("src", obj.src);
          $(a).append(img);
          $(col).append(a);
        } else {
          $(col).append('<div class="col-name"><strong>' + obj.col + '</strong></div>');
          $(col).append('<div class="col-value">' + obj.val + '</div>');
        }

        $(rowElement).append(col);
      }
      $(dataElement).html(rowElement);
      return $(tempDiv).html(dataElement).html();
    },

    listCallback: function (data) {
      comm.paging.emptyList(".noticeList");

      for (let i = 0; i < data.list.length; i++) {
        const obj = data.list[i];

        // 상태 값 정의
        const secretStatus = (obj['SECRET_YN'] === 'Y' ? '비공개' : '공개');
        const viewCount = obj['VIEW_CNT'] || 0;
        const commentCount = obj['COMMENT_CNT'] || 0;
        const likeCount = obj['LIKE_CNT'] || 0;
        const title = obj['TITLE'];
        const thumbUrl = null

        // 1. li 태그 생성
        let $li = $('<li class="post-item"></li>');

        // 2. 내부 HTML 조립 (HTML 주석 가이드 준수)
        let innerHtml = '';
        innerHtml += '<input type="checkbox" class="check">';
        innerHtml += '<div class="post-info">';
        innerHtml += '    <a href="' + window.getNoticeViewUrl(obj.ID) + '">' + title
            + '</a>';
        innerHtml += '    <div class="post-meta">';
        innerHtml += '<span class="post-status">' + secretStatus + '</span>  · ';
        innerHtml += '      조회수 ' + viewCount.toLocaleString() + ' · ';
        innerHtml += '      댓글 ' + commentCount + ' · ';
        innerHtml += '      좋아요 ' + likeCount + ' · ';
        innerHtml += obj['REG_DATE'];
        innerHtml += '    </div>';
        innerHtml += '</div>';

        if (thumbUrl) {
          innerHtml += '<div class="post-thumb">';
          innerHtml += '    <img src="' + thumbUrl + '" alt="썸네일">';
          innerHtml += '</div>';
        }

        // 3. jQuery 객체화 및 데이터 바인딩
        $li.html(innerHtml);
        $li.data(obj); // 행 전체에 데이터 바인딩

        // 4. 리스트 렌더링
        comm.paging.renderList(".noticeList", $li);
      }

      // 체크박스 전체 선택/해제 등 초기화
      if (typeof noticeObj.initCheckBox === "function") {
        noticeObj.initCheckBox();
      }
    },

    getTr: function () {
      return $('<tr></tr>').clone(true);
    },
  }

  $(document).on("ready", function () {
    $("#search").on("click", function () {
      noticeObj.search();
    });

    $("#searchKeyword").on("keypress", function (e) {
      if (e.keyCode == 13) {
        noticeObj.search();
        return false;
      }
    });

    noticeObj.search();
  })


</script>