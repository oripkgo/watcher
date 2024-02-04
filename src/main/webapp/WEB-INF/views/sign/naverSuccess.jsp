<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<script type="text/javascript" src="/resources/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript" src="/resources/task/js/common/utils/sign/signNaverSuccess.js"></script>
<script>
    SIGN_NAVER_SUCCESS.init(
        naver_id_login,
        window.opener['loginNaverToken'],
        window.opener['loginNaverCallback']
    );
</script>
