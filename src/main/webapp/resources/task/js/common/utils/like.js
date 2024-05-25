const likeYImgUrl = "/resources/img/icon_heart_on.png";
const likeNImgUrl = "/resources/img/zim_ico.png";

const boardLikeApiUrl = '/board/like';

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

const LIKE = {
    init: function (id, type, loginYn, notLoginStatusProcessingFunc) {
        const result = getBoardLike(id, type);

        this.id = id;
        this.type = type;
        this.likeId = result['LIKE_ID'];
        this.likeYn = result['LIKE_YN'];
        this.likeCnt = result['LIKE_CNT'];
        this.loginYn = loginYn;
        this.notLoginStatusProcessingFunc = notLoginStatusProcessingFunc;
    },

    setLikeElementDataSet: function (targetObj, data) {
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
    },

    changeLikeElementDataSet: function (targetObj, likeYn, likeId) {
        if (likeYn == 'Y') {
            let likeCnt = (targetObj.dataset['likeCnt'] * 1) + 1;
            targetObj.innerText = ('공감 ' + likeCnt);
            targetObj.dataset['likeCnt'] = likeCnt;

            targetObj.dataset['likeId'] = likeId;
            targetObj.dataset['likeYn'] = 'Y';

        } else {
            let likeCnt = (targetObj.dataset['likeCnt'] * 1) - 1

            if (likeCnt < 0) {
                likeCnt = 0;
            }

            targetObj.innerText = ('공감 ' + likeCnt);
            targetObj.dataset['likeCnt'] = likeCnt;
            delete targetObj.dataset['likeId'];
        }

    },

    changeTheLikeImageWithLikeYnValue: function (targetObj, likeYn) {
        if (likeYn == 'N') {
            targetObj.style.background = "url('" + likeNImgUrl + "') no-repeat left center";
        } else {
            targetObj.style.background = "url('" + likeYImgUrl + "') no-repeat left center";
        }
    },

    render: function (tagId) {
        const likeThis = this;
        const targetElement = document.getElementById(tagId);

        likeThis.setLikeElementDataSet(targetElement, likeThis);

        likeThis.changeTheLikeImageWithLikeYnValue(targetElement, likeThis['likeYn']);

        targetElement.addEventListener("click", function () {
            // const $this = this;
            if (likeThis['loginYn'] == 'Y') {
                targetElement.dataset['likeYn'] = (targetElement.dataset['likeYn'] == 'Y' ? 'N' : 'Y');

                const resp = updateBoardLike(
                    targetElement.dataset.contentsId,
                    targetElement.dataset.contentsType,
                    targetElement.dataset.likeId,
                    targetElement.dataset.likeYn
                );

                likeThis.changeLikeElementDataSet(targetElement, targetElement.dataset['likeYn'], resp['like_id']);
                likeThis.changeTheLikeImageWithLikeYnValue(targetElement, targetElement.dataset['likeYn']);
            } else {
                console.log('비로그인 상태에서 좋아요 클릭');
                if (likeThis.notLoginStatusProcessingFunc) {
                    likeThis.notLoginStatusProcessingFunc();
                }
            }
        });
    },
}
