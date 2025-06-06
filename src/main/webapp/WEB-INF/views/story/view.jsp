<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" src="/resources/task/js/common/utils/share.js"></script>

<link href="/resources/code-block/prism.css" rel="stylesheet" />
<script src="/resources/code-block/prism.js"></script>


<div class="section">
    <div class="ani-in sub_layout">
        <div class="detail_top ani_y delay1">
            <div class="detail_kind"><a href="/my-story/${storyAdminId}">스토리</a></div>
            <strong id="title"></strong>
            <div class="detail_memo">
                <em><a href="/my-story/${storyMemId}" class="hover_line" id="nickName"></a></em>
                <img src="/resources/img/line.png">
                <span id="last_time"></span>

                <div class="btn_basic">
                    <a href="javascript:;" onclick="moveReferrerPage('${storyParam.referrerPage}')">목록</a>
                    <c:if test="${modifyAuthorityYn eq 'Y'}">
                        <img src="/resources/img/line.png">
                        <a href="javascript:;" onclick="updateStory()">수정</a>
                        <img src="/resources/img/line.png">
                        <a href="javascript:;" onclick="deleteStory()">삭제</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<form id="storyViewForm" name="storyViewForm">
    <div class="section uline2">
        <div class="ani-in sub_layout rline">
            <div class="conts_wrap ani_y delay2">
                <div id="storyContents">${view.contents}</div>
                <div class="conts_sns">
                    <a href="javascript:;" class="zimm like" id="likeTarget" data-likecnt="0">공감 0</a>
                    <a href="javascript:;" class="sns_btn"></a>
                    <%--                    <a href="javascript:;" class="read_btn">구독하기</a>--%>
                    <div class="sns_view" style="display: none;">
                        <div class="uptip"></div>
                        <span>해당 글 SNS에 공유하기</span>
                        <p>
                            <a href="javascript:;" id="twiterShare"><img src="/resources/img/sns_twiter.png"></a>
                            <a href="javascript:;" id="faceBookShare"><img src="/resources/img/sns_facebook.png"></a>
                            <a href="javascript:;" id="kakaoShare"><img src="/resources/img/sns_kakao_story.png"></a>
                            <%--                            <a href="javascript:;"><img src="/resources/img/sns_kakao_talk.png"></a>--%>
                            <%--                            <a href="javascript:;"><img src="/resources/img/sns_insta.png"></a>--%>
                            <%--                            <a href="javascript:;"><img src="/resources/img/sns_youtube.png"></a>--%>
                        </p>
                        <a href="javascript:;" id="urlCopy" class="btn_url">url 복사</a>
                    </div>
                </div>

                <div class="conts_tag" id="tagsTarget">
                    <strong class="conts_tit">태그</strong>
                </div>

                <div class="conts_rel" id="relatedPostArea" style="display: none;">
                    <strong class="conts_tit">관련글</strong>
                    <ul id="relatedPostList"></ul>
                </div>

                <div class="conts_review" id="commentTarget"></div>
            </div>
        </div>
    </div>
</form>

<script>
    const url               = window.location.href;
    const listUrl           = globalObj.getStoryListUrl();
    const deleteUrl         = globalObj.getStoryDeleteUrl();
    const updateUrl         = globalObj.getStoryUpdateUrl();
    const referrerUrl       = '${storyParam.referrerPage}';
    const relatedPostsUrl   = "/story/related/posts";


    const type              = 'STORY';
    const storyMemId        = '${storyMemId}';
    const id                = '${view.id}';
    const title             = '${view.title}';
    const nickName          = '${view.nickname}';
    const regDate           = '${view.regDate}';
    const likeCnt           = '${view.likeCnt}' * 1;
    const summary           = '<c:out escapeXml="true" value="${view.summary}"/>';
    const commentRegYn      = '${commentRegYn}';

    const contents          = $("#storyContents").html();
    const thumbnail         = window.getServerImg('${fn:replace(view.thumbnailImgPath, '\\', '/')}'.replace(/[\\]/g, '/'));


    // 뒤로 가기 url 지정
    // history.pushState(null, null, referrerUrl);
    // window.addEventListener('popstate', function(event) {
    //     debugger;
    //     window.location.href = referrerUrl;
    // });

    const moveReferrerPage = function (referrerUrl) {
        if( referrerUrl ){
            location.href = referrerUrl
        }else{
            window.history.back();
        }
    }

    const updateStory = function () {
        location.href = updateUrl + id;
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
                            location.href = listUrl;
                        });
                    }
                });
            }
        })
    }

    const initSNS = function(){

        $(".sns_btn").click(function () {
            $(".sns_view").slideToggle("fast");
        });

        $("#twiterShare").on("click",function(){
            SHARE.onTwiter(summary, url);
        })

        $("#faceBookShare").on("click",function(){
            SHARE.onFacebook(url);
        })

        $("#urlCopy").on("click",function(){
            SHARE.onCopyUrl(window.location.href); comm.message.alert('URL이 복사되었습니다.')
        })

        SHARE.onKakaoStory(
            Kakao,
            '#kakaoShare',
            title,
            summary,
            url,
            thumbnail
        )

    }

    const initRelatedPost = function(){

        if( !contents ){
            return;
        }

        const params = {
            contents      : contents,
            searchMemId  : storyMemId,
        }

        comm.request({
            url: relatedPostsUrl,
            method: "POST",
            data: JSON.stringify(params)
        }, function (resp) {
            if (resp.code == '0000') {

                if (resp.relatedPostList && resp.relatedPostList.length > 0) {

                    resp.relatedPostList.forEach(function (obj) {

                        if (String(obj['ID']) == String(id)) {
                            return;
                        }

                        let relatedPostHtml = '';
                        let summary = obj.SUMMARY || '';

                        if (summary.length < 100) {
                            summary = summary;
                        } else {
                            summary = summary.substring(0, 100) + ' ...';
                        }

                        relatedPostHtml += '<li>';
                        relatedPostHtml += '<a href="' + window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']) + '">';
                        relatedPostHtml += window.getImgTagStr(obj['THUMBNAIL_IMG_PATH']);
                        relatedPostHtml += '<strong>' + obj['TITLE'] + '</strong>';
                        relatedPostHtml += '<span>' + obj['REG_DATE'].split(" ")[0] + '</span>';
                        relatedPostHtml += '</a>';
                        relatedPostHtml += '</li>';

                        $("#relatedPostList", "#relatedPostArea").append(relatedPostHtml);

                    })

                    if ($("#relatedPostList > li", "#relatedPostArea").length > 0) {
                        $("#relatedPostArea").show();
                    }

                }

            }
        });
    }

    const initView = function(){
        $("#title").text(title);
        $("#nickName").text("by " + nickName);
        $("#last_time").html(comm.date.getPastDate(regDate));
        $("#likeTarget").data('likecnt', likeCnt);
        $("#likeTarget").text('공감 ' + likeCnt);
    }

    $(document).on("ready", function () {
        initView();

        comm.boardView.init(id, type);
        comm.boardView.tags.render('tagsTarget');
        comm.boardView.like.render('likeTarget');
        comm.boardView.comment.render('commentTarget');

        if( commentRegYn == 'N' ){
            comm.boardView.comment.disabled();
        }

        initSNS();
        initRelatedPost();
    })

</script>