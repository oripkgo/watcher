
// document.write('<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>')

const shareUrlFacebook = "https://www.facebook.com/sharer.php?u=";
const shareUrlTwiter = "https://twitter.com/intent/tweet?text=";

const SHARE = {
    onTwiter: function (sendText, sendUrl) {
        window.open(shareUrlTwiter + sendText + "&url=" + sendUrl);
    },

    onFacebook: function (sendUrl) {
        window.open(shareUrlFacebook + sendUrl);
    },

    onKakaoStory: function (buttonId, title, description, sendUrl, imageUrl) {
        if(!Kakao){
            comm.message.alert('No Kakao object found.');
            return;
        }
        // 사용할 앱의 JavaScript 키 설정
        Kakao.init(window.loginKakaoToken);

        // 카카오링크 버튼 생성
        Kakao.Link.createDefaultButton({
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
    },

    onCopyUrl : function(url){
        var textarea = document.createElement("textarea");
        document.body.appendChild(textarea);
        textarea.value = url;
        textarea.select();
        document.execCommand("copy");
        document.body.removeChild(textarea);
    }
}