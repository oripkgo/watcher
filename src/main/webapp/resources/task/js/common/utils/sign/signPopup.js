const SIGN_POPUP = function () {

    const loginPopWrapId = "loginPopupObj";
    const popupBackgroundId = "backbg";
    const kakaoButtonId = "kakao-login-btn";
    const naverButtonId = "naver_id_login";
    const keepLoginCheckboxId = "keepLoginCheckbox"; // 체크박스 ID 정의

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

            // ▼ 로그인 상태 유지 체크박스 영역 (클래스 구조 개선)
            loginHtml += '      <div class="login_keep_wrap">';
            loginHtml += '          <label class="login_keep_label">';
            loginHtml += '              <input type="checkbox" id="'+keepLoginCheckboxId+'" class="login_keep_chk" /> 로그인 상태 유지';
            loginHtml += '          </label>';
            loginHtml += '      </div>';
            // ▲

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

        // 체크박스 체크 여부를 확인하는 함수 추가
        isKeepLoginChecked: function () {
            const checkbox = document.getElementById(keepLoginCheckboxId);
            return checkbox ? checkbox.checked : false;
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