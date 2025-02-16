<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="manage_line">인기글</div>
<div class="conts_rel">
    <ul style="padding:20px 0px;" class="articleList">
    </ul>
</div>

<script>
    const apiUrlManagementBoardPoularStorys = "/management/board/popularity/storys";

    comm.request({url: apiUrlManagementBoardPoularStorys, method: "GET"}, function (resp) {
        if (resp.code == '0000') {
            $(".articleList").empty();
            resp.list.forEach(function (obj) {
                let liObj = $("<li></li>");
                let liHtml = '';
                liHtml += '<a href="'+window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID'])+'">                          ';
                liHtml += window.getImgTagStr(obj['THUMBNAIL_IMG_PATH']);
                liHtml += '        <strong>[' + obj['CATEGORY_NM'] + '] ' + obj['TITLE'] + '</strong> ';
                liHtml += '        <span>' + obj['SUMMARY'] + '</span>                         ';
                liHtml += '</a>                                                         ';
                liHtml += '<p>                                                          ';
                liHtml += '    <em>댓글 ' + obj['COMMENT_CNT'] + '</em>                          ';
                liHtml += '    <img src="/resources/img/line.png">     ';
                liHtml += '        <em>공감 ' + obj['LIKE_CNT'] + '</em>                         ';
                liHtml += '</p>                                                         ';

                $(liObj).html(liHtml);
                $(".articleList").append(liObj);
            });
        }
    })
</script>
