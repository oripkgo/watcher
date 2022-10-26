<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    const categListSpaceNm = "category_left";
    const categListNm = "category_1st";
    const categSelectNm = "categorySelect";
    const category_list = ${category_list};
    const member_category_list = ${member_category_list};

    function getCategoryTagObj(){
        return $('<a href="javascript:;" class="'+categListNm+'"></a>');
    }

    function getSelectCategoryOptionObj(){
        return $('<option></option>');
    }

    function setSelectCategory(target){
        category_list.forEach(function(obj,idx){
            const option = getSelectCategoryOptionObj();

            $(option).text(obj.CATEGORY_NM);
            $(option).attr("value", obj.ID);

            $(option).data(obj);
            $(target).append(option);
        })
    }

    function setCategory(target){
        member_category_list.forEach(function(obj,idx){
            const category = getCategoryTagObj();

            $(category).text(obj.CATEGORY_NM);

            $(category).data(obj);
            $(target).append(category);
        })
    }

    function makeEventClick(target, callback){
        $(target).off("click").on("click", callback)
    }

    function initCategory(){
        setSelectCategory("." + categSelectNm);
        setCategory("." + categListSpaceNm);

        makeEventClick($("." + categListNm, "." + categListSpaceNm), function(e){
            const thisData = $(this).data();



        })
    }

    $(document).on("ready", function () {
        initCategory();
    });
</script>


<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <%@include file="include/commMenu.jsp"%>

            <div class="manage_box_wrap">

                <div class="sub_title01">
                    카테고리
                    <div class="btn_tb_wrap">
                        <div class="btn_tb">
                            <a href="javascript:;">카테고리 추가</a>
                            <a href="javascript:;">카테고리 삭제</a>
                            <a href="javascript:;">카테고리 저장</a>
                        </div>
                    </div>
                </div>

                <div class="category_wrap">

                    <div class="category_left">
                        <a href="javascript:;" class="category_list">카테고리 목록</a>
                    </div>

                    <div class="category_right">
                        <table>
                            <tr>
                                <th>카테고리명</th>
                                <td><input type="text"></td>
                            </tr>
                            <tr>
                                <th>주제</th>
                                <td>
                                    <select id="category" name="category" class="categorySelect">
                                        <option>선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>대표이미지</th>
                                <td><input type="file"></td>
                            </tr>
                            <tr>
                                <th>공개여부</th>
                                <td>
                                    <input type="radio" name="open" id="open01"><label for="open01">공개</label>&nbsp;&nbsp;
                                    <input type="radio" name="open" id="open02"><label for="open02">비공개</label>
                                </td>
                            </tr>
                            <tr>
                                <th>카테고리 소개</th>
                                <td><textarea></textarea></td>
                            </tr>
                        </table>
                    </div>

                </div>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>