<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%

    Map<String,String> globalVar = new LinkedHashMap<>();

    globalVar.put("myManagementMain"         , "/myManagement/main"      );
    globalVar.put("myManagementBoard"        , "/myManagement/board"     );
    globalVar.put("myManagementCategory"     , "/myManagement/category"  );
    globalVar.put("myManagementNotice"       , "/myManagement/notice"    );
    globalVar.put("myManagementComment"      , "/myManagement/comment"   );
    globalVar.put("myManagementSetting"      , "/myManagement/setting"   );
    globalVar.put("myManagementStatistics"   , "/myManagement/statistics");

    request.setAttribute("globalVar" , globalVar);

%>



<script type="text/javascript">
    const origin    = location.origin;
    const loginYn   = '${sessionScope.loginInfo.LOGIN_ID}'    ?   true    :   false;
    const loginId   = '${sessionScope.loginInfo.LOGIN_ID}';
    const loginType = '${sessionScope.loginInfo.MEM_TYPE}' == '00' ? "naver" : "kakao";
    const memberId  = '${sessionScope.loginInfo.ID}';
</script>

