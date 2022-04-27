let comm = {


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

                    if( loginYn ){
                        let param = obj;

                        comm.request({url:"/board/like/modify",data:JSON.stringify(param)},function(resp){

                            $($this).data().likeYn = obj.likeYn = ( $($this).data().likeYn=='Y'?'N':'Y' );

                            if( obj.likeYn == 'N' ){

                                let likecnt = ($($this).data('likecnt')*1)-1

                                if( likecnt < 0 ){
                                    likecnt = 0;
                                }

                                $($this).text( '공감 ' + likecnt );
                                $($this).data('likecnt',likecnt);

                                $(option.likeTarget).css({"background":"url('/resources/img/zim_ico.png') no-repeat left center"});
                            }else{

                                let likecnt = ($($this).data('likecnt')*1)+1
                                $($this).text( '공감 ' + likecnt );
                                $($this).data('likecnt',likecnt);

                                $(option.likeTarget).css({"background":"url('/resources/img/icon_heart_on.png') no-repeat left center"});
                            }

                        });


                    }else{

                        comm.message.confirm("해당 콘텐츠가 마음에 드시나요? 로그인 후 의견을 알려주세요.\n\n로그인 하시겠습니까?", function(Yn){
                            if( Yn ){
                                $(".btn_start").click();
                            }
                        });

                    }


                })


                // 공감하기 세팅 e

                // 댓글 목록 세팅 s
                if( option && option.commentTarget ){

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

    last_time_cal : function(last_date){
        let write_date = new Date(last_date) ;
        let now_date = new Date();
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
                    loginYn = false;

                    if( callback ){
                        callback(res);
                    }

                    window.location.reload();

                })

            }

        });

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

    list : function(form,url,callback,pageNo,listNo,pagigRange,sPageNo,ePageNo,totalCnt,scrollTopYn){

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


    mobile : {
        isYn : function(){
            return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
        }
    }

};