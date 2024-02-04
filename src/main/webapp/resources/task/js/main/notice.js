const noticeListUrl = '/notice/list/data';
const formTargetId = "#mainNoticeForm";
const listTargetId = "#noticeList";
const notice = {
    init : function(){
        this.list();
    },

    isHide : function(regDt){
        let result = false;
        let regDate = new Date(regDt);
        let toDay = new Date();

        var dateDif = (toDay.getTime() - regDate.getTime()) / (1000*60*60*24) ;

        if( dateDif > 14) {
            result = true;
        }

        return result;
    },

    list : function(){
        const noticeObj = this;
        comm.paging.getList(formTargetId, noticeListUrl, function (data) {
            let node = $('<a href="javascript:;" style="display:none;"></a>')
            if (data.code == '0000' && (data.list && data.list.length > 0)) {
                if( noticeObj.isHide(data.list[0]['REG_DATE']) ){
                    return;
                }

                data.list.forEach(function (obj/*, idx*/) {
                    let copyNode = $(node).clone(true);
                    $(copyNode).text(obj['TITLE']);
                    $(copyNode).attr("href", window.getNoticeViewUrl(obj['ID']));

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
        }, 1, 5);
    }
};