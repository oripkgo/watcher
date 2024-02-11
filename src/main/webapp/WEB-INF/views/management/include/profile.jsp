<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 2:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="manage_photo">
    <img src="/resources/img/member_ico_s.png"/>
</div>

<script>
    if( window.loginYn ){
        $("img",".manage_photo").attr("src", window.memProfileImg)
    }
</script>


