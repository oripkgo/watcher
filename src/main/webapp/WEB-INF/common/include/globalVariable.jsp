<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<script type="text/javascript">
    const origin        = location.origin;
    const loginYn       = '${sessionScope.loginInfo.id}'    ?   true    :   false;
    const loginType     = '${sessionScope.loginInfo.type}' || "";

</script>