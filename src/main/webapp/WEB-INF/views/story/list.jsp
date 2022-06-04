<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">

    function RecommendedListCallback(data){


        $("#RecommendedDataList").empty();

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listNum += '<li>';
            listNum += '    <a href="/notice/view?id=' + obj.ID + '">';
            listNum += '        <div><img src="'+obj.THUMBNAIL_IMG_PATH+'"></div>';
            listNum += '        <strong>'+obj.TITLE+'</strong>';
            listNum += '        <span>'+(obj.SUMMARY || '').substring(0,50)+' ...</span>';
            listNum += '    </a>';
            listNum += '    <div class="story_key">';
            listNum += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'전</span>';
            listNum += '        <span>공감 ' + obj.LIKE_CNT + '</span>';
            listNum += '        <em>by ' + obj.NICKNAME + '</em>';
            // listNum += '        <a href="javascript:;">#컬처</a>';
            // listNum += '        <a href="javascript:;">#영화</a>';
            // listNum += '        <a href="javascript:;">#영화컬처</a>';
            listNum += '    </div>';
            listNum += '</li>';
            listHtml = $(listHtml);

            $(listHtml).data(obj);

            $("#RecommendedDataList").append(listHtml);

        }
    }

    function deflistCallback(data) {

        $("#defaultList").empty();

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);


            listNum += '<li>';
            listNum += '    <a href="/notice/view?id=' + obj.ID + '">';
            listNum += '        <strong>'+obj.TITLE+'</strong>';
            listNum += '        <span>'+(obj.SUMMARY || '').substring(0,50)+' ...</span>';
            listNum += '        <img src="'+obj.THUMBNAIL_IMG_PATH+'">';
            listNum += '    </a>';
            listNum += '    <div class="story_key">';
            // listNum += '        <a href="javascript:;">#컬처</a>';
            // listNum += '        <a href="javascript:;">#영화</a>';
            // listNum += '        <a href="javascript:;">#영화컬처</a>';
            listNum += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'전</span>';
            listNum += '        <span>공감 ' + obj.LIKE_CNT + '</span>';
            listNum += '        <em>by ' + obj.NICKNAME + '</em>';
            listNum += '    </div>';
            listNum += '</li>';
            listNum += '';

            listHtml = $(listHtml);

            $(listHtml).data(obj);

            $("#defaultList").append(listHtml);

        }

    }

    // id="defaultList">


</script>

<div class="section">
    <div class="ani-in layout">

        <div class="story_search_wrap ani_y delay1">
            <div class="sub_title">Story</div>
            <span>다양한 지식을 공유 해보세요</span>
            <div class="story_search">
                <select>
                    <option value="">카테고리</option>
                    <c:if test="${ !((empty category_list) || fn:length(category_list) == 0) }">
                        <c:forEach var="obj" items="${category_list}" varStatus="status">
                            <option value="${obj.ID}">${obj.CATEGORY_NM}</option>
                        </c:forEach>
                    </c:if>
                </select>
                <input type="text" placeholder="">
                <a href="javascript:;"><img src="/resources/img/btn_search_b.png"></a>
            </div>
        </div>

    </div>
</div>


<div class="section">
    <div class="ani-in layout">

        <div class="tab_wrap ani_y delay2">
            <!--탭메뉴-->
            <div id="tab_box">
                <div id="tab_cnt">
                    <c:if test="${ !((empty category_list) || fn:length(category_list) == 0) }">
                        <c:forEach var="obj" items="${category_list}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.index == 0}">
                                    <a href="javascript:;" class="tab_ov"><span>${obj.CATEGORY_NM}</span></a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:;"><span>${obj.CATEGORY_NM}</span></a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:if>
                </div>
                <div class="grap">
                    <div class="obj">
                        <!--------------------라이프------------------------>

                        <form id="RecommendedListForm" name="RecommendedListForm">
                            <input type="hidden" name="SortByRecommendationYn" id="SortByRecommendationYn" value="YY">
                            <ul class="story_wrap" id="RecommendedDataList">
<%--                                <li>--%>
<%--                                    <a href="story_detail.html">--%>
<%--                                        <div><img src="/resources/img/sample02.jpg"></div>--%>
<%--                                        <strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>--%>
<%--                                        <span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온...</span>--%>
<%--                                    </a>--%>
<%--                                    <div class="story_key">--%>
<%--                                        <a href="javascript:;">#컬처</a>--%>
<%--                                        <a href="javascript:;">#영화</a>--%>
<%--                                        <a href="javascript:;">#영화컬처</a>--%>
<%--                                        <span>1시간전</span>--%>
<%--                                        <span>공감21</span>--%>
<%--                                        <em>by gauni1229</em>--%>
<%--                                    </div>--%>
<%--                                </li>--%>
                            </ul>

                            <jsp:include page="/WEB-INF/common/include/paging.jsp">
                                <jsp:param name="form" value="#RecommendedListForm"/>
                                <jsp:param name="url" value="/story/listAsync"/>
                                <jsp:param name="listCallback" value="RecommendedListCallback"/>
                                <jsp:param name="pageNo" value="${vo.pageNo}"/>
                                <jsp:param name="listNo" value="${vo.listNo}"/>
                                <jsp:param name="pagigRange" value="${vo.pagigRange}"/>
                            </jsp:include>
                        </form>

                        <form id="defaultListForm" name="defaultListForm">
                            <input type="hidden" name="SortByRecommendationYn" id="SortByRecommendationYn" value="NN">
                            <div class="story_wrap01">
                                <ul id="defaultList">
<%--                                    <li>--%>
<%--                                        <a href="story_detail.html">--%>
<%--                                            <strong>[칼럼] 재난지원인가 빈민구휼인가?<br>[칼럼] 재난지원인가</strong>--%>
<%--                                            <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 흉년으로 ...</span>--%>
<%--                                            <img src="/resources/img/s_sample01.jpg">--%>
<%--                                        </a>--%>
<%--                                        <div class="story_key">--%>
<%--                                            <a href="javascript:;">#컬처</a>--%>
<%--                                            <a href="javascript:;">#영화</a>--%>
<%--                                            <a href="javascript:;">#영화컬처</a>--%>
<%--                                            <span>1시간전</span>--%>
<%--                                            <span>공감21</span>--%>
<%--                                            <em>by gauni1229</em>--%>
<%--                                        </div>--%>
<%--                                    </li>--%>
                                </ul>
                            </div>

                            <jsp:include page="/WEB-INF/common/include/paging.jsp">
                                <jsp:param name="form" value="#defaultListForm"/>
                                <jsp:param name="url" value="/story/listAsync"/>
                                <jsp:param name="listCallback" value="deflistCallback"/>
                                <jsp:param name="pageNo" value="${vo.pageNo}"/>
                                <jsp:param name="listNo" value="${vo.listNo}"/>
                                <jsp:param name="pagigRange" value="${vo.pagigRange}"/>
                            </jsp:include>
                        </form>

<%--                        <a href="javascript:;" class="btn_story2">더보기</a>--%>
                        <!--------------------//라이프------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------여행------------------------>
                        <a href="javascript:;" class="btn_story2">여행 내용이 들어갑니다.</a>
                        <!--------------------//여행------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------맛집------------------------>
                        <a href="javascript:;" class="btn_story2">맛집 내용이 들어갑니다.</a>
                        <!--------------------//맛집------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------문화------------------------>
                        <a href="javascript:;" class="btn_story2">문화 내용이 들어갑니다.</a>
                        <!--------------------//문화------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------연애------------------------>
                        <a href="javascript:;" class="btn_story2">연애 내용이 들어갑니다.</a>
                        <!--------------------//연애------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------IT------------------------>
                        <a href="javascript:;" class="btn_story2">IT 내용이 들어갑니다.</a>
                        <!--------------------//IT------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------게임------------------------>
                        <a href="javascript:;" class="btn_story2">게임 내용이 들어갑니다.</a>
                        <!--------------------//게임------------------------>
                    </div>

                    <div class="obj">
                        <!--------------------스포츠------------------------>
                        <a href="javascript:;" class="btn_story2">스포츠 내용이 들어갑니다.</a>
                        <!--------------------//스포츠------------------------>
                    </div>

                </div>
            </div>
            <script type="text/javascript">
                var param = "#tab_box";
                var btn = "#tab_cnt>a";
                var obj = "#tab_box .obj";
                var img = false;
                var event = "click";
                document_tab(param,btn,obj,img,event);
            </script>
            <!--//탭메뉴 끝-->

        </div>

    </div>
</div>