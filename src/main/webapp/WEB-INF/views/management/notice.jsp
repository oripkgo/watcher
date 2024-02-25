<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 2:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<form id="noticeForm">
    <%@include file="include/header.jsp" %>
    <div class="section uline2">
        <div class="ani-in manage_layout">
            <div class="manage_conts">
                <%@include file="include/menus.jsp" %>
                <div class="manage_box_wrap">

                    <div class="new_manage_head_box">
                        <div class="new_manage_title_box">
                            <p class="new_manage_title">
                                공지 관리
                            </p>
                            <div class="new_manage_btn_and_search_box">
                                <div class="new_search_right_box">
                                    <div class="search_right_box">
                                        <select id="searchSecretYn" name="searchSecretYn">
                                            <option value="">전체</option>
                                            <option value="NN">공개</option>
                                            <option value="YY">비공개</option>
                                        </select>
                                        <input type="text" id="searchKeyword" name="searchKeyword" placeholder="">
                                        <a href="javascript:;" id="search"></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="new_manage_btn_and_search_box">
                            <div class="new_btn_right_box">
                                <div class="btn_tb">
                                    <a href="javascript:;" onclick="noticeObj.deleteNotices()">삭제</a>
                                    <a href="javascript:;" onclick="noticeObj.updatePublic();">공개</a>
                                    <a href="javascript:;" onclick="noticeObj.updatePrivate();">비공개</a>
                                    <a href="/notice/write">공지쓰기</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="board_notice">
                        <table class="board_list_table">
                            <colgroup>
                                <col width="5%">
                                <col width="10%">
                                <col>
                                <col width="20%">
                            </colgroup>
                            <tbody class="list_header">
                            <tr>
                                <th class="not-none"><input type="checkbox" class="check all"></th>
                                <th>공개여부</th>
                                <th colspan="2"></th>
                            </tr>
                            </tbody>
                            <tbody class="noticeList"></tbody>

                        </table>
                        <div class="pagging_wrap"></div>
                    </div>
                </div><!-------------//manage_box_wrap------------->
            </div>
        </div>
    </div>
</form>

<script>
    const noticeWriteUrl = window.getNoticeWriteUrl();
    const noticeApiUrl = "/management/board/notices";
    const noticePublicUrl = "/management/board/notices/public";
    const noticePrivateUrl = "/management/board/notices/private";

    const noticeObj = {
        confirmCheckBox: function () {
            return $(".check:checked:not('.all')").length == 0 ? false : true;
        },

        getSelCheckBoxObjs: function () {
            return $(".check:checked:not('.all')");
        },

        getNoticeIds: function () {
            const checkObjs = noticeObj.getSelCheckBoxObjs();
            const storyIds = [];

            checkObjs.each(function (idx, checkObj) {
                const obj = $(checkObj).parents("tr").data();
                storyIds.push(obj.ID);
            })

            return storyIds;
        },

        deleteNotice: function () {
            if (!noticeObj.confirmCheckBox()) {
                comm.message.alert('공지사항을 선택해주세요.');
                return;
            }

            comm.message.confirm("선택한 공지사항을 삭제하시겠습니까?", function (result) {
                if (result) {
                    const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
                    comm.request({url: noticeApiUrl, method: "DELETE", data: param}, function (resp) {
                        // 수정 성공
                        if (resp.code == '0000') {
                            $(noticeObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                                $(checkObj).parents("tr").remove();
                            })
                        }
                    })
                }
            })
        },

        deleteNotices: function () {
            if (!noticeObj.confirmCheckBox()) {
                comm.message.alert('공지사항을 선택해주세요.');
                return;
            }

            comm.message.confirm("선택한 공지사항을 삭제하시겠습니까?", function (result) {
                if (result) {
                    const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
                    comm.request({url: noticeApiUrl, method: "DELETE", data: param}, function (resp) {
                        // 수정 성공
                        if (resp.code == '0000') {
                            $(noticeObj.getSelCheckBoxObjs()).each(function (idx, checkObj) {
                                $(checkObj).parents("tr").remove();
                            })
                        }
                    })
                }
            })
        },

        updatePublic: function () {
            if (!noticeObj.confirmCheckBox()) {
                comm.message.alert('공지사항을 선택해주세요.');
                return;
            }

            comm.message.confirm("선택한 공지사항을 공개하시겠습니까?", function (result) {
                if (result) {
                    const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
                    comm.request({url: noticePublicUrl, method: "PUT", data: param}, function (resp) {
                        // 수정 성공
                        if (resp.code == '0000') {
                            $("#searchSecretYn").val("NN");
                            noticeObj.search();
                        }
                    })
                }
            })
        },

        updatePrivate: function () {
            if (!noticeObj.confirmCheckBox()) {
                comm.message.alert('공지사항을 선택해주세요.');
                return;
            }

            comm.message.confirm("선택한 공지사항을 비공개하시겠습니까?", function (result) {
                if (result) {
                    const param = JSON.stringify({paramJson: JSON.stringify(noticeObj.getNoticeIds())});
                    comm.request({url: noticePrivateUrl, method: "PUT", data: param}, function (resp) {
                        // 수정 성공
                        if (resp.code == '0000') {
                            $("#searchSecretYn").val("YY");
                            noticeObj.search();
                        }
                    })
                }
            })
        },

        search: function () {
            comm.paging.getList('#noticeForm', noticeApiUrl, noticeObj.listCallback, 1, 10);
        },

        initCheckBox: function () {
            $(".check").off().on("click", function () {
                let $clickTarget = this;

                if ($($clickTarget).hasClass("all")) {
                    if ($($clickTarget).is(":checked")) {
                        $(".check").prop("checked", true)
                    } else {
                        $(".check").prop("checked", false)
                    }
                }

                if ($(".check:not('.all')").length == $(".check:checked:not('.all')").length) {
                    $(".check.all").prop("checked", true)
                } else {
                    $(".check.all").prop("checked", false)
                }
            })
        },

        getMobileRecord: function (target, arr) {
            let tempDiv = $("<div></div>");
            let dataElement = $(document.createElement(target));
            let rowElement = $('<div class="mobile-data-row"></div>');
            $(dataElement).addClass("mobile-data");

            for (let obj of arr) {
                const col = $('<div class="mobile-data-col"></div>');
                if (obj.type == 'image') {
                    $(col).addClass("image");
                    const a = $('<a></a>');
                    const img = $('<img></img>');
                    $(a).attr("href", obj.href);
                    $(img).attr("src", obj.src);
                    $(a).append(img);
                    $(col).append(a);
                } else {
                    $(col).append('<div class="col-name"><strong>' + obj.col + '</strong></div>');
                    $(col).append('<div class="col-value">' + obj.val + '</div>');
                }

                $(rowElement).append(col);
            }
            $(dataElement).html(rowElement);
            return $(tempDiv).html(dataElement).html();
        },

        listCallback: function (data) {
            comm.paging.emptyList(".noticeList");

            if (data.dto.pageNo == 1 && data.list.length == 0) {
                $(".list_header").hide();
            } else {
                $(".list_header").show();
            }

            for (let i = 0; i < data.list.length; i++) {
                const obj = data.list[i];
                const secretStatus = (obj['SECRET_YN'] == 'Y' ? '비공개' : '공개');
                let trHtml = '';

                trHtml += '<td class="not-none"><input type="checkbox" class="check"></td>';
                trHtml += '<td>' + secretStatus + '</td>';
                trHtml += '<td class="title">';
                trHtml += '    <a href="' + window.getNoticeViewUrl(obj.ID) + '" class="subject_link">' + obj['TITLE'] + '</a>';
                trHtml += '</td>';
                trHtml += '<td>';
                trHtml += obj['REG_DATE'];
                trHtml += '</td>';

                trHtml += noticeObj.getMobileRecord('td', [
                    {col: "공개여부", val: secretStatus},
                    {
                        col: "제목",
                        val: ('<a href="' + window.getNoticeViewUrl(obj.ID) + '" className="subject_link">' + obj['TITLE'] + '</a>')
                    },
                    {col: "작성일", val: obj['REG_DATE']},
                ])

                trHtml = $(noticeObj.getTr()).html(trHtml);
                $(trHtml).data(obj);
                comm.paging.drawList(".noticeList", trHtml);
            }

            noticeObj.initCheckBox();
        },

        getTr: function () {
            return $('<tr></tr>').clone(true);
        },
    }

    $(document).on("ready", function () {
        $("#search").on("click", function () {
            noticeObj.search();
        });

        $("#searchKeyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                noticeObj.search();
                return false;
            }
        });

        noticeObj.search();
    })


</script>