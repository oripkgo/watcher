<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 5:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="include/header.jsp" %>
<form id="commentForm" name="commentForm">
  <div class="section uline2">
    <div class="ani-in manage_layout">
      <div class="manage_conts">
        <%@include file="include/menus.jsp" %>
        <div class="manage_box_wrap">

          <div class="new_manage_head_box">
            <div class="new_manage_title_box">
              <p class="new_manage_title">
                댓글 설정
              </p>
              <div class="new_manage_btn_and_search_box">
                <div class="new_btn_right_box">
                  <div class="btn_tb_wrap">
                    <div class="btn_tb">
                      <a href="javascript:;" class="on" onclick="settingObj.saveSettingInfo('#commentForm')">변경사항 저장</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

         <%-- <div class="review_write">
            <span>스토리의 모든 댓글은</span>
            <select id="storyCommentPublicStatus" name="storyCommentPublicStatus">
              <option value="01">공개</option>
              <option value="02">비공개</option>
            </select>
            <span>합니다.</span>
          </div>--%>

          <div class="review_write">
            <span>댓글 작성은</span>
            <select id="commentPermStatus" name="commentPermStatus">
              <option value="01">모두</option>
              <option value="02">작성자</option>
            </select>
            <span>가능합니다.</span>
          </div>
          <div class="review_write">
            <span>스토리 작성은</span>
            <select id="storyRegPermStatus" name="storyRegPermStatus">
              <option value="01">작성자</option>
              <option value="02">모두</option>
            </select>
            <span>가능합니다.</span>
          </div>
        </div><!-------------//manage_box_wrap------------->
      </div>
    </div>
  </div>
</form>

<script>
  const storySettingUpdateUrl = "/management/setting/story";

  const settingObj = {
    getManagementSetInfo : function(){
      let result = {};
      comm.request({url: storySettingUpdateUrl, method: "GET", async: false}, function (resp) {
        // 수정 성공
        if (resp.code == '0000') {
          result = JSON.parse(resp['info']);
        }
      })

      return result
    },

    saveSettingInfo: function (formId) {
      comm.request({
        url: storySettingUpdateUrl,
        method: "PUT",
        form: formId,
        // headers: {"Content-type": "application/x-www-form-urlencoded"},
      }, function (resp) {
        // 성공
        if (resp.code == '0000') {
          comm.message.alert("스토리 설정정보가 저장되었습니다.");
        }
      })
    },
  }

  $(document).on("ready", function(){
    const managementInfo = settingObj.getManagementSetInfo();
    // $("#storyCommentPublicStatus").val(managementInfo['STORY_COMMENT_PUBLIC_STATUS']);
    $("#commentPermStatus").val(managementInfo['COMMENT_PERM_STATUS']);
    $("#storyRegPermStatus").val(managementInfo['STORY_REG_PERM_STATUS']);
  })
</script>