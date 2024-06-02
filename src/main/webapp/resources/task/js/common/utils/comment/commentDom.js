

const COMMENT_DOM = {
    replaceCommentRoot : function(target, root){
        const rootId = root.id;
        target.parentNode.replaceChild(root, target);
        return document.getElementById(rootId);
    },

    appendChild : function(target, child){
        target.appendChild(child);
    },

    appendFirst : function(target, element){
        target.insertBefore(element, target.firstChild);
    },

    resetInput : function(element){
        element.value = '';
    },

    setCount : function(target, cnt){
        target.dataset['cnt'] = cnt;
    },

    getCount : function(target){
        return ( (target.dataset['cnt'] || 0) * 1 );
    },

    renderCount : function(target){
        const nowCount =  target.dataset['cnt'];
        target.innerHTML = '댓글<em>'+nowCount+'</em>';
    },

    setDataSet : function (target, oriData) {
        let changeData = {
            comment         : oriData.comment         || oriData['COMMENT'],
            confirmId       : oriData.confirmId       || oriData['CONFIRM_ID'],
            contentsId      : oriData.contentsId      || oriData['CONTENTS_ID'],
            contentsType    : oriData.contentsType    || oriData['CONTENTS_TYPE'],
            id              : oriData.id              || oriData['ID'],
            nickName        : oriData.nickName        || oriData['NICKNAME'],
            profile         : oriData.profile         || oriData['MEM_PROFILE_IMG'],
            refContentsId   : oriData.refContentsId   || oriData['REF_CONTENTS_ID'],
            regId           : oriData.regId           || oriData['REG_ID'],
        }

        Object.assign(target.dataset, changeData);
    },

    getDataSet : function (target, key) {
        return target.dataset[key];
    },


    getElementById : function(commentId){
        return document.getElementById("comment-"+commentId);
    },

    replaceLineBreakWithBrReturnValue : function(element){
        return  element.value.replace(/[\n]/g,'<br>');
    },

}
