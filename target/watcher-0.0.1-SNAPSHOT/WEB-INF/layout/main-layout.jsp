<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
    
<!DOCTYPE html>
<html>

<tiles:insertAttribute name="header"/>
<body>
<tiles:insertAttribute name="body"/>
</body>
<tiles:insertAttribute name="footer"/>

</html>