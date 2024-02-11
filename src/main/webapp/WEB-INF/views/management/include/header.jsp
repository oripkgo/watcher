<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="section">
    <div class="ani-in manage_layout">
        <div class="manage_top ani_y delay1">
            <div class="mystory_title">{{storyTitle}}</div>
            <a href="javascript:;" class="manage_btn"></a>
        </div>
    </div>
</div>

<script>
    $(".mystory_title").text(window.storyTitle);
</script>