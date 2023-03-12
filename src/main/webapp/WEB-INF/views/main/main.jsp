<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
	const swiper = {
		init : function(){
			if( $(".swiper-wrapper", ".swiper_product").find(".swiper-slide").length <= 1 ){
				$(".swiper-pagination", ".swiper_product").hide();
			}

			new Swiper('.swiper_product', {
				centeredSlides: true,
				loop: true,
				autoplay: {
					delay: 6000,
					disableOnInteraction: false,
				},
				pagination: {
					el: '.swiper-pagination',
					clickable: true,
				},
				navigation: {
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',
				}
			});

			new Swiper('.swiper_banner', {
				slidesPerView: 'auto',
				speed : 600,
				spaceBetween: 0,
				loop: true,
				autoplay: {
					delay: 8000,
					disableOnInteraction: false,
				},
				//initialSlide: 1,
				//freeMode: true,
				//centeredSlides: true,
				pagination: {
					el: '.swiper-pagination',
					clickable: true,
				}
			});
		}
	}

	const notice = {
		init : function(){
			this.list();
		},

		isHide : function(regDt){
			let result = false;
			let regDate = new Date(regDt);
			let toDay = new Date();

			var dateDif = (toDay.getTime() - regDate.getTime()) / (1000*60*60*24) ;

			if( dateDif > 14) {
				result = true;
			}

			return result;
		},

		list : function(){
			const noticeObj = this;
			comm.list('#mainNoticeForm', '/notice/list/data', function (data) {
				let node = $('<a href="javascript:;" style="display:none;"></a>')
				if (data.code == '0000' && (data.list && data.list.length > 0)) {
					if( noticeObj.isHide(data.list[0]['REG_DATE']) ){
						return;
					}

					data.list.forEach(function (obj, idx) {
						let copyNode = $(node).clone(true);
						$(copyNode).text(obj['TITLE']);
						$(copyNode).attr("href", getNoticeViewUrl(obj['ID']));

						$(copyNode).data(obj)

						$("#noticeList").append(copyNode)
					})
					$("#noticeList").parents(".notice_wrap").show();
					$("a:eq(0)", "#noticeList").show();

					$(".notice_wrap").find(".prev_a, .next_a").on("click", function () {
						let aIndex = $("a", "#noticeList").index($("a:visible", "#noticeList"));
						let target;

						if ($(this).hasClass("prev_a")) {
							target = $($("a", "#noticeList")[--aIndex]);
						} else {
							target = $($("a", "#noticeList")[++aIndex]);
						}
						if( $(target).length > 0 ){
							$("a", "#noticeList").hide();
							$(target).show();
						}
					})
				}
			}, 1, 5);
		}
	};

	$(document).on("ready",function(){
		swiper.init();
		notice.init();
	})

</script>
<form name="mainNoticeForm" id="mainNoticeForm"></form>

<div class="section">
	<div class="ani-in">

		<div class="swiper_product ani_y delay1">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<img src="/resources/img/main_visual01.jpg">
				</div>
				<%--
				<div class="swiper-slide">
					<img src="/resources/img/main_visual01.jpg">
				</div>
				<div class="swiper-slide">
					<img src="/resources/img/main_visual01.jpg">
				</div>
				--%>
			</div>
			<div class="swiper-pagination"></div>
			<!--
			<div class="swiper-button-next swiper-button-white"></div>
			<div class="swiper-button-prev swiper-button-white"></div>
			-->

			<div class="notice_wrap" style="display: none;">
				<div class="notice_tit">공지사항</div>
				<div class="notice_area" id="noticeList"></div>
				<div class="notice_btn">
					<a href="javascript:;" class="prev_a"></a>
					<a href="javascript:;" class="next_a"></a>
				</div>
			</div>

		</div>
	</div>
</div>

<div class="section bg_grey">
	<div class="ani-in layout">

		<div class="issue_wrap ani_y delay1">
			<div class="stip"></div>
			<div class="title_main"><span>issue</span></div>

			<div class="swiper_banner">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<img src="/resources/img/mid_visual01.jpg">
						<div class="issue_box">
							<span class="kind">정치.환경</span>
							<strong>인류는 지구온난화를 <br>막을 수 있을것인가?</strong>
							<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면 기온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온난화는 산업혁명 이후 전지구 지표면 평균 기온표면 평균 기온표면 평...</span>
							<em>by gauni1229</em>
							<a href="javascript:;"><img src="/resources/img/btn_more.png"></a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="/resources/img/mid_visual01.jpg">
						<div class="issue_box">
							<span class="kind">정치.환경</span>
							<strong>인류는 지구온난화를 <br>막을 수 있을것인가?</strong>
							<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면 기온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온난화는 산업혁명 이후 전지구 지표면 평균 기온표면 평균 기온표면 평...</span>
							<em>by gauni1229</em>
							<a href="javascript:;"><img src="/resources/img/btn_more.png"></a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="/resources/img/mid_visual01.jpg">
						<div class="issue_box">
							<span class="kind">정치.환경</span>
							<strong>인류는 지구온난화를 <br>막을 수 있을것인가?</strong>
							<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면 기온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온난화는 산업혁명 이후 전지구 지표면 평균 기온표면 평균 기온표면 평...</span>
							<em>by gauni1229</em>
							<a href="javascript:;"><img src="/resources/img/btn_more.png"></a>
						</div>
					</div>
					<div class="swiper-slide">
						<img src="/resources/img/mid_visual01.jpg">
						<div class="issue_box">
							<span class="kind">정치.환경</span>
							<strong>인류는 지구온난화를 <br>막을 수 있을것인가?</strong>
							<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면 기온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온난화는 산업혁명 이후 전지구 지표면 평균 기온표면 평균 기온표면 평...</span>
							<em>by gauni1229</em>
							<a href="javascript:;"><img src="/resources/img/btn_more.png"></a>
						</div>
					</div>
				</div>
				<div class="swiper-pagination"></div>
			</div>

		</div>

	</div>
</div>


<div class="section">
	<div class="ani-in layout">

		<div class="tab_wrap ani_y delay2">
			<!--탭메뉴-->
			<div id="tab_box">
				<div id="tab_cnt">
					<a href="javascript:;" class="tab_ov"><span>라이프</span></a>
					<a href="javascript:;"><span>여행</span></a>
					<a href="javascript:;"><span>맛집</span></a>
					<a href="javascript:;"><span>문화</span></a>
					<a href="javascript:;"><span>연애</span></a>
					<a href="javascript:;"><span>IT</span></a>
					<a href="javascript:;"><span>게임</span></a>
					<a href="javascript:;"><span>스포츠</span></a>
				</div>
				<div class="grap">
					<div class="obj">
						<!--------------------라이프------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//라이프------------------------>
					</div>

					<div class="obj">
						<!--------------------여행------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행여행...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//여행------------------------>
					</div>

					<div class="obj">
						<!--------------------맛집------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>맛집맛집맛집맛집맛집맛집맛집맛집맛집맛집...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//맛집------------------------>
					</div>

					<div class="obj">
						<!--------------------문화------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화문화...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//문화------------------------>
					</div>

					<div class="obj">
						<!--------------------연애------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>연애연애연애연애연애연애연애연애연애연애연애연애연애연애연애...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//연애------------------------>
					</div>

					<div class="obj">
						<!--------------------IT------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>ITITITITITITITITITITITITITITITITITITITITIT...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>ITITITITITITITITITITITITITITITITITITITITITIT...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>ITITITITITITITITITITITITITITITITITITITITITITIT...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//IT------------------------>
					</div>

					<div class="obj">
						<!--------------------게임------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>게임게임게임게임게임게임게임게임게임게임게임게임게임게임...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>게임게임게임게임게임게임게임게임게임게임...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>게임게임게임게임게임게임게임게임게임게임게임게임게임게임게임게임게임게임...</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//게임------------------------>
					</div>

					<div class="obj">
						<!--------------------스포츠------------------------>
						<ul class="story_wrap">
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample01.jpg"></div>
									<strong>스포츠이 때때로 느려지는 놀라운 이유</strong>
									<span>넓은 의미에서 지구온난화는 장기간에 걸쳐 전지구 평균 지표면온이 상승하는 것을 의미한다. 하지만 좀더 일반적으로 지구온...</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample02.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>스포츠스포츠스포츠스포츠</span>
									<em>by gauni1229</em>
								</a>
							</li>
							<li>
								<a href="javascript:;">
									<div><img src="/resources/img/sample03.jpg"></div>
									<strong>베트남 인터넷이 때때로 느려지는 놀라운 이유 <br>(+인터넷 속도 측정방법)</strong>
									<span>스포츠스포츠스포츠스포츠스포츠스포츠스포츠스포츠스포츠스포츠스포츠</span>
									<em>by gauni1229</em>
								</a>
							</li>
						</ul>
						<a href="javascript:;" class="btn_story2">스토리보러가기</a>
						<!--------------------//스포츠------------------------>
					</div>

				</div>
			</div>
			<script type="text/javascript">
				var param = "#tab_box";
				var btn = "#tab_cnt>a";
				var obj = "#tab_box .obj";
				var img = false;
				var event = "click";
				document_tab(param,btn,obj,img,event);
			</script>
			<!--//탭메뉴 끝-->

		</div>

	</div>
</div>

<div class="section bg_grey2">
	<div class="ani-in layout">

		<div class="keyword_wrap ani_y delay2">

			<div class="keyword_tit">keyword</div>
			<div class="keyword_search">
				<input type="text" placeholder="나의 감성을 더해줄 이야기를 찾아보세요.">
				<a href="javascript:;"><img src="/resources/img/btn_search_b.png"></a>
			</div>
			<div class="keyword_box_wrap">
				<a href="javascript:;">
					<img src="/resources/img/keyword01.jpg">
					<div>
						<strong>여행</strong>
						<span>#가을여행</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword02.jpg">
					<div>
						<strong>맛집</strong>
						<span>#락페스티벌</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword03.jpg">
					<div>
						<strong>문화</strong>
						<span>#락페스티벌</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword04.jpg">
					<div>
						<strong>맛집</strong>
						<span>#달고나만들기</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword03.jpg">
					<div>
						<strong>스포츠</strong>
						<span>#골프연습</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword02.jpg">
					<div>
						<strong>여행</strong>
						<span>#가을여행</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword01.jpg">
					<div>
						<strong>문화</strong>
						<span>#락페스티벌</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword02.jpg">
					<div>
						<strong>맛집</strong>
						<span>#달고나만들기</span>
					</div>
				</a>
				<a href="javascript:;">
					<img src="/resources/img/keyword03.jpg">
					<div>
						<strong>여행</strong>
						<span>#달고나만들기</span>
					</div>
				</a>
			</div>

		</div>

	</div>
</div>