const SIGN_KAKAO = function () {

    const kakaoKey = window.loginKakaoToken;
    const loginBtnImgKakao = '/resources/img/login_kakao.png';
    const kakaoBtnId = "kakao-login-btn";

    return {

        init: function () {
            const kakaoObj = window['Kakao'];
            kakaoObj['init'](kakaoKey);
            kakaoObj['isInitialized']();

            const kakaoLoginBtn = document.getElementById(kakaoBtnId);
            if (kakaoLoginBtn) {
                kakaoLoginBtn.addEventListener("click", function () {
                    kakaoObj.Auth.login({
                        success: function (authObj) { // eslint-disable-line no-unused-vars
                            kakaoObj.API.request({
                                url: '/v2/user/me',
                                success: function (res) {
                                    window.handleLoginSuccess(Object.assign(res, {"type": "kakao"}));
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

}()



