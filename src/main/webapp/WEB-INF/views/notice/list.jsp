<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>

    function listCallback(data) {

        $("#dataList").empty();

        for( let i=0;i<data.list.length;i++ ){
            let obj = data.list[i];
            let listHtml = '';

            listHtml += '<tr>                                                                            ';
            listHtml += '    <td><input type="checkbox"></td>                                            ';
            listHtml += '    <td>                                                                        ';
            listHtml += '        <a href="/notice/view?id='+obj.id+'" class="subject_link">'+obj.title+'</a>';
            listHtml += '    </td>                                                                       ';
            listHtml += '    <td>' + obj.regId + '</td>';
            listHtml += '    <td>' + obj.regDate.substring(2) + '</td>';
            listHtml += '    <td>'+obj.viewCnt+'</td>';
            listHtml += '</tr>                                                                           ';
            listHtml = $(listHtml);

            $(listHtml).data(obj);

            $("#dataList").append(listHtml);

        }

    }

</script>


<form id="noticeForm" name="noticeForm" method="get">

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
                        NOTICE
                        <div class="search_right_box">
                            <select>
                                <option>제목</option>
                                <option>내용</option>
                            </select>
                            <input type="text" placeholder="">
                            <a href="javascript:;"></a>
                        </div>
                    </div>

                    <div class="board_notice">
                        <table>
                            <colgroup>
                                <col/>
                                <col/>
                                <col width="100"/>
                                <col width="150"/>
                                <col width="100"/>
                            </colgroup>

                            <tbody id="dataList"></tbody>
                        </table>


                        <jsp:include page="/WEB-INF/common/include/paging.jsp">
                            <jsp:param name="form"          value="#noticeForm"         />
                            <jsp:param name="url"           value="/notice/listAsync"   />
                            <jsp:param name="listCallback"  value="listCallback"        />
                            <jsp:param name="pageNo"        value="${vo.pageNo}"        />
                            <jsp:param name="listNo"        value="${vo.listNo}"        />
                            <jsp:param name="pagigRange"    value="${vo.pagigRange}"    />
                        </jsp:include>

                    </div>

                </div><!-------------//manage_box_wrap------------->

            </div>

        </div>
    </div>

</form>