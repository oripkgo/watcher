<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
                <div id="storyContents"></div>
                <div class="conts_sns">
                    <a href="javascript:;" class="zimm like" id="likeTarget" data-likecnt="0">공감 0</a>
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
    const id = '${view['ID']}';
    const type = 'STORY';
    const memId = '${memId}';
    const listUrl = '/story/list';
    const deleteUrl = "/story/delete";
    const updateUrl = "/story/update?id=";

    const title = '${view['TITLE']}';
    const nickName = '${view['NICKNAME']}';
    const regDate = '${view['REG_DATE']}';
    const contents = '${view['CONTENTS']}';
    const likeCnt = '${view['LIKE_CNT']}' * 1;

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

    $(document).on("ready", function () {

        $("#title").text(title);
        $("#nickName").text("by " + nickName);
        $("#storyContents").replaceWith(contents);
        $("#last_time").html(comm.date.getPastDate(regDate));
        $("#likeTarget").data('likecnt', likeCnt);
        $("#likeTarget").text('공감 ' + likeCnt);

        comm.boardView.init(id, type);
        comm.boardView.renderTag('tagsTarget');
        comm.boardView.renderLike('likeTarget');
        comm.boardView.renderComment('commentTarget');

        $(".sns_btn").click(function () {
            $(".sns_view").slideToggle("fast");
        });
    })

</script>