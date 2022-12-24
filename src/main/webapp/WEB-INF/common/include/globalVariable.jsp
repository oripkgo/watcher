<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%

    Map<String,String> globalVar = new LinkedHashMap<>();

    // 나의 관리자 왼쪽 메뉴 리스트
    globalVar.put("managementMain"         , "/management/main"      );
    globalVar.put("managementBoard"        , "/management/board"     );
    globalVar.put("managementCategory"     , "/management/category"  );
    globalVar.put("managementNotice"       , "/management/notice"    );
//    globalVar.put("managementComment"      , "/management/comment"   );
    globalVar.put("managementSetting"      , "/management/setting"   );
    globalVar.put("managementStatistics"   , "/management/statistics");

    // 메뉴 리스트
    globalVar.put("storyUrlView"           , "/story/view"           );
    globalVar.put("storyUrlWrite"          , "/story/write"          );
    globalVar.put("noticeUrlView"          , "/notice/view"          );
    globalVar.put("noticeUrlWrite"         , "/notice/write"         );
    globalVar.put("noticeUrlUpdate"        , "/notice/update"         );

    request.setAttribute("globalVar" , globalVar);

%>

<script type="text/javascript">
    const origin    = location.origin;
    const loginYn   = '${sessionScope.loginInfo.LOGIN_ID}'    ?   true    :   false;
    const loginId   = '${sessionScope.loginInfo.LOGIN_ID}';
    const loginType = '${sessionScope.loginInfo.MEM_TYPE}' == '00' ? "naver" : "kakao";
    const memberId  = '${sessionScope.loginInfo.ID}';
    const storyUrlView = '${globalVar.storyUrlView}';
    const storyUrlWrite = '${globalVar.storyUrlWrite}';
    const noticeUrlView = '${globalVar.noticeUrlView}';
    const noticeUrlWrite = '${globalVar.noticeUrlWrite}';

    const managementNotice = '${globalVar.managementNotice}';

    const getStoryViewUrl = function (id, memId) {
        return '/' + memId + storyUrlView + '?id=' + id;
    }
    const getStoryWriteUrl = function(){
        return storyUrlWrite;
    }

    const getNoticeViewUrl = function(id){
        return noticeUrlView+'?id=' + id;
    }
    const getNoticeWriteUrl = function(){
        return noticeUrlWrite;
    }
</script>

