const naverKey = window.loginNaverToken;
const loginNaverCallbackUrl = window.location.origin + "/sign/naver/success";
const naverBtnImgUrl = "/resources/img/login_naver.png";

const SIGN_NAVER = {
    init: function () {
        window.name = 'parentWindow';
        const naverObj = new window['naver_id_login'](naverKey, loginNaverCallbackUrl);
        let state = naverObj['getUniqState']();
        localStorage.setItem("naverLoginAuthData", state);
        naverObj['setButton']("white", 2, 40);
        naverObj['setDomain'](window.location.origin);
        naverObj['setState'](state);
        naverObj['oauthParams'].state = state;
        naverObj['setPopup']();
        naverObj['is_callback'] = true;
        naverObj['init_naver_id_login_callback'] = function () {
            const naverIdLoginImg = document.querySelector("#naver_id_login img");
            naverIdLoginImg.src = naverBtnImgUrl;
            naverIdLoginImg.style.width = 'auto';
            naverIdLoginImg.style.height = 'auto';
        }

        naverObj['init_naver_id_login']();

        window['naver_id_login'] = naverObj;
        // 네이버 로그인 e
    },

    getButtonImgUrl: function () {
        return naverBtnImgUrl;
    },
};
