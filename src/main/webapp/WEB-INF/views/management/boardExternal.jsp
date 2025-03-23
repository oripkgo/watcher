<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 2:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<script type="text/javascript">
    const CATEGORY_LIST = comm.category.get();
    const storyExternalListUrl = '/management/board/external/storys';

    const getSelCheckBoxObjs = function(){
        return $(".check:checked:not(.all)");
    }

    const getStoryIds = function(){
        const checkObjs = getSelCheckBoxObjs();
        const storyIds = [];

        checkObjs.each(function(idx,checkObj){
            const obj = $(checkObj).parents("tr").data();
            storyIds.push(obj.ID);
        })

        return storyIds;
    }

    const deleteStory = function () {
        if (!confirmCheckBox()) {
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 삭제하시겠습니까?", function (result) {
            if (result) {
                const param = JSON.stringify({paramJson: JSON.stringify(getStoryIds())});
                comm.request({url: storyExternalListUrl, method: "DELETE", data: param}, function (resp) {
                    // 수정 성공
                    if (resp.code == '0000') {
                        $(getSelCheckBoxObjs()).each(function (idx, checkObj) {
                            $(checkObj).parents("tr").remove();
                        })
                    }
                })
            }
        })
    }

    const confirmCheckBox = function(){
        return $(".check:checked:not(.all)").length == 0 ? false : true ;
    }

    const search = function() {
        comm.paging.getList('managementBoardExternalForm', storyExternalListUrl, listCallback, 1, 10, 10);
    }

    const initCategory = function (obj) {
        const selObj = obj || '#seachCategory';

        $(selObj).empty();
        $(selObj).append('<option value="">카테고리</option>')

        CATEGORY_LIST.forEach(function(obj){
            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            $(selObj).append('<option value="'+id+'">'+nm+'</option>')
        })
    }

    const getMobileRecord = function(target, arr){
        let tempDiv = $("<div></div>");
        let dataElement = $(document.createElement(target));
        let rowElement = $('<div class="mobile-data-row"></div>');
        $(dataElement).addClass("mobile-data");

        for(let obj of arr){
            const col = $('<div class="mobile-data-col"></div>');
            if( obj.type == 'image' ){
                $(col).addClass("image");
                const a = $('<a></a>');
                const img = $(window.getImgTagStr(obj.src));
                $(a).attr("href",obj.href);
                $(a).append(img);
                $(col).append(a);
            }else{
                $(col).append('<div class="col-name"><strong>'+obj.col+'</strong></div>');
                $(col).append('<div class="col-value">'+obj.val+'</div>');
            }

            $(rowElement).append(col);
        }
        $(dataElement).html(rowElement);
        return  $(tempDiv).html(dataElement).html();
    }

    const getTr = function () {
        return $('<tr></tr>').clone(true);
    }

    const initCheckBox = function () {
        $(".check").on("click",function(){
            let $this = this;

            if( $($this).hasClass("all") ){
                if( $($this).is(":checked") ){
                    $(".check").prop("checked",true)
                }else{
                    $(".check").prop("checked",false)
                }
            }

            if( $(".check:not(.all)").length == $(".check:checked:not(.all)").length ){
                $(".check.all").prop("checked",true)
            }else{
                $(".check.all").prop("checked",false)
            }
        })
    }

    const listCallback = function(data){
        comm.paging.emptyList("#storyList");

        if( data.dto.pageNo == 1 && data.list.length == 0 ){
            $(".list_header").hide();
        }else{
            $(".list_header").show();
        }

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            // let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listHtml += '<td class="not-none"><input type="checkbox" class="check"></td>                                                         ';
            listHtml += '<td>'+obj['blogName']+'</td>                                                                              ';
            listHtml += '<td><a href="' + window.getStoryViewUrl(obj['memberId'], obj['id']) + '" class="kind_link">'+obj['categoryNm']+'</a></td>           ';
            listHtml += '<td class="story_info">                                                                                                   ';
            listHtml += '    <a href="' + window.getStoryViewUrl(obj['memberId'], obj['id']) + '" class="subject_link">                                    ';
            listHtml += '        <strong>'+obj['title']+'</strong>                                                                 ';
            listHtml += '        <span>'+(obj['summary'] || '')+'</span>                                                                   ';
            listHtml += '    </a>                                                                                               ';
            listHtml += '    <div class="story_key">                                                                            ';

            if( obj['tags'] ){
                let tag_arr = obj['tags'].split(',');

                tag_arr.forEach(function(tag){
                    listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                })
            }

            listHtml += '    </div>                                                                                        ';
            listHtml += '    <div class="story_key">                                                                       ';
            listHtml += '        <span>'+comm.date.getPastDate(obj['regDate'])+'</span>                                         ';
            listHtml += '        <span>공감 ' + obj['likeCnt'] + '</span>                                                      ';
            listHtml += '        <span>댓글 ' + obj['commentCnt'] + '</span>                                                   ';
            listHtml += '    </div>                                                                                        ';
            listHtml += '</td>                                                                                             ';
            listHtml += '<td class="story_image">                                                                                              ';
            listHtml += '    <a href="' + window.getStoryViewUrl(obj['memberId'], obj['id']) + '" class="pic_link">                                   ';
            listHtml += window.getImgTagStr(obj['thumbnailImgPath'],"management-story-pc-image");
            listHtml += '    </a>                                                                                               ';
            listHtml += '</td>                                                                                                  ';

            listHtml += getMobileRecord("td", [
                {
                    type: "image",
                    href: window.getStoryViewUrl(obj['memberId'], obj['id']),
                    src: obj['thumbnailImgPath']
                },
                {col: "블로그명", val: obj['blogName']},
                {col: "카테고리", val: obj['categoryNm']},
                {col: "제목", val: obj['title']},
                {col: "내용", val: obj['summary'] || ''},
                {col: "공감", val: obj['likeCnt']},
                {col: "댓글", val: obj['commentCnt']},
                {col: "작성일", val: obj['regDate']},
            ])

            listHtml = $(getTr()).html(listHtml);
            $(listHtml).data(obj);
            comm.paging.renderList("#storyList", listHtml)
        }

        initCheckBox();
    }

    $(document).on("ready", function () {
        initCategory();
        search();

        $("#search").on("click", function () {
            boardObj.search();
        });

        $("#searchKeyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                search();
                return false;
            }
        });

        $("#storyDelete").on("click", function () {
            deleteStory();
        });
    })

</script>


<%@include file="include/header.jsp" %>
<form id="managementBoardExternalForm">
    <div class="section uline2">
        <div class="ani-in manage_layout">

            <div class="manage_conts">
                <%@include file="include/menus.jsp" %>
                <div class="manage_box_wrap">

                    <div class="new_manage_head_box">
                        <div class="new_manage_title_box">
                            <p class="new_manage_title">
                                외부 게시글 관리
                            </p>
                            <div class="new_manage_btn_and_search_box">
                                <div class="new_search_right_box">
                                    <div class="search_right_box">
                                        <select id="seachCategory" name="searchCategoryId"></select>
                                        <input type="text" placeholder="" name="searchKeyword" id="searchKeyword">
                                        <a href="javascript:;" id="search"></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="new_manage_btn_and_search_box">
                            <div class="new_btn_right_box">
                                <div class="btn_tb">
                                    <a href="javascript:;" id="storyDelete">삭제</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="board_basic">
                        <table class="board_list_table">
                            <colgroup>
                                <col width="5%">
                                <col width="25%">
                                <col width="20%">
                                <col>
                                <col>
                            </colgroup>
                            <tbody class="list_header">
                                <th class="not-none"><input type="checkbox" class="check all"></th>
                                <th>블로그명</th>
                                <th>카테고리</th>
                                <th colspan="2"></th>

                            </tbody>
                            <tbody id="storyList"></tbody>
                        </table>
                        <div class="pagging_wrap"></div>
                    </div>
                </div><!-------------//manage_box_wrap------------->
            </div>
        </div>
    </div>
</form>

