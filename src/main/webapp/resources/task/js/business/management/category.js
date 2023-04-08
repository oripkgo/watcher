const categListSpaceNm = "category_left";
const categListNm = "category_1st";
const categSelectNm = "categorySelect";
const field_names = {
    title: "categoryNm",
    topic: "defalutCategId",
    file: "representativeImage",
    secret: "showYn",
    explanation: "categoryComents",
};
const formId = '#managementCategoryForm';

let category_list;
let member_category_list;
let thisObj;
const categoryObj = {
    init : function(categoryList, memberCategoryList){
        category_list = categoryList;
        member_category_list = memberCategoryList;
        thisObj = this;

        thisObj.initCategory();
        thisObj.initFields();
    },

    getCategoryTagObj : function(){
        return $('<a href="javascript:;" class="'+categListNm+'"></a>');
    },

    getSelectCategoryOptionObj : function(){
        return $('<option></option>');
    },

    setSelectCategory : function(){
        category_list.forEach(function(obj,idx){
            const option = thisObj.getSelectCategoryOptionObj();

            $(option).text(obj.CATEGORY_NM);
            $(option).attr("value", obj.ID);

            $(option).data(obj);
            $("." + categSelectNm).append(option);
        })
    },

    setCategoryList : function(){
        member_category_list.forEach(function(obj,idx){
            const category = thisObj.getCategoryTagObj();

            $(category).text(obj.CATEGORY_NM);

            $(category).data(obj);
            $("." + categListSpaceNm).append(category);
        })
    },

    makeEventClick : function(target, callback){
        $(target).off("click").on("click", callback)
    },

    setCategoryInfoInField : function(data){
        $("#categoryNm").val(data.CATEGORY_NM);
        $("#categoryComents").val(data.CATEGORY_COMENTS);
        $("#defalutCategId").val(data.DEFALUT_CATEG_ID);
        $("[name='showYn'][value='"+data.SHOW_YN+"']").prop("checked",true);
    },

    applyCategoryEvents : function(){
        $("." + categListNm, "." + categListSpaceNm).off("click").on("click", function(e){
            if ($("." + categListNm+".on", "." + categListSpaceNm).length > 0 && comm.validation(formId)) {
                return
            }

            const thisData = $(this).data();
            thisObj.enableFields();
            thisObj.setCategoryInfoInField(thisData);

            $("." + categListNm, "." + categListSpaceNm).removeClass("on");
            $(this).addClass("on");
        })
    },

    initCategory : function(){
        thisObj.setSelectCategory();
        thisObj.setCategoryList();
        thisObj.applyCategoryEvents();
    },

    applyEventCategoryInfoFields : function(){
        $("#categoryNm").on("keyup", function (e) {
            $("." + categListNm+".on", "." + categListSpaceNm).text($(this).val());
        })

        $("select, input, textarea", "#fieldsObj").on("blur", function () {
            let category_nm = $("#categoryNm").val();
            let category_coments = $("#categoryComents").val();
            let defalut_categ_id = $("#defalutCategId").val();
            let show_yn = $("[name='showYn']:checked").val();

            const data = $("." + categListNm+".on", "." + categListSpaceNm).data();
            data.CATEGORY_NM = category_nm;
            data.CATEGORY_COMENTS = category_coments;
            data.DEFALUT_CATEG_ID = defalut_categ_id;
            data.SHOW_YN = show_yn;

            $("." + categListNm+".on", "." + categListSpaceNm).data(data);
        })
    },

    initFields : function(){
        thisObj.disableFields();
        thisObj.applyEventCategoryInfoFields();
    },

    disableFields : function(){
        $("#categoryComents, #categoryNm, #defalutCategId", "#fieldsObj").val("");
        $("[name='showYn'][value='Y']").prop("checked",true);

        $("select, input, textarea", "#fieldsObj").prop("disabled", true);
    },

    enableFields : function(){
        $("select, input, textarea", "#fieldsObj").prop("disabled", false);
    },

    insertCategory : function(){
        if ($("." + categListNm+".on", "." + categListSpaceNm).length > 0 && comm.validation(formId)) {
            return
        }

        let obj = thisObj.getCategoryTagObj();
        $("#fieldsObj .category_left").append(obj)
        thisObj.applyCategoryEvents();
        $(obj).click();

        $("#categoryNm").focus();
    },

    deleteCategory : function(){
        if( $("." + categListNm+".on", "." + categListSpaceNm).length <= 0 ){
            comm.message.alert("선택된 카테고리가 없습니다.");
            return;
        }

        if( $('.category_1st').length == 1 ){
            comm.message.alert("카테고리 더이상 삭제할수 없습니다.");
            return;
        }

        comm.message.confirm("선택한 카테고리를 삭제하시겠습니까?",function(result){
            if( result ){
                const target = $("." + categListNm+".on", "." + categListSpaceNm);
                if( !$(target).data()['ID'] ){
                    $(target).remove();
                }else{
                    $(target).data()["DELETE_YN"] = "Y";
                    $(target).hide();

                }
                $(".category_1st.on" ).removeClass("on");
                thisObj.disableFields();

            }
        });
    },

    getIdx : function(obj){
        return $("#fieldsObj .category_left").find(".category_1st").index(obj);
    },

    saveCategory : function(){
        if( thisObj.isCategoryListCheck() ){
            return;
        }

        comm.message.confirm("카테고리를 저장하시겠습니까?",function(result){
            if( result ){
                let jsonArr = [];

                $("." + categListNm, "." + categListSpaceNm).each(function(){
                    const categObj = $(this).data();
                    jsonArr.push(categObj);
                })

                let param = {};
                param.paramJson = JSON.stringify(jsonArr);

                comm.request({url:"/management/category/insert", method : "POST", data : JSON.stringify(param)},function(resp){
                    // 수정 성공
                    if( resp.code == '0000'){
                        comm.message.alert("카테고리가 저장되었습니다.");
                    }
                })
            }
        });
    },

    isCategoryListCheck : function(){
        let checkVal = false;
        $('.category_1st').each(function(obj){
            const thisObj = $(this);
            const data = $(thisObj).data();

            if( checkVal )
                return;

            if( (!data['CATEGORY_NM']) || !(data['DEFALUT_CATEG_ID']) ){
                checkVal = true;

                $("." + categListNm, "." + categListSpaceNm).removeClass("on")
                $(thisObj).addClass("on");
                thisObj.setCategoryInfoInField($("." + categListNm+".on", "." + categListSpaceNm).data());

                if( !(data['CATEGORY_NM']) ){
                    comm.message.alert("카테고리 이름을 입력해주세요.");
                    $("#categoryNm").focus();
                    return;
                }

                if( !(data['DEFALUT_CATEG_ID']) ){
                    comm.message.alert("카테고리 주제를 선택해주세요.");
                    $("#defalutCategId").focus();
                    return;
                }
            }
        })

        return checkVal;
    },
};