<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="/WEB-INF/common/include/comIncludeJsp.jsp" %> 

<div class="loginArea translate50">
	<h1>전자결재에 오신 것을 환영합니다.</h1>

	<div class="loginInfoWrap clearFix">
		<p class="pic"><img src="resources/assets/images/common/login_person.png" alt=""></p>

		<div class="loginInfo">
			<div class="inner">
				<label for="id01">ID</label>
				<input type="text" id="id01" maxlength="12" placeholder="아이디를 입력하세요">
			</div>

			<div class="inner">
				<label for="pwd01">PASSWORD</label>
				<input type="password" id="pwd01" maxlength="12" placeholder="비밀번호를 입력하세요">
			</div>

			<div class="inner">
				<input type="checkbox" name="sa" id="sa">
				<label for="sa">아이디저장</label>
			</div>
		</div>
		<!-- EOD : loginInfo -->

		<button type="button" id="btn01">LOGIN</button>
	</div>
	<!-- EOD : loginInfoWrap -->

	<div class="warning01">
		<p>이곳은 관리자 전용사이트입니다.</p>
		<p>ProWise 임직원이 아니신 분은 로그인 할 수 없습니다.</p>
	</div>
	<!-- EOD : warning01 -->
</div>
<script src="/resources/js/login/login.js"></script>