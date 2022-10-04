<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">

</script>


<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <%@include file="include/commMenu.jsp"%>

            <div class="manage_box_wrap">

                <div class="sub_title01">
                    공지 관리
                    <div class="search_right_box">
                        <select>
                            <option>카테고리</option>
                            <option>여행</option>
                            <option>맛집</option>
                            <option>문화</option>
                            <option>연애</option>
                            <option>IT</option>
                            <option>게임</option>
                            <option>스포츠</option>
                        </select>
                        <input type="text" placeholder="">
                        <a href="javascript:;"></a>
                    </div>
                </div>

                <div class="board_notice">
                    <table>
                        <tr>
                            <th><input type="checkbox"></th>
                            <th colspan="2">
                                <div class="btn_tb">
                                    <a href="javascript:;">삭제</a>
                                    <a href="javascript:;">공개</a>
                                    <a href="javascript:;">비공개</a>
                                    <a href="javascript:;" class="on">공지쓰기</a>
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                            </td>
                            <td>
                                2021.11.11  13:44
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                            </td>
                            <td>
                                2021.11.11  13:44
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                            </td>
                            <td>
                                2021.11.11  13:44
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">[칼럼] 재난지원인가 빈민구휼인가?</a>
                            </td>
                            <td>
                                2021.11.11  13:44
                            </td>
                        </tr>
                    </table>

                    <div class="pagging_wrap">
                        <a href="javascript:;"><img src="/resources/img/prev_arrow.png"></a>
                        <a href="javascript:;" class="on">1</a>
                        <a href="javascript:;">2</a>
                        <a href="javascript:;">3</a>
                        <a href="javascript:;"><img src="/resources/img/next_arrow.png"></a>
                    </div>

                </div>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>