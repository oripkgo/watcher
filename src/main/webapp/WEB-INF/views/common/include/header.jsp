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

<header>
    <div class="logo" onclick="location.href='/main'">Watcher</div>

    <nav class="nav">
        <ul class="menu">
            <li><a href="/notice/list">공지사항</a></li>
            <li><a href="/story/list">스토리</a></li>
        </ul>
    </nav>

    <div class="hamburger" onclick="toggleMenu()">☰</div>
    <div class="auth top_navi" id="auth"></div>

</header>


<script>

    const sessionExceededYn = '${sessionExceededYn}';
    const token = window.loginNaverToken;
    const callbackUrl = window.loginNaverCallback;

    //window.signNaverSuccess = SIGN_NAVER_SUCCESS;


    function toggleMenu() {
        const menu = document.querySelector('.menu');

        if (menu.classList.contains('open')) {
            // 닫기: max-height 0으로
            menu.style.maxHeight = menu.scrollHeight + 'px'; // 먼저 설정
            requestAnimationFrame(() => {
                menu.style.maxHeight = null;
                menu.classList.remove('open');
            });
        } else {
            // 열기: max-height 값 지정
            menu.style.maxHeight = menu.scrollHeight + 'px';
            menu.classList.add('open');

            // 애니메이션 후 auto로 설정 (안해도 되지만 깔끔)
            menu.addEventListener('transitionend', function handler() {
                menu.style.maxHeight = 'none';
                menu.removeEventListener('transitionend', handler);
            });
        }
    }

</script>


<script>


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
                {
                    url: window.storyUrlWrite + '?referrerPage=' + encodeURIComponent(globalObj.getManagementBoard()),
                    name: "글쓰기"
                },
            ],
            comm.sign
        );
    });


</script>