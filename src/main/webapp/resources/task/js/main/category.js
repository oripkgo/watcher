const mainCategory = {
    categoryApiUrl: '/category/list',
    listUrl: storyListUrl,
    data: [],
    init: function () {
        this.data = comm.category.get();
        const categoryObj = this;
        categoryObj.data.forEach(function (obj, idx) {
            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            if (idx == 0) {
                $('.category_tab').append('<a href="javascript:;" class="tab_ov tab_' + id + '"><span>' + nm + '</span></a>');
            } else {
                $('.category_tab').append('<a href="javascript:;" class="tab_' + id + '"><span>' + nm + '</span></a>');
            }

            const tabObj = categoryObj.tab.append(id, $("#tab_parent"));
            $(tabObj).html(categoryObj.tab.drawInTags(id));

            categoryObj.tab.event();

            // 추천순 목록
            categoryObj.recommendedList(id);
        })
    },

    recommendedList: function (id) {
        comm.request({
            form: $("#RecommendedListForm" + id)
            , url: this.listUrl
            , method: "GET"
            , headers: {"Content-type": "application/x-www-form-urlencoded"}
        }, function (data) {
            $("#RecommendedDataList" + id).empty();

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];
                let listHtml = '';
                // let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

                listHtml += '<li>';
                listHtml += '    <a href="' + window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']) + '">';
                listHtml += '<div>' + window.getImgTagStr(obj['THUMBNAIL_IMG_PATH']) + '</div>';
                listHtml += '        <strong>' + obj['TITLE'] + '</strong>';
                listHtml += '        <span>';

                if (!obj.SUMMARY) {
                    obj.SUMMARY = '';
                }

                if (obj.SUMMARY.length < 100) {
                    listHtml += obj.SUMMARY;
                } else {
                    listHtml += (obj.SUMMARY || '').substring(0, 100) + ' ...';
                }

                listHtml += '        </span>';
                listHtml += '    </a>';
                listHtml += '    <div class="story_key">';

                if (obj['TAGS']) {
                    let tag_arr = obj['TAGS'].split(',');

                    tag_arr.forEach(function (tag/*,index*/) {
                        listHtml += '        <a href="javascript:;">#' + tag.trim() + '</a>';
                    })
                }
                listHtml += '    </div>';
                listHtml += '    <div class="story_key">';

                listHtml += '        <span>' + comm.date.getPastDate(obj['REG_DATE']) + '</span>';
                listHtml += '        <span>공감 ' + obj['LIKE_CNT'] + '</span>';
                listHtml += '        <em>by ' + obj['NICKNAME'] + '</em>';


                // listHtml += '        <a href="javascript:;">#컬처</a>';
                // listHtml += '        <a href="javascript:;">#영화</a>';
                // listHtml += '        <a href="javascript:;">#영화컬처</a>';
                listHtml += '    </div>';
                listHtml += '</li>';
                listHtml = $(listHtml);

                $(listHtml).data(obj);

                $("#RecommendedDataList" + id).append(listHtml);
            }
        });
    },

    tab: {
        drawInTags: function (id) {
            let div = $('<div></div>')
            let recommendedListForm = comm.dom.appendForm('RecommendedListForm' + id);

            comm.dom.appendInput(recommendedListForm, "SortByRecommendationYn", "YY");
            comm.dom.appendInput(recommendedListForm, "searchCategoryId", id);
            comm.dom.appendInput(recommendedListForm, "limitNum", "3");
            $(recommendedListForm).append('<ul class="story_wrap" id="RecommendedDataList' + id + '"></ul>');

            $(div).append(recommendedListForm);

            return $(div).html();
        },

        append: function (id, target) {
            let tabId = 'tabObj_' + id;
            let tabHtml = '';

            tabHtml += '<div class="obj" id="' + tabId + '">';
            tabHtml += '<a href="javascript:;" class="btn_story2"></a>';
            tabHtml += '</div>';

            $(target).append(tabHtml);

            return $("#" + tabId, target);
        },

        event: function () {
            var param = "#tab_box";
            var btn = "#tab_cnt>a";
            var obj = "#tab_box .obj";
            var img = false;
            var event = "click";
            window.document_tab(param, btn, obj, img, event);
        },
    },
};