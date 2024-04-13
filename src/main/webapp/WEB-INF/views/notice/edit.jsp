<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Main Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>--%>


<!-- Place the first <script> tag in your HTML's <head> -->
<script src="https://cdn.tiny.cloud/1/x4lfthehuygci0gyh27r2085hd2z6pljljatiadlrrdcjpae/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>

<form id="notice_write_form">
    <input type="hidden" name="id" id="id">
    <input type="hidden" name="contents" id="contents">

    <div class="section uline2">
        <div class="ani-in manage_layout">
            <div class="manage_conts">
                <div class="notice_tb">
                    <table>
                        <tbody>
                        <tr>
                            <th>공개여부</th>
                            <td class="notice_top">
                                <select id="secretYn" name="secretYn">
                                    <option value="N">공개</option>
                                    <option value="Y">비공개</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td><input type="text" name="title" id="title" placeholder="제목을 입력하세요">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div id="editor" class="editor" style="height:400px;font-size:14px;">
                                    ${view['CONTENTS']}
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="non">첨부파일1</th>
                            <td class="non notice_thumbnailImg">
                                <label for="attachFiles" class="input-file-button">파일 첨부</label>
                                <input type="file" name="attachFiles" id="attachFiles"
                                       accept="image/gif, image/jpeg, image/png">
                                <input type="text" disabled name="attachFiles_text"
                                       id="attachFiles_text" placeholder="첨부파일을 선택하세요">
                            </td>
                        </tr>
                        </tbody>
                    </table>

                </div>

                <div class="not_btn">
                    <a href="javascript:;" class="on write_confirm" onclick="insert();">작성완료</a>
                    <a href="javascript:;" class="write_cancel" onclick="window.history.back();">작성취소</a>
                </div>
            </div><!-------------//manage_conts------------->
        </div>
    </div>
</form>

<script>

    const type = 'NOTICE';
    const id = '${view['ID']}';
    const title = '${view['TITLE']}';
    const thumbnail = '${view['THUMBNAIL_IMG_PATH']}';
    const secretYn = '${view['SECRET_YN']}';
    const insertUrl = "/notice/insert";
    const imgSaveUrl = "/file/upload/image";
    const editerId = '#editor';
    const toolbarOptions = {
        selector: editerId,
        skin: 'material-outline',
        content_css: 'material-outline',
        icons: 'material',
        plugins: 'code image link lists',
        toolbar: 'undo redo | styles | bold italic underline forecolor backcolor | link image code | align | bullist numlist',
        menubar: false,
        forced_root_block:'div'
    };


    const initEditer = function (id, option) {
        tinymce.init(option);
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


    const insert = function () {
        if ($("#title").val() == '') {
            comm.message.alert("제목을 입력해주세요.");
            return;
        }

        tinymce.triggerSave();

        $("#id").val(id);
        changeImagePathToS3Path($(editerId).find("img"));
        $("#contents").val($(editerId).html());

        comm.dom.appendInput('#notice_write_form', 'summary', String($(".ql-editor", "#editor").text()).substring(0, 200));
        comm.dom.appendInput('#notice_write_form', 'regId', window.loginId);
        comm.dom.appendInput('#notice_write_form', 'uptId', window.loginId);

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
        if( id ){
            $("#title").val(title);
            $("#attachFiles_text").val(thumbnail)
            $("#secretYn").val(secretYn);
        }

        initEditer(editerId, toolbarOptions);

        $("#attachFiles").on("change", function () {
            $("#attachFiles_text").val(this.value);
        });
    })

</script>