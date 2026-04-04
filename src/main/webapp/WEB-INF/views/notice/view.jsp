<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
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
                    <button type="button" class="btn-list-sm"
                            onclick="moveReferrerPage('${noticeParam.referrerPage}')">
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

        <section class="story-content">
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

            <%--
            <div class="share-popup" id="sharePopup">
                <ul>
                    <li><a href="#" id="shareNaver"><i class="fa fa-leaf"></i> 네이버</a></li>
                    <li><a href="#" id="shareKakao"><i class="fa fa-comment"></i> 카카오</a></li>
                    <li><a href="#" id="shareFacebook"><i class="fa fa-facebook"></i> 페이스북</a></li>
                    <li><a href="#" id="shareInstagram"><i class="fa fa-instagram"></i> 인스타그램</a></li>
                    <li><a href="#" id="shareTwitch"><i class="fa fa-twitch"></i> 트위치</a></li>
                </ul>
            </div>
            --%>
        </section>

        <nav class="story-navigation">
            <a href="#" onclick="goPrev()" class="nav-card prev">
                <div class="nav-label"><i class="fa fa-arrow-left"></i> 이전 공지</div>
                <div class="nav-title">${view.prev['TITLE']}</div>
            </a>
            <a href="#" onclick="goNext()" class="nav-card next">
                <div class="nav-label">다음 공지 <i class="fa fa-arrow-right"></i></div>
                <div class="nav-title">${view.next['TITLE']}</div>
            </a>
        </nav>


        <section class="story-comments" id="commentTarget"></section>

    </main>
</div>

<script>
  const id = '${view.current.ID}';
  const prevId = '${view.prev.ID}'
  const nextId = '${view.next.ID}'
  const type = 'NOTICE';
  const noticeDeleteApiUrl = "/notice/delete";

  const title = '${view.current['TITLE']}';
  const nickName = '${view.current['NICKNAME']}';
  const likeCnt = '${view.current['LIKE_CNT']}';
  const regDate = '${view.current['REG_DATE']}';

  const moveReferrerPage = function (referrerUrl) {
    if (referrerUrl) {
      location.href = referrerUrl
    } else {
      window.history.back();
    }
  }

  const moveEdit = function () {
    window.location.href = window.getNoticeUpdateUrl(id);
  }

  const goPrev = function () {
    if (!prevId) {
      return;
    }

    location.href = window.getNoticeViewUrl('${view.prev.ID}');
  }

  const goNext = function () {
    if (!nextId) {
      return;
    }
    location.href = window.getNoticeViewUrl('${view.next.ID}');
  }

  const deleteNotice = function () {
    comm.message.confirm("공지사항을 삭제하시겠습니까?", function (result) {
      if (result) {
        const param = {id: id};
        comm.request({url: noticeDeleteApiUrl, method: "DELETE", data: param}, function (resp) {
          // 수정 성공
          if (resp.code == '0000') {
            location.href = window.getNoticeListUrl(window.memberId);
          }
        })
      }
    })
  }

  $(document).on("ready", function () {

    $("#title").text(title);
    $("#nickname").text(nickName);
    $("#last_time").text(regDate);
    $("#likeTarget").data('likecnt', likeCnt);

    comm.boardView.init(id, type);
    comm.boardView.like.render('likeTarget');
    comm.boardView.comment.render('commentTarget');

  })

  document.addEventListener('DOMContentLoaded', () => {

    const shareToggle = document.getElementById('shareToggle');
    const shareTitle = '${view.current["TITLE"]}'.trim();
    const shareText = `${view.current["CONTENTS"]}`
    .replace(/<[^>]*>?/gm, '')  // HTML 제거
    .substring(0, 80);

    const currentUrl = window.location.href;

    shareToggle.addEventListener('click', async () => {
      // 1) Web Share API 지원하면 시도
      if (navigator.share) {
        try {
          await navigator.share({
            title: shareTitle,
            text: shareText,
            url: currentUrl
          });
          return; // 성공 → 종료
        } catch (err) {
          console.warn("Web Share 사용 실패:", err);
          // 실패 시 → fallback (URL 복사)
        }
      }

      // 2) 지원하지 않으면 URL 복사 fallback
      try {
        await navigator.clipboard.writeText(currentUrl);
        alert("현재 링크가 복사되었습니다!");
      } catch (err) {
        console.error("Clipboard 실패:", err);

        // 아주 구형 브라우저용 fallback
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