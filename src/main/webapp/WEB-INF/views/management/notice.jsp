<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    function confirmCheckBox(){
        return $(".check:checked:not('.all')").length == 0 ? false : true ;
    }

    function getSelCheckBoxObjs(){
        return $(".check:checked:not('.all')");
    }

    function getNoticeIds(){
        const checkObjs = getSelCheckBoxObjs();
        const storyIds = [];

        checkObjs.each(function(idx,checkObj){
            const obj = $(checkObj).parents("tr").data();
            storyIds.push(obj.ID);
        })

        return storyIds;
    }

    function deleteStory(){
        if( !confirmCheckBox() ){
            comm.message.alert('공지사항을 선택해주세요.');
            return;
        }

        comm.message.confirm("선택한 공지사항을 삭제하시겠습니까?",function(result){
            if( result ){
                const param = JSON.stringify({paramJson:JSON.stringify(getNoticeIds())});
                comm.request({url:"/management/board/notices", method : "DELETE", data : param},function(resp){
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

    function search() {
        comm.list('#noticeForm', '/management/board/notices', listCallback, 1, 20);
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

    function listCallback(data) {
        $("#noticeList").empty();
        $("#noticeList").append(getTrHead());

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listHtml += '<td><input type="checkbox" class="check"></td>';
            listHtml += '<td>';
            listHtml += '    <a href="/notice/view?id=' + obj.ID + '" class="subject_link">'+obj.TITLE+'</a>';
            listHtml += '</td>';
            listHtml += '<td>';
            listHtml += obj.REG_DATE;
            listHtml += '</td>';

            listHtml = $(getTr()).html(listHtml);
            $(listHtml).data(obj);

            $("#noticeList").append(listHtml);
        }

        initCheckBox();
    }

    function getTr(){
        return $('<tr></tr>').clone(true);
    }

    function getTrHead(){
        let _TrHeadStr = '';

        _TrHeadStr += '<th><input type="checkbox" class="check all"></th>';
        _TrHeadStr += '<th colspan="2">';
        _TrHeadStr += '    <div class="btn_tb">';
        _TrHeadStr += '        <a href="javascript:;" onclick="deleteStory();">삭제</a>';
        _TrHeadStr += '        <a href="javascript:;">공개</a>';
        _TrHeadStr += '        <a href="javascript:;">비공개</a>';
        _TrHeadStr += '        <a href="javascript:;">공지쓰기</a>';
        _TrHeadStr += '    </div>';
        _TrHeadStr += '</th>';

        return $(getTr()).html(_TrHeadStr);
    }

    $(document).on("ready", function () {
        $("#search").on("click", function () {
            search();
        });

        $("#search_keyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                search();
                return false;
            }
        });
    })
</script>

<form id="noticeForm">
    <div class="section uline2">
        <div class="ani-in manage_layout">
            <div class="manage_conts">
                <%@include file="include/commMenu.jsp"%>
                <div class="manage_box_wrap">
                    <div class="sub_title01">
                        공지 관리

                        <div class="search_right_box">
                            <select id="search_id" name="search_id">
                                <option value="">선택</option>
                                <option value="01">제목</option>
                                <option value="02">내용</option>
                            </select>
                            <input type="text" id="search_keyword" name="search_keyword" placeholder="">
                            <a href="javascript:;" id="search"></a>
                        </div>
                    </div>

                    <div class="board_notice">
                        <table id="noticeList"></table>

                        <jsp:include page="/WEB-INF/common/include/paging.jsp">
                            <jsp:param name="form" value="#noticeForm"/>
                            <jsp:param name="url" value="/management/board/notices"/>
                            <jsp:param name="listCallback" value="listCallback"/>
                            <jsp:param name="pageNo" value="${vo.pageNo}"/>
                            <jsp:param name="listNo" value="${vo.listNo}"/>
                            <jsp:param name="pagigRange" value="${vo.pagigRange}"/>
                        </jsp:include>
                    </div>
                </div><!-------------//manage_box_wrap------------->
            </div>
        </div>
    </div>
</form>
