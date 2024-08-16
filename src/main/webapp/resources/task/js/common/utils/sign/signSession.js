const SIGN_SESSION = function(){

    return {

        get: function(){
            return JSON.parse(localStorage.getItem("sessionData") || '{}');
        },
        add: function (memData) {
            const accessToken = localStorage.getItem('accessToken');
            localStorage.clear();

            localStorage.setItem("sessionData", JSON.stringify({
                loginId                     : memData.loginId,
                loginYn                     : (memData["loginId"] ? true : false),
                loginType                   : memData["loginType"],
                memberId                    : memData.memberId,
                memProfileImg               : memData.memProfileImg,
                sessionId                   : memData.sessionId,
                commentPermStatus           : memData.commentPermStatus,
                storyRegPermStatus          : memData.storyRegPermStatus,
                storyCommentPublicStatus    : memData.storyCommentPublicStatus,
                storyTitle                  : memData.storyTitle,
                expiry                      : new Date().getTime() + (30 * 60 * 1000),   // 로그인 세션시간 30분
                accessToken                 : accessToken,
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

}()

