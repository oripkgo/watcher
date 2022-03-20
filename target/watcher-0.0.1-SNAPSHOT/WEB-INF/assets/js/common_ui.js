$(function() {
	_UI = {
		init : function() {
			changeLnbTreeStatus();
			_UI.datepicker();
		},
		// 달력 선택
		datepicker : function() {
			$('.datepicker').datepicker({
				changeMonth: true,
				changeYear: true
			});
		},
		/**
		 * 팝업 호출
		 * 결재자 선택
		 * @param objPop : ID or Class Naming
		 */
		actPopup : function(objPop) {
			$(objPop).show();
			$(objPop).find('.btnClose').on('click', function() {
				$(this).closest('.popup').hide();
			});

			_UI.setAuth(objPop);
		},
		/**
		 * 팝업 호출
		 * 주소 선택
		 * @param objPop : ID or Class Naming
		 */
		actPopupAddress : function() {
			$('.popAddress').show();
			$('.popAddress .btnClose').on('click', function() {
				$(this).closest('.popup').hide();
			});
		},
		// 결재자 선택(팝업)
		setAuth : function(elem) {

			let popSelectAuth = $(elem).find('.popSelectAuth');

			const controlSelect = popSelectAuth.find('.controlSelect');
			const allUser = popSelectAuth.find('.left');
			const midAuth = popSelectAuth.find('.right');

			// 사용자 클릭시 해당 요소만 활성화 한다.
			$(document).on('click', '.popSelectAuth a', function() {
				$(this).addClass('selected').siblings('a').removeClass('selected');
			});

			// 우측 버튼 클릭시 전체사용자 선택된 요소를 중간 결재자 영역으로 이동한다.
			// 좌측 버튼 클릭시 중간결재자 선택된 요소를 전체사용자 영역으로 이동한다.
			controlSelect.find('button').on('click', function() {
				// 클릭한 버튼의 data-btn 값을 변수에 담는다.
				let dataBtn = $(this).data('btn');

				// 클릭한 버튼의 custom data 속성 값이 add 일 경우(전체사용자 -> 중간결재자)
				if(dataBtn == 'add') {
					// 전체사용자의 선택된 요소를 변수에 담는다.
					let selected = allUser.find('.selected');

					if($(elem).is('.popMidAuth') || $(elem).is('.popRefAuth')) { // 중간결재자 선택 팝업일 경우
						// 중간결재자 영역의 모든 selected class를 삭제하고 선택한 요소를 append한다.
						midAuth.find('.inner').append(selected).end().find('a').removeClass('selected');
					} else { // 최종결재자 선택 팝업일 경우
						let len = midAuth.find('.inner a').length;

						if(!len) { // 최종결재자 선택 없을 경우
							midAuth.find('.inner').append(selected).end().find('a').removeClass('selected');
						} else { // 최종결재자 선택 있을 경우
							// 기존 선택자를 전체사용자로 이동한다.
							midAuth.find('.inner a').appendTo(allUser.find('.inner'));

							// 선택한 사용자를 최종결재자 영역으로 이동한다.
							midAuth.find('.inner').append(selected).end().find('a').removeClass('selected');

							// 요소 순차정렬
							sortAuth(elem, 'remove');
						}
					}
				} else if(dataBtn == 'remove') {
					// 중간결재자 영역의 선택된 요소를 변수에 담는다.
					let reSelected = midAuth.find('.selected');

					// 전체사용자 영역의 모든 selected class를 삭제하고 선택한 요소를 append한다.
					allUser.find('.inner').append(reSelected).end().find('a').removeClass('selected');
				}

				// 요소 순차정렬
				sortAuth(elem, dataBtn);
			});

			// 확인 버튼 클릭시 팝업 닫는다.
			$(elem).find('.btnControls a').on('click', function() {
				$(this).closest('.popup').hide();
			});
		}
	}

	_UI.init();
});


/**
 * LNB Tree Show/Hide
 */
function changeLnbTreeStatus() {
	const list = $('.lnb a');

	$('.lnb .list01 > li > a').on('click', function() {
		// 활성 클래스 active를 전체 삭제한다.

		// 하위 메뉴가 있을 경우에만 active 클래스를 toggle 한다.
		// 좌측 아이콘 이미지 열고 닫힘 설정
		if($(this).next('ul').length) {
			$(this).toggleClass('active');
		} else {
			$(this).removeClass('active');
		}

		$(this).next('ul').slideToggle();
	});
}


/**
 * 중간결재자 선택창 리스트 정렬
 * @param obj
 */
function sortAuth(elem, customData) {
	const leftList = $(elem).find('.popSelectAuth .left .inner');
	const rightList = $(elem).find('.popSelectAuth .right .inner');
	let arr = [],
		right,
		left,
		list;

	// 왼쪽/오른쪽 리스트를 구분하여 변수에 넣는다.
	list = customData == 'add' ? rightList : leftList;


	// 각 요소를 탐색하여 배열에 넣는다.
	list.find('a').each(function(idx, item) {
		arr.push($(this));
	});


	// 요소의 data-num 값을 이용하여 정렬한다.
	arr.sort(function(a, b) {
		return $(a).data('num') - $(b).data('num');
	});

	// 정렬된 요소를 삽입한다.
	list.html(arr);






}






