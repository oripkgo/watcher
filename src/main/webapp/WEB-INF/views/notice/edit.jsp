<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-edit.css"/>

<!-- Toast UI Editor CDN -->
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

            <form id="notice_write_form">
                <input type="hidden" name="id" id="id">
                <input type="hidden" name="contents" id="contents">
                <input type="hidden" name="editPermId" id="editPermId" value="${noticeParam.editPermId}">
                <input type="hidden" name="summary" id="summary">

                <!-- 공개 여부 -->
                <div class="form-group">
                    <select id="secretYn" name="secretYn" class="category-select" required>
                        <option value="N">공개</option>
                        <option value="Y">비공개</option>
                    </select>
                </div>

                <!-- 제목 -->
                <div class="form-group">
                    <input type="text" name="title" id="title" placeholder="제목을 입력하세요">
                </div>

                <!-- 본문 (Toast UI Editor 영역) -->
                <div class="form-group">
                    <div id="editor"></div>
                </div>

                <!-- 버튼 -->
                <div class="confirm-btn-area">
                    <button type="button" class="submit-btn" onclick="insert()">공지사항 게시</button>
                </div>
            </form>
        </div>
    </main>
</div>

<!-- 본문 HTML Escape 방지용 안전 영역 -->
<textarea id="initialContentHolder" style="display:none;"><c:out value="${view['CONTENTS']}" escapeXml="false"/></textarea>

<script>
  let editor;

  const type = 'NOTICE';
  const id = '${view['ID']}';
  const title = '<c:out value="${view['TITLE']}"/>';
  const secretYn = '${view['SECRET_YN']}' || 'N';
  const insertUrl = "/notice/insert";
  const imgSaveUrl = "/file/upload/image";

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


  const initEditor = function () {
    editor = new toastui.Editor({
      el: document.querySelector('#editor'),
      height: '400px',
      initialEditType: 'wysiwyg',
      previewStyle: 'vertical'
    });

    bindImageResizeEvents();

    const initialContent = $("#initialContentHolder").val() || '';
    if (initialContent.trim() !== '') {
      // 저장된 HTML에서 이미지 너비를 기억하고, Toast UI 렌더링 이후 복원합니다.
      rememberImageSizesFromMarkup(initialContent);
      editor.setHTML(initialContent);
      window.setTimeout(function() {
        applyImageSizeOverridesToEditor();
      }, 0);
    }
  };

  const changeImagePathToS3Path = function ($imgs) {
    $imgs.each(function () {
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

  const insert = function () {
    if ($("#title").val() == '') {
      comm.message.alert("제목을 입력해주세요.");
      return;
    }

    $("#id").val(id);

    const editorContent = applyImageSizeOverridesToHtml(editor.getHTML());
    const editorText = editorContent.replace(/<[^>]*>?/g, '');

    const $tempDiv = $('<div>').html(editorContent);
    changeImagePathToS3Path($tempDiv.find("img"));

    $("#contents").val($tempDiv.html());
    $("#summary").val(String(editorText).substring(0, 200));

    comm.dom.appendInput('#notice_write_form', 'regId', window.loginId);
    comm.dom.appendInput('#notice_write_form', 'uptId', window.loginId);

    const formData = new FormData($('#notice_write_form').get(0));

    comm.request({
      url: insertUrl,
      data: formData,
      processData: false,
      contentType: false,
    }, function (res) {
      if (res.code == '0000') {
        const msg = id ? '공지가 수정되었습니다.' : '공지가 등록되었습니다.';
        comm.message.alert(msg, function () {
          location.href = window.managementNotice;
        });
      }
    });
  };

  $(document).ready(function () {
    initEditor();

    if (id) {
      $("#title").val(title);
      $("#secretYn").val(secretYn);
    }
  });
</script>