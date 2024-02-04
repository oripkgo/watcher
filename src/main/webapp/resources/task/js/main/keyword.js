const keywordApiUrl = '/keyword/popular';

const keyword = {
    listUrl : keywordApiUrl,
    init : function(){
        this.getPopularList();
    },

    search : function(/*obj*/){
        if( event.type == 'keypress' && event.keyCode != 13 ){
            return;
        }

        const $this = this;
        const param = {};
        param.keyword = $("#keyword").val();

        comm.request({url: keywordApiUrl, method: "POST", data: JSON.stringify(param)}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
                $this.render(resp.list);
            }
        })
    },

    getPopularList : function(){
        const $this = this;
        comm.request({
            url:this.listUrl,
            method : "GET",
            headers : {"Content-type":"application/x-www-form-urlencoded"}
        },function(data){
            if (data.code == '0000' && data.list) {
                $this.render(data.list);
            }
        });
    },

    render: function (list) {
        let $node = $('<a href="javascript:;"></a>');
        $("#popularKeywordList").empty();
        list.forEach(function (obj/*, idx*/) {
            let $nodeCopy = $($node).clone(true);
            let nodeHtml = '';

            if (obj['CATEGORY_IMG_PATH']) {
                nodeHtml += '<img src="' + obj['CATEGORY_IMG_PATH'] + '">';
            }

            nodeHtml += '<div>';
            nodeHtml += '	<strong>' + obj['CATEGORY_NM'] + '</strong>';
            nodeHtml += '	<span>#' + obj['TAGS'] + '</span>';
            nodeHtml += '</div>';

            $($nodeCopy).attr("href", window.getStoryListUrl(obj['CATEGORY_ID'], obj['TAGS']))

            $($nodeCopy).data(obj);
            $($nodeCopy).html(nodeHtml);

            $("#popularKeywordList").append($nodeCopy);
        })
    },
};