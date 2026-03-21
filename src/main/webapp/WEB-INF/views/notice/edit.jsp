<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="/resources/css/story-edit.css"/>
<jsp:include page="../common/include/tinymceEditor.jsp"/>


<div class="container">
    <main>
        <div class="editor-container">

            <div class="back-btn-container">
                <button type="button" class="back-btn" onclick="history.back()">이전으로 돌아가기</button>
            </div>

            <form id="notice_write_form">
                <input type="hidden" name="id" id="id">
                <input type="hidden" name="contents" id="contents">
                <input type="hidden" name="editPermId" id="editPermId"
                       value="${noticeParam.editPermId}">
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

                <!-- 본문 -->
                <div class="form-group">
                    <div id="editor" class="editor" style="height: 400px;">
                        ${view['CONTENTS']}
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="confirm-btn-area">
                    <button type="button" class="submit-btn" onclick="insert()">공지사항 게시</button>
                </div>
            </form>
        </div>
    </main>
</div>


<script>

  const type = 'NOTICE';
  const id = '${view['ID']}';
  const title = '${view['TITLE']}';
  const thumbnail = '${view['THUMBNAIL_IMG_PATH']}';
  const secretYn = '${view['SECRET_YN']}';
  const insertUrl = "/notice/insert";
  const imgSaveUrl = "/file/upload/image";

  const initEditer = function () {
    webEdit.init();
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

  const insert = function () {
    if ($("#title").val() == '') {
      comm.message.alert("제목을 입력해주세요.");
      return;
    }

    webEdit.save();

    $("#id").val(id);

    const editorContent = tinymce.get('editor').getContent();
    const editorText = tinymce.get('editor').getContent({format: 'text'});

    changeImagePathToS3Path($(editerId).find("img"));
    $("#contents").val($(editerId).html());
    $("#summary").val(String(editorText).substring(0, 200));

    comm.dom.appendInput('#notice_write_form', 'regId', window.loginId);
    comm.dom.appendInput('#notice_write_form', 'uptId', window.loginId);

    // 이미지 경로 처리 (S3 변환)
    // 에디터 내용을 가상 DOM으로 만들어 이미지 처리 루프 실행
    const $tempDiv = $('<div>').html(editorContent);
    changeImagePathToS3Path($tempDiv.find("img"));

    // 변환된 HTML을 hidden input에 넣기
    $("#contents").val($tempDiv.html());

    const formData = new FormData($('#notice_write_form').get(0));

    comm.request({
      url: insertUrl,
      data: formData,
      // headers : {"Content-type":"application/x-www-form-urlencoded"},
      processData: false,
      contentType: false,
    }, function (res) {
      // 성공
      if (res.code == '0000') {
        if (id) {
          comm.message.alert('공지가 수정되었습니다.', function () {
            location.href = window.managementNotice;
          });
        } else {
          comm.message.alert('공지가 등록되었습니다.', function () {
            location.href = window.managementNotice;
          });
        }
      }
    })
  }

  $(document).on("ready", function () {
    if (id) {
      $("#title").val(title);
      $("#attachFiles_text").val(thumbnail)
      $("#secretYn").val(secretYn);
    }

    initEditer();

    $("#attachFiles").on("change", function () {
      $("#attachFiles_text").val(this.value);
    });
  })

</script>