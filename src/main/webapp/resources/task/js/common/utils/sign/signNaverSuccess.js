
const SIGN_NAVER_SUCCESS = {
    init : function(naverObj, token, callbackUrl){
        const naver_id_login = new naverObj(token, callbackUrl);
        naver_id_login['get_naver_userprofile']("SIGN_NAVER_SUCCESS.callback()");

        // 접근 토큰 값 출력
        localStorage.setItem("access_token",naver_id_login['oauthParams'].access_token);
    },

    callback : function(){
        if (!window.opener) {
            window.opener = window.open('', 'parentWindow');
        }

        if( window.opener.handleLoginSuccess ){
            window.opener.handleLoginSuccess( Object.assign(window['inner_profileParams'], {"type":"naver"}));
        }

        window.close();
    },
};
