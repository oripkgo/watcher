<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

			<c:choose>
				<c:when test="${!empty sessionScope.loginInfo}">

					<c:choose>
						<c:when test="${!empty sessionScope.loginInfo.MEM_PROFILE_IMG }">
							<a href="javascript:;" class="member_set logOut"><img src="${sessionScope.loginInfo.MEM_PROFILE_IMG}"></a>
						</c:when>
						<c:otherwise>
							<a href="javascript:;" class="member_set logOut"><img src="/resources/img/member_ico_b.png"></a>
						</c:otherwise>
					</c:choose>

					<%--<div class="member_app logOut" style="display: none;">
						<a href="javascript:;" id="myStory">내 스토리</a>
						<a href="javascript:;" id="management">관리</a>
						<a href="javascript:;" id="writing">글쓰기</a>
						<a href="javascript:;" id="logout">로그아웃</a>
					</div>--%>

					<a href="javascript:;" class="btn_start loginStart" style="display: none;">시작하기</a>
				</c:when>
				<c:otherwise>

					<a href="javascript:;" class="member_set logOut" style="display: none;"><img src="/resources/img/member_ico_b.png"></a>

					<%--<div class="member_app logOut" style="display: none;">
						<a href="javascript:;" id="myStory">내 스토리</a>
						<a href="javascript:;" id="management">관리</a>
						<a href="javascript:;" id="writing">글쓰기</a>
						<a href="javascript:;" id="logout">로그아웃</a>
					</div>--%>

					<a href="javascript:;" class="btn_start loginStart">시작하기</a>

				</c:otherwise>
			</c:choose>


		<a href="javascript:;"><img src="/resources/img/btn_search.png"></a>
	</div>
</div>
<div class="head_tip"></div>

<div class="quick_wrap">
	<a href="javascript:;" id="to_top"><img src="/resources/img/btn_top.png"></a>
</div>

<script type="text/javascript">

	comm.loginObj.init(loginType);
	comm.loginObj.kakaoInit(Kakao);
	comm.loginObj.naverInit(naver_id_login);

</script>