<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-edit.css"/>

<!-- Toast UI Editor CDN (CSS 및 JS) -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

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
                <input type="hidden" name="editPermId" id="editPermId" value="${storyParam.editPermId}">
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
                    <input type="text" id="title" name="title" placeholder="스토리 제목을 입력하세요" required/>
                </div>

                <!-- 본문 (Toast UI Editor가 렌더링될 영역) -->
                <div class="form-group">
                    <div id="editor"></div>
                </div>

                <!-- 태그 -->
                <div class="form-group">
                    <input type="text" id="tagInput" placeholder="태그 입력 후 Enter"/>
                    <div class="tag-input" id="tagList"></div>
                </div>

                <!-- 썸네일 체크박스 -->
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
                        <input type="file" name="thumbnailImgPathParam" id="thumbnailImgPathParam" accept="image/*" style="display: none;"/>
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

<textarea id="initialContentHolder" style="display:none;"><c:out value="${view.contents}" escapeXml="false"/></textarea>

<script>
  let editor;

  const memId = '${storyAdminMemId}';
  const id = '${view.id}';
  const categoryId = '${view.categoryId}';
  const memberCategoryId = '${view.memberCategoryId}';
  const secretYn = '${view.secretYn}' || 'N';
  const title = '<c:out value="${view.title}"/>';
  const tags = '<c:out value="${view.tags}"/>';
  const realFileName = '<c:out value="${view.realFileName}"/>';
  const thumbnailImgPath = '<c:out value="${view.thumbnailImgPath}"/>';
  const insertUrl = "/story/insert";
  const imgSaveUrl = "/file/upload/image";

  const tagsSet = new Set();

  function insertStory() {
    if ($("#story_category").val() == '') {
      comm.message.alert("카테고리를 선택해주세요.");
      return;
    }

    if ($("#title").val() == '') {
      comm.message.alert("제목을 입력해주세요.");
      return;
    }

    const editorContent = editor.getHTML();
    const editorText = editorContent.replace(/<[^>]*>?/g, '');

    $("#categoryId").val($("#story_category").val());
    $("#memberCategoryId").val($("#story_category_member").val());
    $("#summary").val(String(editorText).substring(0, 200));

    const $tempDiv = $('<div>').html(editorContent);
    changeImagePathToS3Path($tempDiv.find("img"));

    $("#contents").val($tempDiv.html());
    $("#tags").val(Array.from(tagsSet).join(','));

    var form = $('#story_write_form')[0];
    var formData = new FormData(form);

    comm.request({
      url: insertUrl,
      data: formData,
      processData: false,
      contentType: false,
    }, function (res) {
      if (res.code == '0000') {
        comm.message.alert('스토리가 ' + (id ? '수정' : '등록') + '되었습니다.', function () {
          $("#nextPageForm").attr("action", window.getStoryViewUrl(memId));
          $("#nextPageForm").find("[name='id']").val(res['storyId']);
          $("#nextPageForm").submit();
        });
      }
    });
  }

  const changeImagePathToS3Path = function (imgs) {
    $(imgs).each(function () {
      const img = this;
      const src = $(img).attr("src");
      if (!src || !src.startsWith('data:image')) {
        return;
      }

      const param = {
        id: src,
        base64Img: src,
      };

      comm.request({url: imgSaveUrl, method: "POST", data: JSON.stringify(param), async: false},
          function (resp) {
            if (resp.code == '0000') {
              $(img).attr("src", resp.path);
            }
          });
    });
  };

  const setCategoryOptions = function () {
    const categoryList = comm.category.get();
    categoryList.forEach(function (obj) {
      let option = $("<option></option>");
      option.attr("value", obj['ID']);
      option.text(obj['CATEGORY_NM']);
      option.data(obj);
      $("#story_category").append(option);
    });
  };

  const setCategoryMemberOptions = function (defaultCategoryId) {
    $("#story_category_member").empty();
    $("#story_category_member").html("<option value=''>선택</option>");

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
  };

  const setValue = function () {
    $("#story_category").val(categoryId);
  };

  const initEdit = function () {
    editor = new toastui.Editor({
      el: document.querySelector('#editor'),
      height: '400px',
      initialEditType: 'wysiwyg',
      previewStyle: 'vertical'
    });

    const initialContent = $("#initialContentHolder").val() || '';
    if (initialContent.trim() !== '') {
      editor.setHTML(initialContent);
    }
  };

  const addEvents = function () {
    $(".write_confirm").on("click", function () {
      insertStory();
    });

    $(".write_cancel").on("click", function () {
      history.back();
    });

    $("#story_category").on("change", function () {
      setCategoryMemberOptions($(this).val());
    });
  };

  // -------------------------------------------------------------
  // 썸네일 관련 처리
  // -------------------------------------------------------------
  const enableThumbnailCheckbox = document.getElementById('enableThumbnail');
  const thumbnailInput = document.getElementById('thumbnailImgPathParam');
  const thumbnailBox = document.getElementById('thumbnailBox');
  const preview = document.getElementById('thumbnail-preview');

  enableThumbnailCheckbox.addEventListener('change', () => {
    if (enableThumbnailCheckbox.checked) {
      thumbnailBox.style.display = 'block';
    } else {
      thumbnailBox.style.display = 'none';
      thumbnailInput.value = '';
      preview.innerHTML = '';
    }
  });

  function showThumbnail(file) {
    if (!file || !file.type.startsWith('image/')) return;

    const reader = new FileReader();
    reader.onload = function (e) {
      // DOM 조작 방식으로 안전하게 이미지 요소 생성 (JSP 백틱문법 파싱 이슈 방지)
      preview.innerHTML = '';
      const img = document.createElement('img');
      img.src = e.target.result;
      img.alt = '썸네일 미리보기';
      img.style.maxWidth = '100%';
      img.style.maxHeight = '200px';
      img.style.marginTop = '10px';
      preview.appendChild(img);
    };
    reader.readAsDataURL(file);
  }

  // 박스 클릭 시 input 호출 (input 자식 요소 중복 클릭 방지)
  thumbnailBox.addEventListener('click', (e) => {
    if (e.target !== thumbnailInput) {
      thumbnailInput.click();
    }
  });

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
    thumbnailBox.classList.remove('dragover');
    const file = e.dataTransfer.files[0];
    if (file) {
      thumbnailInput.files = e.dataTransfer.files;
      showThumbnail(file);
    }
  });

  // -------------------------------------------------------------
  // 태그 입력 처리
  // -------------------------------------------------------------
  const tagInput = document.getElementById('tagInput');
  const tagList = document.getElementById('tagList');

  function removeTag(tagValue, element) {
    tagsSet.delete(tagValue);
    element.parentElement.remove();
  }

  function setTag(value) {
    const trimmed = value.trim();
    if (trimmed !== '' && !tagsSet.has(trimmed)) {
      tagsSet.add(trimmed);
      const chip = document.createElement('div');
      chip.className = 'tag-chip';

      const textSpan = document.createElement('span');
      textSpan.textContent = trimmed + ' ';

      const removeBtn = document.createElement('span');
      removeBtn.innerHTML = '&times;';
      removeBtn.style.cursor = 'pointer';
      removeBtn.onclick = function() {
        removeTag(trimmed, this);
      };

      chip.appendChild(textSpan);
      chip.appendChild(removeBtn);
      tagList.appendChild(chip);
    }
  }

  tagInput.addEventListener('keydown', function (e) {
    if (e.key === 'Enter' && this.value.trim() !== '') {
      e.preventDefault();
      setTag(this.value);
      this.value = '';
    }
  });

  initEdit();
  setCategoryOptions();
  setValue();
  addEvents();

  $(document).ready(function () {
    $("#story_category").val(categoryId);
    $("#story_category").change();
    $("#story_category_member").val(memberCategoryId);
    $("#secretYn").val(secretYn);
    $("#title").val(title);

    // 태그 초기화
    if (tags) {
      tags.split(',').forEach(function(tag) {
        if (tag.trim() !== '') {
          setTag(tag.trim());
        }
      });
    }

    // 수정 모드: 기존 썸네일 복원
    if (thumbnailImgPath || realFileName) {
      enableThumbnailCheckbox.checked = true;
      thumbnailBox.style.display = 'block';
      if (thumbnailImgPath) {
        preview.innerHTML = '';
        const img = document.createElement('img');
        img.src = thumbnailImgPath;
        img.alt = '기존 썸네일';
        img.style.maxWidth = '100%';
        img.style.maxHeight = '200px';
        img.style.marginTop = '10px';
        preview.appendChild(img);
      }
    }
  });
</script>