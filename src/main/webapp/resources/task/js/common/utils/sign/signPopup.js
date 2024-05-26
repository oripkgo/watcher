const SIGN_POPUP = function () {

    const loginPopWrapId = "loginPopupObj";
    const popupBackgroundId = "backbg";
    const kakaoButtonId = "kakao-login-btn";
    const naverButtonId = "naver_id_login";

    return {

        init: function (btnImgUrlKakao, btnImgUrlNaver) {
            const signPopupThis = this;
            let loginHtml = '';
            loginHtml += '<div class="pop_wrap" id="'+loginPopWrapId+'">';
            loginHtml += '	<a href="javascript:;" class="btn_close"></a>';
            loginHtml += '	<div class="pop_tit">로그인</div>';
            loginHtml += '	<div class="btn_pop">';
            loginHtml += '		<a href="javascript:;" id="'+kakaoButtonId+'"><img src="' + btnImgUrlKakao + '"/></a>';
            loginHtml += '		<a href="javascript:;" id="'+naverButtonId+'"><img src="' + btnImgUrlNaver + '"/></a>';
            loginHtml += '	</div>';
            loginHtml += '</div>';

            let existingLoginHtmlObj = document.getElementById(loginPopWrapId);
            if (existingLoginHtmlObj) {
                existingLoginHtmlObj.remove();
            }

            let body = document.body || document.getElementsByTagName('body')[0];
            body.insertAdjacentHTML('beforeend', loginHtml);

            document.querySelector(".btn_close").addEventListener("click", function () {
                signPopupThis.close();
            });
        },

        open: function () {
            document.getElementById(popupBackgroundId).style.display = "block";
            document.getElementById(loginPopWrapId).style.display = "block";
        },

        close: function () {
            document.getElementById(popupBackgroundId).style.display = "none";
            document.getElementById(loginPopWrapId).style.display = "none";
        },

    }

}()
