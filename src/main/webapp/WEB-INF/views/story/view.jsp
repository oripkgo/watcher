<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-detail.css"/>

<div class="container">
    <main class="story-detail-container">
        <section class="story-header">
            <h1 class="story-title">${view.current.title}</h1>
            <div class="story-meta">
                <div>
                    <span class="author"> <a
                            href="/my-story/${storyAdminId}">by ${view.current.nickname}</a> </span>
                    <span class="date">${view.current.regDate}</span>
                </div>
                <div class="admin-actions-top">
                    <button type="button" class="btn-list-sm"
                            onclick="moveReferrerPage('${storyParam.referrerPage}')">목록
                    </button>
                    <c:if test="${modifyAuthorityYn eq 'Y'}">
                        <button type="button" class="btn-edit-sm" onclick="updateStory()">수정
                        </button>
                        <button type="button" class="btn-delete-sm" onclick="deleteStory()">삭제
                        </button>
                    </c:if>
                </div>
            </div>
        </section>

        <section class="story-content">
            ${view.current.contents}
        </section>

        <section class="story-actions">

             <span class="story-like" id="likeTarget">
                <i class="fa fa-heart"></i>
                <span class="likeCount" data-likecnt="0"></span>
            </span>

            <button class="share-btn" id="shareToggle">
                <i class="fa fa-share-alt"></i> 공유
            </button>

            <div class="share-popup" id="sharePopup">
                <ul>
                    <li><a href="#" id="shareNaver"><i class="fa fa-leaf"></i> 네이버</a></li>
                    <li><a href="#" id="shareKakao"><i class="fa fa-comment"></i> 카카오</a></li>
                    <li><a href="#" id="shareFacebook"><i class="fa fa-facebook"></i> 페이스북</a></li>
                    <li><a href="#" id="shareInstagram"><i class="fa fa-instagram"></i> 인스타그램</a>
                    </li>
                    <li><a href="#" id="shareTwitch"><i class="fa fa-twitch"></i> 트위치</a></li>
                </ul>
            </div>
        </section>

        <nav class="story-navigation">
            <a href="#" onclick="goPrev()" class="nav-card prev">
                <div class="nav-label"><i class="fa fa-arrow-left"></i> 이전 스토리</div>
                <div class="nav-title">${view.prev['title']}</div>
            </a>
            <a href="#" onclick="goNext()" class="nav-card next">
                <div class="nav-label">다음 스토리 <i class="fa fa-arrow-right"></i></div>
                <div class="nav-title">${view.next['title']}</div>
            </a>
        </nav>


        <section class="story-comments" id="commentTarget"></section>

    </main>
</div>


<script>
  const url = window.location.href;
  const params = new URLSearchParams(window.location.search);
  const searchCategoryId = params.get('searchCategoryId');

  const listUrl = globalObj.getStoryListUrl();
  const deleteUrl = globalObj.getStoryDeleteUrl();
  const updateUrl = globalObj.getStoryUpdateUrl();
  const referrerUrl = '${storyParam.referrerPage}';
  const relatedPostsUrl = "/story/related/posts";
  const prevId = '${view.prev.id}';
  const nextId = '${view.next.id}';

  const type = 'STORY';
  const storyMemId = '${storyMemId}';
  const id = '${view.current.id}';
  const title = '${view.current.title}';
  const nickName = '${view.current.nickname}';
  const regDate = '${view.current.regDate}';
  const likeCnt = '${view.current.likeCnt}' * 1;
  const commentRegYn = '${commentRegYn}';

  const contents = $("#storyContents").html();
  const thumbnail = window.getServerImg(
      '${fn:replace(view.current.thumbnailImgPath, '\\', '/')}'.replace(/[\\]/g, '/'));

  // 뒤로 가기 url 지정
  // history.pushState(null, null, referrerUrl);
  // window.addEventListener('popstate', function(event) {
  //     window.location.href = referrerUrl;
  // });

  const moveReferrerPage = function (referrerUrl) {
    if (referrerUrl) {
      location.href = referrerUrl
    } else {
      window.history.back();
    }
  }

  const updateStory = function () {
    location.href = updateUrl + id + '&referrerPage=' + (referrerUrl || document.referrer);
  }

  const deleteStory = function () {
    const $this = this;
    comm.message.confirm("스토리를 삭제하시겠습니까?", function (status) {
      if (status) {
        comm.request({
          url: deleteUrl,
          method: "DELETE",
          data: JSON.stringify({id: id})
        }, function (resp) {
          if (resp.code == '0000') {
            comm.message.alert('삭제가 완료되었습니다.', function () {
              location.href = (referrerUrl || document.referrer);
            });
          }
        });
      }
    })
  }

  const goPrev = function () {
    if (!prevId) {
      return;
    }

    location.href = window.getStoryViewUrl(storyMemId, prevId, searchCategoryId);
  }

  const goNext = function () {
    if (!nextId) {
      return;
    }
    location.href = window.getStoryViewUrl(storyMemId, nextId, searchCategoryId);
  }

  const initView = function () {
    $("#likeTarget").data('likecnt', likeCnt);

    comm.boardView.init(id, type);
    // comm.boardView.tags.render('tagsTarget');
    comm.boardView.like.render('likeTarget');
    comm.boardView.comment.render('commentTarget');

    if (commentRegYn == 'N') {
      comm.boardView.comment.disabled();
    }

  }

  const initShare = function () {
    const currentUrl = window.location.href;
    const shareToggle = document.getElementById('shareToggle');
    const shareTitle = '${view.current["title"]}';
    const shareText = `${view.current["contents"]}`
    .replace(/<[^>]*>?/gm, '')  // HTML 제거
    .substring(0, 80);

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
  }

  $(document).on("ready", function () {
    initView();
    initShare();
  })

</script>