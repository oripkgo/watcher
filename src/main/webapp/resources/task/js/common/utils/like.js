const LIKE = function () {

    const boardLikeApiUrl = '/board/like';
    const likeYImgUrl = "/resources/img/icon_heart_on.png";
    const likeNImgUrl = "/resources/img/zim_ico.png";

    const init = function (id, type, loginYn, notLoginStatusProcessingFunc) {
        const result = getBoardLike(id, type);

        this.id = id;
        this.type = type;
        this.likeId = result['LIKE_ID'];
        this.likeYn = result['LIKE_YN'];
        this.likeCnt = result['LIKE_CNT'];
        this.loginYn = loginYn;
        this.notLoginStatusProcessingFunc = notLoginStatusProcessingFunc;
    }

    const getBoardLike = function (id, type) {
        let result = {};
        REQUEST.send(boardLikeApiUrl, "GET", {
            "contentsId": id,
            "contentsType": type,
        }, function (resp) {
            result = resp;
        }, null, null, false)

        return result
    }

    const updateBoardLike = function (contentsId, contentsType, likeId, likeYn) {
        let result = {};
        let param = {};

        if (contentsId) {
            param.contentsId = contentsId;
        }

        if (contentsType) {
            param.contentsType = contentsType;
        }

        if (likeId) {
            param.likeId = likeId;
        }

        if (likeYn) {
            param.likeYn = likeYn;
        }


        REQUEST.send(boardLikeApiUrl, "POST", param, function (resp) {
            result = resp;
        }, null, {'Content-type': "application/json"}, false);

        return result;
    }

    const setElementDataSet = function (targetObj, data) {
        if (data.id) {
            targetObj.dataset['contentsId'] = data.id;
        }
        if (data.type) {
            targetObj.dataset['contentsType'] = data.type;
        }
        if (data['likeId']) {
            targetObj.dataset['likeId'] = data['likeId'];
        }
        if (data['likeYn']) {
            targetObj.dataset['likeYn'] = data['likeYn'];
        }

        if (data['likeYn']) {
            targetObj.dataset['likeCnt'] = data['likeCnt'];
        }
    }

    const changeElementDataSet = function (targetObj, liked, likeId) {
        if (liked) {
            let likeCnt = (targetObj.dataset['likeCnt'] * 1) + 1;
            targetObj.dataset['likeCnt'] = likeCnt;

            targetObj.dataset['likeId'] = likeId;
            targetObj.dataset['likeYn'] = 'Y';

        } else {
            let likeCnt = (targetObj.dataset['likeCnt'] * 1) - 1

            if (likeCnt < 0) {
                likeCnt = 0;
            }

            targetObj.dataset['likeCnt'] = likeCnt;
            delete targetObj.dataset['likeId'];
        }

    }

    const setImage = function (targetObj, likeYn) {
        if (likeYn == 'N') {
            targetObj.style.background = "url('" + likeNImgUrl + "') no-repeat left center";
        } else {
            targetObj.style.background = "url('" + likeYImgUrl + "') no-repeat left center";
        }
    }

    const render = function (tagId) {
        const likeThis = this;
        const likeBtn = document.getElementById(tagId);
        if (!likeBtn) return;

        const likeCountEl = likeBtn.querySelector('.likeCount');
        if (!likeCountEl) return;

        setElementDataSet(likeBtn, likeThis);

        let liked = likeThis['likeYn'] === 'Y';

        likeBtn.classList.toggle('liked', liked);
        likeCountEl.textContent = parseInt(likeBtn.dataset.likeCnt, 10) || 0;

        likeBtn.addEventListener('click', () => {
            if (likeThis['loginYn'] !== 'Y') {
                console.log('비로그인 상태에서 좋아요 클릭');
                if (likeThis.notLoginStatusProcessingFunc) {
                    likeThis.notLoginStatusProcessingFunc();
                }
                return;
            }

            liked = !liked;
            const resp = updateBoardLike(
                likeBtn.dataset.contentsId,
                likeBtn.dataset.contentsType,
                likeBtn.dataset.likeId,
                liked ? 'Y' : 'N'
            );

            changeElementDataSet(likeBtn, liked, resp['boardParam'].likeId);
            likeBtn.classList.toggle('liked', liked);
            likeCountEl.textContent = likeBtn.dataset['likeCnt'];
        });

    }

    return {

        init: init,

        render: render

    }

}()
