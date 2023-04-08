const storyPublicUrl = '/management/board/storys/public';
const storyPrivateUrl = '/management/board/storys/private';
const storyDeleteUrl = '/management/board/storys';
const storyListUrl = '/management/board/storys';

let category_list;
let thisObj;

const boardObj = {
    init : function(categoryList){
        category_list = JSON.parse(categoryList);
        thisObj = this;
    },

    goWritingPage : function(){
        window.location.href = getStoryWriteUrl();
    },

    confirmCheckBox : function(){
        return $(".check:checked:not('.all')").length == 0 ? false : true ;
    },

    changeCheckBoxOff : function(){
        $(".check:checked").prop("checked", false);
    },

    getSelCheckBoxObjs : function(){
        return $(".check:checked:not('.all')");
    },

    getStoryIds : function(){
        const checkObjs = thisObj.getSelCheckBoxObjs();
        const storyIds = [];

        checkObjs.each(function(idx,checkObj){
            const obj = $(checkObj).parents("tr").data();
            storyIds.push(obj.ID);
        })

        return storyIds;
    },

    updatePublic: function () {
        if (!thisObj.confirmCheckBox()) {
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 공개하시겠습니까?", function (result) {
            if (result) {
                const param = JSON.stringify({paramJson: JSON.stringify(thisObj.getStoryIds())});
                comm.request({url: storyPublicUrl, method: "PUT", data: param}, function (resp) {
                    // 수정 성공
                    if (resp.code == '0000') {
                        $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                            const trObj = $(checkObj).parents("tr");
                            $("td:eq(1)", trObj).text("공개");
                        })

                        thisObj.changeCheckBoxOff();
                    }
                })
            }
        })
    },

    updatePrivate: function () {
        if (!thisObj.confirmCheckBox()) {
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 비공개하시겠습니까?", function (result) {
            if (result) {
                const param = JSON.stringify({paramJson: JSON.stringify(thisObj.getStoryIds())});
                comm.request({url: storyPrivateUrl, method: "PUT", data: param}, function (resp) {
                    // 수정 성공
                    if (resp.code == '0000') {
                        $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                            const trObj = $(checkObj).parents("tr");
                            $("td:eq(1)", trObj).text("비공개");
                        })
                    }
                })
            }
        })
    },

    deleteStory: function () {
        if (!thisObj.confirmCheckBox()) {
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 삭제하시겠습니까?", function (result) {
            if (result) {
                const param = JSON.stringify({paramJson: JSON.stringify(thisObj.getStoryIds())});
                comm.request({url: storyDeleteUrl, method: "DELETE", data: param}, function (resp) {
                    // 수정 성공
                    if (resp.code == '0000') {
                        $(thisObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                            $(checkObj).parents("tr").remove();
                        })
                    }
                })
            }
        })
    },

    initCheckBox: function () {
        $(".check").on("click",function(){
            let $this = this;

            if( $($this).hasClass("all") ){
                if( $($this).is(":checked") ){
                    $(".check").prop("checked",true)
                }else{
                    $(".check").prop("checked",false)
                }
            }

            if( $(".check:not('.all')").length == $(".check:checked:not('.all')").length ){
                $(".check.all").prop("checked",true)
            }else{
                $(".check.all").prop("checked",false)
            }
        })
    },

    initCategory: function (obj) {
        const selObj = obj || '#seachCategory';

        $(selObj).empty();
        $(selObj).append('<option value="">카테고리</option>')

        category_list.forEach(function(obj,idx){
            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            $(selObj).append('<option value="'+id+'">'+nm+'</option>')
        })
    },

    getTr: function () {
        return $('<tr></tr>').clone(true);
    },

    getTrHead: function () {
        let _TrHeadStr = '';

        _TrHeadStr += '<th><input type="checkbox" class="check all"></th>';
        _TrHeadStr += '<th>공개여부</th>';
        _TrHeadStr += '<th>카테고리</th>';
        _TrHeadStr += '<th colspan="2">';
        _TrHeadStr += '    <div class="btn_tb">';
        _TrHeadStr += '        <a href="javascript:;" onclick="boardObj.deleteStory();"  >삭제</a>';
        _TrHeadStr += '        <a href="javascript:;" onclick="boardObj.updatePublic();" >공개</a>';
        _TrHeadStr += '        <a href="javascript:;" onclick="boardObj.updatePrivate();">비공개</a>';
        _TrHeadStr += '        <a href="javascript:;" onclick="boardObj.goWritingPage();">글쓰기</a>';
        _TrHeadStr += '    </div>';
        _TrHeadStr += '</th>';

        return $(thisObj.getTr()).html(_TrHeadStr);
    },

    listCallback: function (data) {
        $("#storyList").empty();
        $("#storyList").append(thisObj.getTrHead());

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);
            let secretStatus = obj.SECRET_YN == 'Y' ? "비공개" : "공개";

            listHtml += '<td><input type="checkbox" class="check"></td>                                                         ';
            listHtml += '<td>'+secretStatus+'</td>                                                                              ';
            listHtml += '<td><a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '" class="kind_link">'+obj.CATEGORY_NM+'</a></td>           ';
            listHtml += '<td>                                                                                                   ';
            listHtml += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '" class="subject_link">                                    ';
            listHtml += '        <strong>'+obj.TITLE+'</strong>                                                                 ';
            listHtml += '        <span>'+obj.SUMMARY+'</span>                                                                   ';
            listHtml += '    </a>                                                                                               ';
            listHtml += '    <div class="story_key">                                                                            ';

            if( obj.TAGS ){
                let tag_arr = obj.TAGS.split(',');

                tag_arr.forEach(function(tag,index){
                    listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                })
            }

            listHtml += '    </div>                                                                                        ';
            listHtml += '    <div class="story_key">                                                                       ';
            listHtml += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>                                         ';
            listHtml += '        <span>공감 ' + obj.LIKE_CNT + '</span>                                                      ';
            listHtml += '        <span>댓글 ' + obj.COMMENT_CNT + '</span>                                                   ';
            listHtml += '    </div>                                                                                        ';
            listHtml += '</td>                                                                                             ';
            listHtml += '<td>                                                                                              ';
            listHtml += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '" class="pic_link">                                   ';

            if( obj.THUMBNAIL_IMG_PATH ){
                listHtml += '<img src="'+obj.THUMBNAIL_IMG_PATH+'">';
            }else{
                listHtml += '<img src="">';
            }

            listHtml += '    </a>                                                                                               ';
            listHtml += '</td>                                                                                                  ';

            listHtml = $(thisObj.getTr()).html(listHtml);
            $(listHtml).data(obj);

            $("#storyList").append(listHtml);

        }

        thisObj.initCheckBox();
    },

    search: function () {
        comm.list("#managementBoardForm", storyListUrl, thisObj.listCallback, 1, 10, 10);
    },
};