<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="pagging_wrap">
	<%--<a href="javascript:;"><img src="/resources/img/prev_arrow.png"></a>
	<a href="javascript:;" class="on">1</a>
	<a href="javascript:;">2</a>
	<a href="javascript:;">3</a>
	<a href="javascript:;"><img src="/resources/img/next_arrow.png"></a>--%>
</div>



<script>
	var _pageForm 		= '${param.form}';
	var _url 			= '${param.url}';
	var _listCallback	= '${param.listCallback}';
	var _totalCnt 		= '${param.totalCnt}'?'${param.totalCnt}'*1:"";
	var _pageNo 		= '${param.pageNo}'?'${param.pageNo}'*1:"1";
	var _listNo 		= '${param.listNo}'?'${param.listNo}'*1:"";
	var _pagigRange 	= '${param.pagigRange}'?'${param.pagigRange}'*1:"";
	var _startPageNo 	= '${param.startPageNo}'?'${param.startPageNo}'*1:"";
	var _endPageNo 		= '${param.endPageNo}'?'${param.endPageNo}'*1:"";
	var _scrollTopYn 	= '${param.scrollTopYn}';


	//function(form,url,callback,pageNo,totalCnt,sPageNo,ePageNo,listNo,pagigRange){
	comm.list(_pageForm,_url,_listCallback,_pageNo,_listNo,_pagigRange,_startPageNo,_endPageNo,_totalCnt,_scrollTopYn);
	
</script>
