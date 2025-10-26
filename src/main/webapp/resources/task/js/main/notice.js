const noticeListUrl = '/notice/list/data';
const formTargetId = "#mainNoticeForm";
const listTargetId = "#noticeList";
const notice = {
    init : function(){
        this.list();
    },

    list : function(){
        const noticeObj = this;
        comm.paging.getList(formTargetId, noticeListUrl, function (data) {
            let node = $('<article class="card"></article>')
            if (data.code == '0000' && (data.list && data.list.length > 0)) {

                data.list.forEach(function (obj, idx) {
                    let copyNode = $(node).clone(true);

                    const contents = $(obj['CONTENTS']).text().trim()
                    const regName = obj['NICKNAME'];
                    const views = obj['VIEW_CNT'];
                    const comments = obj['COMMENT_CNT'];

                    $(copyNode).append('<img src="https://picsum.photos/400/250?random='+idx+'" alt="공지사항">')
                    $(copyNode).append('<h3>'+obj['TITLE']+'</h3>')
                    $(copyNode).append('<div class="meta">👤 '+regName+' · 👀 '+views+' · 💬 '+comments+'</div>')
                    $(copyNode).append('<p class="contents">'+contents+'</p>')
                    $(copyNode).append('<a href="'+window.getNoticeViewUrl(obj['ID'])+'">더보기 →</a>')

                    $(copyNode).data(obj)

                    $(listTargetId).append(copyNode)
                })
                $(listTargetId).parents(".notice_wrap").show();
                $("a:eq(0)", listTargetId).show();

                $(".notice_wrap").find(".prev_a, .next_a").on("click", function () {
                    let aIndex = $("a", listTargetId).index($("a:visible", listTargetId));
                    let target;

                    if ($(this).hasClass("prev_a")) {
                        target = $($("a", listTargetId)[--aIndex]);
                    } else {
                        target = $($("a", listTargetId)[++aIndex]);
                    }
                    if( $(target).length > 0 ){
                        $("a", listTargetId).hide();
                        $(target).show();
                    }
                })
            }
        }, 1, 6);
    }
};