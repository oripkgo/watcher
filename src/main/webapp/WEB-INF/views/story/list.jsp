<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    const category_list = JSON.parse('${category_list}');
    const pageNo = '${vo.pageNo}' || '1';
    const listNo = '${vo.listNo}' || '1';
    const pagigRange = '${vo.pagigRange}' || '1';
    const listUrl = '/story/list/data';

    $(document).on('ready',function(){
        initKeywordSearch();
        initCategory();
    })

    function initCategory(){
        category_list.forEach(function(obj,idx){
            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            $('#seachCategory').append('<option value="'+id+'">'+nm+'</option>')

            if( idx == 0 ){
                $('.category_tab').append('<a href="javascript:;" class="tab_ov tab_'+id+'"><span>'+nm+'</span></a>');
            }else{
                $('.category_tab').append('<a href="javascript:;" class="tab_'+id+'"><span>'+nm+'</span></a>');
            }

            const tabObj = append_tab(id, $("#tab_parent"));
            $(tabObj).html(draw_tags_in_tabs(id));

            tab_event();

            // 추천순 목록
            recommendedList(id);

            // 기본 목록
            defaultList(id);
        })
    }

    function initKeywordSearch(){
        $("#search").on("click", function () {
            let id = $("#seachCategory").val();

            if (!id) {
                comm.message.alert("카테고리를 선택해주세요.",function(){
                    $("#seachCategory").focus();
                });
                return;

                // if (category_list.length > 0) {
                //     id = category_list[0]['ID'];
                // }
            }

            let keyword = $("#searchForm").find("#keyword").val();

            comm.appendInput($('#defaultListForm' + id), 'search_keyword', keyword);
            comm.appendInput($('#defaultListForm' + id), 'search_keyword', keyword);

            // 기본 목록
            defaultList(id, function(){
                $(".tab_"+id).click();
            });
        })

        $("#keyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                $("#search").click();
                return false;
            }
        });
    }

    function tab_event(){
        var param = "#tab_box";
        var btn = "#tab_cnt>a";
        var obj = "#tab_box .obj";
        var img = false;
        var event = "click";
        document_tab(param,btn,obj,img,event);
    }

    function recommendedList(id){
        comm.request({
            form:$("#RecommendedListForm"+id)
            , url:listUrl
            , method : "GET"
            , headers : {"Content-type":"application/x-www-form-urlencoded"}
        },function(data){
            $("#RecommendedDataList"+id).empty();

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];
                let listHtml = '';
                let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

                listHtml += '<li>';
                listHtml += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '">';

                if( obj.THUMBNAIL_IMG_PATH ){
                    listHtml += '<div><img src="'+obj.THUMBNAIL_IMG_PATH.replace(/[\\]/g,'/')+'"></div>';
                }

                listHtml += '        <strong>'+obj.TITLE+'</strong>';
                listHtml += '        <span>';

                if( !obj.SUMMARY ){
                    obj.SUMMARY = '';
                }

                if( obj.SUMMARY.length < 100 ){
                    listHtml += obj.SUMMARY;
                }else{
                    listHtml += (obj.SUMMARY || '').substring(0,100)+' ...';
                }

                listHtml += '        </span>';
                listHtml += '    </a>';
                listHtml += '    <div class="story_key">';

                if( obj.TAGS ){
                    let tag_arr = obj.TAGS.split(',');

                    tag_arr.forEach(function(tag,index){
                        listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                    })
                }
                listHtml += '    </div>';
                listHtml += '    <div class="story_key">';

                listHtml += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>';
                listHtml += '        <span>공감 ' + obj.LIKE_CNT + '</span>';
                listHtml += '        <em>by ' + obj.NICKNAME + '</em>';


                // listHtml += '        <a href="javascript:;">#컬처</a>';
                // listHtml += '        <a href="javascript:;">#영화</a>';
                // listHtml += '        <a href="javascript:;">#영화컬처</a>';
                listHtml += '    </div>';
                listHtml += '</li>';
                listHtml = $(listHtml);

                $(listHtml).data(obj);

                $("#RecommendedDataList"+id).append(listHtml);
            }
        });
    }

    function defaultList(id, callback){
        comm.list('#defaultListForm'+id, listUrl,function(data){
            $("#defaultList"+id).empty();

            for (let i = 0; i < data.list.length; i++) {
                let obj = data.list[i];
                let listHtml = '';
                let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

                listHtml += '<li>';
                listHtml += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '">';
                listHtml += '        <strong>'+obj.TITLE+'</strong>';

                listHtml += '        <span>';
                if( !obj.SUMMARY ){
                    obj.SUMMARY = '';
                }

                if( obj.SUMMARY.length < 100 ){
                    listHtml += obj.SUMMARY;
                }else{
                    listHtml += (obj.SUMMARY || '').substring(0,100)+' ...';
                }

                listHtml += '</span>';

                if( obj.THUMBNAIL_IMG_PATH ){
                    listHtml += '        <img src="'+obj.THUMBNAIL_IMG_PATH+'">';
                }

                listHtml += '    </a>';
                listHtml += '    <div class="story_key">';

                if( obj.TAGS ){
                    let tag_arr = obj.TAGS.split(',');

                    tag_arr.forEach(function(tag,index){
                        listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                    })
                }

                listHtml += '    </div>';
                listHtml += '    <div class="story_key">';
                // listHtml += '        <a href="javascript:;">#컬처</a>';
                // listHtml += '        <a href="javascript:;">#영화</a>';
                // listHtml += '        <a href="javascript:;">#영화컬처</a>';
                listHtml += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>';
                listHtml += '        <span>공감 ' + obj.LIKE_CNT + '</span>';
                listHtml += '        <em>by ' + obj.NICKNAME + '</em>';
                listHtml += '    </div>';
                listHtml += '</li>';
                listHtml += '';

                listHtml = $(listHtml);

                $(listHtml).data(obj);

                $("#defaultList"+id).append(listHtml);
            }

            if( callback ){
                callback();
            }
        }, pageNo, listNo, pagigRange);
    }


    function append_tab(id,target){
        let tabId = 'tabObj_'+id;
        let tabHtml = '';

        tabHtml += '<div class="obj" id="'+tabId+'">';
        tabHtml += '<a href="javascript:;" class="btn_story2"></a>';
        tabHtml += '</div>';

        $(target).append(tabHtml);

        return $("#"+tabId, target);
    }

    function draw_tags_in_tabs(id){
        let div = $('<div></div>')
        let recommendedListForm = comm.appendForm('RecommendedListForm'+id);
        let defaultListForm = comm.appendForm('defaultListForm'+id);

        comm.appendInput(recommendedListForm, "SortByRecommendationYn", "YY", true);
        comm.appendInput(recommendedListForm, "search_category_id", id, true);
        comm.appendInput(recommendedListForm, "limitNum", "3", true);
        $(recommendedListForm).append('<ul class="story_wrap" id="RecommendedDataList'+id+'"></ul>')

        comm.appendInput(defaultListForm, "SortByRecommendationYn", "NN", true);
        comm.appendInput(defaultListForm, "search_category_id", id, true);
        $(defaultListForm).append('<div class="story_wrap01"><ul id="defaultList'+id+'"></ul></div>');
        $(defaultListForm).append('<div class="pagging_wrap"></div>');

        $(div).append(recommendedListForm);
        $(div).append(defaultListForm);

        return $(div).html();
    }


    function RecommendedListCallback(data){
        $("#RecommendedDataList").empty();

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listNum += '<li>';
            listNum += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '">';
            listNum += '        <div><img src="'+obj.THUMBNAIL_IMG_PATH+'"></div>';
            listNum += '        <strong>'+obj.TITLE+'</strong>';

            if( obj.SUMMARY.length < 100 ){
                listNum += '        <span>'+(obj.SUMMARY || '')+'</span>';
            }else{
                listNum += '        <span>'+(obj.SUMMARY || '').substring(0,100)+' ...</span>';
            }

            listNum += '    </a>';
            listNum += '    <div class="story_key">';

            if( obj.TAGS ){
                let tag_arr = obj.TAGS.split(',');

                tag_arr.forEach(function(tag,index){
                    listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                })
            }

            listNum += '    </div>';
            listNum += '    <div class="story_key">';

            listNum += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>';
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
            listNum += '    <a href="' + getStoryViewUrl(obj['ID'], obj['MEMBER_ID']) + '">';
            listNum += '        <strong>'+obj.TITLE+'</strong>';

            if( obj.SUMMARY.length < 100 ){
                listNum += '        <span>'+(obj.SUMMARY || '')+'</span>';
            }else{
                listNum += '        <span>'+(obj.SUMMARY || '').substring(0,100)+' ...</span>';
            }


            listNum += '        <img src="'+obj.THUMBNAIL_IMG_PATH+'">';
            listNum += '    </a>';
            listNum += '    <div class="story_key">';

            if( obj.TAGS ){
                let tag_arr = obj.TAGS.split(',');

                tag_arr.forEach(function(tag,index){
                    listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                })
            }
            listNum += '    </div>';
            listNum += '    <div class="story_key">';
            // listNum += '        <a href="javascript:;">#컬처</a>';
            // listNum += '        <a href="javascript:;">#영화</a>';
            // listNum += '        <a href="javascript:;">#영화컬처</a>';
            listNum += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>';
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
            <form name="searchForm" id="searchForm">
                <div class="story_search">
                        <select id="seachCategory">
                            <option value="">카테고리</option>
        <%--                    <c:if test="${ !((empty category_list) || fn:length(category_list) == 0) }">--%>
        <%--                        <c:forEach var="obj" items="${category_list}" varStatus="status">--%>
        <%--                            <option value="${obj.ID}">${obj.CATEGORY_NM}</option>--%>
        <%--                        </c:forEach>--%>
        <%--                    </c:if>--%>
                        </select>
                        <input type="text" id="keyword" placeholder="키워드 입력">
                    <a href="javascript:;" id="search"><img src="/resources/img/btn_search_b.png"></a>
                </div>
            </form>
        </div>

    </div>
</div>


<div class="section">
    <div class="ani-in layout">

        <div class="tab_wrap ani_y delay2">
            <!--탭메뉴-->
            <div id="tab_box">
                <div id="tab_cnt" class="category_tab">
<%--                    <c:if test="${ !((empty category_list) || fn:length(category_list) == 0) }">--%>
<%--                        <c:forEach var="obj" items="${category_list}" varStatus="status">--%>
<%--                            <c:choose>--%>
<%--                                <c:when test="${status.index == 0}">--%>
<%--                                    <a href="javascript:;" class="tab_ov"><span>${obj.CATEGORY_NM}</span></a>--%>
<%--                                </c:when>--%>
<%--                                <c:otherwise>--%>
<%--                                    <a href="javascript:;"><span>${obj.CATEGORY_NM}</span></a>--%>
<%--                                </c:otherwise>--%>
<%--                            </c:choose>--%>
<%--                        </c:forEach>--%>
<%--                    </c:if>--%>
                </div>
                <div class="grap" id="tab_parent">
<%--                    <div class="obj">--%>
<%--                        <!--------------------라이프------------------------>--%>

<%--                        <form id="RecommendedListForm" name="RecommendedListForm">--%>
<%--                            <input type="hidden" name="SortByRecommendationYn" value="YY">--%>
<%--                            <input type="hidden" name="limitNum" value="3">--%>

<%--                            <ul class="story_wrap" id="RecommendedDataList">--%>
<%--&lt;%&ndash;                                <li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <a href="story_detail.html">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div><img src="/resources/img/sample02.jpg"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온...</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="story_key">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <a href="javascript:;">#컬처</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <a href="javascript:;">#영화</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <a href="javascript:;">#영화컬처</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <span>1시간전</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <span>공감21</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <em>by gauni1229</em>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </li>&ndash;%&gt;--%>
<%--                            </ul>--%>

<%--                            <jsp:include page="/WEB-INF/common/include/paging.jsp">--%>
<%--                                <jsp:param name="form" value="#RecommendedListForm"/>--%>
<%--                                <jsp:param name="url" value="/story/list/data"/>--%>
<%--                                <jsp:param name="listCallback" value="RecommendedListCallback"/>--%>
<%--                                <jsp:param name="pageNo" value="${vo.pageNo}"/>--%>
<%--                                <jsp:param name="listNo" value="${vo.listNo}"/>--%>
<%--                                <jsp:param name="pagigRange" value="${vo.pagigRange}"/>--%>
<%--                            </jsp:include>--%>
<%--                        </form>--%>

<%--                        <form id="defaultListForm" name="defaultListForm">--%>
<%--                            <input type="hidden" name="SortByRecommendationYn" value="NN">--%>
<%--                            <div class="story_wrap01">--%>
<%--                                <ul id="defaultList">--%>
<%--&lt;%&ndash;                                    <li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <a href="story_detail.html">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <strong>[칼럼] 재난지원인가 빈민구휼인가?<br>[칼럼] 재난지원인가</strong>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <span>18세기 조선에서는 큰 역병이 돌았다. 1783년에는 돌림병 1786에는 전국적으로 대홍역이 돌아 조선사회는 큰 충격에 휩싸였다. 흉년으로 ...</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <img src="/resources/img/s_sample01.jpg">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="story_key">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <a href="javascript:;">#컬처</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <a href="javascript:;">#영화</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <a href="javascript:;">#영화컬처</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <span>1시간전</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <span>공감21</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <em>by gauni1229</em>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </li>&ndash;%&gt;--%>
<%--                                </ul>--%>
<%--                            </div>--%>

<%--                            <jsp:include page="/WEB-INF/common/include/paging.jsp">--%>
<%--                                <jsp:param name="form" value="#defaultListForm"/>--%>
<%--                                <jsp:param name="url" value="/story/list/data"/>--%>
<%--                                <jsp:param name="listCallback" value="deflistCallback"/>--%>
<%--                                <jsp:param name="pageNo" value="${vo.pageNo}"/>--%>
<%--                                <jsp:param name="listNo" value="${vo.listNo}"/>--%>
<%--                                <jsp:param name="pagigRange" value="${vo.pagigRange}"/>--%>
<%--                            </jsp:include>--%>
<%--                        </form>--%>

<%--&lt;%&ndash;                        <a href="javascript:;" class="btn_story2">더보기</a>&ndash;%&gt;--%>
<%--                        <!--------------------//라이프------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------여행------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">여행 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//여행------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------맛집------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">맛집 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//맛집------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------문화------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">문화 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//문화------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------연애------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">연애 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//연애------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------IT------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">IT 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//IT------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------게임------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">게임 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//게임------------------------>--%>
<%--                    </div>--%>

<%--                    <div class="obj">--%>
<%--                        <!--------------------스포츠------------------------>--%>
<%--                        <a href="javascript:;" class="btn_story2">스포츠 내용이 들어갑니다.</a>--%>
<%--                        <!--------------------//스포츠------------------------>--%>
<%--                    </div>--%>

                </div>
            </div>
            <!--//탭메뉴 끝-->

        </div>

    </div>
</div>