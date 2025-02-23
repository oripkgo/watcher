<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="org.springframework.core.env.Environment" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%

    Map<String, String> globalVar = new LinkedHashMap<>();

    // 나의 관리자 왼쪽 메뉴 리스트
    globalVar.put("managementMain", "/management/index");
    globalVar.put("managementBoard", "/management/board");
    globalVar.put("managementBoardExternal", "/management/board/external");
    globalVar.put("managementCategory", "/management/category");
    globalVar.put("managementNotice", "/management/notice");
//    globalVar.put("managementComment"      , "/management/comment"   );
    globalVar.put("managementSetting", "/management/setting");
    globalVar.put("managementStatistics", "/management/statistics");

    // 메뉴 리스트
    globalVar.put("storyUrlList", "/story/list");
    globalVar.put("storyUrlView", "/story/view");
    globalVar.put("storyUrlWrite", "/story/write");
    globalVar.put("noticeUrlView", "/notice/view");
    globalVar.put("noticeUrlWrite", "/notice/write");
    globalVar.put("noticeUrlUpdate", "/notice/update");


    Environment environment = WebApplicationContextUtils.getWebApplicationContext(pageContext.getServletContext()).getEnvironment();

    globalVar.put("loginNaverToken", environment.getProperty("naver.login.token"));
    globalVar.put("loginNaverCallback", environment.getProperty("naver.login.callback"));
    globalVar.put("loginKakaoToken", environment.getProperty("kakao.login.token"));
    globalVar.put("activate", environment.getProperty("spring.config.activate.on-profile"));

    request.setAttribute("globalVar", globalVar);
%>

<script type="text/javascript">
    const globalObj = {

        serverActivate: '${globalVar.activate}',

        apiHost: window.location.origin,

        loginNaverToken: '${globalVar.loginNaverToken}',

        loginNaverCallback: '${globalVar.loginNaverCallback}',

        loginKakaoToken: '${globalVar.loginKakaoToken}',

        refererUrl: document.referrer,

        origin: location.origin,

        storyUrlList: "/story/list",

        storyUrlDelete : "/story/delete",

        storyUrlUpdate : "/story/update?id=",

        storyUrlView: "/story/view",

        storyUrlWrite: "/story/write",

        noticeUrlList: "/notice/list",

        noticeUrlView: "/notice/view",

        noticeUrlWrite: "/notice/write",

        noticeUrlUpdate: "/notice/update",

        managementMain: "/management/index",

        managementBoard: "/management/board",

        managementBoardExternal: "/management/board/external",

        managementCategory: "/management/category",

        managementNotice: "/management/notice",

        managementComment: "/management/comment",

        managementSetting: "/management/setting",

        managementStatistics: "/management/statistics",

        nowStoryMemId: "",

        animateQueue: new Array(),

        ready: true,

        triggerJqueryFadeIn: function () {
            $('.ani-in').each(function () {
                var object_top = $(this).offset().top;
                var window_bottom = $(window).scrollTop() + $(window).height() - 200;

                if (window_bottom > object_top) {
                    $(this).addClass('action');
                }
            });
            window.triggerJqueryFadeInQueue();
        },

        triggerJqueryFadeInQueue: function () {
            if (window.animateQueue.length != 0 && window.ready) {
                window.ready = false;
                // $this = animateQueue.shift();
                // $($this).addClass('action');
            }
        },

        getNowStoryMemId: function () {
            let result;
            if (window.location.pathname.indexOf("/story/view") > -1) {
                result = window.location.pathname.replace("/story/view", "").substring(1);
            }
            return result;
        },

        getStoryListUrl: function (categoryId, keyword) {
            let listUrl = this.storyUrlList;

            if (categoryId) {
                listUrl += '?searchCategoryId=' + categoryId;
            }

            if (keyword) {
                listUrl += '&searchKeyword=' + keyword;
            }

            return listUrl;
        },

        getStoryDeleteUrl: function () {
            return this.storyUrlDelete;
        },

        getStoryUpdateUrl: function (id) {
            return this.storyUrlUpdate + (id ? id : '');
        },

        getStoryViewUrl: function (memId, id) {
            return this.storyUrlView + '/' + memId + (id ? ('?id=' + id) : '');
        },

        getStoryWriteUrl: function () {
            return this.storyUrlWrite;
        },

        getNoticeListUrl: function (memId) {
            return (memId ? "/my-story/" + memId : "") + this.noticeUrlList;
        },

        getNoticeViewUrl: function (id, memId) {
            return (memId ? "/my-story/" + memId : "") + this.noticeUrlView + '?id=' + id;
        },

        getNoticeWriteUrl: function () {
            return this.noticeUrlWrite;
        },

        getNoticeUpdateUrl: function (id) {
            return this.noticeUrlUpdate + "?id=" + id;
        },

        getServerImg: function (path) {
            return (path ? /*this.apiHost + */path : "");
        },

        getManagementBoard : function(){
            return this.managementBoard;
        },

        getImgTagStr: function (src, className) {
            let imgStr = '';

            imgStr += '<img ';
            if (src) {
                imgStr += 'src="' + this.getServerImg(src.replace(/[\\]/g, '/')) + '" ';
            } else {
                imgStr += ' src="/resources/img/noimage.jpg" ';
            }

            if (className) {
                imgStr += ' class="' + className + '" ';
            }

            imgStr += 'onerror="this.src=\'/resources/img/noimage.jpg\'" ';
            imgStr += '/>';

            return imgStr;
        },

        mergeSessionStorageData: function () {
            Object.assign(globalObj, JSON.parse((localStorage.getItem("sessionData") || '{}')));
        },

    }

    globalObj['nowStoryMemId'] = globalObj.getNowStoryMemId();
    globalObj.mergeSessionStorageData();
    Object.assign(window, globalObj);
</script>

