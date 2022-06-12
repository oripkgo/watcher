
const kakaoKey = '16039b88287b9f46f214f7449158dfde';
const naverKey = 'ThouS3nsCEwGnhkMwI1I';


let comment_li = '';

comment_li += '<li>';
comment_li += '    <div class="member_re"><img class="profile" src="/resources/img/member_ico.png"></div>';
comment_li += '    <div class="review_info">';
comment_li += '        <em class="writer"></em>';
comment_li += '        <img src="/resources/img/line.png">';
comment_li += '            <span class="writer_time"></span>';
comment_li += '            <img src="/resources/img/line.png">';
comment_li += '                <span class="accuse">신고</span>';
comment_li += '                <strong class="contents"></strong>';
// comment_li += '                <a href="javascript:;" class="see_replies">답글보기</a>';
// comment_li += '                <a href="javascript:;" class="Write_a_reply">답글달기</a>';
comment_li += '    </div>';
comment_li += '</li>';


let loginProcessEventHtml = '';

loginProcessEventHtml += '<div class="member_app logOut" style="display: none;">';
loginProcessEventHtml += '    <a href="javascript:;" id="myStory">내 스토리</a>';
loginProcessEventHtml += '    <a href="javascript:;" id="management">관리</a>';
loginProcessEventHtml += '    <a href="/story/write" id="writing">글쓰기</a>';
loginProcessEventHtml += '    <a href="javascript:;" id="logout">로그아웃</a>';
loginProcessEventHtml += '</div>';


let comm = {

    comment_setting : function(contents_type, contents_id, target, cnt, list, login_yn){

        let $conts_review = $('<div class="conts_review" id="conts_review"></div>');

        $($conts_review).html('<strong class="conts_tit">댓글<em>'+cnt+'</em></strong>');

        if( login_yn == 'N' ){
            $($conts_review).append('<div class="write_wrap"><textarea placeholder="로그인하고 댓글을 입력해보세요!"></textarea><a href="javascript:;">확인</a></div>');

            $($conts_review).find('.write_wrap').on("focus click", function(){

                comm.loginObj.popup.open();
            });

        }else{
            $($conts_review).append('<div class="write_wrap"><textarea placeholder="댓글 입력" name="coment"></textarea><a href="javascript:;" id="coment_insert">확인</a></div>');

            // 댓글 등록
            $($conts_review).find('#coment_insert').on("click", function(){


                let comment_insert_param = {
                    "contentsType":contents_type,
                    "contentsId":contents_id,
                    "refContentsId":"0",

                };

                // comm.message.confirm(
                //     '댓글을 등록하시겠습니까?'
                // )

                comment_insert_param.coment = $(target).find("[name='coment']").val().replace(/[\n]/g,'<br>')
                comm.request({url:"/board/insert/comment",data:JSON.stringify(comment_insert_param)},function(resp){

                    let profile_img = "/resources/img/member_ico.png";

                    if( resp.comment['profile'] ){
                        profile_img = resp.comment['profile'];
                    }

                    // 등록성공
                    if( resp.code == '0000'){
                        let comment_obj = $(comment_li);

                        $(".profile"    , comment_obj).attr("src",profile_img);
                        $(".writer"     , comment_obj).html(resp.comment['nickName']);
                        $(".writer_time", comment_obj).html("지금");
                        $(".contents"   , comment_obj).html(resp.comment['coment']);

                        $(target).find(".reviewList","#conts_review").prepend(comment_obj);
                        $("[name='coment']",target).val('');

                    }
                })

            });

        }

        $($conts_review).append('<ul class="reviewList"></ul>');

        if( list && list.length > 0 ){

            let comment_obj_html = '';
            for(let i=0;i<list.length;i++){
                let listObj = list[i];
                let comment_obj = $("<div>"+comment_li+"</div>");

                let profile_img_arr = "/resources/img/member_ico.png";

                if( listObj['MEM_PROFILE_IMG'] ){
                    profile_img_arr = listObj['MEM_PROFILE_IMG'];
                }

                $(".profile"    , comment_obj).attr("src",profile_img_arr);
                $(".writer"     , comment_obj).html(listObj['NICKNAME']);
                $(".writer_time", comment_obj).html(comm.last_time_cal( listObj['REG_DATE'] ));
                $(".contents"   , comment_obj).html((listObj['COMENT']?listObj['COMENT']:""));

                comment_obj_html += $(comment_obj).html();
            }
            $('.reviewList', $conts_review).html(comment_obj_html);
        }


        $(target).replaceWith($conts_review);

        if( list && list.length > 0 ){
            $(target).append('<div class="pagging_wrap"></div>');
        }

    },

    board_view_init : function(viewType, viewId, callback, option){
        let param = {
            "contentsType"  : viewType,
            "contentsId"    : viewId,
        };

        comm.request({url:"/board/view/init",data:JSON.stringify(param)},function(resp){
            if( callback ){
                let call_resp_obj = resp;

                // 태그 세팅 s
                call_resp_obj.tagsHtml = comm.tags_setting_val(call_resp_obj.tags);
                if( option && option.tagsTarget && call_resp_obj.tagsHtml ){
                    $('.conts_tag').show();
                    $('.conts_tag').append(call_resp_obj.tagsHtml);
                }
                // 태그 세팅 e

                // 공감하기 세팅 s
                if( option && option.likeTarget ){

                    $(option.likeTarget).data({
                        "likeId"        : call_resp_obj.LIKE_ID,
                        "contentsType"  : param.contentsType,
                        "contentsId"    : param.contentsId,
                        "likeType"      : '01',
                        "likeYn"        : call_resp_obj.LIKE_YN,
                    });

                    if( call_resp_obj.LIKE_YN == 'N' ){
                        $(option.likeTarget).css({"background":"url('/resources/img/zim_ico.png') no-repeat left center"});
                    }else{
                        $(option.likeTarget).css({"background":"url('/resources/img/icon_heart_on.png') no-repeat left center"});
                    }
                }

                $( (option.likeTarget?option.likeTarget:".like") ).on("click", function(){
                    let $this = $(this);
                    let obj = $($this).data();

                    if( call_resp_obj.loginYn == 'Y' ){
                        let param = obj;

                        comm.request({url:"/board/like/modify",data:JSON.stringify(param)},function(like_resp){

                            $($this).data().likeYn = obj.likeYn = ( $($this).data().likeYn=='Y'?'N':'Y' );

                            if( obj.likeYn == 'N' ){

                                let likecnt = ($($this).data('likecnt')*1)-1

                                if( likecnt < 0 ){
                                    likecnt = 0;
                                }

                                $($this).text( '공감 ' + likecnt );
                                $($this).data('likecnt',likecnt);

                                delete $($this).data().likeId;

                                $(option.likeTarget).css({"background":"url('/resources/img/zim_ico.png') no-repeat left center"});
                            }else{

                                let likecnt = ($($this).data('likecnt')*1)+1
                                $($this).text( '공감 ' + likecnt );
                                $($this).data('likecnt',likecnt);

                                $($this).data().likeId = like_resp.like_id;

                                $($this).data().likeYn = "Y";

                                $(option.likeTarget).css({"background":"url('/resources/img/icon_heart_on.png') no-repeat left center"});
                            }

                        });


                    }else{

                        comm.message.confirm("해당 콘텐츠가 마음에 드시나요? 로그인 후 의견을 알려주세요.\n\n로그인 하시겠습니까?", function(Yn){
                            if( Yn ){
                                comm.loginObj.popup.open();
                            }
                        });

                    }


                })


                // 공감하기 세팅 e

                // 댓글 목록 세팅 s
                if( option && option.commentTarget ){

                    let _pageForm 		= $(option.commentTarget).parents('form');

                    comm.appendInput(_pageForm, "contentsType"  , param.contentsType    );
                    comm.appendInput(_pageForm, "contentsId"    , param.contentsId      );

                    //function(form,url,callback,pageNo,totalCnt,sPageNo,ePageNo,listNo,pagigRange){
                    comm.list(_pageForm, "/board/select/comment", function(comment_resp){

                        comm.comment_setting(
                            param.contentsType,
                            param.contentsId,
                            option.commentTarget,
                            comment_resp.comment.cnt,
                            comment_resp.comment.list,
                            call_resp_obj.loginYn
                        );

                    },1,10);

                }
                // 댓글 목록 세팅 e

                // 댓글 등록 세팅 s
                if( option && option.commentInsertBtn ){

                }
                // 댓글 등록 세팅 e

                callback(call_resp_obj);

            }

        })

    },

    tags_setting_val : function(tags){

        if( !tags ){
            return '';
        }

        let tags_arr = tags.split(",");

        let tagsHtml = '';
        for( let i=0;i<tags_arr.length;i++ ){
            tagsHtml += '<a href="javascript:;">#'+tags_arr[i]+'</a>';
        }

        return tagsHtml;
    },


    getDate : function(date,format){

        let date_format = format || ''

        let year = date.getFullYear(); // 년도
        let month = date.getMonth() + 1;  // 월
        let dt = date.getDate();  // 날짜
        let day = date.getDay();  // 요일

        month = ( "00"+month )
        month = month.substring(month.length-2,month.length);

        dt = ( "00"+dt )
        dt = dt.substring(dt.length-2,dt.length);

        return year + date_format + month + date_format + dt;

    },

    last_time_cal : function(last_date){
        let write_date = new Date(last_date) ;
        let now_date = new Date();

        if( this.getDate(now_date) != this.getDate(write_date)){
            write_date = new Date(this.getDate(write_date,'-')) ;
        }

        let last_time_result = now_date.getTime() - write_date.getTime();
        let floor = function(num){
            return Math.floor(num*1);
        }
        if( ( last_time_result/1000 ) < 60 ){
            return floor(( last_time_result/1000 ))+"초 전";
        }

        if( ( last_time_result/1000/60 ) < 60 ){
            return floor(( last_time_result/1000/60 ))+'분 전';
        }

        if( ( last_time_result/1000/60/60 ) < 60 ){
            return floor(( last_time_result/1000/60/60 ))+'시간 전';
        }

        if( ( last_time_result/1000/60/60/24 ) < 365 ){
            return floor(( last_time_result/1000/60/60/24 ))+'일 전';
        }

        return floor(( last_time_result/1000/60/60/24/365 ))+'년 전';

    },

    loginObj : {
        init : function(type){
            this.popup.init();

            this.loginProcessEvent(type);
            window['login_success_callback'] = this.login_success_callback;

        },

        kakaoInit : function(kakaoObj){



            kakaoObj.init(kakaoKey);
            kakaoObj.isInitialized();

            $(document).on("ready",function(){

                $("#kakao-login-btn").on("click",function(){

                    kakaoObj.Auth.login({
                        success: function(authObj) {
                            kakaoObj.API.request({
                                url: '/v2/user/me',
                                success: function(res) {
                                    login_success_callback(Object.assign(res,{"type":"kakao"}));
                                },
                                fail: function(error) {
                                    comm.message.alert(
                                        'login success, but failed to request user information: ' +
                                        JSON.stringify(error)
                                    )
                                },
                            })
                        },
                        fail: function(err) {
                            comm.message.alert(JSON.stringify(err))
                        },
                    })

                })

            })


        },

        naverInit : function(naverObj){

            const naver_id_login = new naverObj(naverKey, window.location.origin + "/login/loginSuccess");
            let state = naver_id_login.getUniqState();
            naver_id_login.setButton("white", 2,40);
            naver_id_login.setDomain(window.location.origin);
            naver_id_login.setState(state);
            naver_id_login.setPopup();
            naver_id_login.is_callback = true;
            naver_id_login.init_naver_id_login_callback = function(){
                $("img","#naver_id_login").attr("src","/resources/img/login_naver.png");
                $("img","#naver_id_login").css({
                    width: 'auto',height: 'auto'
                })
            }
            naver_id_login.init_naver_id_login();
            // 네이버 로그인 e


        },

        login_success_callback : async function(obj){
            console.log(JSON.stringify(obj));

            let param = {}

            if( obj.type == 'naver' ){
                param.type 		= obj.type;
                param.id 		= obj.id;
                param.email 	= obj.email;
                param.nickname 	= obj.nickname;
                param.name 		= obj.name;
                param.profile 	= obj.profile_image;

            }else{
                param.type 		= obj.type;
                param.id 		= obj.id;
                param.email 	= obj.email;
                param.name 		= obj.name;
                param.nickname 	= obj.properties.nickname;
                param.profile 	= obj.properties.profile_image;

            }

            comm.request({
                url: "/login/loginSuccessCallback",
                data : JSON.stringify(param)
            },function(res){
                // 로그인 성공

                //팝업 닫기
                // comm.loginObj.popup.close();
                //
                // $(".member_set.logOut").show();
                // $(".loginStart").hide();

                window.location.reload();


            })

        },


        loginProcessEvent : function(type){

            $(document).on("ready",function(){

                $('.member_set.logOut').after(loginProcessEventHtml)

                $(".member_set").on("click",function(){
                    $(".member_app").slideToggle("fast");
                })

                $("#logout").on("click",function(){
                    comm.loginObj.logOut(type);
                })


            })
        },

        popup : {
            init : function(){

                let loginHtml = '';
                loginHtml += '<div class="pop_wrap" id="loginHtmlObj">';
                loginHtml += '	<a href="javascript:;" class="btn_close"></a>';
                loginHtml += '	<div class="pop_tit">로그인</div>';
                loginHtml += '	<div class="btn_pop">';
                loginHtml += '		<a href="javascript:;" id="kakao-login-btn"><img src="/resources/img/login_kakao.png"></a>';
                loginHtml += '		<a href="javascript:;" id="naver_id_login"><img src="/resources/img/login_naver.png"></a>';
                loginHtml += '	</div>';
                loginHtml += '</div>';

                if( $("#loginHtmlObj").length > 0 ){
                    $("#loginHtmlObj").remove();
                }

                $("body").append(loginHtml);


                $(".btn_start").click(function () {
                    $("#backbg").fadeIn("slow");
                    $(".pop_wrap").show();
                });
                $(".btn_close").click(function () {
                    $("#backbg").fadeOut("slow");
                    $(".pop_wrap").hide();
                });
            },

            open : function(){
                $("#backbg").fadeIn("slow");
                $(".pop_wrap").show();
            },
            close : function(){
                $("#backbg").fadeOut("slow");
                $(".pop_wrap").hide();
            },
        },

        logOut : function(loginType, callback){

            comm.message.confirm("로그아웃 하시겠습니까?",function(Yn){

                if( Yn ){

                    let logOutParam = {};

                    if( loginType == 'naver' ){
                        logOutParam.type = 'naver';
                        logOutParam.access_token = localStorage.getItem("access_token");
                    }else{
                        logOutParam.type = 'kakao';
                    }

                    comm.request({url:"/login/logOut",data:JSON.stringify(logOutParam)},function(res){

                        $(".logOut").hide();
                        $(".loginStart").show();

                        if( callback ){
                            callback(res);
                        }

                        window.location.reload();

                    })

                }

            });

        },


    },

    request: async function (opt, succCall, errCall) {

        if( opt.form ){

            opt.data = comm.serializeJson($(opt.form).serializeArray());

        }


        $.ajax({

            url: opt.url,
            beforeSend: function (xhr) {

                if( opt.headers ){

                    $.map(opt.headers,function(val,key){
                        xhr.setRequestHeader(key,val);
                    })

                }else{
                    xhr.setRequestHeader("Content-type","application/json");
                }

            },

            type:opt.method || 'POST',
            data : opt.data || null,
            success : function(result){

                if( result.code = '0000' ){
                    if( succCall ){
                        succCall(result);
                    }
                }else{
                    if( errCall ){
                        errCall(result);
                    }else{
                        comm.message.alert(result.message);
                    }
                }

            },
            error:function(result){
                if( errCall ){
                    errCall(result);
                }else{

                    if( result.responseJSON ){
                        let status = result.responseJSON.status;
                        let msg = result.responseJSON.message;

                        comm.message.alert(msg);

                    }else{
                        comm.message.alert("http server error");
                    }

                }
            }

        })
    },

    message: {
        alert: function (msg) {
            alert(msg);
        },
        confirm : function(msg,callback){
            if( confirm(msg) ){
                callback(true);
            }else{
                callback(false);
            }

        }
    },

    list : function(formObj,url,callback,pageNo,listNo,pagigRange,sPageNo,ePageNo,totalCnt,scrollTopYn){

        var form = formObj;

        if( typeof formObj == 'object' ){

            if( $(formObj).attr("id") ){
                form = "#" + $(formObj).attr("id");
            }else{
                form = "#" + "commListForm" + $("form").index($(formObj));
            }

        }

        var _pageNo =1;			// 현재 페이지 번호
        var _listNo = 20;		// 한 페이지에 보여지는 목록 갯수
        var _pagigRange = 10;		// 한페이지에 보여지는 페이징처리 범위
        var _startPageNo;		// 시작 페이지
        var _endPageNo;			// 끝 페이지

        if( $(form).find("[name='viewType']").length == 0 ){
            $(form).append('<input type="hidden" name="viewType" id="viewType">');
        }
        $("[name='viewType']"	,form).val( "ajax" );


        if( $(form).find("[name='pageNo']").length == 0 ){
            $(form).append('<input type="hidden" name="pageNo">');
        }

        if( $(form).find("[name='listNo']").length == 0 ){
            $(form).append('<input type="hidden" name="listNo">');
        }

        if( $(form).find("[name='pagigRange']").length == 0 ){
            $(form).append('<input type="hidden" name="pagigRange">');
        }

        if( $(form).find("[name='startPageNo']").length == 0 ){
            $(form).append('<input type="hidden" name="startPageNo">');
        }


        if( $(form).find("[name='endPageNo']").length == 0 ){
            $(form).append('<input type="hidden" name="endPageNo">');
        }


        if( pageNo ){
            _pageNo = pageNo*1;
        }

        if( listNo ){
            _listNo = listNo*1;
        }

        if( pagigRange ){
            _pagigRange = pagigRange*1;
        }

        if( sPageNo &&  ePageNo){
            _startPageNo = sPageNo*1;
            _endPageNo = ePageNo*1;
        }


        $("[name='pageNo']"		,form).val( _pageNo	 	 );
        $("[name='listNo']"		,form).val( _listNo  	 );
        $("[name='pagigRange']"	,form).val( _pagigRange  );
        $("[name='startPageNo']",form).val( _startPageNo );
        $("[name='endPageNo']"	,form).val( _endPageNo 	 );

        var param = comm.serializeJson($(form).serializeArray());

        comm.request({
              form:form
            , url:url
            , method : "GET"
            , headers : {"Content-type":"application/x-www-form-urlencoded"}
        },function(data){
            // result

            if( callback ){
                if( $.type(callback) == 'function' ){
                    window[$(form).attr("id")+'commListCallback'] = callback;
                }else{
                    window[$(form).attr("id")+'commListCallback'] = window[callback];
                }
                window[$(form).attr("id")+'commListCallback'](data);

            }

            var pageObj = data.vo;

            var firstPage = 1;
            var lastPage = Math.ceil((pageObj.totalCnt*1)/(pageObj.listNo*1));

            if( pageObj.pageNo == 1 ){
                pageObj.startPageNo = pageObj.pageNo;
            }else if(pageObj.pageNo < pageObj.startPageNo){
                pageObj.startPageNo = pageObj.startPageNo - pageObj.pagigRange;
            }else if( pageObj.pageNo > pageObj.endPageNo ){
                pageObj.startPageNo = pageObj.pageNo;
            }


            pageObj.endPageNo = (pageObj.startPageNo + pageObj.pagigRange)-1;

            if(pageObj.endPageNo > lastPage) pageObj.endPageNo=(lastPage==0?1:lastPage);

            var listFunc = "comm.list('"+form+"','"+url+"','"+$(form).attr("id")+"commListCallback'"+
                ",'[pageNo]','"+pageObj.listNo+"','"+pageObj.pagigRange+"','"+pageObj.startPageNo+"','"+pageObj.endPageNo+"','"+totalCnt+"','"+scrollTopYn+"')";


            if( comm.mobile.isYn() ){
                // 모바일
                var pagination_mobile = $(".pagging_wrap",form);

                if( $(pagination_mobile).length == 0 ){
                    pagination_mobile = $(".pagging_wrap");
                }

                if( pageObj.pageNo >= lastPage ){
                    $(pagination_mobile).hide();
                }else{
                    $(pagination_mobile).html('<button type="button" class="more" onclick="'+listFunc.replace("[pageNo]",((pageObj.pageNo*1)+1))+'">+ 더보기</button>');
                }


            }else{
                // pc

                var pageHtml = '';
                if( pageObj.startPageNo <= 1 ){
                    pageHtml += '<a href="javascript:;"><img src="/resources/img/prev_arrow.png"></a>';
                }else{
                    //pageHtml += '<a href="#none" class="first" title="처음" onclick="'+listFunc.replace("[pageNo]",1)+'"><span> << 처음</span></a>';
                    pageHtml += '<a href="javascript:;" onclick="'+listFunc.replace("[pageNo]",pageObj.startPageNo-1)+'"><img src="/resources/img/prev_arrow.png"></a>';
                }

                for(var i =pageObj.startPageNo;i<=pageObj.endPageNo;i++){
                    if( i == pageNo ){
                        pageHtml += '<a href="javascript:;" class="on">'+(i)+'</a>';
                    }else{
                        pageHtml += '<a href="javascript:;" onclick="'+listFunc.replace("[pageNo]",i)+'">'+i+'</a>';
                    }
                }

                if( pageObj.endPageNo >= lastPage ){
                    pageHtml += '<a href="javascript:;"><img src="/resources/img/next_arrow.png"></a>';
                    pageHtml += '';
                }else{
                    pageHtml += '<a href="javascript:;" onclick="'+listFunc.replace("[pageNo]",pageObj.endPageNo+1)+'"><img src="/resources/img/next_arrow.png"></a>';
                    //pageHtml += '<a href="#none" class="last" title="마지막" onclick="'+listFunc.replace("[pageNo]",lastPage)+'"><span>마지막 >> </span></a>';
                }

                var pagination_pc = $(".pagging_wrap",form);
                if( $(pagination_pc).length == 0 ){
                    pagination_pc = $(".pagging_wrap");
                }

                $(pagination_pc).html(pageHtml);
                if( !scrollTopYn || scrollTopYn == "Y" ){
                    $('html').scrollTop(0);
                }

            }

        })

    },

    /**
     * form 요소에 serializeArray를 json 파라미터 형태로 리턴해준다
     * */
    serializeJson : function(arr){
        var obj = {};
        arr.forEach(function(data) {
            if( data.value ){
                obj[data.name] = data.value;
            }

        })

        return obj;
    },

    appendInput : function(form, name, value){
        if( $("#"+name).length == 0 ){
            $(form).append('<input type="hidden" name="'+name+'" id="'+name+'">');
        }

        $(form).find("input[name='"+name+"']").val(value);
        return $(form).find("input[name='"+name+"']");
    },

    mobile : {
        isYn : function(){
            return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
        }
    }

};