const kakaoKey = window.loginKakaoToken;
const loginBtnImgKakao = '/resources/img/login_kakao.png';
const SIGN_KAKAO = {
    init: function () {
        const kakaoObj = window['Kakao'];
        kakaoObj['init'](kakaoKey);
        kakaoObj['isInitialized']();

        var kakaoLoginBtn = document.getElementById("kakao-login-btn");
        if (kakaoLoginBtn) {
            kakaoLoginBtn.addEventListener("click", function () {
                kakaoObj.Auth.login({
                    success: function (authObj) { // eslint-disable-line no-unused-vars
                        kakaoObj.API.request({
                            url: '/v2/user/me',
                            success: function (res) {
                                window.callbackLoginSuccess(Object.assign(res, {"type": "kakao"}));
                            },
                            fail: function (error) {
                                console.error('login success, but failed to request user information: ' +
                                    JSON.stringify(error))
                            },
                        })
                    },
                    fail: function (err) {
                        console.error(JSON.stringify(err))
                    },
                })
            });
        }
    },

    getButtonImgUrl: function () {
        return loginBtnImgKakao;
    },
};

