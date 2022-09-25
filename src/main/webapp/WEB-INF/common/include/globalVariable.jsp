<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
    const origin    = location.origin;
    const loginYn   = '${sessionScope.loginInfo.LOGIN_ID}'    ?   true    :   false;
    const loginId   = '${sessionScope.loginInfo.LOGIN_ID}';
    const loginType = '${sessionScope.loginInfo.MEM_TYPE}' == '00' ? "naver" : "kakao";
    const memberId  = '${sessionScope.loginInfo.ID}';
</script>

