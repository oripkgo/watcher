<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-edit.css"/>

<!-- Toast UI Editor CDN -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

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

  const initEditor = function () {
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

    const editorContent = editor.getHTML();
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