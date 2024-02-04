const commentInsertApiUrl = "/board/comment/insert";
const commentDeleteApiUrl = "/board/comment/delete";
const commentUpdateApiUrl = "/board/comment/update";

const COMMENT = {
    init: function (id, type, loginYn, notLoginStatusProcessingFunc, deleteConfirmMsgFunc) {
        this.deleteMsg = "해당 댓글을 삭제하시겠습니까?";
        this.id = id;
        this.type = type;
        this.loginYn = loginYn;
        this.notLoginStatusProcessingFunc = notLoginStatusProcessingFunc;
        this.deleteConfirmMsgFunc = deleteConfirmMsgFunc;
    },


    leadLogin: function () {
        const commentThis = this;

        if (commentThis.notLoginStatusProcessingFunc) {
            commentThis.notLoginStatusProcessingFunc();
        }
    },

    declaration: function (/*commentElement*/) {
        // const commentThis = this;
        alert('댓글 신고');
    },

    update: function (id, regId) {
        const commentElement = COMMENT_ELEMENT.getCommentById(id);

        const target = COMMENT_ELEMENT.button.getUpdate(commentElement);
        const param = {
            commentId: id,
            regId: regId,
        }

        if (target.classList.contains("ing")) {
            target.classList.remove("ing");

            let parent = commentElement;
            let updateWriteArea = COMMENT_ELEMENT.area.getUpdate(parent);
            let textarea = COMMENT_ELEMENT.textArea.getUpdate(parent);
            let contents = COMMENT_ELEMENT.area.getContents(parent);

            textarea.value = contents.textContent;
            updateWriteArea.style.display = 'none';
            contents.style.display = 'block';

            target.textContent = "수정";
        } else {
            target.classList.add("ing");

            let parent = commentElement;
            let writeWrap = COMMENT_ELEMENT.area.getUpdate(parent);
            let contents = COMMENT_ELEMENT.area.getContents(parent);
            let commentModifyButton = COMMENT_ELEMENT.button.getUpdateConfirm(parent);

            writeWrap.style.display = 'block';
            contents.style.display = 'none';
            target.textContent = "수정 취소";

            commentModifyButton.addEventListener("click", function () {
                const thisObj = this;
                param.comment = COMMENT_DOM.replaceLineBreakWithBrReturnValue(COMMENT_ELEMENT.textArea.getUpdate(thisObj.parentElement));

                REQUEST.send(commentUpdateApiUrl, "PUT", param, function (resp) {
                    if (resp.code === '0000') {
                        target.classList.remove("ing");
                        contents.innerHTML = resp.comment;
                        writeWrap.style.display = 'none';
                        contents.style.display = 'block';
                        target.textContent = "수정";
                    }
                }, null, {'Content-type': "application/json"})
            });
        }
    },


    delete: function (id, regId) {
        const param = {
            commentId: id,
            regId: regId,
        }

        REQUEST.send(commentDeleteApiUrl, "DELETE", param, function (resp) {
            // 삭제 성공
            if (resp.code == '0000') {
                const countEle = COMMENT_ELEMENT.getCount();
                COMMENT_ELEMENT.getCommentById(id).remove();

                let cmtCnt = COMMENT_DOM.getCount(countEle);

                if (cmtCnt > 0) {
                    cmtCnt = cmtCnt - 1;
                }

                COMMENT_DOM.setCount(countEle, cmtCnt);
                COMMENT_DOM.drawCount(countEle)
            }
        })
    },

    insertAndApplyEvents: function () {
        const commentThis = this;

        let commentInsertParam = {
            contentsId: commentThis.id,
            contentsType: commentThis.type,
            refContentsId: "0",
            comment: COMMENT_DOM.replaceLineBreakWithBrReturnValue(COMMENT_ELEMENT.textArea.getInsert()),
        };


        if( !commentInsertParam.comment ){
            MESSAGE.alert('댓글을 입력해주세요.');
            return;
        }

        REQUEST.send(commentInsertApiUrl, "POST", commentInsertParam, function (resp) {
            // 등록성공
            if (resp.code == '0000') {
                let listElement = COMMENT_ELEMENT.getComment(
                    resp.comment['id'],
                    resp.comment['profile'],
                    resp.comment['nickName'],
                    resp.comment['comment'],
                    resp.comment.regId,
                    "방금"
                );

                COMMENT_DOM.appendFirst(COMMENT_ELEMENT.area.getList(), listElement)
                COMMENT_DOM.resetInput(COMMENT_ELEMENT.textArea.getInsert());
                COMMENT_DOM.setCount(COMMENT_ELEMENT.getCount(), COMMENT_DOM.getCount(COMMENT_ELEMENT.getCount()) + 1);
                COMMENT_DOM.drawCount(COMMENT_ELEMENT.getCount())

                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getUpdate(listElement), resp.comment);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getDelete(listElement), resp.comment);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getDeclaration(listElement), resp.comment);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getUpdateConfirm(listElement), resp.comment);

                commentThis.addEventToElement(COMMENT_ELEMENT.getListFirstElement())
            }
        }, null, {'Content-type': "application/json"})
    },

    drawList: function (list) {
        if (list && list.length > 0) {
            for (let listObj of list) {
                let commentElement = COMMENT_ELEMENT.getComment(
                    listObj['ID'],
                    listObj['MEM_PROFILE_IMG'],
                    listObj['NICKNAME'],
                    (listObj['COMMENT'] ? listObj['COMMENT'] : ""),
                    listObj['REG_ID'],
                    listObj['REG_DATE']
                );

                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getUpdate(commentElement), listObj);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getDelete(commentElement), listObj);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getDeclaration(commentElement), listObj);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getUpdateConfirm(commentElement), listObj);

                COMMENT_DOM.appendChild(COMMENT_ELEMENT.area.getList(), commentElement)
            }
        }
    },

    addEventToElement: function (element) {
        const commentThis = this;

        // 삭제 이벤트 적용
        COMMENT_ELEMENT.button.getDelete(element).addEventListener("click", function () {
            const obj = this;
            if (commentThis.deleteConfirmMsgFunc) {
                commentThis.deleteConfirmMsgFunc(function (result) {
                    if (result) {
                        commentThis.delete(
                            COMMENT_DOM.getDataSet(obj, "id"),
                            COMMENT_DOM.getDataSet(obj, "regId")
                        );
                    }
                })
            }
        })

        // 수정 이벤트 적용
        COMMENT_ELEMENT.button.getUpdate(element).addEventListener("click", function () {
            const obj = this;
            commentThis.update(
                COMMENT_DOM.getDataSet(obj, "id"),
                COMMENT_DOM.getDataSet(obj, "regId")
            );
        })

        // 신고하기 이벤트 적용
        COMMENT_ELEMENT.button.getDeclaration(element).addEventListener("click", function () {
            const obj = this;
            commentThis.declaration(
                COMMENT_DOM.getDataSet(obj, "id"),
                COMMENT_DOM.getDataSet(obj, "regId")
            );
        })
    },

    render: function (tagId) {
        const commentThis = this;
        const loginYn = commentThis.loginYn;
        const targetElement = document.getElementById(tagId);

        COMMENT_DOM.replaceWithCommentRoot(
            targetElement,
            COMMENT_ELEMENT.getRootShell(commentThis.loginYn)
        );

        COMMENT_DOM.appendChild(
            COMMENT_ELEMENT.getRoot(),
            COMMENT_ELEMENT.getListFormShell(commentThis.id, commentThis.type)
        );

        if (loginYn === 'Y') {
            COMMENT_ELEMENT.button.getInsert().addEventListener("click", function () {
                commentThis.insertAndApplyEvents();
            })
        } else {
            COMMENT_ELEMENT.area.getInsert().addEventListener("click", function () {
                commentThis.leadLogin();
            });
        }

        COMMENT_LIST.get(COMMENT_ELEMENT.getListForm(), function (resp) {
            const listArea = COMMENT_ELEMENT.area.getList();
            const countEle = COMMENT_ELEMENT.getCount();
            COMMENT_LIST.empty(listArea);

            COMMENT_DOM.setCount(countEle, resp.comment['cnt'])
            COMMENT_DOM.drawCount(countEle)

            commentThis.drawList(resp.comment['list']);

            for(let obj of listArea.children){
                commentThis.addEventToElement(obj);
            }
        })
    },
}
