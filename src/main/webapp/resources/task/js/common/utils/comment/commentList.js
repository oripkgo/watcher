
const commentListApiUrl = '/board/comment/select';
const COMMENT_LIST = {
    get: function (form, callback) {
        PAGING.getList(form, commentListApiUrl, callback, 1, 10)
    },

    empty: function (target) {
        PAGING.emptyList("#" + target.id)
    },
}

