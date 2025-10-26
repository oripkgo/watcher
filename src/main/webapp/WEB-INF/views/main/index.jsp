<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form name="mainNoticeForm" id="mainNoticeForm"></form>

<section class="hero">
    <h1>세상의 이야기를 연결하는 블로그 플랫폼</h1>
    <p>누구나 글을 쓰고, 공유하고, 발견할 수 있는 곳</p>
    <div class="btn-group">
        <a href="#">블로그 시작하기</a>
        <a href="#">인기글 보기</a>
    </div>
</section>

<!-- 검색창 -->
<div class="search-bar">
    <input type="text" placeholder="블로그 글 검색..." id="keyword"/>
    <button onclick="searchKeyword()">검색</button>
</div>

<!-- 오늘의 추천 글 -->
<div class="container">
    <section class="featured">
        <img src="https://picsum.photos/600/400?random=1" alt="추천 글">
        <div class="featured-content">
            <h2>오늘의 추천 글: AI 시대의 글쓰기</h2>
            <p>AI와 함께하는 글쓰기, 창작의 새로운 가능성에 대한 이야기입니다.</p>
            <a href="#">지금 읽기 →</a>
        </div>
    </section>
</div>

<!-- 메인 -->
<div class="container">
    <main>
        <div>

            <!-- 공지사항 -->
            <section>
                <h2>📢 공지사항</h2>
                <div class="posts-grid" id="noticeList">
                </div>
            </section>


            <!-- 인기글 -->
            <section>
                <h2>🔥 인기글</h2>
                <div class="posts-grid" id="popularStoryList">
                </div>
            </section>

            <!-- 최신글 -->
            <section>
                <h2>🆕 최신 글</h2>
                <div class="posts-grid" id="newStoryList">
                </div>
            </section>

        </div>

        <!-- 사이드바 -->
        <aside class="sidebar">
            <%--<section>
                <h3>🌟 추천 블로거</h3>
                <div class="blogger">
                    <img src="https://picsum.photos/40/40?random=7" alt="User">
                    <span>코딩하는길동</span>
                    <button>팔로우</button>
                </div>
                <div class="blogger">
                    <img src="https://picsum.photos/40/40?random=8" alt="User">
                    <span>여행하는영희</span>
                    <button>팔로우</button>
                </div>
            </section>--%>

            <section>
                <h3># 인기 태그</h3>
                <div class="tags" id="popularKeywordList">
                    <%--<a href="#">#코딩</a>
                    <a href="#">#디자인</a>
                    <a href="#">#여행</a>
                    <a href="#">#음식</a>
                    <a href="#">#일상</a>--%>
                </div>
            </section>
        </aside>
    </main>
</div>

<script type="text/javascript" src="/resources/task/js/main/notice.js"></script>
<script type="text/javascript" src="/resources/task/js/main/story.js"></script>
<script type="text/javascript" src="/resources/task/js/main/keyword.js"></script>
<script type="text/javascript" src="/resources/task/js/main/category.js"></script>

<script type="text/javascript">

   function searchKeyword(){
        const keyword = $("#keyword").val();
       location.href="/story/list?searchKeyword="+keyword;
   }

    notice.init();
    story.init();
    keyword.init();

</script>