
const COMMENT = function(){
    const commentInsertApiUrl = "/board/comment/insert";
    const commentDeleteApiUrl = "/board/comment/delete";
    const commentUpdateApiUrl = "/board/comment/update";

    const renderCount = function(commentCount){
        const countEle = COMMENT_ELEMENT.area.getCount();
        COMMENT_DOM.setCount(countEle, commentCount)
        COMMENT_DOM.renderCount(countEle)
    }

    const renderList = function (list) {
        const listArea = COMMENT_ELEMENT.area.getList();

        COMMENT_LIST.empty(listArea);

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

                COMMENT_DOM.appendChild(listArea, commentElement)
            }
        }
    }

    const declaration = function (/*commentElement*/) {
        // const commentThis = this;
        alert('댓글 신고');
    }

    const updateComment = function (id, regId) {
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

            textarea.value = (contents.innerHTML || "").replace(/<br>/g,"\n");
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
    }

    const deleteComment = function (id, regId) {
        const param = {
            commentId: id,
            regId: regId,
        }

        REQUEST.send(commentDeleteApiUrl, "DELETE", param, function (resp) {
            // 삭제 성공
            if (resp.code == '0000') {
                const countEle = COMMENT_ELEMENT.area.getCount();
                COMMENT_ELEMENT.getCommentById(id).remove();

                let cmtCnt = COMMENT_DOM.getCount(countEle);

                if (cmtCnt > 0) {
                    cmtCnt = cmtCnt - 1;
                }

                COMMENT_DOM.setCount(countEle, cmtCnt);
                COMMENT_DOM.renderCount(countEle)
            }
        })
    }

    const insertComment = function (id, type, callback) {
        let commentInsertParam = {
            contentsId: id,
            contentsType: type,
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
                COMMENT_DOM.setCount(COMMENT_ELEMENT.area.getCount(), COMMENT_DOM.getCount(COMMENT_ELEMENT.area.getCount()) + 1);
                COMMENT_DOM.renderCount(COMMENT_ELEMENT.area.getCount())

                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getUpdate(listElement), resp.comment);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getDelete(listElement), resp.comment);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getDeclaration(listElement), resp.comment);
                COMMENT_DOM.setDataSet(COMMENT_ELEMENT.button.getUpdateConfirm(listElement), resp.comment);

                if( callback ){
                    callback(COMMENT_ELEMENT.getListFirstElement());
                }

            }
        }, null, {'Content-type': "application/json"})
    }

    const addEventDelete = function(element, callback){
        // 삭제 이벤트 적용
        COMMENT_ELEMENT.button.getDelete(element).addEventListener("click", function () {
            const obj = this;
            if (callback) {
                callback(function (result) {
                    if (result) {
                        deleteComment(
                            COMMENT_DOM.getDataSet(obj, "id"),
                            COMMENT_DOM.getDataSet(obj, "regId")
                        );
                    }
                })
            }
        })
    }

    const addEventUpdate = function(element){
        // 수정 이벤트 적용
        COMMENT_ELEMENT.button.getUpdate(element).addEventListener("click", function () {
            const obj = this;
            updateComment(
                COMMENT_DOM.getDataSet(obj, "id"),
                COMMENT_DOM.getDataSet(obj, "regId")
            );
        })
    }

    const addEventDeclaration = function(element){
        // 신고하기 이벤트 적용
        COMMENT_ELEMENT.button.getDeclaration(element).addEventListener("click", function () {
            const obj = this;
            declaration(
                COMMENT_DOM.getDataSet(obj, "id"),
                COMMENT_DOM.getDataSet(obj, "regId")
            );
        })
    }


    return {

        init: function (id, type, loginYn, handleNotLogin, deleteConfirmMsgFunc) {
            this.deleteMsg = "해당 댓글을 삭제하시겠습니까?";
            this.id = id;
            this.type = type;
            this.loginYn = loginYn;
            this.handleNotLogin = handleNotLogin;
            this.deleteConfirmMsgFunc = deleteConfirmMsgFunc;
        },

        disabled : function(){
            $("textarea", COMMENT_ELEMENT.area.getInsert()).attr("placeholder", "관리자가 댓글작성을 제한했습니다.");
            $("textarea", COMMENT_ELEMENT.area.getInsert()).prop("disalbed", true);

            $(COMMENT_ELEMENT.area.getInsert()).off();
            $("textarea", COMMENT_ELEMENT.area.getInsert()).off();
            $("a",COMMENT_ELEMENT.area.getInsert()).off();
        },

        render: function (tagId) {
            const commentThis = this;
            const targetElement = document.getElementById(tagId);

            COMMENT_DOM.replaceCommentRoot(
                targetElement,
                COMMENT_ELEMENT.getRootArea(commentThis.loginYn)
            );

            COMMENT_DOM.appendChild(
                COMMENT_ELEMENT.getRoot(),
                COMMENT_ELEMENT.getListFormArea(commentThis.id, commentThis.type)
            );

            if (commentThis.loginYn === 'Y') {
                $(COMMENT_ELEMENT.button.getInsert()).on("click", function () {
                    insertComment(commentThis.id, commentThis.type, function(element){
                        addEventDelete(element, commentThis.deleteConfirmMsgFunc);
                        addEventUpdate(element);
                        addEventDeclaration(element);
                    });
                })
            } else {
                $(COMMENT_ELEMENT.area.getInsert()).on("click", function () {
                    if (commentThis.handleNotLogin) {
                        commentThis.handleNotLogin();
                    }
                });
            }

            COMMENT_LIST.get(COMMENT_ELEMENT.getListForm(), function (resp) {

                renderCount(resp.comment['cnt']);
                renderList(resp.comment['list']);

                const listArea = COMMENT_ELEMENT.area.getList();

                for(let element of listArea.children){
                    addEventDelete(element, commentThis.deleteConfirmMsgFunc);
                    addEventUpdate(element);
                    addEventDeclaration(element);
                }

            })
        },

    }
}()


