<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<form id="noticeForm" name="noticeForm" method="get">
    <div class="container">

        <main>
            <section class="title-area">
                <h1 class="page-title">공지사항</h1>
            </section>

            <section class="notice-list" id="dataList"></section>
            <nav class="pagination"></nav>
        </main>

    </div>
</form>

<script>
    const noticeListUrl = '${noticeListUrl}';
    const searchMemId = '${dto.searchMemId}';
    const listNo = ${dto.listNo};
    const pageNoRange = ${dto.pagigRange};

    const search = function () {
        comm.paging.getList('#noticeForm', noticeListUrl, listCallback, 1, listNo, pageNoRange);
    }


    const listCallback = function (data) {
        $("#dataList").empty();

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listEle = $(`

             <article class="notice-card" tabindex="0" role="button">
                 <div class="notice-content">
                     <div class="title-row">
                         <h2 class="notice-title">신규 기능 업데이트 안내</h2>
                     </div>
                     <p class="notice-summary">새로운 기능들이 추가되어 사용자 경험이 향상되었습니다. 자세한 내용은 공지사항을 확인해주세요.</p>
                     <div class="notice-footer">
                         <time datetime="2025-06-15" class="notice-date">2025.06.15</time>
                         <div class="author-info">
                             <img src="https://i.pravatar.cc/999999999999999?img=8" alt="개발팀 프로필" class="author-avatar"/>
                             <span class="author-name">개발팀</span>
                         </div>
                     </div>
                 </div>
             </article>

            `);


            $(listEle).find(".notice-title").html(obj['TITLE'])
            $(listEle).find(".notice-summary").html(obj['TITLE'])
            $(listEle).find(".notice-date").html(obj['REG_DATE'].substring(2))
            $(listEle).find(".author-name").html(obj['NICKNAME'])
            $(listEle).find(".author-avatar").attr("src", "https://i.pravatar.cc/" + (obj['REG_ID']*1) + "?img=8")
            $(listEle).off("click").on("click", function () {
                location.href = window.getNoticeViewUrl(obj.ID);
            });

            comm.paging.renderList("#dataList", listEle)
        }
    }

    $(document).on("ready", function () {
        $("#search").on("click", function () {
            $("#dataList").empty();
            search();
        });

        $("#searchKeyword").on("keypress", function (e) {
            if (e.keyCode == 13) {
                $("#dataList").empty();
                search();
                return false;
            }
        });

        search();
    })

</script>
