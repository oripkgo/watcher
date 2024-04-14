const categoryApiUrl = '/category/list';
const categoryMemberApiUrl = '/category/list/member';
const categoryMemberPublicApiUrl = '/category/list/member/public';

const CATEGORY = {

    apiUrl: {
        delete: "",
        insert: "",
        select: "",
        update: "",
    },

    insert: function () {},

    update: function () {},

    delete: function () { },

    get: function () {
        let category_list = "[]";
        REQUEST.send(categoryApiUrl, "GET", null, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
                category_list = resp['categoryList'];
            }
        }, null, null, false);

        return JSON.parse(category_list);
    },


    getMember: function () {
        let category_list = "[]";
        REQUEST.send(categoryMemberApiUrl, "GET", null, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
                category_list = resp['memberCategoryList'];
            }
        }, null, null, false);

        return JSON.parse(category_list);
    },

    getMemberPublic: function (memId) {
        let category_list = "[]";

        REQUEST.send(categoryMemberPublicApiUrl, "GET", {memId: memId}, function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
                category_list = resp['memberCategoryList'];
            }
        }, null, null, false);

        return JSON.parse(category_list);
    },

}