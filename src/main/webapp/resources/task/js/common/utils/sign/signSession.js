const SIGN_SESSION = {
    add: function (memData) {
        localStorage.clear();
        localStorage.setItem("sessionData", JSON.stringify({
            loginId: memData.loginId,
            loginYn: (memData["loginId"] ? true : false),
            loginType: (memData["loginType"] == '00' ? "naver" : "kakao"),
            memberId: memData.memberId,
            memProfileImg: memData.memProfileImg,
            sessionId: memData.sessionId,
            commentPermStatus: memData.commentPermStatus,
            storyRegPermStatus: memData.storyRegPermStatus,
            storyCommentPublicStatus: memData.storyCommentPublicStatus,
            storyTitle: memData.storyTitle,
            expiry : new Date().getTime() + (30 * 60 * 1000),   // 로그인 세션시간 30분
        }));
        localStorage.setItem("apiToken", memData['apiToken']);
    },

    remove: function () {
        localStorage.clear();
        delete window.loginId;
        delete window.loginYn;
        delete window.loginType;
        delete window.memProfileImg;
        delete window.memberId;
        delete window.nowStoryMemId;
    },
}

