<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-edit.css"/>

<jsp:include page="../common/include/tinymceEditor.jsp"/>


<div class="container">
    <main>
        <div class="editor-container">

            <div class="back-btn-container">
                <button type="button" class="back-btn" onclick="history.back()">이전으로 돌아가기</button>
            </div>

            <form id="story_write_form">

                <input type="hidden" name="id" id="id" value="${view.id}">
                <input type="hidden" name="categoryId" id="categoryId">
                <input type="hidden" name="memberCategoryId" id="memberCategoryId">
                <input type="hidden" name="contents" id="contents">
                <input type="hidden" name="editPermId" id="editPermId"
                       value="${storyParam.editPermId}">
                <input type="hidden" name="tags" id="tags">
                <input type="hidden" name="summary" id="summary">


                <!-- 카테고리 선택 -->
                <div class="form-group">
                    <select id="story_category" class="category-select" required>
                        <option value="">선택</option>
                    </select>
                </div>

                <!-- 회원 카테고리 선택 -->
                <div class="form-group">
                    <select id="story_category_member" class="category-select">
                        <option value="">선택</option>
                    </select>
                </div>

                <!-- 공개 여부 -->
                <div class="form-group">
                    <select id="secretYn" name="secretYn" class="category-select" required>
                        <option value="N">공개</option>
                        <option value="Y">비공개</option>
                    </select>
                </div>


                <!-- 제목 -->
                <div class="form-group">
                    <input type="text" id="title" name="title" placeholder="스토리 제목을 입력하세요"
                           required/>
                </div>

                <!-- 본문 -->
                <div class="form-group">
                    <div id="editor" class="editor" style="height: 400px;">
                        ${view.contents}
                    </div>
                </div>

                <!-- 태그 -->
                <div class="form-group">
                    <input type="text" id="tagInput" placeholder="태그 입력 후 Enter"/>
                    <div class="tag-input" id="tagList"></div>
                </div>

                <!-- 썸네일 -->
                <div class="form-group">
                    <div class="custom-checkbox-group">
                        <input type="checkbox" id="enableThumbnail" class="custom-checkbox"/>
                        <label for="enableThumbnail" class="checkbox-label">
                            <span class="checkbox-custom"></span>
                            대표 이미지 추가하기
                        </label>
                    </div>

                </div>


                <!-- 썸네일 업로드 박스 -->
                <div class="form-group">
                    <div class="thumbnail-box" id="thumbnailBox" style="display:none;">
                        클릭 또는 드래그하여 이미지 업로드
                        <input type="file" name="thumbnailImgPathParam" id="thumbnailImgPathParam"
                               accept="image/*" style="display: none;"/>
                        <div id="thumbnail-preview"></div>
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="confirm-btn-area">
                    <button type="button" class="submit-btn" onclick="insertStory()">스토리 게시</button>
                </div>
            </form>
        </div>
    </main>
</div>


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

  function insertStory() {
    if ($("#story_category").val() == '') {
      comm.message.alert("카테고리를 선택해주세요.");
      return;
    }

    if ($("#title").val() == '') {
      comm.message.alert("제목을 입력해주세요.");
      return;
    }

    const editorContent = tinymce.get('editor').getContent();
    const editorText = tinymce.get('editor').getContent({format: 'text'});

    $("#categoryId").val($("#story_category").val());
    $("#memberCategoryId").val($("#story_category_member").val());
    $("#summary").val(String(editorText).substring(0, 200));

    // 이미지 경로 처리 (S3 변환)
    // 에디터 내용을 가상 DOM으로 만들어 이미지 처리 루프 실행
    const $tempDiv = $('<div>').html(editorContent);
    changeImagePathToS3Path($tempDiv.find("img"));

    // 변환된 HTML을 hidden input에 넣기
    $("#contents").val($tempDiv.html());

    // 5. 태그 세팅
    $("#tags").val(Array.from(tagsSet).join(','));

    var form = $('#story_write_form')[0]
    var formData = new FormData(form);

    comm.request({
      url: insertUrl,
      data: formData,
      processData: false,
      contentType: false,
    }, function (res) {
      // 성공
      if (res.code == '0000') {
        comm.message.alert('스토리가 ' + (id ? '수정' : '등록') + '되었습니다.', function () {
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
      if (
          // src.indexOf('watcher-bucket.s3.ap-northeast-2.amazonaws.com') > -1 ||
          !src.startsWith('data:image')
      ) {
        return;
      }

      const param = {
        id: src,
        base64Img: src,
      }

      comm.request({url: imgSaveUrl, method: "POST", data: JSON.stringify(param), async: false},
          function (resp) {
            // 수정 성공
            if (resp.code == '0000') {
              $(img).attr("src", resp.path);
            }
          })
    })
  }

  const setCategoryOptions = function () {
    const categoryList = comm.category.get();
    categoryList.forEach(function (obj) {
      let option = $("<option></option>");

      option.attr("value", obj['ID']);
      option.text(obj['CATEGORY_NM']);

      option.data(obj);
      $("#story_category").append(option);
    });
  }

  const setCategoryMemberOptions = function (defaultCategoryId) {
    $("#story_category_member").empty();
    $("#story_category_member").html("<option value=''>선택</option>")

    const categoryListMember = comm.category.getMemberPublic(memId);
    categoryListMember.forEach(function (obj) {
      if (obj['DEFALUT_CATEG_ID'] != defaultCategoryId) {
        return;
      }

      let option = $("<option></option>");

      option.attr("value", obj['ID']);
      option.text(obj['CATEGORY_NM']);

      option.data(obj);
      $("#story_category_member").append(option);
    });
  }

  const setValue = function () {
    $("#story_category").val(categoryId);
  }

  const initEdit = function () {
    webEdit.setCodeFrame();
    webEdit.init();
  }

  const addEvents = function () {
    $(".write_confirm").on("click", function () {
      webEdit.save();
      insertStory();
    });

    $(".write_cancel").on("click", function () {
      history.back();
    });

    $("#thumbnailImgPathParam").on("change", function () {
      $("#thumbnailImgPathParam_text").val(this.value);
    });

    $("#story_category").on("change", function () {
      setCategoryMemberOptions($(this).val());
    })
  }

  // 썸네일 미리보기 및 드래그 앤 드롭 처리
  const enableThumbnailCheckbox = document.getElementById('enableThumbnail');
  const thumbnailInput = document.getElementById('thumbnailImgPathParam');
  const thumbnailBox = document.getElementById('thumbnailBox');
  const preview = document.getElementById('thumbnail-preview');

  enableThumbnailCheckbox.addEventListener('change', () => {
    if (enableThumbnailCheckbox.checked) {
      thumbnailBox.style.display = 'block';
    } else {
      thumbnailBox.style.display = 'none';
      // 선택된 이미지 초기화
      thumbnailInput.value = '';
      preview.innerHTML = '';
    }
  });

  function showThumbnail(file) {
    if (!file || !file.type.startsWith('image/')) return;

    const reader = new FileReader();
    reader.onload = function (e) {
      preview.innerHTML = `<img src="\${e.target.result}" alt="썸네일 미리보기">`;
    };
    reader.readAsDataURL(file);
  }

  function setTag(value) {
    if (!tagsSet.has(value)) {
      tagsSet.add(value);
      const chip = document.createElement('div');
      chip.className = 'tag-chip';
      chip.innerHTML = `\${value}<span onclick="this.parentElement.remove(); tagsSet.delete('\${value}')">×</span>`;
      tagList.prepend(chip);
    }
  }

  thumbnailInput.addEventListener('change', function () {
    const file = this.files[0];
    showThumbnail(file);
  });

  // 드래그 앤 드롭
  ['dragenter', 'dragover'].forEach(eventName => {
    thumbnailBox.addEventListener(eventName, (e) => {
      e.preventDefault();
      thumbnailBox.classList.add('dragover');
    });
  });

  ['dragleave', 'drop'].forEach(eventName => {
    thumbnailBox.addEventListener(eventName, (e) => {
      e.preventDefault();
      thumbnailBox.classList.remove('dragover');
    });
  });

  thumbnailBox.addEventListener('drop', (e) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (file) {
      thumbnailInput.files = e.dataTransfer.files;
      showThumbnail(file);
    }
  });

  thumbnailBox.addEventListener('click', () => {
    thumbnailInput.click();
  });

  // 태그 입력
  const tagInput = document.getElementById('tagInput');
  const tagList = document.getElementById('tagList');
  const tagsSet = new Set();

  tagInput.addEventListener('keydown', function (e) {
    if (e.key === 'Enter' && this.value.trim() !== '') {
      e.preventDefault();
      const value = this.value.trim();
      setTag(value);
      this.value = '';
    }
  });

  // document.getElementById('story_write_form').addEventListener('submit', function (e) {
  //   e.preventDefault();
  //   // 서버 연동은 여기에 추가
  //   insertStory();
  // });

  initEdit();
  setCategoryOptions();
  setValue();
  addEvents();

  $(document).on("ready", function () {

    $("#story_category").val(categoryId);
    $("#story_category").change();
    $("#story_category_member").val(memberCategoryId);
    $("#secretYn").val(secretYn);
    $("#title").val(title);
    // $("#editor").html(contents);

    if (tags) {
      for (const tag of tags.split(',')) {
        if (tag) {
          setTag(tag)
        }
      }
    }

    $("#thumbnailImgPathParam_text").val(realFileName);

  })

</script>

