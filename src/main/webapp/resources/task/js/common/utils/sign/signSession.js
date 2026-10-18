const SIGN_SESSION = function(){

    return {

        get: function(){
            return JSON.parse(localStorage.getItem("sessionData") || '{}');
        },
        add: function (memData) {
            const accessToken = localStorage.getItem('accessToken');
            localStorage.clear();

            // 서버에서 내려준 dynamicSessionTime(초 단위)을 밀리초(ms)로 변환
            // 만약 값이 없다면 기본값으로 1800초(30분) 적용
            const sessionTimeSeconds = memData.dynamicSessionTime || 1800;
            const expiryTime = new Date().getTime() + (sessionTimeSeconds * 1000);

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
                sessionTimeSeconds          : sessionTimeSeconds,
                expiry                      : expiryTime,   // 서버 연동된 세션 유효 시간 적용
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

