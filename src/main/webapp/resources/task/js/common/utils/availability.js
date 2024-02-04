
const AVAILABILITY = {
    check: function (target) {
        let checkVal = false;
        let message, failTarget;
        $("input:not([type='hidden']),select,textarea", target).each(function () {
            if (checkVal) return;

            const thisObj = $(this);
            const tagNm = $(thisObj).prop("tagName").toLowerCase();
            const tagTp = $(thisObj).prop("type").toLowerCase();
            const title = $(thisObj).attr("title");
            const checkYn = $(thisObj).attr("checkYn");
            const checkMsg = $(thisObj).attr("checkMsg");

            if (checkYn == 'Y') {
                if (!$(thisObj).val()) {
                    checkVal = true;
                    if (checkMsg) {
                        message = checkMsg;
                    }

                    if (title) {
                        message = title;

                        if (tagNm == 'select' || tagTp == 'file') {
                            message += ' 선택은 필수입니다.';
                        } else {
                            message += ' 입력은 필수입니다.';
                        }
                    }

                    failTarget = thisObj;
                }
            }
        });

        return {checkVal: checkVal, message: message, failTarget: failTarget};
    },
}
