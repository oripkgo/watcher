
const storyListUrl = '/story/list/data';
const popularStoryListUrl = '/story/popular/main';
const newStoryListUrl = '/story/new/main';
const listElement = $('<article class="card"></article>')

const story = {
    init : function(){
        this.getPopularList();
        this.getNewList();
    },
    getPopularList : function(){
        const storyThis = this;
        comm.request({
            url: popularStoryListUrl,
            method : "GET",
            headers : {"Content-type":"application/x-www-form-urlencoded"},
        },function(data){
            if( data.code == '0000' && ( data['popularStorys'] && data['popularStorys'].length > 0 ) ){
                data['popularStorys'].forEach(function(obj,idx){
                    let story = $(listElement).clone(true);

                    const contents = obj['SUMMARY'] || $(obj['CONTENTS']).text().trim()
                    const regName = obj['NICKNAME'];
                    const views = obj['VIEW_CNT'];
                    const comments = obj['COMMENT_CNT'];
                    const img = obj['THUMBNAIL_IMG_PATH']?
                        $(window.getImgTagStr(obj['THUMBNAIL_IMG_PATH'])):
                        $('<img src="'+('https://picsum.photos/400/250?random='+(new Date().getTime()+idx))+'" alt="인기 스토리">')

                    $(story).append(img)
                    $(story).append('<h3>'+obj['TITLE']+'</h3>')
                    $(story).append('<div class="meta">👤 '+regName+' · 👀 '+views+' · 💬 '+comments+'</div>')
                    $(story).append('<p class="contents">'+contents+'</p>')
                    $(story).append('<a href="'+window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID'])+'">더보기 →</a>')

                    $(story).data(obj)


                    $("#popularStoryList").append(story);
                })
            }

        });
    },

    getNewList : function(){
        const storyThis = this;
        comm.request({
            url: newStoryListUrl,
            method : "GET",
            headers : {"Content-type":"application/x-www-form-urlencoded"},
        },function(data){
            if( data.code == '0000' && ( data['newStorys'] && data['newStorys'].length > 0 ) ){
                data['newStorys'].forEach(function(obj,idx){
                    let story = $(listElement).clone(true);

                    const contents = obj['SUMMARY'] || $(obj['CONTENTS']).text().trim()
                    const regName = obj['NICKNAME'];
                    const views = obj['VIEW_CNT'];
                    const comments = obj['COMMENT_CNT'];
                    const img = obj['THUMBNAIL_IMG_PATH']?
                        $(window.getImgTagStr(obj['THUMBNAIL_IMG_PATH'])):
                        $('<img src="'+('https://picsum.photos/400/250?random='+(new Date().getTime()+idx))+'" alt="인기 스토리">')

                    $(story).append(img)
                    $(story).append('<h3>'+obj['TITLE']+'</h3>')
                    $(story).append('<div class="meta">👤 '+regName+' · 👀 '+views+' · 💬 '+comments+'</div>')
                    $(story).append('<p class="contents">'+contents+'</p>')
                    $(story).append('<a href="'+window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID'])+'">더보기 →</a>')

                    $(story).data(obj)


                    $("#newStoryList").append(story);
                })
            }

        });
    },
};