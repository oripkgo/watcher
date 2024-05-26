
const PAGING = function(){

    const pagingAreaClassName   = 'pagging_wrap';
    const prevArrowImgUrl       = "/resources/img/prev_arrow.png";
    const nextArrowImgUrl       = "/resources/img/next_arrow.png";

    const isMobileYn = function () {
        return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    }

    const getFormId = function (formObj) {
        let form;
        if (typeof formObj === 'object') {
            if (formObj.id) {
                form = formObj.id;
            } else {
                const forms = document.querySelectorAll('form');
                const index = Array.from(forms).indexOf(formObj);
                form = (formObj.id || "commListForm" + index);
            }
        } else {
            form = formObj;
        }

        if (form.substring(0, 1) != '#') {
            form = "#" + form;
        }

        return form;
    }

    const appendInput = function (formId, name) {
        const form = document.querySelector(formId);
        const existingInput = form.querySelector("[name='" + name + "']");

        if (!existingInput) {
            const newInput = document.createElement("input");
            newInput.type = "hidden";
            newInput.name = name;
            newInput.id = name;
            form.appendChild(newInput);
        }
    }

    const setInput = function (formId, name, val) {
        const form = document.querySelector(formId);

        let inputElement = form.querySelector("[name='" + name + "']");

        if (inputElement) {
            inputElement.value = val || '';
        }
    }

    const getFormData = function (formId) {
        let form = document.querySelector(formId);
        let formData = {};

        // 폼 내의 모든 input 요소에 대해 반복
        for (let i = 0; i < form.elements.length; i++) {
            let element = form.elements[i];

            // 입력 요소의 이름과 값을 JSON 객체에 추가
            if (element.type !== 'button') {
                if (element.value) {
                    formData[element.name] = element.value;
                }
            }
        }

        return formData;
    }

    const getElementPagingArea = function (formId) {
        let pagingArea = document.querySelector(formId).querySelector('.' + pagingAreaClassName);

        if (!pagingArea) {
            pagingArea = document.querySelector('.' + pagingAreaClassName);
        }

        return pagingArea;
    }

    const getArrowPrev = function (startPageNo) {
        let elementArrowPrev = document.createElement('a');

        elementArrowPrev.href = 'javascript:;';
        if (!(startPageNo <= 1)) {
            elementArrowPrev.setAttribute(
                'onclick',
                window['pagingNumberTagClickFuncStr'].replace("[pageNo]", startPageNo - 1)
            );
        }

        let elementImg = document.createElement('img');
        elementImg.src = prevArrowImgUrl;
        elementArrowPrev.appendChild(elementImg)

        return elementArrowPrev;
    }

    const getArrowNext = function (endPageNo, lastPageNo) {
        let elementArrowNext = document.createElement('a');

        elementArrowNext.href = 'javascript:;';
        if (!(endPageNo >= lastPageNo)) {
            elementArrowNext.setAttribute(
                'onclick',
                window['pagingNumberTagClickFuncStr'].replace("[pageNo]", endPageNo + 1)
            );
        }

        let elementImg = document.createElement('img');
        elementImg.src = nextArrowImgUrl;
        elementArrowNext.appendChild(elementImg)

        return elementArrowNext;

    }

    const getPageNumberList = function (startPageNo, endPageNo, nowPageNo) {
        let list = [];

        for (let i = startPageNo; i <= endPageNo; i++) {
            let elementPageNumber = document.createElement('a');
            elementPageNumber.href = "javascript:;"
            if (i == nowPageNo) {
                elementPageNumber.className = "on";
                elementPageNumber.innerText = i;
            } else {
                elementPageNumber.setAttribute(
                    'onclick',
                    window['pagingNumberTagClickFuncStr'].replace("[pageNo]", i)
                );
                elementPageNumber.innerText = i;
            }
            list.push(elementPageNumber);
        }

        return list;
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

    const getList = function (formObj, url, callback, pageNo, listNo, pagigRange, sPageNo, ePageNo, totalCnt, scrollTopYn) {
        let form = getFormId(formObj);
        let _pageNo = 1;			// 현재 페이지 번호
        let _listNo = 20;		// 한 페이지에 보여지는 목록 갯수
        let _pagigRange = 10;		// 한페이지에 보여지는 페이징처리 범위
        let _startPageNo;		// 시작 페이지
        let _endPageNo;			// 끝 페이지

        if (PAGING && PAGING.getList) {
            window['pagingListFunc'] = PAGING.getList
        }

        if (pageNo) {
            _pageNo = pageNo * 1;
        }

        if (listNo) {
            _listNo = listNo * 1;
        }

        if (pagigRange) {
            _pagigRange = pagigRange * 1;
        }

        if (sPageNo && ePageNo) {
            _startPageNo = sPageNo * 1;
            _endPageNo = ePageNo * 1;
        }

        appendInput(form, 'viewType');
        appendInput(form, 'pageNo');
        appendInput(form, 'listNo');
        appendInput(form, 'pagigRange');
        appendInput(form, 'startPageNo');
        appendInput(form, 'endPageNo');

        setInput(form, "pageNo"      , _pageNo);
        setInput(form, "listNo"      , _listNo);
        setInput(form, "pagigRange"  , _pagigRange);
        setInput(form, "startPageNo" , _startPageNo);
        setInput(form, "endPageNo"   , _endPageNo);
        setInput(form, "viewType"    , "ajax");

        REQUEST.send(url, "GET", getFormData(form), function (data) {
            if (callback) {
                if (typeof callback == 'function') {
                    window[form + 'commListCallback'] = callback;
                } else {
                    window[form + 'commListCallback'] = window[callback];
                }
                window[form + 'commListCallback'](data);

            }

            let pageObj = data.dto || data.vo;
            let firstPage = 1; // eslint-disable-line no-unused-vars
            let lastPage = Math.ceil((pageObj.totalCnt * 1) / (pageObj.listNo * 1));

            if (pageObj.pageNo == 1) {
                pageObj.startPageNo = pageObj.pageNo;
            } else if (pageObj.pageNo < pageObj.startPageNo) {
                pageObj.startPageNo = pageObj.startPageNo - pageObj.pagigRange;
            } else if (pageObj.pageNo > pageObj.endPageNo) {
                pageObj.startPageNo = pageObj.pageNo;
            }


            pageObj.endPageNo = (pageObj.startPageNo + pageObj.pagigRange) - 1;

            if (pageObj.endPageNo > lastPage) pageObj.endPageNo = (lastPage == 0 ? 1 : lastPage);


            window['pagingNumberTagClickFuncStr'] = "pagingListFunc('" + form + "','" + url + "','" + form + "commListCallback'" +
                ",'[pageNo]','" + pageObj.listNo + "','" + pageObj.pagigRange + "','" + pageObj.startPageNo + "','" + pageObj.endPageNo + "','" + totalCnt + "'," + (scrollTopYn ? ("'" + scrollTopYn + "'") : null) + ")";

            if (isMobileYn()) {
                // 모바일
                let pagination_mobile = getElementPagingArea(form);

                if (pageObj.pageNo >= lastPage) {
                    if( pagination_mobile ){
                        pagination_mobile.style.display = 'none';
                    }
                } else {
                    if(pagination_mobile){
                        let newPagination = document.createElement('a');
                        newPagination.href = 'javascript:;';
                        newPagination.className = 'btn_story2 pagging_wrap';
                        newPagination.setAttribute('onclick', window['pagingNumberTagClickFuncStr'].replace("[pageNo]", (pageObj.pageNo * 1) + 1));
                        newPagination.textContent = '더보기';

                        pagination_mobile.parentNode.replaceChild(newPagination, pagination_mobile);
                    }

                    // 또는 아래 코드를 사용하여 기존 내용을 갱신합니다.
                    // pagination_mobile.innerHTML = '<a href="javascript:;" class="btn_story2 pagging_wrap" onclick="' + listFunc.replace("[pageNo]", ((pageObj.pageNo * 1) + 1)) + '">더보기</a>';
                }
            } else {
                // pc
                let pagination_pc = getElementPagingArea(form);

                if (pagination_pc) {
                    emptyElementChild(pagination_pc);

                    pagination_pc.appendChild(getArrowPrev(pageObj.startPageNo))
                    const pageNumberList = getPageNumberList(pageObj.startPageNo, pageObj.endPageNo, _pageNo);

                    pageNumberList.forEach(function (aElement) {
                        pagination_pc.appendChild(aElement);
                    });

                    pagination_pc.appendChild(getArrowNext(pageObj.endPageNo, lastPage))
                    if (!scrollTopYn || scrollTopYn == "Y") {
                        document.documentElement.scrollTop = 0;
                    }
                }
            }
        })
    }

    return {

        emptyList : emptyList,

        renderList : renderList,

        getList : getList,

    }

}()
