<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-04
  Time: 오후 6:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-list.css"/>


<div class="container">
    <main>
        <section class="title-area">
            <h1 class="page-title">스토리</h1>
        </section>
        <section class="search-area">
            <div class="search-message">
                <p>다양한 이야기를 공유해보세요</p>
            </div>

            <form name="searchForm" id="searchForm">
                <div class="search-group">
                    <select id="seachCategory">
                        <option value="">카테고리</option>
                    </select>

                    <div class="search-box">
                        <input type="text" id="keyword" placeholder="키워드 입력"/>

                        <button type="button" id="searchBtn" class="search-button" aria-label="검색">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>

                </div>
            </form>
        </section>

        <section class="category-tabs category_tab_area"></section>

        <section class="story-list-box tab_parent">
        </section>


    </main>
</div>

<script>
    const SEARCH_CATEGORY_ID = '${searchCategoryId}';
    const SEARCH_KEYWORD = '${searchKeyword}';
    const CATEGORY_LIST = comm.category.get();
    const listUrl = '/story/list/data';

    const initCategory = function(){
        CATEGORY_LIST.forEach(function(obj,idx){
            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            $('#seachCategory').append('<option value="'+id+'">'+nm+'</option>')

            if( idx == 0 ){
                $('.category_tab_area').append(`<button class="category-tab active" data-category="\${id}">\${nm}</button>`);
            }else{
                $('.category_tab_area').append(`<button class="category-tab" data-category="\${id}">\${nm}</button>`);
            }

            $(".tab_parent").replaceWith(drawTabList(id));

            // 기본 목록
            defaultList(id, null);
        })
    }


    const initKeywordSearch = function(){
        $("#searchBtn").on("click", function () {
            let id = $("#seachCategory").val();

            if (!id) {
                comm.message.alert("카테고리를 선택해주세요.",function(){
                    $("#seachCategory").focus();
                });
                return;

                // if (CATEGORY_LIST.length > 0) {
                //     id = CATEGORY_LIST[0]['ID'];
                // }
            }

            comm.dom.appendInput($('#defaultListForm' + id), 'searchKeyword', $("#searchForm").find("#keyword").val());

            $("#defaultList"+id).empty();

            // 기본 목록
            defaultList(id, function(){
                $(".tab_"+id).click();
            });
        })

        $("#keyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                $("#searchBtn").click();
                return false;
            }
        });
    }


    const recommendedList = function(id){
        comm.request({
            form: $("#RecommendedListForm" + id)
            , url: listUrl
            , method: "GET"
            , headers: {"Content-type": "application/x-www-form-urlencoded"}
        },function(data){
            $("#RecommendedDataList"+id).empty();

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];
                let listHtml = '';
                // let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

                listHtml += '<li>';
                listHtml += '    <a href="' + window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']) + '">';
                listHtml += '<div>'+window.getImgTagStr(obj['THUMBNAIL_IMG_PATH'])+'</div>';
                listHtml += '        <strong>'+obj['TITLE']+'</strong>';
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

                    tag_arr.forEach(function(tag){
                        listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                    })
                }
                listHtml += '    </div>';
                listHtml += '    <div class="story_key">';

                listHtml += '        <span>'+comm.date.getPastDate(obj.REG_DATE)+'</span>';
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
    }

    const defaultList = function(id, callback){
        comm.paging.getList('#defaultListForm'+id, listUrl,function(data){
            comm.paging.emptyList("#defaultList"+id);

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];

                if (!obj.SUMMARY) {
                    obj.SUMMARY = '';
                }

                const summary = obj.SUMMARY.length < 100 ? obj.SUMMARY : (obj.SUMMARY || '').substring(0, 100) + ' ...'
                const image = obj['THUMBNAIL_IMG_PATH'] ? window.getImgTagStr(obj['THUMBNAIL_IMG_PATH']) : '<img src="https://i.pravatar.cc/102" alt="썸네일" class="story-thumbnail" />';

                let listHtml = `
                    <div class="story-card" onclick="location.href='\${window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID'])}'">
                        <div class="story-content">
                            <h2 class="story-title">\${obj.TITLE}</h2>
                            <p class="story-summary">\${summary}</p>
                            <div class="story-meta">
                                <span class="author">by \${obj.NICKNAME}</span>
                                <span class="date">\${obj.REG_DATE}</span>
                            </div>
                        </div>
                        \${image}
                    </div>

                `;

                listHtml = $(listHtml);
                $(listHtml).data(obj);

                $("#defaultList"+id).append(listHtml);
            }

            if( callback ){
                callback();
            }
        });
    }


    const appendTab = function(id,target){
        let tabId = 'tabObj_'+id;
        let tabHtml = '';

        tabHtml += '<div class="obj" id="'+tabId+'">';
        tabHtml += '<a href="javascript:;" class="btn_story2"></a>';
        tabHtml += '</div>';

        $(target).append(tabHtml);

        return $("#"+tabId, target);
    }

    const drawTabList = function(id){
        let div = $('<div></div>')
        let defaultListForm = comm.dom.appendForm('defaultListForm'+id);

        comm.dom.appendInput(defaultListForm, "SortByRecommendationYn", "NN", true);
        comm.dom.appendInput(defaultListForm, "searchCategoryId", id, true);
        $(defaultListForm).append(`<section class="story-list-box tab_parent" id="defaultList\${id}"></section`);
        $(defaultListForm).append('<nav class="pagination"></nav>');
        $(div).append(defaultListForm);

        return $(div).html();
    }


    $(document).on("ready", function(){
        initCategory();
        initKeywordSearch();
        if( SEARCH_CATEGORY_ID && SEARCH_KEYWORD ){
            $("#seachCategory").val(SEARCH_CATEGORY_ID);
            $("#keyword").val(SEARCH_KEYWORD);
            $("#searchBtn").click();
        }
    })

</script>
