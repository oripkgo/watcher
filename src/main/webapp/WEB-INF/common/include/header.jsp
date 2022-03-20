<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>

<script>
	Kakao.init('16039b88287b9f46f214f7449158dfde');
	Kakao.isInitialized();

	$(document).on("ready",function(){

		$("#kakao-login-btn").on("click",function(){


			Kakao.Auth.login({
				success: function(authObj) {
					alert(JSON.stringify(authObj))
					Kakao.API.request({
						url: '/v2/user/me',
						success: function(res) {
							alert(JSON.stringify(res))
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

		/*$("#naver_id_login").on("click",function(){

			var naver_id_login = new naver_id_login("ThouS3nsCEwGnhkMwI1I", "http://localhost:8080/loginSuccess");
			var state = naver_id_login.getUniqState();
			naver_id_login.setButton("white", 2,40);
			naver_id_login.setDomain("http://localhost:8080");
			naver_id_login.setState(state);
			naver_id_login.setPopup();
			naver_id_login.init_naver_id_login();

		});*/

	})


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
		<a href="javascript:;" class="btn_start">시작하기</a>
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

	var naver_id_login = new naver_id_login("ThouS3nsCEwGnhkMwI1I", "http://localhost:8080/loginSuccess");
	var state = naver_id_login.getUniqState();
	naver_id_login.setButton("white", 2,40);
	naver_id_login.setDomain("http://localhost:8080");
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

</script>