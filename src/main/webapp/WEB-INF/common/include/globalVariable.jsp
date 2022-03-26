<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<script type="text/javascript">
    const origin = location.origin;
    const kakaoKey = '16039b88287b9f46f214f7449158dfde';
    const naverKey = 'ThouS3nsCEwGnhkMwI1I';
    let loginYn = '${sessionScope.loginInfo.id}'    ?   true    :   false;
    let loginType = '${sessionScope.loginInfo.type}' || "";

</script>