<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 2:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-board.css"/>

<form id="managementBoardForm">
    <div class="layout">
        <!-- 사이드바 -->
        <%@include file="include/menus.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main">
            <!-- 검색/필터 -->
            <div class="filter-box">
                <select name="searchSecretYn">
                    <option value="ALL">공개 여부</option>
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
                <button type="button" onclick="boardObj.updatePublic();">공개</button>
                <button type="button" onclick="boardObj.updatePrivate();">비공개</button>
                <button type="button" onclick="boardObj.deleteStory();">삭제</button>
                <button type="button" onclick="boardObj.goWritingPage();"
                        style="background:#286BB7;color:#fff;border:none;">+ 새 글 작성
                </button>
            </div>

            <!-- 게시글 목록 -->
            <div class="posts">
                <h3>전체 게시글</h3>
                <ul class="post-list storyList">
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
  const storyPublicUrl = '/management/board/storys/public';
  const storyPrivateUrl = '/management/board/storys/private';
  const storyDeleteUrl = '/management/board/storys';
  const storyListUrl = '/management/board/storys';

  let CATEGORY_LIST = comm.category.get();
  let thisObj;

  const boardObj = {
    init: function () {
      thisObj = this;
    },

    goWritingPage: function () {
      window.location.href = window.getStoryWriteUrl();
    },

    confirmCheckBox: function () {
      return $(".check:checked:not(.all)").length == 0 ? false : true;
    },

    changeCheckBoxOff: function () {
      $(".check:checked").prop("checked", false);
    },

    getSelCheckBoxObjs: function () {
      return $(".check:checked:not(.all)");
    },

    getStoryIds: function () {
      const checkObjs = thisObj.getSelCheckBoxObjs();
      const storyIds = [];

      checkObjs.each(function (idx, checkObj) {
        const obj = $(checkObj).parents("li").data();
        storyIds.push(obj.ID);
      })

      return storyIds;
    },

    updatePublic: function () {
      if (!thisObj.confirmCheckBox()) {
        comm.message.alert('스토리를 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 스토리를 공개하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(thisObj.getStoryIds())});
          comm.request({url: storyPublicUrl, method: "PUT", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                const trObj = $(checkObj).parents("li");
                $(".post-meta .post-status", trObj).text("공개");

              })

              thisObj.changeCheckBoxOff();
            }
          })
        }
      })
    },

    updatePrivate: function () {
      if (!thisObj.confirmCheckBox()) {
        comm.message.alert('스토리를 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 스토리를 비공개하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(thisObj.getStoryIds())});
          comm.request({url: storyPrivateUrl, method: "PUT", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                const trObj = $(checkObj).parents("li");
                $(".post-meta .post-status", trObj).text("비공개");
              })

              thisObj.changeCheckBoxOff();
            }
          })
        }
      })
    },

    deleteStory: function () {
      if (!thisObj.confirmCheckBox()) {
        comm.message.alert('스토리를 선택해주세요.');
        return;
      }

      comm.message.confirm("선택한 스토리를 삭제하시겠습니까?", function (result) {
        if (result) {
          const param = JSON.stringify({paramJson: JSON.stringify(thisObj.getStoryIds())});
          comm.request({url: storyDeleteUrl, method: "DELETE", data: param}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                $(checkObj).parents("li").remove();
              })
            }
          })
        }
      })
    },

    initCheckBox: function () {
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
    },

    initCategory: function (obj) {
      const selObj = obj || '#seachCategory';

      $(selObj).empty();
      $(selObj).append('<option value="">카테고리</option>')

      CATEGORY_LIST.forEach(function (obj) {
        const id = obj['ID'];
        const nm = obj['CATEGORY_NM'];

        $(selObj).append('<option value="' + id + '">' + nm + '</option>')
      })
    },

    getTr: function () {
      return $('<tr></tr>').clone(true);
    },

    getLi: function () {
      return $('<li class="post-item"></li>').clone(true);
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
          const img = $(window.getImgTagStr(obj.src));
          $(a).attr("href", obj.href);
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
      // 리스트 컨테이너 비우기 (.storyList)
      $(".storyList").empty();

      if (data.dto.pageNo == 1 && data.list.length == 0) {
        $(".posts").hide(); // 게시글이 없을 때 영역 숨김
        return;
      } else {
        $(".posts").show();
      }

      for (let i = 0; i < data.list.length; i++) {
        let obj = data.list[i];
        let secretStatus = obj['SECRET_YN'] == 'Y' ? '비공개' : "공개";

        // 조회수나 숫자 포맷팅 (아까 배운 toLocaleString 활용 가능)
        let viewCnt = obj['VIEW_CNT'] ? Number(obj['VIEW_CNT']).toLocaleString() : '0';
        let likeCnt = obj['LIKE_CNT'] ? Number(obj['LIKE_CNT']).toLocaleString() : '0';
        let commentCnt = obj['COMMENT_CNT'] ? Number(obj['COMMENT_CNT']).toLocaleString() : '0';

        // HTML 구조 생성
        let listHtml = '';
        listHtml += '<input type="checkbox" class="check">';
        listHtml += '<div class="post-info">';
        listHtml += '    <a href="' + window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']) + '">'
            + obj['TITLE'] + '</a>';
        listHtml += '    <div class="post-meta">';
        listHtml += '<span class="post-status">' + secretStatus + '</span>  · ';
        listHtml += obj['CATEGORY_NM'] + ' · ';
        listHtml += (obj['MEMBER_CATEGORY_NM'] || "일반") + ' · ';
        listHtml += '조회수 ' + viewCnt + ' · ';
        listHtml += '댓글 ' + commentCnt + ' · ';
        listHtml += '좋아요 ' + likeCnt + ' · ';
        listHtml += comm.date.getPastDate(obj['REG_DATE']); // 작성일
        listHtml += '    </div>';
        listHtml += '</div>';
        listHtml += '<div class="post-thumb">';
        if (obj['THUMBNAIL_IMG_PATH']) {
          listHtml += window.getImgTagStr(obj['THUMBNAIL_IMG_PATH']);
        }
        listHtml += '</div>';

        // 요소 생성 및 데이터 바인딩
        let $li = thisObj.getLi();
        $li.html(listHtml);
        $li.data(obj); // 👈 ID 등 데이터를 jQuery data 객체에 저장 (공개/비공개/삭제 시 필요)

        $(".storyList").append($li);
      }

      thisObj.initCheckBox();
    },

    search: function () {
      comm.paging.getList($("#managementBoardForm").get(0), storyListUrl, thisObj.listCallback, 1,
          10, 10,
          true);
    },
  }

  $(document).on("ready", function () {
    boardObj.init();
    boardObj.initCategory();
    boardObj.search();

    $("#search").on("click", function () {
      boardObj.search();
    });

    $("#searchKeyword").on("keypress", function (e) {
      if (e.keyCode == 13) {
        boardObj.search();
        return false;
      }
    });
  })

</script>


