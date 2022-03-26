let comm = {

    logOut : function( callback){
        comm.request({url:"/login/logOut",data:JSON.stringify({})},function(res){

            if( callback ){
                callback(res);
            }

        })
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

        comm.request({form:form, url:url},function(data){
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


            if( wfaComm.mobile.isYn() ){
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

                pageHtml += '<ol>';

                for(var i =pageObj.startPageNo;i<=pageObj.endPageNo;i++){
                    if( i == pageNo ){
                        pageHtml += '<a href="javascript:;" className="on">'+(i)+'</a>';
                    }else{
                        pageHtml += '<a href="javascript:;" onclick="'+listFunc.replace("[pageNo]",i)+'">'+i+'</a>';
                    }
                }

                pageHtml += '</ol>';

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

};