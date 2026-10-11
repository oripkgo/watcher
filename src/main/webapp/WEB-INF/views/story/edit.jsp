```
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-edit.css"/>

<!-- Toast UI Editor CDN (CSS 및 JS) -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<!-- WYSIWYG 이미지 드래그 리사이징 UI -->
<style>
  #editor { position: relative; }
  #editor-image-resize-handle {
    position: fixed;
    width: 12px;
    height: 12px;
    background: #2563eb;
    border: 2px solid #fff;
    border-radius: 3px;
    box-shadow: 0 1px 4px rgba(0,0,0,.3);
    z-index: 99999;
    cursor: nwse-resize;
    display: none;
    touch-action: none;
  }
  #editor-image-resize-outline {
    position: fixed;
    border: 1px dashed #2563eb;
    pointer-events: none;
    z-index: 99998;
    display: none;
    box-sizing: border-box;
  }
  #editor .toastui-editor-ww-container img { cursor: pointer; }
</style>

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

  // Toast UI의 내부 편집 모델은 DOM에서 직접 바꾼 이미지 크기를 저장 시 버릴 수 있으므로,
  // 이미지 순서별 크기를 별도로 보관해 저장 HTML과 수정 화면에 다시 적용합니다.
  const imageSizeOverrides = new Map();

  function getEditorImages() {
    return Array.from(document.querySelectorAll('#editor .toastui-editor-ww-container img'));
  }

  function getImageWidthFromMarkup(img) {
    if (!img) return null;
    const styleWidth = img.style && img.style.width ? parseFloat(img.style.width) : NaN;
    const attrWidth = img.getAttribute('width') ? parseFloat(img.getAttribute('width')) : NaN;
    const width = Number.isFinite(styleWidth) && styleWidth > 0 ? styleWidth : attrWidth;
    return Number.isFinite(width) && width > 0 ? Math.round(width) : null;
  }

  function rememberImageSizesFromMarkup(html) {
    const holder = document.createElement('div');
    holder.innerHTML = html || '';
    Array.from(holder.querySelectorAll('img')).forEach(function(img, index) {
      const width = getImageWidthFromMarkup(img);
      if (width) imageSizeOverrides.set(index, width);
    });
  }

  function applyImageSizeOverridesToEditor() {
    getEditorImages().forEach(function(img, index) {
      const width = imageSizeOverrides.get(index);
      if (!width) return;
      img.setAttribute('width', String(width));
      img.style.width = width + 'px';
      img.style.height = 'auto';
      img.style.maxWidth = '100%';
    });
  }

  function applyImageSizeOverridesToHtml(html) {
    const holder = document.createElement('div');
    holder.innerHTML = html || '';
    Array.from(holder.querySelectorAll('img')).forEach(function(img, index) {
      const width = imageSizeOverrides.get(index);
      if (!width) return;
      img.setAttribute('width', String(width));
      img.style.width = width + 'px';
      img.style.height = 'auto';
      img.style.maxWidth = '100%';
    });
    return holder.innerHTML;
  }

  function insertStory() {
    if ($("#story_category").val() == '') {
      comm.message.alert("카테고리를 선택해주세요.");
      return;
    }

    if ($("#title").val() == '') {
      comm.message.alert("제목을 입력해주세요.");
      return;
    }

    const editorContent = applyImageSizeOverridesToHtml(editor.getHTML());
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

  // -------------------------------------------------------------
  // 본문 이미지 드래그 리사이징
  // 마크다운 탭에서 내용을 붙여넣은 뒤 WYSIWYG 탭으로 전환하면
  // 이미지 모서리 핸들을 드래그해 크기를 조절할 수 있습니다.
  // -------------------------------------------------------------
  let selectedResizeImage = null;
  let resizeStartX = 0;
  let resizeStartWidth = 0;
  let resizeStartHeight = 0;
  let resizeActive = false;
  let resizeHandle = null;
  let resizeOutline = null;

  function ensureResizeControls() {
    if (!resizeHandle) {
      resizeHandle = document.createElement('div');
      resizeHandle.id = 'editor-image-resize-handle';
      resizeHandle.setAttribute('title', '드래그하여 이미지 크기 조절');
      document.body.appendChild(resizeHandle);
      resizeHandle.addEventListener('pointerdown', beginImageResize);
    }
    if (!resizeOutline) {
      resizeOutline = document.createElement('div');
      resizeOutline.id = 'editor-image-resize-outline';
      document.body.appendChild(resizeOutline);
    }
  }

  function positionResizeControls() {
    if (!selectedResizeImage || !selectedResizeImage.isConnected) {
      hideResizeControls();
      return;
    }
    ensureResizeControls();
    const rect = selectedResizeImage.getBoundingClientRect();
    resizeHandle.style.left = (rect.right - 7) + 'px';
    resizeHandle.style.top = (rect.bottom - 7) + 'px';
    resizeOutline.style.left = rect.left + 'px';
    resizeOutline.style.top = rect.top + 'px';
    resizeOutline.style.width = rect.width + 'px';
    resizeOutline.style.height = rect.height + 'px';
    resizeHandle.style.display = 'block';
    resizeOutline.style.display = 'block';
  }

  function hideResizeControls() {
    selectedResizeImage = null;
    if (resizeHandle) resizeHandle.style.display = 'none';
    if (resizeOutline) resizeOutline.style.display = 'none';
  }

  function beginImageResize(e) {
    if (!selectedResizeImage) return;
    e.preventDefault();
    e.stopPropagation();
    resizeActive = true;
    resizeStartX = e.clientX;
    const rect = selectedResizeImage.getBoundingClientRect();
    resizeStartWidth = rect.width;
    resizeStartHeight = rect.height;
    resizeHandle.setPointerCapture(e.pointerId);
    document.addEventListener('pointermove', performImageResize);
    document.addEventListener('pointerup', endImageResize, { once: true });
    document.addEventListener('pointercancel', endImageResize, { once: true });
  }

  function performImageResize(e) {
    if (!resizeActive || !selectedResizeImage) return;
    const editorArea = document.querySelector('#editor .toastui-editor-ww-container');
    const maxWidth = editorArea ? Math.max(80, editorArea.clientWidth - 32) : 1200;
    const nextWidth = Math.max(80, Math.min(maxWidth, resizeStartWidth + (e.clientX - resizeStartX)));
    const nextHeight = resizeStartWidth > 0 ? resizeStartHeight * (nextWidth / resizeStartWidth) : resizeStartHeight;
    const images = getEditorImages();
    const imageIndex = images.indexOf(selectedResizeImage);
    if (imageIndex >= 0) imageSizeOverrides.set(imageIndex, Math.round(nextWidth));

    // 화면에도 적용하고, 저장 시 내부 편집 모델이 크기를 버리는 경우를 대비해 별도 보관합니다.
    selectedResizeImage.setAttribute('width', String(Math.round(nextWidth)));
    selectedResizeImage.setAttribute('height', String(Math.round(nextHeight)));
    selectedResizeImage.style.width = Math.round(nextWidth) + 'px';
    selectedResizeImage.style.height = 'auto';
    selectedResizeImage.style.maxWidth = '100%';
    positionResizeControls();
  }

  function endImageResize() {
    resizeActive = false;
    document.removeEventListener('pointermove', performImageResize);
    positionResizeControls();
  }

  function bindImageResizeEvents() {
    const editorRoot = document.querySelector('#editor');
    if (!editorRoot || editorRoot.dataset.resizeBound === 'true') return;
    editorRoot.dataset.resizeBound = 'true';

    editorRoot.addEventListener('click', function (e) {
      const img = e.target && e.target.closest ? e.target.closest('.toastui-editor-ww-container img') : null;
      if (img && editorRoot.contains(img)) {
        selectedResizeImage = img;
        positionResizeControls();
      } else if (!e.target.closest('#editor-image-resize-handle')) {
        hideResizeControls();
      }
    });

    editorRoot.addEventListener('input', function () {
      if (selectedResizeImage && !selectedResizeImage.isConnected) hideResizeControls();
    });
    window.addEventListener('scroll', positionResizeControls, true);
    window.addEventListener('resize', positionResizeControls);
  }

  const initEdit = function () {
    editor = new toastui.Editor({
      el: document.querySelector('#editor'),
      height: '400px',
      initialEditType: 'wysiwyg',
      previewStyle: 'vertical'
    });

    bindImageResizeEvents();

    const initialContent = $("#initialContentHolder").val() || '';
    if (initialContent.trim() !== '') {
      // 저장된 HTML에 들어 있는 이미지 크기를 먼저 읽고, Toast UI가 내용을 렌더링한 뒤 복원합니다.
      rememberImageSizesFromMarkup(initialContent);
      editor.setHTML(initialContent);
      window.setTimeout(function() {
        applyImageSizeOverridesToEditor();
      }, 0);
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
