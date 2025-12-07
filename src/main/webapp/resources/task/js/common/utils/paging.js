const PAGING = function () {

    const pagingAreaClassName = ".pagination";

    const isMobileYn = function () {
        return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    }


    const emptyElementChild = function (targetElement) {
        while (targetElement.firstChild) {
            targetElement.removeChild(targetElement.firstChild);
        }
    }

    const emptyList = function (target, pageNo) {
        if (!isMobileYn() || (pageNo === 1 && isMobileYn())) {
            emptyElementChild(document.querySelector(target))
        }
    }

    const renderList = function (target, element) {
        let targetElement = document.querySelector(target); // your_target_selector에는 실제로 사용하는 적절한 셀렉터를 넣어야 합니다.

        if (targetElement) {
            if (element && element.length > 0) {
                for (let i = 0; i < element.length; i++) {
                    let obj = element[i];
                    targetElement.appendChild(obj);
                }
            }
        }
    }

    function renderPagination({
          pageNo,         // 현재 페이지
          listNo,         // 페이지당 목록수
          pagigRange,     // 페이지 버튼 표시 개수 (예: 5)
          totalCnt,       // 전체 데이터 수
          url,
          callback,
          formObj
      }) {
        const totalPage = Math.ceil(totalCnt / listNo);
        const pagination = document.querySelector(".pagination");
        pagination.innerHTML = "";

        if (totalPage <= 0) return;

        const half = Math.floor(pagigRange / 2);

        // -------- 중앙 기반 페이징 계산 --------
        let startPage = pageNo - half;
        let endPage = pageNo + half;

        // 범위를 벗어나면 보정
        if (startPage < 1) {
            startPage = 1;
            endPage = pagigRange;
        }
        if (endPage > totalPage) {
            endPage = totalPage;
            startPage = Math.max(1, endPage - pagigRange + 1);
        }

        // -------- 페이지 버튼 생성 --------
        for (let i = startPage; i <= endPage; i++) {
            pagination.insertAdjacentHTML(
                "beforeend",
                `<button class="page-btn ${i === pageNo ? "active" : ""}" 
                     data-page="${i}">
                ${i}
             </button>`
            );
        }

        // -------- 클릭 이벤트 --------
        pagination.querySelectorAll(".page-btn").forEach((btn) => {
            btn.addEventListener("click", function () {
                const newPage = Number(this.dataset.page);

                getList(
                    formObj,
                    url,
                    callback,
                    newPage,
                    listNo,
                    pagigRange,
                    true
                );
            });
        });
    }


    const getList = function (
        formObj,
        url,
        callback,
        pageNo,
        listNo,
        pagigRange,
        scrollTopYn
    ) {
        const listId = Date.now();
        let _pageNo = pageNo ? Number(pageNo) : 1;
        let _listNo = listNo ? Number(listNo) : 20;
        let _pagigRange = pagigRange ? Number(pagigRange) : 10;

        const payload = {
            pageNo: _pageNo,
            listNo: _listNo,
            pagigRange: _pagigRange,
            ...formObj,
        };

        REQUEST.send(url, "GET", payload, function (data) {
            // 1) 리스트 렌더링
            if (callback) {
                const func =
                    typeof callback == "function"
                        ? callback
                        : window[callback];

                // 유니크 콜백 등록
                window[listId + "commListCallback"] = func;

                // 실제 리스트 그리기
                window[listId + "commListCallback"](data);
            }

            // 2) 페이징 렌더링 (totalCnt, pageNo, listNo 필수)
            renderPagination({
                pageNo: _pageNo,
                listNo: _listNo,
                pagigRange: _pagigRange,
                totalCnt: data?.dto?.totalCnt || 0,
                url,
                callback,
                formObj
            });

            // 3) 스크롤 맨 위로
            if (scrollTopYn)
                window.scrollTo({top: 0, behavior: "smooth"});
        });
    };


    return {

        emptyList: emptyList,

        renderList: renderList,

        getList: getList,

    }

}()
