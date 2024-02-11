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
    <a href="javascript:;" id="to_top"><img src="/resources/img/btn_top.png"></a>
</div>

<script>
    const token = window.loginNaverToken;
    const callbackUrl = window.loginNaverCallback;
    //window.signNaverSuccess = SIGN_NAVER_SUCCESS;
    comm.token.init(function(){
        comm.navigation.init(
            document.querySelector(".top_navi"),
            [
                {url: "/myStory/" + window.memberId, name: "내 스토리"},
                {url: "/management/index", name: "관리"},
                {url: window.storyUrlWrite, name: "글쓰기"},
            ],
        );

        comm.visitor.save(window.nowStoryMemId, window.refererUrl);
    });

</script>