<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>

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
</script>

<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <div class="story_top">
                <select>
                    <option>카테고리</option>
                    <option>공지사항</option>
                    <option>스토리</option>
                </select>
            </div>
            <div class="story_tb">

                <div class="story_title"><input type="text" placeholder="제목을 입력하세요"></div>
                <div class="story_contents">
                    <textarea class="editor"></textarea>
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
