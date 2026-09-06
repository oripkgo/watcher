<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" type="text/css" href="/resources/css/notice-detail.css"/>

<div class="container">
    <main class="story-detail-container">
        <section class="story-header">
            <h1 class="story-title" id="title"></h1>
            <div class="story-meta">
                <div>
                    <span class="date" id="last_time"></span>
                    <span class="author" id="nickname"></span>
                </div>

                <div class="admin-actions-top">
                    <button type="button" class="btn-list-sm" onclick="moveReferrerPage('${noticeParam.referrerPage}')">
                        <i class="fa fa-list"></i> 목록
                    </button>
                    <c:if test="${modifyAuthorityYn eq 'Y'}">
                        <button type="button" class="btn-edit-sm" onclick="moveEdit()">
                            <i class="fa fa-pencil"></i> 수정
                        </button>
                        <button type="button" class="btn-delete-sm" onclick="deleteNotice()">
                            <i class="fa fa-trash"></i> 삭제
                        </button>
                    </c:if>
                </div>
            </div>
        </section>

        <!-- 본문 렌더링 영역 -->
        <section class="story-content" id="storyContent">
            ${view.current['CONTENTS']}
        </section>

        <section class="story-actions">
            <span class="story-like" id="likeTarget">
                <i class="fa fa-heart"></i>
                <span class="likeCount" data-likecnt="0"></span>
            </span>

            <button class="share-btn" id="shareToggle">
                <i class="fa fa-share-alt"></i> 공유
            </button>
        </section>

        <nav class="story-navigation">
            <a href="#" onclick="goPrev()" class="nav-card prev">
                <div class="nav-label"><i class="fa fa-arrow-left"></i> 이전 공지</div>
                <div class="nav-title"><c:out value="${view.prev['TITLE']}"/></div>
            </a>
            <a href="#" onclick="goNext()" class="nav-card next">
                <div class="nav-label">다음 공지 <i class="fa fa-arrow-right"></i></div>
                <div class="nav-title"><c:out value="${view.next['TITLE']}"/></div>
            </a>
        </nav>

        <section class="story-comments" id="commentTarget"></section>
    </main>
</div>

<script>
  const id = '${view.current.ID}';
  const prevId = '${view.prev.ID}';
  const nextId = '${view.next.ID}';
  const type = 'NOTICE';
  const noticeDeleteApiUrl = "/notice/delete";

  const title = '<c:out value="${view.current['TITLE']}"/>';
  const nickName = '<c:out value="${view.current['NICKNAME']}"/>';
  const likeCnt = '${view.current['LIKE_CNT']}';
  const regDate = '${view.current['REG_DATE']}';

  const moveReferrerPage = function (referrerUrl) {
    if (referrerUrl) {
      location.href = referrerUrl;
    } else {
      window.history.back();
    }
  };

  const moveEdit = function () {
    window.location.href = window.getNoticeUpdateUrl(id);
  };

  const goPrev = function () {
    if (!prevId) return;
    location.href = window.getNoticeViewUrl(prevId);
  };

  const goNext = function () {
    if (!nextId) return;
    location.href = window.getNoticeViewUrl(nextId);
  };

  const deleteNotice = function () {
    comm.message.confirm("공지사항을 삭제하시겠습니까?", function (result) {
      if (result) {
        const param = {id: id};
        comm.request({url: noticeDeleteApiUrl, method: "DELETE", data: param}, function (resp) {
          if (resp.code == '0000') {
            location.href = window.getNoticeListUrl(window.memberId);
          }
        });
      }
    });
  };

  $(document).ready(function () {
    $("#title").text(title);
    $("#nickname").text(nickName);
    $("#last_time").text(regDate);
    $("#likeTarget").data('likecnt', likeCnt);

    comm.boardView.init(id, type);
    comm.boardView.like.render('likeTarget');
    comm.boardView.comment.render('commentTarget');
  });

  document.addEventListener('DOMContentLoaded', () => {
    const shareToggle = document.getElementById('shareToggle');
    const shareTitle = title.trim();

    // JS 문법 에러 방지: DOM텍스트 기반 순수 텍스트 추출
    const storyContentEl = document.getElementById('storyContent');
    const shareText = (storyContentEl ? storyContentEl.textContent || storyContentEl.innerText : '')
    .replace(/\s+/g, ' ')
    .trim()
    .substring(0, 80);

    const currentUrl = window.location.href;

    shareToggle.addEventListener('click', async () => {
      if (navigator.share) {
        try {
          await navigator.share({
            title: shareTitle,
            text: shareText,
            url: currentUrl
          });
          return;
        } catch (err) {
          console.warn("Web Share 사용 실패:", err);
        }
      }

      try {
        await navigator.clipboard.writeText(currentUrl);
        alert("현재 링크가 복사되었습니다!");
      } catch (err) {
        console.error("Clipboard 실패:", err);
        const temp = document.createElement("input");
        temp.value = currentUrl;
        document.body.appendChild(temp);
        temp.select();
        document.execCommand("copy");
        document.body.removeChild(temp);
        alert("현재 링크가 복사되었습니다!");
      }
    });
  });
</script>