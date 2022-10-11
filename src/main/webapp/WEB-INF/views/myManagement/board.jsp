<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    const category_list = JSON.parse('${category_list}');

    function deleteStory(){

        const checkObjs = $(".check:checked:not('.all')")
        const storyIds = [];

        checkObjs.each(function(idx,checkObj){
            const obj = $(checkObj).parents("tr").data();
            storyIds.push(obj.ID);
        })

        comm.message.confirm("선택한 스토리를 삭제하시겠습니까?",function(result){

            if( result ){

                comm.request({url:"/myManagement/articles", method : "DELETE", data : JSON.stringify({paramJson:JSON.stringify(storyIds)})},function(resp){
                    // 수정 성공
                    if( resp.code == '0000'){

                    }
                })

            }

        })

    }

    function initCheckBox(){
        $(".check").on("click",function(){
            let $this = this;

            if( $($this).hasClass("all") ){
                if( $($this).is(":checked") ){
                    $(".check").prop("checked",true)
                }else{
                    $(".check").prop("checked",false)
                }
            }

            if( $(".check:not('.all')").length == $(".check:checked:not('.all')").length ){
                $(".check.all").prop("checked",true)
            }else{
                $(".check.all").prop("checked",false)
            }

        })
    }

    function initCategory(){
        category_list.forEach(function(obj,idx){

            const id = obj['ID'];
            const nm = obj['CATEGORY_NM'];

            $('#seachCategory').append('<option value="'+id+'">'+nm+'</option>')

        })
    }

    function getTr(){
        return $('<tr></tr>').clone(true);
    }

    function getTrHead(){

        let _TrHeadStr = '';

        _TrHeadStr += '<th><input type="checkbox" class="check all"></th>';
        _TrHeadStr += '<th>카테고리</th>';
        _TrHeadStr += '<th colspan="2">';
        _TrHeadStr += '    <div class="btn_tb">';
        _TrHeadStr += '        <a href="javascript:;">삭제</a>';
        _TrHeadStr += '        <a href="javascript:;">공개</a>';
        _TrHeadStr += '        <a href="javascript:;">비공개</a>';
        _TrHeadStr += '        <a href="javascript:;">글쓰기</a>';
        _TrHeadStr += '    </div>';
        _TrHeadStr += '</th>';

        return $(getTr()).html(_TrHeadStr);

    }

    function listCallback(data){

        $("#dataList").empty();
        $("#dataList").append(getTrHead());

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((data.vo.pageNo - 1) * data.vo.listNo) + (i + 1);

            listHtml += '<td><input type="checkbox" class="check"></td>                                                                       ';
            listHtml += '<td><a href="' + getStoryViewUrl(obj.ID) + '" class="kind_link">'+obj.CATEGORY_NM+'</a></td>                         ';
            listHtml += '<td>                                                                                                   ';
            listHtml += '    <a href="' + getStoryViewUrl(obj.ID) + '" class="subject_link">                                                  ';
            listHtml += '        <strong>'+obj.TITLE+'</strong>                                                                 ';
            listHtml += '        <span>'+obj.SUMMARY+'</span>                                                                   ';
            listHtml += '    </a>                                                                                               ';
            listHtml += '    <div class="story_key">                                                                            ';

            if( obj.TAGS ){
                let tag_arr = obj.TAGS.split(',');

                tag_arr.forEach(function(tag,index){
                    listHtml += '        <a href="javascript:;">#'+tag.trim()+'</a>';
                })
            }

            listHtml += '    </div>                                                                                             ';
            listHtml += '    <div class="story_key">                                                                            ';
            listHtml += '        <span>'+comm.last_time_cal(obj.REG_DATE)+'</span>                                                                              ';
            listHtml += '        <span>공감 ' + obj.LIKE_CNT + '</span>                                                                              ';
            listHtml += '        <span>댓글 ' + obj.COMMENT_CNT + '</span>                                                                             ';
            listHtml += '    </div>                                                                                             ';
            listHtml += '</td>                                                                                                  ';
            listHtml += '<td>                                                                                                   ';
            listHtml += '    <a href="' + getStoryViewUrl(obj.ID) + '" class="pic_link">                                                      ';

            if( obj.THUMBNAIL_IMG_PATH ){
                listHtml += '<img src="'+obj.THUMBNAIL_IMG_PATH+'">';
            }else{
                listHtml += '<img src="">';
            }

            listHtml += '    </a>                                                                                               ';
            listHtml += '</td>                                                                                                  ';

            listHtml = $(getTr()).html(listHtml);
            $(listHtml).data(obj);

            $("#dataList").append(listHtml);

        }

        initCheckBox();

    }

</script>

<form id="myManagementBoardForm">
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
                        <table id="dataList">
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
                            <%--<tr>
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
                            </tr>--%>
                        </table>

                        <jsp:include page="/WEB-INF/common/include/paging.jsp">
                            <jsp:param name="form" value="#myManagementBoardForm"/>
                            <jsp:param name="url" value="/myManagement/articles"/>
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
