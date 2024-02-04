<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section">
    <div class="ani-in sub_layout">
        <div class="detail_top ani_y delay1">
            <div class="detail_kind">공지사항</div>
            <strong id="title">${view['TITLE']}</strong>
            <div class="detail_memo">
                <em id="nickname">by ${view['NICKNAME']}</em>
                <img src="/resources/img/line.png">
                <span id="last_time"></span>

                <c:if test="${modify_authority_yn eq 'Y'}">
                    <div class="btn_basic" id="notice_edit">
                        <a href="javascript:;" id="story_update" onclick="moveEdit();">수정</a>
                        <img src="/resources/img/line.png">
                        <a href="javascript:;" id="story_delete" onclick="deleteNotice();">삭제</a>
                    </div>
                </c:if>

            </div>
        </div>
    </div>
</div>


<form id="noticeForm" name="noticeForm" method="get">
    <div class="section uline2">
        <div class="ani-in sub_layout rline">
            <div class="conts_wrap ani_y delay2">
                <div id="noticeContents"></div>

                <div class="conts_sns">
                    <a href="javascript:;" class="zimm" id="likeTarget" data-likecnt="0">공감 0</a>
                </div>

                <div class="conts_tag" id="tagTarget" style="display: none;">
                    <strong class="conts_tit">태그</strong>
                </div>

                <div class="conts_review" id="commentTarget"></div>
            </div>
        </div>
    </div>
</form>

<script>
    const id = '${view.ID}';
    const type = 'NOTICE';
    const noticeDeleteApiUrl = "/notice/delete";

    const title = '${view['TITLE']}';
    const nickName = '${view['NICKNAME']}';
    const contents = '${view['CONTENTS']}';
    const likeCnt = '${view['LIKE_CNT']}';
    const regDate = '${view['REG_DATE']}' * 1;


    const moveEdit = function () {
        window.location.href = window.getNoticeUpdateUrl(id);
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
        $("#last_time").text(comm.date.getPastDate(regDate));
        $("#noticeContents").replaceWith(contents.replace(/\/resources/g, window.getServerImg("/resources")))
        $("#likeTarget").data('likecnt', likeCnt);
        $("#likeTarget").text('공감 ' + likeCnt);


        comm.boardView.init(id, type);
        comm.boardView.renderLike('likeTarget');
        comm.boardView.renderComment('commentTarget');
    })

</script>