<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript">
	var naver_id_login = new naver_id_login("ThouS3nsCEwGnhkMwI1I", "http://localhost:8080/loginSuccess");
	// 접근 토큰 값 출력
	// 네이버 사용자 프로필 조회
	naver_id_login.get_naver_userprofile("naverSignInCallback()");
	// 네이버 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function

    function naverSignInCallback() {
        if( window.opener.login_success_callback ){
            window.opener.login_success_callback(Object.assign(inner_profileParams,{"type":"naver"}));
        }
        window.close();
    }

</script>