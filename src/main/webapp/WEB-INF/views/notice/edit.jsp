<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Main Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>

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
                                <div id="editor" class="editor" style="height:400px;font-size:14px;"></div>
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

    const title = '${view['TITLE']}';
    const contents = '${view['CONTENTS']}';
    const thumbnail = '${view['THUMBNAIL_IMG_PATH']}';
    const secretYn = '${view['SECRET_YN']}';

    const id = '${view['ID']}';
    const type = 'NOTICE';
    const viewApiUrl = '/notice/view/api';
    const insertUrl = "/notice/insert";
    const editerId = '#editor';
    const toolbarOptions = [
        ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
        ['blockquote', 'code-block'],

        [{'header': 1}, {'header': 2}],               // custom button values
        [{'list': 'ordered'}, {'list': 'bullet'}],
        [{'script': 'sub'}, {'script': 'super'}],      // superscript/subscript
        [{'indent': '-1'}, {'indent': '+1'}],          // outdent/indent
        [{'direction': 'rtl'}],                         // text direction

        [{'size': ['small', false, 'large', 'huge']}],  // custom dropdown
        [{'header': [1, 2, 3, 4, 5, 6, false]}],

        [{'color': []}, {'background': []}],          // dropdown with defaults from theme
        [{'font': []}],
        [{'align': []}],

        ['clean']                                         // remove formatting button
    ];

    const getNoticeInfo = function (id, callback) {
        let data = {id: id};
        let path = viewApiUrl;

        comm.request({
            url: path,
            method: "GET",
            data: data,
        }, function (resp) {
            if (callback) {
                callback(resp);
            }
        })

        return data;
    }

    const initEditer = function (id, option) {
        new window['Quill'](id, {
            modules: {
                //toolbar: '#toolbar-container',
                toolbar: option
            },
            theme: 'snow'
        });
    }

    const insert = function () {
        if ($("#title").val() == '') {
            comm.message.alert("제목을 입력해주세요.");
            return;
        }

        $("#id").val(id);
        $("#contents").val($(".ql-editor", "#editor").html());

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
        $("#title").val(title);
        $("#editor").html(contents);
        $("#attachFiles_text").val(thumbnail)
        $("#secretYn").val(secretYn);

        initEditer(editerId, toolbarOptions);

        $("#attachFiles").on("change", function () {
            $("#attachFiles_text").val(this.value);
        });
    })

</script>