<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<style>

    .ck-editor__editable_inline { height: 400px; width:100%; }
    .ck-content { font-size: 16px; }
</style>

<script src="https://cdn.ckeditor.com/ckeditor5/34.1.0/classic/ckeditor.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/translations/ko.js"></script>
<script>
    $(document).on("ready",function(){

        ClassicEditor
            .create( document.querySelector( '.editor' ),{
                removePlugins: [ 'Heading' ],
                language: "ko"
            })
            .catch( error => {
                console.error( error );
            } );

    })
</script>--%>


<%--<script src="https://cdn.ckeditor.com/4.19.0/standard-all/ckeditor.js"></script>
<script>
    let category_list = JSON.parse('${category_list}');

    $(document).on("ready",function(){

        category_list.forEach(function(obj,idx){
            let option = $("<option></option>");

            option.attr("value",obj['ID']);
            option.text(obj['CATEGORY_NM']);

            option.data(obj);
            $("#story_category").append(option);

        });

        CKEDITOR.replace('contents', {
            height: 400,
            removeButtons: 'PasteFromWord'
        });
    });
</script>--%>

<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<form id="story_write_form">

    <input type="hidden" name="categoryId"          id="categoryId "        >
    <input type="hidden" name="memberCategoryId"    id="memberCategoryId"   >

    <div class="section uline2">
        <div class="ani-in manage_layout">

            <div class="manage_conts">

                <div class="story_top">
                    <select id="story_category">
                        <option value="">카테고리</option>
                    </select>
                </div>
                <div class="story_tb">

                    <div class="story_title"><input type="text" name="title" id="title" placeholder="제목을 입력하세요"></div>
                    <div class="story_contents">
                        <%--<textarea class="editor" id="contents" name="contents"></textarea>--%>

                        <div id="contents" class="editor"></div>
                            <!-- Main Quill library -->
                            <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
                            <script type="text/javascript">

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

                                $(document).on("ready",function(){
                                    let quill = new Quill('#contents', {

                                        modules: {
                                            //toolbar: '#toolbar-container',
                                            toolbar: toolbarOptions
                                        },

                                        theme: 'snow'
                                    });


                                    var toolbar = quill.getModule('toolbar');
                                    toolbar.addHandler('italic', function(obj,data2){
                                        return true;
                                    });
                                });

                            </script>

                    </div>

                    <%--<table>
                        <tr>
                            &lt;%&ndash;<th>제목 <input type="checkbox" name="not" id="not"><label for="not">공지</label></th>&ndash;%&gt;

                            <td colspan="2"><input type="text" placeholder="제목을 입력하세요"></td>
                        </tr>
                        <tr>
                            <td colspan="2">

                            </td>
                        </tr>
                       &lt;%&ndash; <tr>
                            <th class="non">관련링크</th>
                            <td class="non"><input type="text"></td>
                        </tr>
                        <tr>
                            <th class="non">첨부파일1</th>
                            <td class="non"><input type="file"></td>
                        </tr>
                        <tr>
                            <th>첨부파일2</th>
                            <td><input type="file"></td>
                        </tr>&ndash;%&gt;
                    </table>--%>
                </div>

                <div class="not_btn">
                    <a href="javascript:;" class="on">작성완료</a>
                    <a href="javascript:;">작성취소</a>
                </div>




            </div><!-------------//manage_conts------------->

        </div>
    </div>
</form>