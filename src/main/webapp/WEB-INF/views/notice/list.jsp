<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">

    $(document).on("ready", function () {
        $("#search").on("click", function () {

            let id = $("#searchForm").find("#id").val();
            let keyword = $("#searchForm").find("#keyword").val();

            comm.appendInput("#noticeForm", "search_id"         , id        );
            comm.appendInput("#noticeForm", "search_keyword"    , keyword   );

            comm.list('#noticeForm', '/notice/listAsync', listCallback, 1, 20);

        });
    })

    function listCallback(data) {

        $("#dataList").empty();

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listHtml += '<tr>                                                                               ';
            // listHtml += '    <td><input type="checkbox"></td>                                            ';
            listHtml += '    <td>' + listNum + '</td>                                                         ';
            listHtml += '    <td>                                                                           ';
            listHtml += '        <a href="/notice/view?id=' + obj.ID + '" class="subject_link">' + obj.TITLE + '</a>';
            listHtml += '    </td>                                                                          ';
            listHtml += '    <td>' + obj.NICKNAME + '</td>';
            listHtml += '    <td>' + obj.REG_DATE.substring(2) + '</td>';
            listHtml += '    <td>' + obj.VIEW_CNT + '</td>';
            listHtml += '</tr>                                                                           ';
            listHtml = $(listHtml);

            $(listHtml).data(obj);

            $("#dataList").append(listHtml);

        }

    }

</script>


<div class="section uline2">
    <div class="ani-in manage_layout action">

        <div class="manage_conts">

            <!-------------//manage_menu------------->
            <script>
                $(".manage_btn").click(function () {
                    $(".manage_menu").toggleClass("on");
                });
            </script>

            <div class="manage_box_wrap">

                <div class="sub_title01">
                    <p>NOTICE</p>


                    <div class="search_right_box">
                        <form id="searchForm" name="searchForm">
                            <select id="id" name="id">
                                <option value="01">제목</option>
                                <option value="02">내용</option>
                            </select>
                            <input type="text" id="keyword" name="keyword" placeholder="검색 키워드 입력">
                            <a href="#none" id="search"></a>
                        </form>
                    </div>

                    <%--
                    <div class="search_right_box">
                        <form id="searchForm" name="searchForm">
                            <select id="id" name="id">
                                <option value="01">제목</option>
                                <option value="02">내용</option>
                            </select>
                            <input type="text" id="keyword" name="keyword" placeholder="검색 키워드 입력">
                            <a href="#none" id="search"></a>
                        </form>
                    </div>--%>
                </div>

                <form id="noticeForm" name="noticeForm" method="get">
                    <div class="board_notice list">
                        <table>
                            <colgroup>
                                <col/>
                                <col/>
                                <col width="100"/>
                                <col width="150"/>
                                <col width="100"/>
                            </colgroup>


                            <thead>
                            <tr>
                                <th scope="col">No.</th>
                                <th scope="col">제목</th>
                                <th scope="col">작성자</th>
                                <th scope="col">작성일</th>
                                <th scope="col">조회수</th>
                            </tr>
                            </thead>

                            <tbody id="dataList"></tbody>
                        </table>


                        <jsp:include page="/WEB-INF/common/include/paging.jsp">
                            <jsp:param name="form" value="#noticeForm"/>
                            <jsp:param name="url" value="/notice/listAsync"/>
                            <jsp:param name="listCallback" value="listCallback"/>
                            <jsp:param name="pageNo" value="${vo.pageNo}"/>
                            <jsp:param name="listNo" value="${vo.listNo}"/>
                            <jsp:param name="pagigRange" value="${vo.pagigRange}"/>
                        </jsp:include>

                    </div>
                </form>
            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>

</div>


