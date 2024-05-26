<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" src="/resources/task/js/common/utils/share.js"></script>

<div class="section">
    <div class="ani-in sub_layout">
        <div class="detail_top ani_y delay1">
            <div class="detail_kind">스토리</div>
            <strong id="title"></strong>
            <div class="detail_memo">
                <em><a href="/myStory/${memId}" class="hover_line" id="nickName"></a></em>
                <img src="/resources/img/line.png">
                <span id="last_time"></span>

                <c:if test="${modifyAuthorityYn eq 'Y'}">
                    <div class="btn_basic">
                        <a href="javascript:;" onclick="updateStory()">수정</a>
                        <img src="/resources/img/line.png">
                        <a href="javascript:;" onclick="deleteStory()">삭제</a>
                    </div>
                </c:if>

            </div>
        </div>
    </div>
</div>

<form id="storyViewForm" name="storyViewForm">
    <div class="section uline2">
        <div class="ani-in sub_layout rline">
            <div class="conts_wrap ani_y delay2">
                <div id="storyContents">${view['CONTENTS']}</div>
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
                <div class="conts_review" id="commentTarget"></div>
            </div>
        </div>
    </div>
</form>

<script>
    const url           = window.location.href;
    const listUrl       = '/story/list';
    const deleteUrl     = "/story/delete";
    const updateUrl     = "/story/update?id=";

    const type          = 'STORY';
    const memId         = '${memId}';
    const id            = '${view['ID']}';
    const title         = '${view['TITLE']}';
    const nickName      = '${view['NICKNAME']}';
    const regDate       = '${view['REG_DATE']}';
    const likeCnt       = '${view['LIKE_CNT']}' * 1;
    const summary       = '${view['SUMMARY']}';
    const thumbnail     = window.getServerImg('${view['THUMBNAIL_IMG_PATH']}'.replace(/[\\]/g, '/'));

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
        comm.boardView.renderTag('tagsTarget');
        comm.boardView.renderLike('likeTarget');
        comm.boardView.renderComment('commentTarget');

        initSNS();

    })

</script>