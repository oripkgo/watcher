<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="vo" value="${view}"/>

<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Main Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script type="text/javascript">
    const contents_obj = '#editor';
    let quill;
    let toolbarOptions = [
        ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
        ['blockquote', 'code-block'],

        [{ 'header': 1 }, { 'header': 2 }],               // custom button values
        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
        [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
        [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent
        [{ 'direction': 'rtl' }],                         // text direction

        [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

        [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
        [{ 'font': [] }],
        [{ 'align': [] }],

        ['clean']                                         // remove formatting button
    ];

    const id = '${vo.ID}';

    $(document).on("ready",function(){
        $(".write_confirm").on("click",function(){
            if($("#title").val() == ''){
                comm.message.alert("제목을 입력해주세요.");
                return;
            }

            $("#contents").val($(".ql-editor","#editor").html());

            comm.appendInput('#notice_write_form'    , 'summary' ,String($(".ql-editor","#editor").text()).substring(0,200)  );
            comm.appendInput('#notice_write_form'    , 'regId'   ,loginId                            );
            comm.appendInput('#notice_write_form'    , 'uptId'   ,loginId                            );

            var form = $('#notice_write_form')[0]
            var formData = new FormData(form);

            comm.request({
                url: "/notice/insert",
                data : formData,
                // headers : {"Content-type":"application/x-www-form-urlencoded"},
                processData : false,
                contentType : false,
            },function(res){
                // 성공
                if( res.code == '0000' ){
                    if (id) {
                        comm.message.alert('스토리가 수정되었습니다.', function () {
                            location.href = managementNotice;
                        });
                    } else {
                        comm.message.alert('스토리가 등록되었습니다.', function () {
                            location.href = managementNotice;
                        });
                    }
                }
            })
        });

        $(".write_cancel").on("click",function(){
            history.back();
        });

        $("#thumbnailImgPathParam").on("change",function(e){
            $("#thumbnailImgPathParam_text").val(this.value);
        });

        $(contents_obj).css({"height":"400px","font-size":"14px"});
        quill = new Quill(contents_obj, {
            modules: {
                //toolbar: '#toolbar-container',
                toolbar: toolbarOptions
            },

            theme: 'snow'
        });
    });
</script>

<form id="notice_write_form">

    <input type="hidden" name="id" id="id" value="${vo.ID}">
    <input type="hidden" name="contents" id="contents">

    <div class="section uline2">
        <div class="ani-in manage_layout">

            <div class="manage_conts">

                <%--<div class="notice_top">
                    <select id="notice_category">
                        <option value="">카테고리</option>
                    </select>
                </div>--%>

                <div class="notice_tb">

                    <table>
                        <tbody>
                        <tr>
                            <th>공개여부</th>
                            <td class="notice_top">
                                <select id="secretYn" name="secretYn">
                                    <option value="N">공개</option>
                                    <option value="Y">비공개</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td><input type="text" name="title" id="title" placeholder="제목을 입력하세요" value="${vo.TITLE}">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="editor" class="editor">${vo.CONTENTS}</div>
                            </td>
                        </tr>
                        <tr>
                            <th class="non">첨부파일1</th>
                            <td class="non notice_thumbnailImg">
                                <label for="thumbnailImgPathParam" class="input-file-button">파일 첨부</label>
                                <input type="file" name="thumbnailImgPathParam" id="thumbnailImgPathParam"
                                       accept="image/gif, image/jpeg, image/png">
                                <input type="text" disabled name="thumbnailImgPathParam_text"
                                       id="thumbnailImgPathParam_text" placeholder="첨부파일을 선택하세요"
                                       value="${vo.THUMBNAIL_IMG_PATH}">
                            </td>
                        </tr>
                        </tbody>
                    </table>

                </div>

                <%--<div class="notice_tag"><input type="text" name="tags" id="tags" placeholder="태그를 입력하세요 (ex:태그1,태그2,태그3)"></div>--%>

                <div class="not_btn">
                    <a href="javascript:;" class="on write_confirm">작성완료</a>
                    <a href="javascript:;" class="write_cancel">작성취소</a>
                </div>


            </div><!-------------//manage_conts------------->

        </div>
    </div>
</form>

