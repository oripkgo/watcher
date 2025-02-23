<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 2:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<script>
    const storyExternalListUrl = '/management/board/external/storys';


    $(document).on("ready", function () {

    })

</script>

<%@include file="include/header.jsp" %>
<form id="managementBoardForm">
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
                                    <a href="javascript:;" >삭제</a>
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
                            </colgroup>
                            <tbody class="list_header">
                            <th class="not-none"><input type="checkbox" class="check all"></th>
                            <th>블로그명</th>
                            <th>카테고리</th>
                            <th></th>

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
