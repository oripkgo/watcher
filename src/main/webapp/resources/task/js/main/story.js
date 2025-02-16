
const storyListUrl = '/story/list/data';
const popularStoryListUrl = '/story/popular/main';
const moreButtonImgPath = '/resources/img/btn_more.png';
const swiperSlide = $('<div class="swiper-slide"></div>')

const story = {
    init : function(funcSwiperExecution){
        this.funcSwiperExecution = funcSwiperExecution;
        this.getPopularList();
    },
    getPopularList : function(){
        const storyThis = this;
        comm.request({
            url: popularStoryListUrl,
            method : "GET",
            headers : {"Content-type":"application/x-www-form-urlencoded"},
        },function(data){
            if( data.code == '0000' && ( data['popularStorys'] && data['popularStorys'].length > 0 ) ){
                data['popularStorys'].forEach(function(obj){
                    let story = $(swiperSlide).clone(true);
                    let storyHtml = '';

                    storyHtml += window.getImgTagStr(obj['THUMBNAIL_IMG_PATH'], "main-middel-banner");
                    storyHtml += '<div class="issue_box">';
                    storyHtml += '<span class="kind">'+obj['CATEGORY_NM']+'</span>';
                    storyHtml += '<strong>'+obj['TITLE']+'</strong>';

                    let summary = obj['SUMMARY'] || '';
                    if( !(summary.length < 100) ){
                        summary = summary.substring(0,100)+' ...';
                    }

                    storyHtml += '<span>'+summary+'</span>';
                    storyHtml += '<em>by ' + obj['NICKNAME'] + '</em>';
                    storyHtml += '<a href="' + window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']) + '"><img src="' + moreButtonImgPath + '"></a>';
                    storyHtml += '</div>';

                    $(story).html(storyHtml)
                    $(story).data(obj);

                    $("#popularStoryList").append(story);
                })
            }

            if( $(".swiper-slide","#popularStoryList").length == 0 ){
                $("#popularStorys").remove();
            }else{
                if( storyThis.funcSwiperExecution ){
                    storyThis.funcSwiperExecution();
                }
            }
        });
    },
};