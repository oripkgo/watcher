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
    const field_names = {
        title: "categoryNm",
        topic: "defalutCategId",
        file: "representativeImage",
        secret: "showYn",
        explanation: "categoryComents",
    };

    const formId = '#managementCategoryForm';

    function getCategoryTagObj(){
        return $('<a href="javascript:;" class="'+categListNm+'"></a>');
    }

    function getSelectCategoryOptionObj(){
        return $('<option></option>');
    }

    function setSelectCategory(){
        category_list.forEach(function(obj,idx){
            const option = getSelectCategoryOptionObj();

            $(option).text(obj.CATEGORY_NM);
            $(option).attr("value", obj.ID);

            $(option).data(obj);
            $("." + categSelectNm).append(option);
        })
    }

    function setCategoryList(){
        member_category_list.forEach(function(obj,idx){
            const category = getCategoryTagObj();

            $(category).text(obj.CATEGORY_NM);

            $(category).data(obj);
            $("." + categListSpaceNm).append(category);
        })
    }

    function makeEventClick(target, callback){
        $(target).off("click").on("click", callback)
    }

    function setCategoryInfoInField(data){
        $("#categoryNm").val(data.CATEGORY_NM);
        $("#categoryComents").val(data.CATEGORY_COMENTS);
        $("#defalutCategId").val(data.DEFALUT_CATEG_ID);
        $("[name='showYn'][value='"+data.SHOW_YN+"']").prop("checked",true);
    }

    function applyCategoryEvents(){
        $("." + categListNm, "." + categListSpaceNm).off("click").on("click", function(e){
            if ($("." + categListNm+".on", "." + categListSpaceNm).length > 0 && comm.validation(formId)) {
                return
            }

            const thisData = $(this).data();
            enableFields();
            setCategoryInfoInField(thisData);

            $("." + categListNm, "." + categListSpaceNm).removeClass("on");
            $(this).addClass("on");
        })
    }

    function initCategory(){
        setSelectCategory();
        setCategoryList();
        applyCategoryEvents();
    }

    function applyEventCategoryInfoFields(){
        $("#categoryNm").on("keyup", function (e) {
            $("." + categListNm+".on", "." + categListSpaceNm).text($(this).val());
        })

        $("select, input, textarea", "#fieldsObj").on("blur", function () {
            let category_nm = $("#categoryNm").val();
            let category_coments = $("#categoryComents").val();
            let defalut_categ_id = $("#defalutCategId").val();
            let show_yn = $("[name='showYn']:checked").val();

            const data = $("." + categListNm+".on", "." + categListSpaceNm).data();
            data.CATEGORY_NM = category_nm;
            data.CATEGORY_COMENTS = category_coments;
            data.DEFALUT_CATEG_ID = defalut_categ_id;
            data.SHOW_YN = show_yn;

            $("." + categListNm+".on", "." + categListSpaceNm).data(data);
        })
    }

    function initFields(){
        disableFields();
        applyEventCategoryInfoFields();
    }

    function disableFields(){
        $("select, input, textarea", "#fieldsObj").prop("disabled", true);
    }

    function enableFields(){
        $("select, input, textarea", "#fieldsObj").prop("disabled", false);
    }

    function insertCategory(){
        if ($("." + categListNm+".on", "." + categListSpaceNm).length > 0 && comm.validation(formId)) {
            return
        }

        let obj = getCategoryTagObj();
        $("#fieldsObj .category_left").append(obj)
        applyCategoryEvents();
        $(obj).click();

        $("#categoryNm").focus();
    }

    function deleteCategory(){
        if( $("." + categListNm+".on", "." + categListSpaceNm).length <= 0 ){
            comm.message.alert("선택된 카테고리가 없습니다.");
            return;
        }

        if( $('.category_1st').length == 1 ){
            comm.message.alert("카테고리 더이상 삭제할수 없습니다.");
            return;
        }

        comm.message.confirm("선택한 카테고리를 삭제하시겠습니까?",function(result){
            if( result ){
                $("." + categListNm+".on", "." + categListSpaceNm).remove();
            }
        });
    }
    function getIdx(obj){
        return $("#fieldsObj .category_left").find(".category_1st").index(obj);
    }

    function saveCategory(){
        if( isCategoryListCheck() ){
            return;
        }

        comm.message.confirm("카테고리를 저장하시겠습니까?",function(result){
            if( result ){

            }
        });
    }

    function isCategoryListCheck(){
        let checkVal = false;
        $('.category_1st').each(function(obj){
            const thisObj = $(this);
            const data = $(thisObj).data();

            if( checkVal )
                return;

            if( (!data['CATEGORY_NM']) || !(data['DEFALUT_CATEG_ID']) ){
                checkVal = true;

                $(thisObj).click();

                if( !(data['CATEGORY_NM']) ){
                    comm.message.alert("카테고리 이름을 입력해주세요.");
                    $("#categoryNm").focus();
                    return;
                }

                if( !(data['DEFALUT_CATEG_ID']) ){
                    comm.message.alert("카테고리 주제를 선택해주세요.");
                    $("#defalutCategId").focus();
                    return;
                }
            }
        })

        return checkVal;
    }

    $(document).on("ready", function () {
        initCategory();
        initFields();
    });
</script>

<form id="managementCategoryForm">
    <div class="section uline2">
        <div class="ani-in manage_layout">

            <div class="manage_conts">

                <%@include file="include/commMenu.jsp"%>

                <div class="manage_box_wrap">

                    <div class="sub_title01">
                        카테고리
                        <div class="btn_tb_wrap">
                            <div class="btn_tb">
                                <a href="javascript:;" onclick="insertCategory();">카테고리 추가</a>
                                <a href="javascript:;" onclick="deleteCategory();">카테고리 삭제</a>
                                <a href="javascript:;">카테고리 저장</a>
                            </div>
                        </div>
                    </div>

                    <div class="category_wrap" id="fieldsObj">
                        <div class="category_left">
                            <a href="javascript:;" class="category_list">카테고리 목록</a>
                        </div>

                        <div class="category_right">
                            <table>
                                <tr>
                                    <th>카테고리명</th>
                                    <td><input type="text" id="categoryNm" name="categoryNm" checkYn="Y" title="카테고리명"></td>
                                </tr>
                                <tr>
                                    <th>주제</th>
                                    <td>
                                        <select id="defalutCategId" name="defalutCategId" class="categorySelect" checkYn="Y" title="카테고리 주제">
                                            <option value="" selected>선택</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>대표이미지</th>
                                    <td><input type="file" id="categoryImgFile"></td>
                                </tr>
                                <tr>
                                    <th>공개여부</th>
                                    <td>
                                        <input type="radio" name="showYn" id="showYn01" value="Y" checked><label for="showYn01">공개</label>&nbsp;&nbsp;
                                        <input type="radio" name="showYn" id="showYn02" value="N"><label for="showYn02">비공개</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>카테고리 소개</th>
                                    <td><textarea id="categoryComents" name="categoryComents"></textarea></td>
                                </tr>
                            </table>
                        </div>

                    </div>

                </div><!-------------//manage_box_wrap------------->

            </div>

        </div>
    </div>
</form>
