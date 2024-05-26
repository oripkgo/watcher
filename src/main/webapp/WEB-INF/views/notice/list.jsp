<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<form id="noticeForm" name="noticeForm" method="get">
    <div class="section ani-in">
        <div class="layout_02">
            <div class="ani_y layout_sub title_box_02">
                <div class="sub_title_top"><p>Notice</p></div>
                <div class="sub_title_bottom">
                    <p class="title_description">다양한 소식을 만나보세요.</p>
                    <div class="search_box_02">
                        <div class="search_group">
                            <select id="search_id" name="search_id">
                                <option value="">선택</option>
                                <option value="01">제목</option>
                                <option value="02">내용</option>
                            </select>
                            <input type="text" id="searchKeyword" name="searchKeyword" placeholder="키워드 입력">
                            <a href="javascript:;" id="search"><img src="/resources/img/btn_search_b.png"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="section ani-in">
        <div class="layout_02">
            <div class="ani_y layout_sub title_box_02">
                <div class="board_notice list line">
                    <table class="board_list_table">
                        <colgroup>
                            <col width="5%"/>
                            <col width="70%"/>
                            <col width="10%"/>
                            <col width="20%"/>
                            <col width="10%"/>
                        </colgroup>

                        <thead>
                        <tr>
                            <th scope="col">No.</th>
                            <th scope="col">제목</th>
                            <th scope="col">작성자</th>
                            <th scope="col">작성일</th>
                            <th scope="col">조회수</th>
                        </tr>
                        </thead>
                        <tbody id="dataList"></tbody>
                    </table>

                    <div class="pagging_wrap"></div>
                </div>
            </div>
        </div>
    </div>

</form>

<script>
    const noticeListUrl = '${noticeListUrl}';
    const searchMemId   = '${dto.searchMemId}';
    const listNo        = ${dto.listNo};
    const pageNoRange   = ${dto.pagigRange};

    const search = function(){
        comm.paging.getList('#noticeForm', noticeListUrl, listCallback, 1, listNo, pageNoRange);
    }

    const getMobileRecord = function(target, arr){
        let tempDiv = $("<div></div>");
        let dataElement = $(document.createElement(target));
        let rowElement = $('<div class="mobile-data-row"></div>');
        $(dataElement).addClass("mobile-data");

        for(let obj of arr){
            const col = $('<div class="mobile-data-col"></div>');
            if( obj.type == 'image' ){
                $(col).addClass("image");
                const a = $('<a></a>');
                const img = $('<img></img>');
                $(a).attr("href",obj.href);
                $(img).attr("src",obj.src);
                $(a).append(img);
                $(col).append(a);
            }else{
                $(col).append('<div class="col-name"><strong>'+obj.col+'</strong></div>');
                $(col).append('<div class="col-value">'+obj.val+'</div>');
            }

            $(rowElement).append(col);
        }
        $(dataElement).html(rowElement);
        return  $(tempDiv).html(dataElement).html();
    }

    const listCallback = function(data) {
        const $this = this;
        const dto = data['dto'];
        comm.paging.emptyList("#dataList", dto['pageNo']);

        for (let i = 0; i < data.list.length; i++) {
            let obj = data.list[i];
            let listHtml = '';
            let listNum = ((dto['pageNo'] - 1) * dto['listNo']) + (i + 1);

            listHtml += '<tr>                                                                               ';
            // listHtml += '    <td><input type="checkbox"></td>                                            ';
            listHtml += '    <td>' + listNum + '</td>                                                         ';
            listHtml += '    <td class="title">                                                                           ';
            listHtml += '        <a href="' + window.getNoticeViewUrl(obj.ID) + '" class="subject_link">' + obj['TITLE'] + '</a>';
            listHtml += '    </td>                                                                          ';
            listHtml += '    <td>' + obj['NICKNAME'] + '</td>';
            listHtml += '    <td>' + obj['REG_DATE'].substring(2) + '</td>';
            listHtml += '    <td>' + obj['VIEW_CNT'] + '</td>';

            listHtml += getMobileRecord("td", [
                {col: "No.", val: listNum},
                {col: "제목", val:('<a href="' + window.getNoticeViewUrl(obj.ID) + '" class="subject_link">' + obj['TITLE'] + '</a>')},
                {col: "작성자", val: obj['NICKNAME']},
                {col: "작성일", val: obj['REG_DATE'].substring(2)},
                {col: "조회수", val: obj['VIEW_CNT']},
            ])

            listHtml += '</tr>                                                                           ';
            listHtml = $(listHtml);

            $(listHtml).data(obj);

            comm.paging.renderList("#dataList", listHtml)
        }
    }

    $(document).on("ready", function(){
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
