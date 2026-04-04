<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 5:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-common.css"/>
<link rel="stylesheet" type="text/css" href="/resources/css/management-settings.css"/>

<form id="commentForm" name="commentForm">
    <div class="layout">
        <!-- 사이드바 -->
        <%@include file="include/menus.jsp" %>


        <!-- 메인 컨텐츠 -->
        <main class="main">
            <div class="settings-box">
                <h3>권한 설정</h3>
                <div class="setting-item">
                    <span>댓글 작성은 작성자만 가능</span>
                    <label class="switch">
                        <input type="checkbox" id="comment-setting">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="setting-item">
                    <span>스토리 작성은 작성자만 가능</span>
                    <label class="switch">
                        <input type="checkbox" id="story-setting">
                        <span class="slider"></span>
                    </label>
                </div>
            </div>
        </main>

    </div>
</form>

<script>
  const storySettingUpdateUrl = "/management/setting/story";
  // 스토리 작성 권한 : 전체(01), 작성자(02)
  // 댓글 작성 권한 : 전체(01), 작성자(02)

  const settingObj = {
    getManagementSetInfo: function () {
      let result = {};
      comm.request({url: storySettingUpdateUrl, method: "GET", async: false}, function (resp) {
        // 수정 성공
        if (resp.code == '0000') {
          result = JSON.parse(resp['info']);
        }
      })

      return result
    },

    saveSettingInfo: function (payload) {
      comm.request({
        url: storySettingUpdateUrl,
        method: "PUT",
        data: payload,
        // headers: {"Content-type": "application/x-www-form-urlencoded"},
      }, function (resp) {
      })
    },
  }

  $(document).on("ready", function () {
    const managementInfo = settingObj.getManagementSetInfo();
    document.querySelector('#comment-setting').checked = managementInfo['COMMENT_PERM_STATUS']
        === '02';
    document.querySelector('#story-setting').checked = managementInfo['STORY_REG_PERM_STATUS']
        === '02';

  })

  $(".switch input").on("change", function () {

    const payload = {
      storyRegPermStatus: "01",
      commentPermStatus: "01",
    };

    $(".switch input").each(function (index, input) {

      if ($(input).attr("id") === 'story-setting' && $(input).is(":checked")) {
        payload.storyRegPermStatus = '02';
      }

      if ($(input).attr("id") === 'comment-setting' && $(input).is(":checked")) {
        payload.commentPermStatus = '02';
      }

    })

    settingObj.saveSettingInfo(payload)

  })

</script>