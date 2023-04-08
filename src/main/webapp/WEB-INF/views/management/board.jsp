<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="/resources/task/js/business/management/board.js"></script>

<script type="text/javascript">
    const categoryListStr = '${category_list}';
    boardObj.init(categoryListStr);
    window.listCallback = boardObj.listCallback;

    $(document).on("ready",function(){
        boardObj.initCategory();

        $("#search").on("click",function(){
            boardObj.search();
        });

        $("#search_keyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                boardObj.search();
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
