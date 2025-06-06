<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../common/include/tinymceEditor.jsp"/>

<form id="story_write_form">

  <input type="hidden"      name="id"                  id="id"                  value="${view.id}"                >
  <input type="hidden"      name="categoryId"          id="categoryId"                                            >
  <input type="hidden"      name="memberCategoryId"    id="memberCategoryId"                                      >
  <input type="hidden"      name="contents"            id="contents"                                              >
  <input type="hidden"      name="editPermId"          id="editPermId"          value="${storyParam.editPermId}"  >

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
                <div id="editor" class="editor" style="height: 400px;">
                  ${view.contents}
                </div>
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

<form id="nextPageForm" method="get">
  <input type="hidden" name="id" value="">
  <input type="hidden" name="referrerPage" value="${storyParam.referrerPage}">
</form>

<script>

  const memId = '${storyAdminMemId}';
  const id = '${view.id}';
  const categoryId = '${view.categoryId}';
  const memberCategoryId = '${view.memberCategoryId}';
  const secretYn = '${view.secretYn}' || 'N';
  const title = '${view.title}';
  const tags = '${view.tags}';
  const realFileName = '${view.realFileName}';
  const insertUrl = "/story/insert";
  const imgSaveUrl = "/file/upload/image";

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

    comm.dom.appendInput('#story_write_form', 'summary' ,String($(".ql-editor","#editor").text()).substring(0,200)  );

    changeImagePathToS3Path($(editerId).find("img"));
    $("#contents").val($(editerId).html());


    var form = $('#story_write_form')[0]
    var formData = new FormData(form);

    comm.request({
      url: insertUrl,
      data : formData,
      processData : false,
      contentType : false,
    },function(res){
      // 성공
      if( res.code == '0000' ){
        comm.message.alert('스토리가 '+(id?'수정':'등록')+'되었습니다.', function(){
          $("#nextPageForm").attr("action", window.getStoryViewUrl(memId))
          $("#nextPageForm").find("[name='id']").val(res['storyId']);
          $("#nextPageForm").submit();
        });
      }
    })
  }

  const changeImagePathToS3Path = function (imgs) {
    $(imgs).each(function () {
      const img = this;
      const src = $(img).attr("src");
      if(
          // src.indexOf('watcher-bucket.s3.ap-northeast-2.amazonaws.com') > -1 ||
          !src.startsWith('data:image')
      ){
        return;
      }

      const param = {
        id: src,
        base64Img: src,
      }

      comm.request({url: imgSaveUrl, method: "POST", data: JSON.stringify(param), async: false}, function (resp) {
        // 수정 성공
        if (resp.code == '0000') {
          $(img).attr("src", resp.path);
        }
      })
    })
  }

  const setCategoryOptions = function(){
    const categoryList = comm.category.get();
    categoryList.forEach(function(obj){
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

    const categoryListMember = comm.category.getMemberPublic(memId);
    categoryListMember.forEach(function(obj){
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

  const initEdit = function(){
    webEdit.setCodeFrame();
    webEdit.init();
  }

  const addEvents = function(){
    $(".write_confirm").on("click",function(){
      webEdit.save();
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

  initEdit();
  setCategoryOptions();
  setValue();
  addEvents();

  $(document).on("ready", function(){

    $("#story_category").val(categoryId);
    $("#story_category").change();
    $("#story_category_member").val(memberCategoryId);
    $("#secretYn").val(secretYn);
    $("#title").val(title);
    // $("#editor").html(contents);
    $("#tags").val(tags);
    $("#thumbnailImgPathParam_text").val(realFileName);

  })
</script>
