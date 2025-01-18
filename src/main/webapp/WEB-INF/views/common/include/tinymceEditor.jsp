<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2025-01-18
  Time: 오후 5:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%--<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Main Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>--%>


<!-- Place the first <script> tag in your HTML's <head> -->
<script src="https://cdn.tiny.cloud/1/x4lfthehuygci0gyh27r2085hd2z6pljljatiadlrrdcjpae/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>


<script>
    const editerId = '#editor';
    const toolbarOptions = {
        selector: editerId,
        height: 500,
        skin: 'material-outline',
        content_css: 'material-outline',
        icons: 'material',
        plugins: 'code image link lists',
        toolbar: 'undo redo | styles fontsize | bold italic underline forecolor backcolor | link image | align | bullist numlist ',
        menubar: false,
        forced_root_block:'div',
        fontsize_formats : '8pt 10pt 12pt 14pt 18pt 24pt 36pt',
    };


    const webEdit = {
        init: function () {
            tinymce.init(toolbarOptions);
        },

        setEditId: function (id) {
            toolbarOptions.selector = id;
        },

        setCodeFrame: function () {
            toolbarOptions.plugins = toolbarOptions.plugins + ' codesample'
            toolbarOptions.toolbar = toolbarOptions.toolbar + ' | codesample'
            toolbarOptions.codesample_languages = [
                {text: 'HTML/XML', value: 'markup'},
                {text: 'JavaScript', value: 'javascript'},
                {text: 'CSS', value: 'css'},
                {text: 'Java', value: 'java'},
                {text: 'Python', value: 'python'}
            ]

        },

        save : function(){
            tinymce.triggerSave();
        },
    }

</script>

