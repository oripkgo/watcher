<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 5:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-settings.css"/>

<div class="layout">
    <!-- 사이드바 -->
    <%@include file="include/menus.jsp" %>

    <!-- 메인 컨텐츠 -->
    <main class="main">
        <!-- 검색/필터 -->
        <div class="filter-box">
            <input type="text" placeholder="제목/내용 검색">
            <select>
                <option>공개 여부</option>
                <option>공개</option>
                <option>비공개</option>
            </select>
            <select>
                <option>카테고리 전체</option>
                <option>개발</option>
                <option>여행</option>
            </select>
            <button>검색</button>
        </div>

        <!-- 일괄 작업 -->
        <div class="bulk-actions">
            <label><input type="checkbox"> 전체 선택</label>
            <button>공개</button>
            <button>비공개</button>
            <button>삭제</button>
            <button>카테고리 변경</button>
            <button style="background:#286BB7;color:#fff;border:none;">+ 새 글 작성</button>
        </div>

        <!-- 게시글 목록 -->
        <div class="posts">
            <h3>전체 게시글</h3>
            <ul class="post-list">
                <li class="post-item">
                    <input type="checkbox">
                    <div class="post-info">
                        <a href="#">React 블로그 만들기</a>
                        <div class="post-meta">공개 · 개발 · 일반회원 · 조회수 1,230 · 댓글 15 · 좋아요 45 ·
                            2025-09-10
                        </div>
                    </div>
                    <div class="post-thumb"><img src="https://placekitten.com/80/60" alt="썸네일">
                    </div>
                </li>
                <li class="post-item">
                    <input type="checkbox">
                    <div class="post-info">
                        <a href="#">AWS 비용 최적화 경험담</a>
                        <div class="post-meta">비공개 · 개발 · 프리미엄회원 · 조회수 980 · 댓글 8 · 좋아요 30 ·
                            2025-09-05
                        </div>
                    </div>
                    <div class="post-thumb"></div>
                </li>
            </ul>
        </div>
    </main>
</div>


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
                                            <a href="javascript:;"
                                               onclick="settingObj.saveSettingInfo('#commentForm')">변경사항
                                                저장</a>
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

  $(document).on("ready", function () {
    const managementInfo = settingObj.getManagementSetInfo();
    // $("#storyCommentPublicStatus").val(managementInfo['STORY_COMMENT_PUBLIC_STATUS']);
    $("#commentPermStatus").val(managementInfo['COMMENT_PERM_STATUS']);
    $("#storyRegPermStatus").val(managementInfo['STORY_REG_PERM_STATUS']);
  })
</script>