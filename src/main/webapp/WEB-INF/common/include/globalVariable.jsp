<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="org.springframework.data.redis.core.ValueOperations" %>
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
    globalVar.put("storyUrlList"           , "/story/list"           );
    globalVar.put("storyUrlView"           , "/story/view"           );
    globalVar.put("storyUrlWrite"          , "/story/write"          );
    globalVar.put("noticeUrlView"          , "/notice/view"          );
    globalVar.put("noticeUrlWrite"         , "/notice/write"         );
    globalVar.put("noticeUrlUpdate"        , "/notice/update"         );

    request.setAttribute("globalVar" , globalVar);
%>

<script type="text/javascript">

    const refererUrl = '${header.referer}';
    const origin    = location.origin;
    const loginYn   = '${loginInfo.LOGIN_ID}'    ?   true    :   false;
    const loginId   = '${loginInfo.LOGIN_ID}';
    const loginType = '${loginInfo.MEM_TYPE}' == '00' ? "naver" : "kakao";
    const memberId  = '${loginInfo.ID}';
    const storyUrlList = '${globalVar.storyUrlList}';
    const storyUrlView = '${globalVar.storyUrlView}';
    const storyUrlWrite = '${globalVar.storyUrlWrite}';
    const noticeUrlView = '${globalVar.noticeUrlView}';
    const noticeUrlWrite = '${globalVar.noticeUrlWrite}';
    const managementNotice = '${globalVar.managementNotice}';
    const nowStoryMemId = '${memId}';

    const getStoryListUrl = function (categoryId, keyword) {
        let listUrl = storyUrlList;

        if( categoryId ){
            listUrl += '?search_category_id=' + categoryId;
        }

        if( keyword ){
            listUrl += '&search_keyword=' + keyword;
        }

        return listUrl;
    }

    const getStoryViewUrl = function (id, memId) {
        return '/' + memId + storyUrlView + '?id=' + id;
    }
    const getStoryWriteUrl = function(){
        return storyUrlWrite;
    }

    const getNoticeViewUrl = function(id, memId){
        return (memId?"/"+memId:"")+noticeUrlView+'?id=' + id;
    }
    const getNoticeWriteUrl = function(){
        return noticeUrlWrite;
    }
</script>

