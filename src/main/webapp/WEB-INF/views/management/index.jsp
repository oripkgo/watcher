<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="include/header.jsp"%>
<div class="section uline2">
    <div class="ani-in manage_layout">
        <div class="manage_conts">
            <%@include file="include/menus.jsp"%>
            <div class="manage_box_wrap">
                <%@include file="include/visitorInfo.jsp"%>
                <div class="graph_wrap">
                    <%@include file="include/charts.jsp"%>
                </div>
                <%@include file="include/popularArticles.jsp"%>
            </div>
        </div>
    </div>
</div>