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
                    게시글 관리
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

                <div class="board_basic">
                    <table>
                        <tr>
                            <th><input type="checkbox"></th>
                            <th>카테고리</th>
                            <th colspan="2">
                                <div class="btn_tb">
                                    <a href="javascript:;">삭제</a>
                                    <a href="javascript:;">공개</a>
                                    <a href="javascript:;">비공개</a>
                                    <a href="javascript:;" class="on">글쓰기</a>
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><a href="story_detail.html" class="kind_link">정치</a></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">
                                    <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                    <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                                </a>
                                <div class="story_key">
                                    <a href="javascript:;">#컬처</a>
                                    <a href="javascript:;">#영화</a>
                                    <a href="javascript:;">#영화컬처</a>
                                    <span>1시간전</span>
                                    <span>공감21</span>
                                    <span>댓글 21</span>
                                </div>
                            </td>
                            <td>
                                <a href="story_detail.html" class="pic_link"><img src="/resources/img/s_sample01.jpg"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><a href="story_detail.html" class="kind_link">정치</a></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">
                                    <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                    <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                                </a>
                                <div class="story_key">
                                    <a href="javascript:;">#컬처</a>
                                    <a href="javascript:;">#영화</a>
                                    <a href="javascript:;">#영화컬처</a>
                                    <span>1시간전</span>
                                    <span>공감21</span>
                                    <span>댓글 21</span>
                                </div>
                            </td>
                            <td>
                                <a href="story_detail.html" class="pic_link"><img src="/resources/img/s_sample01.jpg"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><a href="story_detail.html" class="kind_link">정치</a></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">
                                    <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                    <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                                </a>
                                <div class="story_key">
                                    <a href="javascript:;">#컬처</a>
                                    <a href="javascript:;">#영화</a>
                                    <a href="javascript:;">#영화컬처</a>
                                    <span>1시간전</span>
                                    <span>공감21</span>
                                    <span>댓글 21</span>
                                </div>
                            </td>
                            <td>
                                <a href="story_detail.html" class="pic_link"><img src="/resources/img/s_sample01.jpg"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><a href="story_detail.html" class="kind_link">정치</a></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">
                                    <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                    <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                                </a>
                                <div class="story_key">
                                    <a href="javascript:;">#컬처</a>
                                    <a href="javascript:;">#영화</a>
                                    <a href="javascript:;">#영화컬처</a>
                                    <span>1시간전</span>
                                    <span>공감 21</span>
                                    <span>댓글 21</span>
                                </div>
                            </td>
                            <td>
                                <a href="story_detail.html" class="pic_link"><img src="/resources/img/s_sample01.jpg"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><a href="story_detail.html" class="kind_link">정치</a></td>
                            <td>
                                <a href="story_detail.html" class="subject_link">
                                    <strong>[칼럼] 재난지원인가 빈민구휼인가?</strong>
                                    <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다.</span>
                                </a>
                                <div class="story_key">
                                    <a href="javascript:;">#컬처</a>
                                    <a href="javascript:;">#영화</a>
                                    <a href="javascript:;">#영화컬처</a>
                                    <span>1시간전</span>
                                    <span>공감 21</span>
                                    <span>댓글 21</span>
                                </div>
                            </td>
                            <td>
                                <a href="story_detail.html" class="pic_link"><img src="/resources/img/s_sample01.jpg"></a>
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