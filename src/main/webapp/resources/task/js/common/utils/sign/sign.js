
const signinUrl = "/sign/in";
const signoutUrl = "/sign/out";
const requiresLoginpageUrls = ['/management', '/story/write'];

const callbackLoginSuccess = function (obj) {
    let param = {}

    if (obj.type == 'naver') {
        param.type = obj.type;
        param.id = obj.id;
        param.email = obj.email;
        param.nickname = obj.nickname;
        param.name = obj.name;
        param.profile = obj.profile_image;

        if (obj.gender) {
            if (obj.gender == 'M') {
                param.gender = '1';
            } else {
                param.gender = '2';
            }
        }
    } else {
        param.type = obj.type;
        param.id = obj.id;

        if (obj.properties) {
            param.nickname = obj.properties.nickname;
            param.profile = obj.properties.profile_image;
        }

        if (obj.kakao_account) {
            param.email = obj.kakao_account.email;
            //param.gender 	= obj.kakao_account.gender &&

            if (obj.kakao_account.gender) {
                if (obj.kakao_account.gender == "male") {
                    param.gender = '1';
                } else {
                    param.gender = '2';
                }
            }
        }
    }

    REQUEST.send(signinUrl, "POST", param, function (res) {
        SIGN_SESSION.add(res);
        window.location.reload();
    }, null, {'Content-type': "application/json"})
}

const logout = function (loginType, callback) {
    const logoutCallback = function (res) {
        if (callback) {
            callback(res);
        }

        SIGN_SESSION.remove();

        if (requiresLoginpageUrls.some(function (ele) {
            return (window.location.pathname.indexOf(ele) > -1)
        })) {
            window.location.href = '/main';
        } else {
            window.location.reload();
        }
    };

    MESSAGE.confirm("로그아웃 하시겠습니까?", function (result) {
        if (result) {
            let logoutParam = {};

            if (loginType == 'naver') {
                logoutParam.type = 'naver';
                logoutParam.access_token = localStorage.getItem("access_token");
            } else {
                logoutParam.type = 'kakao';
            }

            REQUEST.send(signoutUrl, "POST", logoutParam, logoutCallback, logoutCallback, {'Content-type': "application/json"})
        }
    });
}

const SIGN = {
    init: function () {
        SIGN_POPUP.init(SIGN_KAKAO.getButtonImgUrl(), SIGN_NAVER.getButtonImgUrl());
        SIGN_NAVER.init();
        SIGN_KAKAO.init();

        window['callbackLoginSuccess'] = callbackLoginSuccess;
    },

    isLogin: function () {
        if( !localStorage.getItem("sessionData") ){
            return false;
        }

        const sessionData = JSON.parse(localStorage.getItem("sessionData"));

        if( !sessionData['expiry'] || (new Date().getTime() > sessionData['expiry']) ){
            localStorage.removeItem("sessionData");
            return false;
        }

        sessionData['expiry'] = new Date().getTime() + (30*60*1000);
        localStorage.setItem("sessionData", JSON.stringify(sessionData));

        return true;
    },


    in: function () {
        SIGN_POPUP.open()
    },
    out: function () {
        const session = this.getSession();
        logout(session.loginType);
    },

    getSession: function () {
        return JSON.parse(localStorage.getItem("sessionData") || '{}');
    },
};

