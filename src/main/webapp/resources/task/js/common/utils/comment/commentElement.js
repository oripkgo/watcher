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
const elementClassUpdateCancelButton = 'commentInputUpdateCancel';

const COMMENT_ELEMENT = {
    getRootArea: function (loginYn) {

        let frameHtmlModelStr = `
        <section class="story-comments" id="${elementIdRoot}">
            <h2 class="comments-title" data-cnt="0" id="${elementIdCount}">댓글 <em>0</em></h2>

            <!-- 댓글 작성 -->
            <form class="comment-form" id="${elementIdInsertWriteArea}">
                <textarea
                    id="${elementIdInsertTextArea}"
                    placeholder="${loginYn === 'Y' ? "댓글을 입력하세요" : "로그인하고 댓글을 입력해보세요!"}"
                    required
                    ${loginYn !== 'Y' ? "disabled" : ""}
                ></textarea>
                <button type="button" id="${elementIdInsertButton}">등록</button>
            </form>
            <!-- 댓글 목록 -->
            <ul class="comment-list" id="${elementIdListArea}"></ul>
            <div class="pagination"></div>
        </section>
        `;


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
        let listElementHtml = `
            <li class="comment-item ${elementClassListData}">
                <div class="comment-avatar">
                    <img class="profile" src="${profileEmptyImgUrl}" alt="avatar">
                </div>
                <div class="comment-body">
                    <div class="comment-meta">
                        <span class="comment-author"></span>
                        <span class="comment-date"></span>
                    </div>
                    <div class="comment-content ${elementClassUpdateContents}">
                    </div>
                    
                    <div class="comment-edit ${elementClassUpdateWriteArea}" style="display: none;">
                        <textarea name="comment_modify" class="comment-edit-input ${elementClassUpdateTextArea}"></textarea>
                        <div class="comment-edit-actions">
                            <button type="button" class="comment-edit-save ${elementClassUpdateConfirmButton}">확인</button>
                            <button type="button" class="comment-edit-cancel ${elementClassUpdateCancelButton}">취소</button>
                        </div>
                    </div>
                    
                    <div class="comment-actions">
                        <a href="javascript:void(0)" class="declaration ${elementClassDeclarationButton}">신고</a>
                        <a href="javascript:void(0)" class="update ${elementClassUpdateButton}">수정</a>
                        <a href="javascript:void(0)" class="delete ${elementClassDeleteButton}">삭제</a>
                    </div>
                </div>
            </li>
        `;


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

        commentElement.querySelector(".comment-author").innerHTML = nickName;
        commentElement.querySelector(".comment-date").innerHTML = regDate;
        commentElement.querySelector(".comment-content").innerHTML = comment;
        commentElement.querySelector("[name='comment_modify']").value = (comment||"").replace(/<br>/g,"\n");

        commentElement.querySelector(".declaration").style.display = 'none';
        commentElement.querySelector(".update").style.display = 'none';
        commentElement.querySelector(".delete").style.display = 'none';

        if (window.loginId == regId) {
            commentElement.querySelector(".update").style.display = 'inline';
            commentElement.querySelector(".delete").style.display = 'inline';
        } else {
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