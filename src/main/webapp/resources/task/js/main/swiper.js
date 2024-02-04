const swiperRootTargetClassNm = ".swiper_product";
const swiperWrapperTargetClassNm = ".swiper-wrapper";
const swiperBannerTargetClassNm = ".swiper_banner";
const swiperPagingTargetClassNm = ".swiper-pagination";
const swiperNavigNextTargetClassNm = ".swiper-button-next";
const swiperNavigPrevTargetClassNm = ".swiper-button-prev";

const mainSwiper = {
    init : function(){
        if( $(swiperWrapperTargetClassNm, swiperRootTargetClassNm).find(".swiper-slide").length > 1 ){
            this.product();
        }else{
            $(swiperPagingTargetClassNm, swiperRootTargetClassNm).hide();
        }
    },

    setSwiper : function(target, option){
        const swp = new Swiper(target, option);

        return swp;
    },

    product : function(){
        mainSwiper.setSwiper(swiperRootTargetClassNm, {
            centeredSlides: true,
            loop: true,
            autoplay: {
                delay: 6000,
            },
            pagination: {
                el: swiperPagingTargetClassNm,
                clickable: true,
            },
            navigation: {
                nextEl: swiperNavigNextTargetClassNm,
                prevEl: swiperNavigPrevTargetClassNm,
            }
        });
    },
    banner : function(){
        mainSwiper.setSwiper(swiperBannerTargetClassNm, {
            slidesPerView: 'auto',
            speed : 600,
            spaceBetween: 0,
            loop: true,
            autoplay: {
                delay: 8000,
            },
            //initialSlide: 1,
            //freeMode: true,
            //centeredSlides: true,
            pagination: {
                el: swiperPagingTargetClassNm,
                clickable: true,
            }
        });
    },
};