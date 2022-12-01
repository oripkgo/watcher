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

    function saveSettingInfo(){
        comm.request({
            url:"/management/setting/update",
            method : "PUT",
            form : $("#commentForm"),
            headers: {"Content-type": "application/x-www-form-urlencoded"},
        },function(resp){
            // 성공
            if( resp.code == '0000'){
                comm.message.alert("스토리 설정정보가 저장되었습니다.");
            }
        })
    }
</script>
<form id="commentForm" name="commentForm">
    <div class="section uline2">
        <div class="ani-in manage_layout">
            <div class="manage_conts">
                <%@include file="include/commMenu.jsp"%>
                <div class="manage_box_wrap">
                    <div class="sub_title01">
                        댓글 설정
                        <div class="btn_tb_wrap">
                            <div class="btn_tb">
                                <a href="javascript:;" class="on" onclick="saveSettingInfo()">변경사항 저장</a>
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
</form>
