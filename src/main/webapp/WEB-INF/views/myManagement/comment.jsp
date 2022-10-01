<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">

</script>

<div class="section uline2">
    <div class="ani-in manage_layout">

        <div class="manage_conts">

            <%@include file="commMenu.jsp"%>

            <div class="manage_box_wrap">

                <div class="sub_title01">
                    댓글 설정
                    <div class="btn_tb_wrap">
                        <div class="btn_tb">
                            <a href="javascript:;" class="on">변경사항 저장</a>
                        </div>
                    </div>
                </div>

                <div class="review_write">
                    <span>댓글 작성은</span>
                    <select>
                        <option>모두</option>
                        <option>관리자</option>
                        <option>작성자</option>
                    </select>
                    <span>가능합니다.</span>
                </div>

            </div><!-------------//manage_box_wrap------------->

        </div>

    </div>
</div>