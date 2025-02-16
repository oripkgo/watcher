<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-01-01
  Time: 오후 3:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="head_wrap">
    <div class="logo">
        <a href="/main">WATCHER</a>
    </div>
    <div class="menu_wrap">
        <a href="/story/list">STORY</a>
        <a href="/notice/list">NOTICE</a>
    </div>
    <div class="top_navi">
        

        <!--      <a v-if="loginInfo.isLogin" href="javascript:;" class="member_set logout">
                <img v-if="loginInfo.memProfileImg" :src="loginInfo.memProfileImg">
                <img v-else src="@/img/member_ico_b.png">
              </a>
              <a v-else href="javascript:;" class="btn_start loginStart">시작하기</a>-->
    </div>

</div>
<div class="head_tip"></div>

<div class="quick_wrap">
    <a id="to_top" href="#none;">▲</a>
<%--    <a href="javascript:;" id="to_top"><img src="/resources/img/btn_top.png"></a>--%>
</div>

<script>

    const sessionExceededYn = '${sessionExceededYn}';
    const token = window.loginNaverToken;
    const callbackUrl = window.loginNaverCallback;
    //window.signNaverSuccess = SIGN_NAVER_SUCCESS;
    comm.token.init(function () {
        comm.visitor.save(window.nowStoryMemId, window.refererUrl);
        // 세션시간 초과 && 클라이언트에서 로그인상태인 경우
        if (comm.sign.isLogin() && sessionExceededYn == 'Y') {
            comm.sign.out();
        }

        comm.navigation.init(
            document.querySelector(".top_navi"),
            [
                {url: "/my-story/" + window.memberId, name: "내 스토리"},
                {url: "/management/index", name: "관리"},
                {url: window.storyUrlWrite + '?referrerPage='+encodeURIComponent(globalObj.getManagementBoard()), name: "글쓰기"},
            ],
            comm.sign
        );
    });


</script>