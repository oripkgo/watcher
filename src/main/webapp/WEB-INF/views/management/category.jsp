<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 2:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%@include file="include/header.jsp" %>
<form id="managementCategoryForm">
    <div class="section uline2">
        <div class="ani-in manage_layout">
            <div class="manage_conts">
                <%@include file="include/menus.jsp" %>
                <div class="manage_box_wrap">

                    <div class="new_manage_head_box">
                        <div class="new_manage_title_box">
                            <p class="new_manage_title">
                                카테고리
                            </p>
                        </div>
                        <div class="new_manage_btn_box">
                            <div class="new_btn_right_box">
                                <div class="btn_tb_wrap">
                                    <div class="btn_tb">
                                        <a href="javascript:;" onclick="categoryObj.insertCategory();">카테고리 추가</a>
                                        <a href="javascript:;" onclick="categoryObj.deleteCategory();">카테고리 삭제</a>
                                        <a href="javascript:;" onclick="categoryObj.saveCategory();">카테고리 저장</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="category_wrap" id="fieldsObj">
                        <div class="category_left">
                            <a href="javascript:;" class="category_list">카테고리 목록</a>
                        </div>

                        <div class="category_right">
                            <table>
                                <tr class="mobile-data">
                                    <th>카테고리 목록</th>
                                    <td><select class="not_disabled" id="categoryMemberList">
                                        <option value="" selected>선택</option>
                                    </select></td>
                                </tr>
                                <tr>
                                    <th>카테고리명</th>
                                    <td><input type="text" id="categoryNm" name="categoryNm" checkYn="Y" title="카테고리명">
                                    </td>
                                </tr>
                                <tr>
                                    <th>주제</th>
                                    <td>
                                        <select id="defalutCategId" name="defalutCategId" class="categorySelect"
                                                checkYn="Y" title="카테고리 주제">
                                            <option value="" selected>선택</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>공개여부</th>
                                    <td>
                                        <input type="radio" name="showYn" id="showYn01" value="Y" checked><label
                                            for="showYn01">공개</label>&nbsp;&nbsp;
                                        <input type="radio" name="showYn" id="showYn02" value="N"><label for="showYn02">비공개</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>카테고리 소개</th>
                                    <td><textarea id="categoryComents" name="categoryComents"></textarea></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div><!-------------//manage_box_wrap------------->
            </div>
        </div>
    </div>
</form>

<script>
    const categoryInsertUrl = "/management/category";
    const categListSpaceNm = "category_left";
    const categoryMemberListIdNm = "categoryMemberList";
    const categListNm = "category_1st";
    const categSelectNm = "categorySelect";
    const formId = '#managementCategoryForm';

    const CATEGORY_LIST = comm.category.get();
    const MEMBER_CATEGORY_LIST = comm.category.getMember();
    let thisObj;

    const categoryObj = {
        init: function () {
            thisObj = this;

            thisObj.initCategory();
            thisObj.initFields();
        },

        getCategoryTagObj: function () {
            return $('<a href="javascript:;" class="' + categListNm + '"></a>');
        },

        getSelectCategoryOptionObj: function () {
            return $('<option></option>');
        },

        setCategorySelectElement: function () {
            CATEGORY_LIST.forEach(function (obj) {
                const option = thisObj.getSelectCategoryOptionObj();

                $(option).text(obj.CATEGORY_NM);
                $(option).attr("value", obj.ID);

                $(option).data(obj);
                $("." + categSelectNm).append(option);
            })
        },

        setCategoryMemberList: function () {
            MEMBER_CATEGORY_LIST.forEach(function (obj) {
                let category = thisObj.getCategoryTagObj();
                $(category).text(obj.CATEGORY_NM);
                $(category).attr("id", "mem_category_" + obj.ID);
                $(category).data(Object.assign({}, obj));
                $("." + categListSpaceNm).append(category);

                let categoryOption = thisObj.getSelectCategoryOptionObj();
                $(categoryOption).text(obj.CATEGORY_NM);
                $(categoryOption).attr("value", obj.ID);
                $("#" + categoryMemberListIdNm).append(categoryOption);
            })
        },

        makeEventClick: function (target, callback) {
            $(target).off("click").on("click", callback)
        },

        setCategoryInfoInField: function (data) {
            $("#categoryNm").val(data.CATEGORY_NM);
            $("#categoryComents").val(data.CATEGORY_COMENTS);
            $("#defalutCategId").val(data.DEFALUT_CATEG_ID);
            $("[name='showYn'][value='" + (data.SHOW_YN || "Y") + "']").prop("checked", true);
        },

        applyCategoryMemberSelectEvents: function () {
            const thisObj = this;
            $("#" + categoryMemberListIdNm).on("change", function () {
                if ($("option:selected", this).val() == "") {
                    if (thisObj.checkCategorySelect()) {
                        return;
                    }

                    thisObj.disableFields();
                    return;
                }

                $("#mem_category_" + $(this).val()).click();

                // const thisData = $("option:selected",this).data();
                // thisObj.enableFields();
                // thisObj.setCategoryInfoInField(thisData);
            })
        },

        checkCategorySelect: function () {
            if ($("." + categListNm + ".on", "." + categListSpaceNm).length > 0) {
                const result = comm.validation(formId);
                if (result.checkVal) {
                    comm.message.alert(result.message, function () {
                        $(result.failTarget).focus();
                        let categorySelectEleId = $("." + categListNm + ".on", "." + categListSpaceNm).attr("id").replace("mem_category_", "");
                        $("#" + categoryMemberListIdNm).val(categorySelectEleId);
                    })

                    return true;
                }
            }

            return false;
        },

        applyCategoryMemberListEvents: function () {
            const thisObj = this;
            $("." + categListNm, "." + categListSpaceNm).off("click").on("click", function () {
                if (thisObj.checkCategorySelect()) {
                    return;
                }

                const thisData = $(this).data();
                thisObj.enableFields();
                thisObj.setCategoryInfoInField(thisData);

                $("." + categListNm, "." + categListSpaceNm).removeClass("on");
                $(this).addClass("on");
            })
        },

        initCategory: function () {
            thisObj.setCategorySelectElement();
            thisObj.setCategoryMemberList();
            thisObj.applyCategoryMemberListEvents();
            thisObj.applyCategoryMemberSelectEvents();
        },

        applyEventCategoryInfoFields: function () {
            $("#categoryNm").on("keyup", function () {
                $("." + categListNm + ".on", "." + categListSpaceNm).text($(this).val());
                $("#" + categoryMemberListIdNm).find("option:selected").text($(this).val())
            })

            $("select, input, textarea", "#fieldsObj").on("blur", function () {
                let category_nm = $("#categoryNm").val();
                let category_coments = $("#categoryComents").val();
                let defalut_categ_id = $("#defalutCategId").val();
                let show_yn = $("[name='showYn']:checked").val();

                if ($("." + categListNm + ".on", "." + categListSpaceNm).length == 0) {
                    return;
                }

                const data = $("." + categListNm + ".on", "." + categListSpaceNm).data();
                data.CATEGORY_NM = category_nm;
                data.CATEGORY_COMENTS = category_coments;
                data.DEFALUT_CATEG_ID = defalut_categ_id;
                data.SHOW_YN = show_yn;

                $("." + categListNm + ".on", "." + categListSpaceNm).data(data);
            })
        },

        initFields: function () {
            thisObj.disableFields();
            thisObj.applyEventCategoryInfoFields();
        },

        disableFields: function () {
            $("#categoryComents, #categoryNm, #defalutCategId", "#fieldsObj").val("");
            $("[name='showYn'][value='Y']").prop("checked", true);
            $("select, input, textarea", "#fieldsObj").not(".not_disabled").prop("disabled", true);
            $(".category_1st.on").removeClass("on");
            $("#" + categoryMemberListIdNm).val("");
        },

        enableFields: function () {
            $("select, input, textarea", "#fieldsObj").not(".not_disabled").prop("disabled", false);
        },

        insertCategory: function () {
            if ($("." + categListNm + ".on", "." + categListSpaceNm).length > 0) {
                const result = comm.validation(formId);
                if (result.checkVal) {
                    comm.message.alert(result.message, function () {
                        $(result.failTarget).focus();
                    })

                    return;
                }
            }

            let obj = thisObj.getCategoryTagObj();

            const tagId = comm.generateUUID();
            $(obj).attr("id", "mem_category_" + tagId);
            $(obj).data()['TAG_ID'] = "mem_category_" + tagId;
            $(obj).data()['DELETE_YN'] = "N";
            $("#fieldsObj .category_left").append(obj)
            thisObj.applyCategoryMemberListEvents();
            $(obj).click();

            let categoryOption = thisObj.getSelectCategoryOptionObj();
            $(categoryOption).attr("value", tagId);
            $("#" + categoryMemberListIdNm).append(categoryOption);
            $("#" + categoryMemberListIdNm).val(tagId);

            $("#categoryNm").focus();
        },

        deleteCategory: function () {
            if ($("." + categListNm + ".on", "." + categListSpaceNm).length <= 0) {
                comm.message.alert("선택된 카테고리가 없습니다.");
                return;
            }

            if ($('.category_1st').length == 1) {
                comm.message.alert("카테고리 더이상 삭제할수 없습니다.");
                return;
            }

            comm.message.confirm("선택한 카테고리를 삭제하시겠습니까?", function (result) {
                if (result) {
                    const target = $("." + categListNm + ".on", "." + categListSpaceNm);

                    if (!$(target).data()['ID']) {
                        $(target).remove();
                    } else {
                        $(target).data()["DELETE_YN"] = "Y";
                        $(target).hide();
                    }

                    $("#" + categoryMemberListIdNm).find("[value='" + $(target).data()['ID'] + "']").remove();
                    thisObj.disableFields();
                }
            });
        },

        getIdx: function (obj) {
            return $("#fieldsObj .category_left").find(".category_1st").index(obj);
        },

        setIdToNewCategory: function (newIds) {
            const ids = newIds;
            const ids_keys = Object.keys(ids);

            for (let i = 0; i < ids_keys.length; i++) {
                const key = ids_keys[i];
                const val = ids[ids_keys[i]];
                $("#" + key).data()["ID"] = val;
            }
        },

        saveCategory: function () {
            if (thisObj.isCategoryListCheck()) {
                return;
            }

            comm.message.confirm("카테고리를 저장하시겠습니까?", function (result) {
                if (result) {
                    let jsonArr = [];

                    $("." + categListNm, "." + categListSpaceNm).each(function () {
                        const categObj = $(this).data();
                        jsonArr.push(categObj);
                    })

                    let param = {};
                    param.paramJson = JSON.stringify(jsonArr);

                    comm.request({
                        url: categoryInsertUrl,
                        method: "POST",
                        data: JSON.stringify(param)
                    }, function (resp) {
                        // 수정 성공
                        if (resp.code == '0000') {
                            thisObj.setIdToNewCategory(JSON.parse(resp['insertIds']));

                            comm.message.alert("카테고리가 저장되었습니다.", function () {
                                thisObj.disableFields();
                            });
                        }
                    })
                }
            });
        },

        isCategoryListCheck: function () {
            let checkVal = false;
            $('.category_1st').each(function () {
                const clickTargetObj = $(this);
                const data = $(clickTargetObj).data();

                if (checkVal)
                    return;

                if ((!data['CATEGORY_NM']) || !(data['DEFALUT_CATEG_ID'])) {
                    checkVal = true;

                    $("." + categListNm, "." + categListSpaceNm).removeClass("on")
                    $(clickTargetObj).addClass("on");
                    thisObj.setCategoryInfoInField($("." + categListNm + ".on", "." + categListSpaceNm).data());

                    if (!(data['CATEGORY_NM'])) {
                        comm.message.alert("카테고리 이름을 입력해주세요.");
                        $("#categoryNm").focus();
                        return;
                    }

                    if (!(data['DEFALUT_CATEG_ID'])) {
                        comm.message.alert("카테고리 주제를 선택해주세요.");
                        $("#defalutCategId").focus();
                        return;
                    }
                }
            })

            return checkVal;
        },
    }

    $(document).on("ready", function () {
        categoryObj.init();
    })

</script>