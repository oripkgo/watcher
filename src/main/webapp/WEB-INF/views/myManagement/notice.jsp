<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    function search() {
        comm.list('#noticeForm', '/myManagement/board/notices', listCallback, 1, 20);
    }

    function listCallback(data) {
        $("#noticeList").empty();
        $("#noticeList").append(getTrHead());

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listHtml += '<td><input type="checkbox"></td>';
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
    }

    function getTr(){
        return $('<tr></tr>').clone(true);
    }

    function getTrHead(){
        let _TrHeadStr = '';

        _TrHeadStr += '<th><input type="checkbox" class="check all"></th>';
        _TrHeadStr += '<th colspan="2">';
        _TrHeadStr += '    <div class="btn_tb">';
        _TrHeadStr += '        <a href="javascript:;">삭제</a>';
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
                            <jsp:param name="url" value="/myManagement/board/notices"/>
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
