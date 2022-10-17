<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2022-10-01
  Time: 오후 4:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<div class="manage_photo">

    <c:choose>
        <c:when test="${!empty sessionScope.loginInfo}">

            <c:choose>
                <c:when test="${!empty sessionScope.loginInfo.MEM_PROFILE_IMG }">
                    <img src="${sessionScope.loginInfo.MEM_PROFILE_IMG}">
                </c:when>
                <c:otherwise>
                    <img src="/resources/img/member_ico_s.png">
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <img src="/resources/img/member_ico_s.png">
        </c:otherwise>
    </c:choose>

</div>
