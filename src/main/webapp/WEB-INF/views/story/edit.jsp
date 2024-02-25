<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-04
  Time: 오후 8:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Main Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>

<form id="story_write_form">

  <input type="hidden"      name="id"                  id="id"                 value="${view['ID']}"      >
  <input type="hidden"      name="tagsId"              id="tagsId"             value="${view['TAGS_ID']}" >
  <input type="hidden"      name="categoryId"          id="categoryId"                                    >
  <input type="hidden"      name="memberCategoryId"    id="memberCategoryId"                              >
  <input type="hidden"      name="contents"            id="contents"                                      >

  <div class="section uline2">
    <div class="ani-in manage_layout">

      <div class="manage_conts">

        <div class="story_tb">

          <table>
            <tbody>
            <tr>
              <th>카테고리</th>
              <td class="story_top">
                <select id="story_category">
                  <option value="">선택</option>
                </select>
              </td>
            </tr>
            <tr>
              <th>회원 카테고리</th>
              <td class="story_top">
                <select id="story_category_member">
                  <option value="">선택</option>
                </select>
              </td>
            </tr>
            <tr>
              <th>공개여부</th>
              <td class="story_top">
                <select id="secretYn" name="secretYn">
                  <option value="N">공개</option>
                  <option value="Y">비공개</option>
                </select>
              </td>
            </tr>
            <tr>
              <th>제목</th>
              <td><input type="text" name="title" id="title" placeholder="제목을 입력하세요"></td>
            </tr>
            <tr>
              <td colspan="2">
                <div id="editor" class="editor"></div>
              </td>
            </tr>
            <tr>
              <th class="non">태그</th>
              <td class="non"><input type="text" name="tags" id="tags" placeholder="태그를 입력하세요 (ex:태그1,태그2,태그3)"></td>
            </tr>
            <tr>
              <th class="non">첨부파일1</th>
              <td class="non story_thumbnailImg">
                <label for="thumbnailImgPathParam" class="input-file-button">썸네일 이미지</label>
                <input type="file" name="thumbnailImgPathParam" id="thumbnailImgPathParam" accept="image/gif, image/jpeg, image/png">
                <input type="text" disabled name="thumbnailImgPathParam_text" id="thumbnailImgPathParam_text" placeholder="썸네일 이미지를 선택하세요">
              </td>
            </tr>
            </tbody></table>

        </div>

        <div class="not_btn">
          <a href="javascript:;" class="on write_confirm">작성완료</a>
          <a href="javascript:;" class="write_cancel">작성취소</a>
        </div>

      </div><!-------------//manage_conts------------->

    </div>
  </div>
</form>

<script>
  const editerId = '#editor';
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


  const CATEGORY_LIST = comm.category.get();
  const CATEGORY_LIST_MEMBER = comm.category.getMemberPublic();

  const id = '${view['ID']}';
  const categoryId = '${view['CATEGORY_ID']}';
  const memberCategoryId = '${view['MEMBER_CATEGORY_ID']}';
  const secretYn = '${view['SECRET_YN']}' || 'N';
  const title = '${view['TITLE']}';
  const contents = '${view['CONTENTS']}';
  const tags = '${view['TAGS']}';
  const realFileName = '${view['REAL_FILE_NAME']}';

  const insertStory = function(){
    if($("#story_category").val() == ''){
      comm.message.alert("카테고리를 선택해주세요.");
      return;
    }

    if($("#title").val() == ''){
      comm.message.alert("제목을 입력해주세요.");
      return;
    }

    $("#categoryId").val($("#story_category").val());
    $("#memberCategoryId").val($("#story_category_member").val());
    $("#contents").val($(".ql-editor","#editor").html());

    comm.dom.appendInput('#story_write_form', 'summary' ,String($(".ql-editor","#editor").text()).substring(0,200)  );

    var form = $('#story_write_form')[0]
    var formData = new FormData(form);

    comm.request({
      url: "/story/insert",
      data : formData,
      processData : false,
      contentType : false,
    },function(res){
      // 성공
      if( res.code == '0000' ){
        comm.message.alert('스토리가 '+(id?'수정':'등록')+'되었습니다.', function(){
          location.href = window.getStoryViewUrl(res['storyId'], window.memberId);
        });
      }
    })
  }

  const setCategoryOptions = function(){
    CATEGORY_LIST.forEach(function(obj){
      let option = $("<option></option>");

      option.attr("value",obj['ID']);
      option.text(obj['CATEGORY_NM']);

      option.data(obj);
      $("#story_category").append(option);
    });
  }


  const setCategoryMemberOptions = function(defaultCategoryId){
    $("#story_category_member").empty();
    $("#story_category_member").html("<option value=''>선택</option>")
    CATEGORY_LIST_MEMBER.forEach(function(obj){
      if( obj['DEFALUT_CATEG_ID'] != defaultCategoryId ){
        return;
      }

      let option = $("<option></option>");

      option.attr("value",obj['ID']);
      option.text(obj['CATEGORY_NM']);

      option.data(obj);
      $("#story_category_member").append(option);
    });
  }


  const setValue = function(){
    $("#story_category").val(categoryId);
  }

  const initEdit = function(id, option){
    $(id).css({"height":"400px","font-size":"15px"});
    new window['Quill'](id, {

      modules: {
        //toolbar: '#toolbar-container',
        toolbar: option
      },

      theme: 'snow'
    });
  }

  const addEvents = function(){
    $(".write_confirm").on("click",function(){
      insertStory();
    });

    $(".write_cancel").on("click",function(){
      history.back();
    });

    $("#thumbnailImgPathParam").on("change",function(){
      $("#thumbnailImgPathParam_text").val(this.value);
    });

    $("#story_category").on("change",function(){
      setCategoryMemberOptions($(this).val());
    })
  }

  $(document).on("ready", function(){

    setCategoryOptions();
    setValue();
    addEvents();

    $("#story_category").val(categoryId);
    $("#story_category").change();
    $("#story_category_member").val(memberCategoryId);
    $("#secretYn").val(secretYn);
    $("#title").val(title);
    $("#editor").html(contents);
    $("#tags").val(tags);
    $("#thumbnailImgPathParam_text").val(realFileName);

    initEdit(editerId, toolbarOptions);

  })
</script>
