<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="/resources/task/js/business/management/category.js"></script>
<script type="text/javascript">
    $(document).on("ready", function () {
        const category_list = ${category_list};
        const member_category_list = ${member_category_list};

        categoryObj.init(category_list, member_category_list);
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
                                <a href="javascript:;" onclick="categoryObj.insertCategory();">카테고리 추가</a>
                                <a href="javascript:;" onclick="categoryObj.deleteCategory();">카테고리 삭제</a>
                                <a href="javascript:;" onclick="categoryObj.saveCategory();">카테고리 저장</a>
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
                                <%--<tr>
                                    <th>대표이미지</th>
                                    <td><input type="file" id="categoryImgFile"></td>
                                </tr>--%>
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
