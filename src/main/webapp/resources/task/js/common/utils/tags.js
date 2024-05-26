
const TAGS = function(){

    const boardTagsApiUrl = '/board/tags';

    const init = function (id, type) {
        const result = getBoardTags(id, type);
        this.id = id;
        this.type = type;
        this.tags = result['tags'] || result['TAGS'];
    }

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

    const render = function (tagId) {
        let result = "<strong class=\"conts_tit\">태그</strong>";
        let targetElement = document.getElementById(tagId);

        let tags = this.tags;

        if (!tags) {
            targetElement.style.display = 'none';
            return;
        }

        let tagArr = tags.split(",");

        for (let i = 0; i < tagArr.length; i++) {
            result += '<a href="javascript:;">#' + tagArr[i] + '</a>';
        }

        targetElement.innerHTML = result;
        targetElement.style.display = 'block';
    }

    return {

        init : init,

        render : render

    }

}()
