const SIGN = function () {

    const signinUrl = "/sign/in";
    const signoutUrl = "/sign/out";
    const requiresLoginpageUrls = ['/management', '/story/write'];

    const handleLoginSuccess = function (obj) {
        let param = {}

        param.keepLogin = SIGN_POPUP.isKeepLoginChecked();

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
        const handle = function (res) {
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

        let logoutParam = {id: SIGN.getSession()['loginId']};

        if (loginType == 'naver') {
            logoutParam.type = 'naver';
            logoutParam.accessToken = JSON.parse(localStorage.sessionData)['accessToken'];
        } else {
            logoutParam.type = 'kakao';
        }

        REQUEST.send(signoutUrl, "POST", logoutParam, handle, handle, {'Content-type': "application/json"})
    }

    return {

        init: function () {
            SIGN_POPUP.init(SIGN_KAKAO.getButtonImgUrl(), SIGN_NAVER.getButtonImgUrl());
            SIGN_NAVER.init();
            SIGN_KAKAO.init();

            window['handleLoginSuccess'] = handleLoginSuccess;
        },

        isLogin: function () {
            if (!localStorage.getItem("sessionData")) {
                return false;
            }

            const sessionData = JSON.parse(localStorage.getItem("sessionData"));

            if (!sessionData['expiry'] || (new Date().getTime() > sessionData['expiry'])) {
                localStorage.removeItem("sessionData");
                return false;
            }

            // 저장해 둔 세션 유지 시간(초)을 가져오고, 없으면 기본 1800초 적용
            const sessionTimeSeconds = sessionData['sessionTimeSeconds'] || 1800;

            // 활동이 감지될 때마다 해당 시간만큼 만료 기한을 연장 (슬라이딩 세션 방식)
            sessionData['expiry'] = new Date().getTime() + (sessionTimeSeconds * 1000);
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
            return SIGN_SESSION.get();
        },

    }

}()




