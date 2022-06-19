<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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


    let category_list = JSON.parse('${category_list}');

    $(document).on("ready",function(){

        $(".write_confirm").on("click",function(){

            if($("#story_category").val() == ''){
                comm.message.alert("카테고리를 선택해주세요.");
                return;
            }

            if($("#title").val() == ''){
                comm.message.alert("제목을 입력해주세요.");
                return;
            }


            let category_obj = $("#story_category option:selected").data();

            if( category_obj['CATEGORY_TYPE'] == 'default' ){
               $("#categoryId").val(category_obj['ID']);
            }else{
                $("#categoryId").val(category_obj['DEFALUT_CATEG_ID']);
                $("#memberCategoryId").val(category_obj['ID']);
            }

            $("#contents").val($(".ql-editor","#editor").html());

            comm.appendInput('#story_write_form'    , 'summary' ,String($(".ql-editor","#editor").text()).substring(0,200)  );
            comm.appendInput('#story_write_form'    , 'regId'   ,loginId                            );
            comm.appendInput('#story_write_form'    , 'uptId'   ,loginId                            );

            comm.request({
                url: "/story/writeInsert",
                form : $("#story_write_form"),
                headers : {"Content-type":"application/x-www-form-urlencoded"}
            },function(res){
                // 성공

                if( res.code == '0000' ){
                    comm.message.alert('스토리가 등록되었습니다.', function(){
                        location.href="/story/list";
                    });
                }

            })

        });

        $(".write_cancel").on("click",function(){
            history.back();
        });


        $("#thumbnailImgPath").on("change",function(e){
            $("#thumbnailImgPath_text").val(this.value);
        });

        // <input type="file" name="thumbnailImgPath" id="thumbnailImgPath">
        //     <input type="text" name="thumbnailImgPath_text" id="thumbnailImgPath_text" placeholder="썸네일 이미지를 선택하세요">


        category_list.forEach(function(obj,idx){
            let option = $("<option></option>");

            option.attr("value",obj['ID']);
            option.text(obj['CATEGORY_NM']);

            option.data(obj);
            $("#story_category").append(option);

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


<form id="story_write_form">

    <input type="hidden" name="categoryId"          id="categoryId"         >
    <input type="hidden" name="memberCategoryId"    id="memberCategoryId"   >
    <input type="hidden" name="contents"            id="contents"           >

    <div class="section uline2">
        <div class="ani-in manage_layout">

            <div class="manage_conts">

                <div class="story_top">
                    <select id="story_category">
                        <option value="">카테고리</option>
                    </select>
                </div>

                <div class="story_tb">
                    <div class="story_thumbnailImg">
                        <label for="thumbnailImgPath" class="input-file-button">썸네일 이미지</label>
                        <input type="file" name="thumbnailImgPath" id="thumbnailImgPath" accept="image/gif, image/jpeg, image/png">
                        <input type="text" disabled name="thumbnailImgPath_text" id="thumbnailImgPath_text" placeholder="썸네일 이미지를 선택하세요">
                    </div>

                    <div class="story_title"><input type="text" name="title" id="title" placeholder="제목을 입력하세요"></div>
                    <div class="story_contents">
                        <%--<textarea class="editor" id="contents" name="contents"></textarea>--%>

                        <div id="editor" class="editor"></div>

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
                <div class="story_tag"><input type="text" name="tags" id="tags" placeholder="태그를 입력하세요 (ex:태그1,태그2,태그3)"></div>

                <div class="not_btn">
                    <a href="javascript:;" class="on write_confirm">작성완료</a>
                    <a href="javascript:;" class="write_cancel">작성취소</a>
                </div>




            </div><!-------------//manage_conts------------->

        </div>
    </div>
</form>

