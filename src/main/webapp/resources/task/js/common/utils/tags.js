const boardTagsApiUrl = '/board/tags';

const getBoardTags = function (id, type) {
    let result = {};
    REQUEST.send(boardTagsApiUrl, "GET", {
        "contentsId": id,
        "contentsType": type,
    }, function (resp) {
        result = resp;
    }, null, null, false)

    return result
}

const TAGS = {
    init: function (id, type) {
        const result = getBoardTags(id, type);
        this.id = id;
        this.type = type;
        this.tags = result['tags'] || result['TAGS'];
    },

    render: function (tagId) {
        let result = "<strong class=\"conts_tit\">태그</strong>";
        let targetElement = document.getElementById(tagId);

        let tags = this.tags;

        if (!tags) {
            targetElement.style.display = 'none';
            return;
        }

        let tags_arr = tags.split(",");

        for (let i = 0; i < tags_arr.length; i++) {
            result += '<a href="javascript:;">#' + tags_arr[i] + '</a>';
        }

        targetElement.innerHTML = result;
        targetElement.style.display = 'block';
    },
}

