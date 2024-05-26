// document.write('<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>')

const SHARE = function () {

    const shareUrlFacebook = "https://www.facebook.com/sharer.php?u=";
    const shareUrlTwiter = "https://twitter.com/intent/tweet?text=";

    const onTwiter = function (sendText, sendUrl) {
        window.open(shareUrlTwiter + sendText + "&url=" + sendUrl);
    }

    const onFacebook = function (sendUrl) {
        window.open(shareUrlFacebook + sendUrl);
    }

    const onKakaoStory = function (kakaoObj, buttonId, title, description, sendUrl, imageUrl) {
        if (!kakaoObj) {
            comm.message.alert('No Kakao object found.');
            return;
        }
        // 사용할 앱의 JavaScript 키 설정
        kakaoObj.init(window.loginKakaoToken);

        // 카카오링크 버튼 생성
        kakaoObj.Link.createDefaultButton({
            container: buttonId, // 카카오공유버튼ID
            objectType: 'feed',
            content: {
                title: title, // 보여질 제목
                description: description, // 보여질 설명
                imageUrl: imageUrl, // 콘텐츠 URL
                link: {
                    mobileWebUrl: sendUrl,
                    webUrl: sendUrl
                }
            }
        });
    }

    const onCopyUrl = function (url) {
        let textarea = document.createElement("textarea");
        document.body.appendChild(textarea);
        textarea.value = url;
        textarea.select();
        document.execCommand("copy");
        document.body.removeChild(textarea);
    }

    return {

        onTwiter: onTwiter,

        onFacebook: onFacebook,

        onKakaoStory: onKakaoStory,

        onCopyUrl: onCopyUrl,

    }

}()

