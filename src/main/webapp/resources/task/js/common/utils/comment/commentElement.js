const profileEmptyImgUrl = "/resources/img/member_ico.png";
const commentButtonDivisionImgUrl = "/resources/img/line.png";

const elementIdRoot = 'commentRoot';
const elementIdForm = 'commentForm';
const elementIdCount = 'commentCount';
const elementIdInsertWriteArea = 'commentWriteArea';
const elementIdInsertTextArea = 'commentInputInsert';
const elementIdInsertButton = 'commentInsertButton';
const elementIdListArea = 'commentList';
const elementClassListData = 'commentListData';
const elementClassUpdateButton = 'update';
const elementClassDeleteButton = 'delete';
const elementClassDeclarationButton = 'declaration';
const elementClassUpdateContents = 'contents';
const elementClassUpdateWriteArea = 'commentWriteArea';
const elementClassUpdateTextArea = 'commentInputUpdate';
const elementClassUpdateConfirmButton = 'commentInputUpdateConfirm';

const COMMENT_ELEMENT = {
    getRootArea: function (loginYn) {
        let frameHtmlModelStr = '<div class="conts_review" id="' + elementIdRoot + '">';
        frameHtmlModelStr += '<strong class="conts_tit" id="' + elementIdCount + '" data-cnt="0">댓글<em>0</em></strong>';
        frameHtmlModelStr += '<div class="write_wrap" id="' + elementIdInsertWriteArea + '">';

        if (loginYn == 'Y') {
            frameHtmlModelStr += '<textarea placeholder="댓글 입력" name="comment" id="' + elementIdInsertTextArea + '"></textarea>';
            frameHtmlModelStr += '<a href="javascript:;" id="' + elementIdInsertButton + '">확인</a>';
        } else {
            frameHtmlModelStr += '<textarea placeholder="로그인하고 댓글을 입력해보세요!" disabled></textarea>';
            frameHtmlModelStr += '<a href="javascript:;">확인</a>';
        }

        frameHtmlModelStr += '</div>';
        frameHtmlModelStr += '<ul class="reviewList" id="' + elementIdListArea + '"></ul>';
        frameHtmlModelStr += '<div class="pagging_wrap"></div>';
        frameHtmlModelStr += '</div>';

        return (new DOMParser().parseFromString(frameHtmlModelStr, 'text/html').getElementById(elementIdRoot));
    },

    getListFormArea: function (id, type) {
        let formStr = '';
        formStr += '<form id="' + elementIdForm + '">';
        formStr += '<input type="hidden" name="contentsId" value="' + id + '">';
        formStr += '<input type="hidden" name="contentsType" value="' + type + '">';
        formStr += '</form>';

        return (new DOMParser().parseFromString(formStr, 'text/html').getElementById(elementIdForm));
    },

    getCommentShell: function () {
        let listElementHtml = '';

        listElementHtml += '<li class="' + elementClassListData + '">';
        listElementHtml += '    <div class="member_re"><img class="profile" src="' + profileEmptyImgUrl + '"></div>';
        listElementHtml += '    <div class="review_info">';
        listElementHtml += '        <em class="writer"></em>';
        listElementHtml += '        <img src="' + commentButtonDivisionImgUrl + '">';
        listElementHtml += '            <span class="writer_time"></span>';
        listElementHtml += '            <img src="' + commentButtonDivisionImgUrl + '" class="declaration_line">';
        listElementHtml += '                <span class="accuse ' + elementClassDeclarationButton + '">신고</span>';
        listElementHtml += '            <img src="' + commentButtonDivisionImgUrl + '" class="update_line">';
        listElementHtml += '                 <span class="accuse ' + elementClassUpdateButton + '">수정</span>';
        listElementHtml += '            <img src="' + commentButtonDivisionImgUrl + '" class="delete_line">';
        listElementHtml += '                 <span class="accuse ' + elementClassDeleteButton + '">삭제</span>';
        listElementHtml += '                <strong class="' + elementClassUpdateContents + '"></strong>';
        listElementHtml += '                <div class="write_wrap ' + elementClassUpdateWriteArea + '" style="display: none;">';
        listElementHtml += '                     <textarea placeholder="입력" name="comment_modify" class="' + elementClassUpdateTextArea + '"></textarea>';
        listElementHtml += '                     <a href="javascript:;" class="' + elementClassUpdateConfirmButton + '">확인</a>';
        listElementHtml += '                </div>';
        // listElementHtml += '                <a href="javascript:;" class="see_replies">답글보기</a>';
        // listElementHtml += '                <a href="javascript:;" class="Write_a_reply">답글달기</a>';
        listElementHtml += '    </div>';
        listElementHtml += '</li>';

        return (new DOMParser().parseFromString(listElementHtml, 'text/html').querySelector("." + elementClassListData));

    },

    getCommentById: function (commentId) {
        return document.getElementById("comment-" + commentId);
    },

    getComment: function (id, profile, nickName, comment, regId, regDate) {
        let commentElement = this.getCommentShell();

        if (profile) {
            commentElement.querySelector(".profile").setAttribute("src", profile);
        }

        commentElement.querySelector(".writer").innerHTML = nickName;
        commentElement.querySelector(".writer_time").innerHTML = regDate;
        commentElement.querySelector(".contents").innerHTML = comment;
        commentElement.querySelector("[name='comment_modify']").value = (comment||"").replace(/<br>/g,"\n");

        commentElement.querySelector(".declaration_line").style.display = 'none';
        commentElement.querySelector(".declaration").style.display = 'none';
        commentElement.querySelector(".update_line").style.display = 'none';
        commentElement.querySelector(".update").style.display = 'none';
        commentElement.querySelector(".delete_line").style.display = 'none';
        commentElement.querySelector(".delete").style.display = 'none';

        if (window.loginId == regId) {
            commentElement.querySelector(".update_line").style.display = 'inline';
            commentElement.querySelector(".update").style.display = 'inline';
            commentElement.querySelector(".delete_line").style.display = 'inline';
            commentElement.querySelector(".delete").style.display = 'inline';
        } else {
            commentElement.querySelector(".declaration_line").style.display = 'inline';
            commentElement.querySelector(".declaration").style.display = 'inline';
        }

        commentElement.setAttribute("id", "comment-" + id);

        return commentElement;
    },

    getRoot: function () {
        return document.getElementById(elementIdRoot);
    },

    getListForm: function () {
        return document.getElementById(elementIdForm);
    },

    getListFirstElement: function () {
        return document.getElementById(elementIdListArea).children[0]
    },

    area: {
        getList: function () {
            return document.getElementById(elementIdListArea);
        },
        getInsert: function () {
            return document.getElementById(elementIdInsertWriteArea);
        },

        getUpdate: function () {
            return document.querySelector('.' + elementClassUpdateWriteArea);
        },

        getContents: function (target) {
            return target.querySelector('.' + elementClassUpdateContents);
        },

        getCount: function () {
            return document.getElementById(elementIdCount);
        },
    },

    button: {
        getInsert: function () {
            return document.getElementById(elementIdInsertButton);
        },

        getUpdate: function (targetElement) {
            return targetElement.querySelector("." + elementClassUpdateButton)
        },

        getUpdateConfirm: function (targetElement) {
            return targetElement.querySelector("." + elementClassUpdateConfirmButton)
        },

        getDelete: function (targetElement) {
            return targetElement.querySelector("." + elementClassDeleteButton)
        },

        getDeclaration: function (targetElement) {
            return targetElement.querySelector("." + elementClassDeclarationButton)
        },
    },

    textArea: {
        getInsert: function () {
            return document.getElementById(elementIdInsertTextArea);
        },
        getUpdate: function (targetElement) {
            return targetElement.querySelector("." + elementClassUpdateTextArea)
        },
    },
}