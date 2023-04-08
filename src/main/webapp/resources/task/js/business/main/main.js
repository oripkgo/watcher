const keywordListUrl = '/keyword/popular';
const keywordSearchUrl = '/keyword/search';
const categoryListUrl = '/story/list/data';
const noticeListUrl = '/notice/list/data';
const storyListUrl = '/story/popular';

const mainObj = {
    keyword : {
        listUrl : keywordListUrl,
        init : function(){
            this.getPopularList();
        },

        search : function(obj){
            if( event.type == 'keypress' && event.keyCode != 13 ){
                return;
            }

            const $this = this;
            const param = {};
            param.keyword = $("#keyword").val();

            comm.request({url: keywordSearchUrl, method: "POST", data: JSON.stringify(param)}, function (resp) {
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
            list.forEach(function (obj, idx) {
                let $nodeCopy = $($node).clone(true);
                let nodeHtml = '';

                if (obj['CATEGORY_IMG_PATH']) {
                    nodeHtml += '<img src="' + obj['CATEGORY_IMG_PATH'] + '">';
                }

                nodeHtml += '<div>';
                nodeHtml += '	<strong>' + obj['CATEGORY_NM'] + '</strong>';
                nodeHtml += '	<span>#' + obj['TAGS'] + '</span>';
                nodeHtml += '</div>';

                $($nodeCopy).attr("href", getStoryListUrl(obj['CATEGORY_ID'], obj['TAGS']))

                $($nodeCopy).data(obj);
                $($nodeCopy).html(nodeHtml);

                $("#popularKeywordList").append($nodeCopy);
            })
        },
    },

    category : {
        listUrl : categoryListUrl,
        data : [],
        init : function(categoryList){
            this.data = JSON.parse(categoryList)
            const categoryObj = this;
            categoryObj.data.forEach(function(obj,idx){
                const id = obj['ID'];
                const nm = obj['CATEGORY_NM'];

                if( idx == 0 ){
                    $('.category_tab').append('<a href="javascript:;" class="tab_ov tab_'+id+'"><span>'+nm+'</span></a>');
                }else{
                    $('.category_tab').append('<a href="javascript:;" class="tab_'+id+'"><span>'+nm+'</span></a>');
                }

                const tabObj = categoryObj.tab.append(id, $("#tab_parent"));
                $(tabObj).html(categoryObj.tab.drawInTags(id));

                categoryObj.tab.event();

                // 추천순 목록
                categoryObj.recommendedList(id);
            })
        },

        recommendedList : function(id){
            comm.request({
                form:$("#RecommendedListForm"+id)
                , url:this.listUrl
                , method : "GET"
                , headers : {"Content-type":"application/x-www-form-urlencoded"}
            },function(data){
                $("#RecommendedDataList"+id).empty();

                for (let i = 0; i < data.list.length; i++) {
                    let obj = data.list[i];
                    let listHtml = '';
                    let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

                    listHtml += '<li>';
                    listHtml += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '">';

                    if( obj.THUMBNAIL_IMG_PATH ){
                        listHtml += '<div><img src="'+obj.THUMBNAIL_IMG_PATH.replace(/[\\]/g,'/')+'"></div>';
                    }

                    listHtml += '        <strong>'+obj.TITLE+'</strong>';
                    listHtml += '        <span>';

                    if( !obj.SUMMARY ){
                        obj.SUMMARY = '';
                    }

                    if( obj.SUMMARY.length < 100 ){
                        listHtml += obj.SUMMARY;
                    }else{
                        listHtml += (obj.SUMMARY || '').substring(0,100)+' ...';
                    }

                    listHtml += '        </span>';
                    listHtml += '    </a>';
                    listHtml += '    <div class="story_key">';

                    if( obj.TAGS ){
                        let tag_arr = obj.TAGS.split(',');

                        tag_arr.forEach(function(tag,index){
                            listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                        })
                    }
                    listHtml += '    </div>';
                    listHtml += '    <div class="story_key">';

                    listHtml += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>';
                    listHtml += '        <span>공감 ' + obj.LIKE_CNT + '</span>';
                    listHtml += '        <em>by ' + obj.NICKNAME + '</em>';


                    // listHtml += '        <a href="javascript:;">#컬처</a>';
                    // listHtml += '        <a href="javascript:;">#영화</a>';
                    // listHtml += '        <a href="javascript:;">#영화컬처</a>';
                    listHtml += '    </div>';
                    listHtml += '</li>';
                    listHtml = $(listHtml);

                    $(listHtml).data(obj);

                    $("#RecommendedDataList"+id).append(listHtml);
                }
            });
        },

        tab : {
            drawInTags : function(id){
                let div = $('<div></div>')
                let recommendedListForm = comm.appendForm('RecommendedListForm'+id);

                comm.appendInput(recommendedListForm, "SortByRecommendationYn", "YY");
                comm.appendInput(recommendedListForm, "search_category_id", id);
                comm.appendInput(recommendedListForm, "limitNum", "3");
                $(recommendedListForm).append('<ul class="story_wrap" id="RecommendedDataList'+id+'"></ul>')

                $(div).append(recommendedListForm);

                return $(div).html();
            },

            append : function(id, target){
                let tabId = 'tabObj_'+id;
                let tabHtml = '';

                tabHtml += '<div class="obj" id="'+tabId+'">';
                tabHtml += '<a href="javascript:;" class="btn_story2"></a>';
                tabHtml += '</div>';

                $(target).append(tabHtml);

                return $("#"+tabId, target);
            },

            event : function(){
                var param = "#tab_box";
                var btn = "#tab_cnt>a";
                var obj = "#tab_box .obj";
                var img = false;
                var event = "click";
                document_tab(param,btn,obj,img,event);
            },
        },
    },

    swiper : {
        init : function(){
            if( $(".swiper-wrapper", ".swiper_product").find(".swiper-slide").length <= 1 ){
                $(".swiper-pagination", ".swiper_product").hide();
            }

            this.product();

        },
        product : function(){
            new Swiper('.swiper_product', {
                centeredSlides: true,
                loop: true,
                autoplay: {
                    delay: 6000,
                    disableOnInteraction: false,
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                }
            });
        },
        banner : function(){
            new Swiper('.swiper_banner', {
                slidesPerView: 'auto',
                speed : 600,
                spaceBetween: 0,
                loop: true,
                autoplay: {
                    delay: 8000,
                    disableOnInteraction: false,
                },
                //initialSlide: 1,
                //freeMode: true,
                //centeredSlides: true,
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                }
            });
        },
    },

    notice : {
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
            comm.list('#mainNoticeForm', noticeListUrl, function (data) {
                let node = $('<a href="javascript:;" style="display:none;"></a>')
                if (data.code == '0000' && (data.list && data.list.length > 0)) {
                    if( noticeObj.isHide(data.list[0]['REG_DATE']) ){
                        return;
                    }

                    data.list.forEach(function (obj, idx) {
                        let copyNode = $(node).clone(true);
                        $(copyNode).text(obj['TITLE']);
                        $(copyNode).attr("href", getNoticeViewUrl(obj['ID']));

                        $(copyNode).data(obj)

                        $("#noticeList").append(copyNode)
                    })
                    $("#noticeList").parents(".notice_wrap").show();
                    $("a:eq(0)", "#noticeList").show();

                    $(".notice_wrap").find(".prev_a, .next_a").on("click", function () {
                        let aIndex = $("a", "#noticeList").index($("a:visible", "#noticeList"));
                        let target;

                        if ($(this).hasClass("prev_a")) {
                            target = $($("a", "#noticeList")[--aIndex]);
                        } else {
                            target = $($("a", "#noticeList")[++aIndex]);
                        }
                        if( $(target).length > 0 ){
                            $("a", "#noticeList").hide();
                            $(target).show();
                        }
                    })
                }
            }, 1, 5);
        }
    },

    story : {
        init : function(){
            this.getPopularList();
        },
        getPopularList : function(){
            comm.request({
                url: storyListUrl,
                method : "GET",
                headers : {"Content-type":"application/x-www-form-urlencoded"},
            },function(data){
                if( data.code == '0000' && ( data.getPopularStorys && data.getPopularStorys.length > 0 ) ){

                    data.getPopularStorys.forEach(function(obj){
                        let story = $('<div class="swiper-slide"></div>')
                        let storyHtml = '';

                        if( obj.THUMBNAIL_IMG_PATH ){
                            storyHtml += '<img width="1000" height="500" src="'+obj.THUMBNAIL_IMG_PATH.replace(/[\\]/g,'/')+'">';
                        }else{
                            return;
                        }

                        storyHtml += '<div class="issue_box">';
                        storyHtml += '<span class="kind">'+obj.CATEGORY_NM+'</span>';
                        storyHtml += '<strong>'+obj.TITLE+'</strong>';

                        let summary = obj.SUMMARY || '';
                        if( summary.length < 100 ){
                            summary = summary;
                        }else{
                            summary = summary.substring(0,100)+' ...';
                        }

                        storyHtml += '<span>'+summary+'</span>';
                        storyHtml += '<em>by ' + obj.NICKNAME + '</em>';
                        storyHtml += '<a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '"><img src="/resources/img/btn_more.png"></a>';
                        storyHtml += '</div>';

                        $(story).html(storyHtml)
                        $(story).data(obj);

                        $("#popularStoryList").append(story);
                    })
                }

                if( $(".swiper-slide","#popularStoryList").length == 0 ){
                    $("#popularStorys").remove();
                }else{
                    mainObj.swiper.banner();
                }
            });
        },
    },

}