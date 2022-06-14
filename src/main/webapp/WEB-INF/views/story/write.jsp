<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Main Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script type="text/javascript">
    const contents_obj = '#contents';
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



<!-- Create the editor container -->
<div class="ql-editor" data-gramm="false" contenteditable="true" style=" border: 4px dashed #bcbcbc;">
    <h1>
        <strong>Hello <em>Wo</em>rld!</strong>
    </h1>
    <p>
        <strong>Some initial <p>bold</p> tex</strong>t
    </p>
    <p>
        <br>
    </p>
</div>


<script type="text/javascript">

    var selObj = window.getSelection();
    var first_tag = selObj.anchorNode.parentElement;
    var last_tag = selObj.focusNode.parentElement;
    var selRange = selObj.getRangeAt(0);
    var childChecker = function(obj, selRange_obj){
        let exec_yn = false;
        let startObj = selRange.startContainer;
        let startOffset = selRange.startOffset;
        let endObj = selRange.endContainer;
        let endOffset = selRange.endOffset;

        if( obj.childNodes.length > 0 ){
            obj.childNodes.forEach(function(nodeObj,index){

                if( nodeObj.childNodes.length > 0 ){
                    debugger;
                    childChecker(nodeObj, selRange_obj);
                }


                if( nodeObj === startObj ){
                    debugger;
                    exec_yn = true;
                }else if( nodeObj === endObj ){

                    exec_yn = false;
                    debugger;
                }else if( exec_yn ){

                }

            })
        }else{
            // 같은 요소를 블록으로 잡았을 경우

debugger;
            let html = obj.parentElement.innerHTML;
            let key = new Date().getTime();

            html = html.substring(0,startOffset) +'<em id="key_'+key+'">'+ html.substring(startOffset,endOffset) +'</em>' + html.substring(endOffset);


            /*
            obj.parentElement.innerHTML = html;

            document.getSelection().setBaseAndExtent(document.querySelector("#key_"+key),0,document.querySelector("#key_"+key),1);
*/
            obj.nodeValue = html;

        }

    };

</script>