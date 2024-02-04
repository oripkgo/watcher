<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<form name="mainNoticeForm" id="mainNoticeForm"></form>

<div class="section">
    <div class="ani-in">

        <div class="swiper_product ani_y delay1">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <img src="/resources/img/main_visual01.jpg">
                </div>
            </div>
            <div class="swiper-pagination"></div>

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

<div class="section bg_grey" id="popularStorys">
    <div class="ani-in layout">

        <div class="issue_wrap ani_y delay1">
            <div class="stip"></div>
            <div class="title_main"><span>issue</span></div>

            <div class="swiper_banner">
                <div class="swiper-wrapper" id="popularStoryList"></div>
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
                <div id="tab_cnt" class="category_tab">
                </div>
                <div class="grap" id="tab_parent"></div>
            </div>
            <!--//탭메뉴 끝-->

        </div>

    </div>
</div>

<div class="section bg_grey2">
    <div class="ani-in layout">
        <div class="keyword_wrap ani_y delay2">
            <div class="keyword_tit">keyword</div>
            <div class="keyword_search">
                <input type="text" v-on:keypress="mainObj.keyword.search(this);" name="keyword" id="keyword"
                       placeholder="나의 감성을 더해줄 이야기를 찾아보세요.">
                <a href="javascript:;" v-on:click="mainObj.keyword.search(this);"><img
                        src="/resources/img/btn_search_b.png"></a>
            </div>
            <div class="keyword_box_wrap" id="popularKeywordList"></div>
        </div>
    </div>
</div>

<script type="text/javascript" src="/resources/task/js/main/swiper.js"></script>
<script type="text/javascript" src="/resources/task/js/main/notice.js"></script>
<script type="text/javascript" src="/resources/task/js/main/story.js"></script>
<script type="text/javascript" src="/resources/task/js/main/keyword.js"></script>
<script type="text/javascript" src="/resources/task/js/main/category.js"></script>

<script type="text/javascript">

    mainSwiper.init();
    notice.init();
    story.init(mainSwiper.banner);
    keyword.init();
    mainCategory.init();

</script>