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

    document.addEventListener('DOMContentLoaded', () => {
        document.getElementById('year').textContent = new Date().getFullYear();

        const authDiv = document.getElementById('auth');

        // 로그인 버튼 클릭 시
        authDiv.addEventListener('click', (e) => {
            if (e.target.id === 'loginBtn') {
                authDiv.innerHTML = `
                <div class="profile-container">
                  <div class="profile-wrapper">
                    <img src="https://i.pravatar.cc/100" alt="프로필 이미지" class="profile-img" id="profileImg" />
                  </div>
                  <ul class="profile-menu" id="profileMenu">
                    <li><a href="#">내 스토리</a></li>
                    <li><a href="#">스토리 관리하기</a></li>
                    <li><a href="#">글쓰기</a></li>
                    <li><a href="#" id="logoutBtn">로그아웃</a></li>
                  </ul>
                </div>
                `;

                const profileImg = document.getElementById('profileImg');
                const profileMenu = document.getElementById('profileMenu');
                const logoutBtn = document.getElementById('logoutBtn');

                profileImg.addEventListener('click', () => {
                    profileMenu.style.display = profileMenu.style.display === 'block' ? 'none' : 'block';
                });

                // 화면 어딘가 클릭 시 프로필 메뉴 닫기
                document.addEventListener('click', (evt) => {
                    if (!evt.target.closest('.profile-container')) {
                        profileMenu.style.display = 'none';
                    }
                });

                logoutBtn.addEventListener('click', (evt) => {
                    evt.preventDefault();
                    authDiv.innerHTML = `<button id="loginBtn">로그인</button>`;
                });
            }
        });
    });
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
                {url: window.storyUrlWrite + '?referrerPage='+encodeURIComponent(globalObj.getManagementBoard()), name: "글쓰기"},
            ],
            comm.sign
        );
    });


</script>