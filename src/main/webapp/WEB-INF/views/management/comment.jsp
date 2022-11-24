<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
    const managementInfo = JSON.parse('${managementInfo}');

    $(document).on("ready",function(){
        initManagementInfo();
    })

    function initManagementInfo(){
        $("#commentPermStatus").val(managementInfo.COMMENT_PERM_STATUS);
    }

    function saveManagementInfo(){

    }
</script>

<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <%@include file="include/commMenu.jsp"%>

            <div class="manage_box_wrap">

                <div class="sub_title01">
                    댓글 설정
                    <div class="btn_tb_wrap">
                        <div class="btn_tb">
                            <a href="javascript:;" class="on">변경사항 저장</a>
                        </div>
                    </div>
                </div>

                <div class="review_write">
                    <span>댓글 작성은</span>
                    <select id="commentPermStatus" name="commentPermStatus">
                        <option value="01">모두</option>
                        <option value="02">작성자</option>
                    </select>
                    <span>가능합니다.</span>
                </div>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>