<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@include file="globalVariable.jsp"%>

<script type="text/javascript">

	$(document).on("ready",function(){

		loginProcessEvent(loginYn);

	})


	async function login_success_callback(obj){
		console.log(JSON.stringify(obj));

		let param = {}

		if( obj.type == 'naver' ){
			param.type = obj.type;
			param.id = obj.id;
			param.email = obj.email;
			param.nickname = obj.nickname;
			param.profile = obj.profile_image;

		}else{
			param.type = obj.type;
			param.id = obj.id;
			param.email = obj.email;
			param.nickname = obj.properties.nickname;
			param.profile = obj.properties.profile_image;

		}

		loginType = obj.type;
		comm.request({
			url: "/login/loginSuccessCallback",
			data : JSON.stringify(param)
		},function(res){
			// 로그인 성공

			//팝업 닫기
			$("#backbg").fadeOut("slow");
			$(".pop_wrap").hide();

			loginYn = true;
			loginProcess(loginYn);


		})

	}

	function loginProcess(loginYn){
		// 로그인 프로필로 변경

		$(".member_set.logOut").show();
		$(".loginStart").hide();

	}

	function loginProcessEvent(loginYn){
		$(".member_set").on("click",function(){
			$(".member_app").slideToggle("fast");
		})

		$("#logout").on("click",function(){
			comm.logOut(loginType);
		})

	}



</script>


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
					<a href="javascript:;" class="member_set logOut"><img src="/resources/img/member_ico_b.png"></a>
					<div class="member_app logOut" style="display: none;">
						<a href="javascript:;" id="myStory">내 스토리</a>
						<a href="javascript:;" id="management">관리</a>
						<a href="javascript:;" id="writing">글쓰기</a>
						<a href="javascript:;" id="logout">로그아웃</a>
					</div>

					<a href="javascript:;" class="btn_start loginStart" style="display: none;">시작하기</a>
				</c:when>
				<c:otherwise>
					<a href="javascript:;" class="member_set logOut" style="display: none;"><img src="/resources/img/member_ico_b.png"></a>
					<div class="member_app logOut" style="display: none;">
						<a href="javascript:;" id="myStory">내 스토리</a>
						<a href="javascript:;" id="management">관리</a>
						<a href="javascript:;" id="writing">글쓰기</a>
						<a href="javascript:;" id="logout">로그아웃</a>
					</div>

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


<div class="pop_wrap">
	<a href="javascript:;" class="btn_close"></a>
	<div class="pop_tit">로그인</div>
	<div class="btn_pop">
		<a href="javascript:;" id="kakao-login-btn"><img src="/resources/img/login_kakao.png"></a>
		<a href="javascript:;" id="naver_id_login"><img src="/resources/img/login_naver.png"></a>
	</div>
</div>

<script>

	// 카카오 로그인 s
	Kakao.init(kakaoKey);
	Kakao.isInitialized();

	$(document).on("ready",function(){

		$("#kakao-login-btn").on("click",function(){

			Kakao.Auth.login({
				success: function(authObj) {
					Kakao.API.request({
						url: '/v2/user/me',
						success: function(res) {
							login_success_callback(Object.assign(res,{"type":"kakao"}));
						},
						fail: function(error) {
							alert(
									'login success, but failed to request user information: ' +
									JSON.stringify(error)
							)
						},
					})
				},
				fail: function(err) {
					alert(JSON.stringify(err))
				},
			})

		})

	})

	// 네이버 로그인 s
	var naver_id_login = new naver_id_login(naverKey, origin + "/login/loginSuccess");
	var state = naver_id_login.getUniqState();
	naver_id_login.setButton("white", 2,40);
	naver_id_login.setDomain(origin);
	naver_id_login.setState(state);
	naver_id_login.setPopup();
	naver_id_login.is_callback = true;
	naver_id_login.init_naver_id_login_callback = function(){
		$("img","#naver_id_login").attr("src","/resources/img/login_naver.png");
		$("img","#naver_id_login").css({
			width: 'auto',height: 'auto'
		})
	}
	naver_id_login.init_naver_id_login();
	// 네이버 로그인 e

</script>