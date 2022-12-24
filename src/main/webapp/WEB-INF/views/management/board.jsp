<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    const category_list = JSON.parse('${category_list}');

    function goWritingPage(){
        window.location.href = getStoryWriteUrl();
    }

    function confirmCheckBox(){
        return $(".check:checked:not('.all')").length == 0 ? false : true ;
    }

    function changeCheckBoxOff(){
        $(".check:checked").prop("checked", false);
    }

    function getSelCheckBoxObjs(){
        return $(".check:checked:not('.all')");
    }

    function getStoryIds(){
        const checkObjs = getSelCheckBoxObjs();
        const storyIds = [];

        checkObjs.each(function(idx,checkObj){
            const obj = $(checkObj).parents("tr").data();
            storyIds.push(obj.ID);
        })

        return storyIds;
    }

    function updatePublic(){
        if( !confirmCheckBox() ){
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 공개하시겠습니까?",function(result){
            if( result ){
                const param = JSON.stringify({paramJson:JSON.stringify(getStoryIds())});
                comm.request({url:"/management/board/storys/public", method : "PUT", data : param},function(resp){
                    // 수정 성공
                    if( resp.code == '0000'){
                        $(getSelCheckBoxObjs()).each(function(idx,checkObj){
                            const trObj = $(checkObj).parents("tr");
                            $("td:eq(1)", trObj).text("공개");
                        })

                        changeCheckBoxOff();
                    }
                })
            }
        })
    }

    function updatePrivate(){
        if( !confirmCheckBox() ){
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 비공개하시겠습니까?",function(result){
            if( result ){
                const param = JSON.stringify({paramJson:JSON.stringify(getStoryIds())});
                comm.request({url:"/management/board/storys/private", method : "PUT", data : param},function(resp){
                    // 수정 성공
                    if( resp.code == '0000'){
                        $(getSelCheckBoxObjs()).each(function(idx,checkObj){
                            const trObj = $(checkObj).parents("tr");
                            $("td:eq(1)", trObj).text("비공개");
                        })
                    }
                })
            }
        })
    }

    function deleteStory(){
        if( !confirmCheckBox() ){
            comm.message.alert('스토리를 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 스토리를 삭제하시겠습니까?",function(result){
            if( result ){
                const param = JSON.stringify({paramJson:JSON.stringify(getStoryIds())});
                comm.request({url:"/management/board/storys", method : "DELETE", data : param},function(resp){
                    // 수정 성공
                    if( resp.code == '0000'){
                        $(getSelCheckBoxObjs()).each(function(idx,checkObj){
                            $(checkObj).parents("tr").remove();
                        })
                    }
                })
            }
        })
    }

    function initCheckBox(){
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
    }

    function initCategory(obj){
        const selObj = obj || '#seachCategory';

        $(selObj).empty();
        $(selObj).append('<option value="">카테고리</option>')

        category_list.forEach(function(obj,idx){
            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            $(selObj).append('<option value="'+id+'">'+nm+'</option>')
        })
    }

    function getTr(){
        return $('<tr></tr>').clone(true);
    }

    function getTrHead(){
        let _TrHeadStr = '';

        _TrHeadStr += '<th><input type="checkbox" class="check all"></th>';
        _TrHeadStr += '<th>공개여부</th>';
        _TrHeadStr += '<th>카테고리</th>';
        _TrHeadStr += '<th colspan="2">';
        _TrHeadStr += '    <div class="btn_tb">';
        _TrHeadStr += '        <a href="javascript:;" onclick="deleteStory();"  >삭제</a>';
        _TrHeadStr += '        <a href="javascript:;" onclick="updatePublic();" >공개</a>';
        _TrHeadStr += '        <a href="javascript:;" onclick="updatePrivate();">비공개</a>';
        _TrHeadStr += '        <a href="javascript:;" onclick="goWritingPage();">글쓰기</a>';
        _TrHeadStr += '    </div>';
        _TrHeadStr += '</th>';

        return $(getTr()).html(_TrHeadStr);
    }

    function listCallback(data){
        $("#storyList").empty();
        $("#storyList").append(getTrHead());

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

            listHtml = $(getTr()).html(listHtml);
            $(listHtml).data(obj);

            $("#storyList").append(listHtml);

        }

        initCheckBox();
    }

    function search(){
        comm.list("#managementBoardForm","/management/board/storys",listCallback,1,10,10);
    }

    $(document).on("ready",function(){
        initCategory();

        $("#search").on("click",function(){
            search();
        });

        $("#search_keyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                search();
                return false;
            }
        });
    });

</script>

<form id="managementBoardForm">
    <div class="section uline2">
        <div class="ani-in manage_layout">

            <div class="manage_conts">

                <%@include file="include/commMenu.jsp"%>

                <div class="manage_box_wrap">
                    <div class="sub_title01">
                        게시글 관리
                        <div class="search_right_box">
                            <select id="seachCategory" name="search_category_id"></select>
                            <input type="text" placeholder="" name="search_keyword" id="search_keyword">
                            <a href="javascript:;" id="search"></a>
                        </div>
                    </div>

                    <div class="board_basic">
                        <table id="storyList"></table>

                        <jsp:include page="/WEB-INF/common/include/paging.jsp">
                            <jsp:param name="form" value="#managementBoardForm"/>
                            <jsp:param name="url" value="/management/board/storys"/>
                            <jsp:param name="listCallback" value="listCallback"/>
                            <jsp:param name="pageNo" value="${vo.pageNo}"/>
                            <jsp:param name="listNo" value="10"/>
                            <jsp:param name="pagigRange" value="${vo.pagigRange}"/>
                        </jsp:include>
                    </div>
                </div><!-------------//manage_box_wrap------------->
            </div>
        </div>
    </div>
</form>
