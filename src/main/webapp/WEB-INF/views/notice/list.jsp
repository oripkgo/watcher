<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>

    function listCallback(data) {

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
                            <tbody>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>
                                    <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                                </td>
                                <td>
                                    2021.11.11 13:44
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>
                                    <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                                </td>
                                <td>
                                    2021.11.11 13:44
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>
                                    <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                                </td>
                                <td>
                                    2021.11.11 13:44
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>
                                    <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                                </td>
                                <td>
                                    2021.11.11 13:44
                                </td>
                            </tr>
                            </tbody>
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