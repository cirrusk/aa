<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>오프라인강의 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>
<script type="text/javascript">
var searchapseqObj = eval("${searchapseqArr}");
var oriSearchapseqObj = eval("${searchapseqArr}");
$(document).ready(function() { 
	setTimeout(function(){ abnkorea_resize(); }, 500);
	var courseid = $("#searchForm > input[name='courseid']").val();
	var back = $("#searchForm > input[name='back']").val();
	if(back != "Y"){
		fnAnchor2();	
	}else{
		//포커스 이동 필요
	}
	defaultCheck();
});
// 상세보기 호출
function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
	$("#searchForm > input[name='courseid']").val(courseidVal);
	$("#searchForm").attr("action", actionUrl);
	$("#searchForm").submit();
}
var defaultCheck = function(){
	if(searchapseqObj.length == 0){
		if("Y" != "${param.searchYn}"){
			$("#searchForm input[name=checkAll]").prop("checked", true);
			$("#seq_button_all").addClass("active");
			$("#searchForm input[name=searchapseq]").prop("checked", true);
			$(".seq_button").addClass("active");
		}
	}else{
		for(var i = 0 ; i < searchapseqObj.length; i++){
			$("#searchForm input[name=searchapseq][value="+searchapseqObj[i]+"]").prop("checked", true);
			$("#seq_button_"+searchapseqObj[i]).addClass("active");
		}
	}
	var checkedNum = $("#searchForm input[name=searchapseq]:checked").length;
	var objNum = $("#searchForm input[name=searchapseq]").length;
	if(checkedNum == objNum){
		$("#checkAll").prop("checked", true);	
		$("#seq_button_all").addClass("active");
	}
	
	if($("#checkAll").is(":checked")){
		$("#searchForm input[name=searchapseq]").prop("checked", false);
		$(".seq_button").removeClass("active");
	}

};
function allCheck(obj){
	$("#searchForm input[name='searchapseq']").prop("checked", $(obj).is(":checked"));
	searchGo();
}
var searchGoSelect =function(){
	$("#searchForm input[name='searchYn']").val("");
	$("#searchForm input[name='searchapseq']").prop("checked", false);
	searchGo();
};

var searchGo = function(){
	var checkedNum = $("#searchForm input[name=searchapseq]:checked").length;
	var objNum = $("#searchForm input[name=searchapseq]").length;
	if(checkedNum != objNum){
		$("#checkAll").prop("checked", false);	
	}else{
		$("#checkAll").prop("checked", true);
	}
	if($("#searchForm input[name='page']").val() == "0"){
		$("#searchForm input[name='page']").val("1");
	}
	var viewtype = $("#searchForm input[name='viewtype']").val();
	if(viewtype != "2"){
		$("#searchForm").attr("action", "/mobile/lms/request/lmsOffline.do");
	}else{
		$("#searchForm").attr("action", "/mobile/lms/request/lmsOfflineMonth.do");
	}
	$("#searchForm").submit();
	
};
var searchTab = function(viewtype){
	$("#searchForm input[name='viewtype']").val(viewtype);
	$("#searchForm input[name='searchYn']").val("");
	searchGo();
};
var changeMonth = function(type){
	$("#searchForm input[name='searchYn']").val("");
	$("#searchForm input[name='searchapseq']").prop("checked", false);
	var searchyear = Number($("#searchyear").val());
	var searchmonth = Number($("#searchmonth").val());
	if(type == "prev"){
		var searchmonth = searchmonth - 1;
		if(searchmonth == 0){
			searchyear = searchyear - 1;
			searchmonth  = 12;
		}
	}
	if(type == "next"){
		var searchmonth = searchmonth + 1;
		if(searchmonth == 13){
			searchyear = searchyear + 1;
			searchmonth  = 1;
		}
	}
	searchmonth = lpad(searchmonth);
	$("#searchyear").val(searchyear);
	$("#searchmonth").val(searchmonth);
	if($("#searchmonth").val() != searchmonth){
		$("#searchmonth").append('<option value="'+searchmonth+'" selected>'+searchmonth+'</option>');
	}
	searchGo();
};
var lpad = function(str){
	if(str < 10 ){
		str = "0"+str;
	}
	return str;
};
</script>
</head>
<body class="uiGnbM3">
<form name="searchForm" id="searchForm">
<input type="hidden" name="courseid" value="${scrData.courseid }">
<input type="hidden" name="page" value="${scrData.page }">
<input type="hidden" name="back" value="${scrData.back }">
<input type="hidden" name="totalPage" value="${scrData.totalPage }">
<input type="hidden" name="viewtype" value="${scrData.viewtype }">
<input type="hidden" name="searchday" value="01">
<input type="hidden" name="searchYn" value="Y">

		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			
			<div class="tabWrap">
				<span class="hide">탭 메뉴</span>
				<ul class="tabDepth1 tNum2">
					<li><a href="javascript:;" onclick="searchTab('');">강의목록</a></li>
					<li class="on"><strong>스케줄목록</strong></li>
				</ul>
			</div>
			
			<div class="selectArea">
				<a href="#none"  id="seq_button_all"><label for="checkAll">전체보기</label></a>
			<c:forEach items="${apList }" var="data" varStatus="status">
				<a href="#none" class="seq_button" id="seq_button_${data.apseq }"><label for="check${data.apseq }">${data.apname }</label></a>
			</c:forEach>
				<div style="display:none">
					<input type="checkbox" name="checkAll" id="checkAll"  onclick="allCheck(this)" value="Y" <c:if test="${param.checkAll eq 'Y' }">checked</c:if> />
			<c:forEach items="${apList }" var="data" varStatus="status">
					<input type="checkbox" name="searchapseq" id="check${data.apseq }"  value="${data.apseq }"  onclick="searchGo();" />
			</c:forEach>
				</div>				
			</div>

			<div class="scheduleMonth">
				<p class="textConnent">※ 신청이 종료된 교육은 리스트에 표기되지 않습니다.</p>
				<%-- <c:if test='${nowyn ne "Y" }'> --%>
					<a href="javascript:;" class="monthPrev" onclick="changeMonth('prev');"><span class="hide">이전달</span></a>
				<%-- </c:if> --%>
				<select class="year" title="년도" name="searchyear" id="searchyear" onchange="searchGoSelect();">
					<c:forEach begin="0" end="1" step="1" var="i">
						<option value="${nowyear + 1 - i }" <c:if test="${ searchyear eq (nowyear + 1 - i) }"> selected</c:if>>${nowyear + 1 - i }년</option>
					</c:forEach>
				</select>
				<c:set var="startnum" value="${1 }" />
				<%-- 
				<c:if test="${nowyear eq searchyear }">
					<c:set var="startnum" value="${nowmonth}"  />
				</c:if>
				 --%>
				<select class="month" title="월" name="searchmonth" id="searchmonth" onchange="searchGoSelect();">
					<c:forEach begin="${startnum }" end="12" step="1" var="i">
						<c:set var="monthval"><fmt:formatNumber pattern="00" value="${i}" /></c:set>
						<option value="${monthval }" <c:if test="${monthval eq searchmonth }"> selected</c:if>>${monthval }</option>
					</c:forEach>
				</select>
				<a href="javascript:;" class="monthNext" onclick="changeMonth('next');"><span class="hide">다음달</span></a>
			</div>
			
			
			<ul class="scheduleList">
		<c:set var="showyntotal" value="N" />
		<c:forEach items="${monthList }" var="item2" varStatus="status">
			<c:set var="showyn" value="N" />
			<c:forEach items="${courseList }" var="item" varStatus="status">
				<c:if test='${item.startdatestr eq item2.usedate }'>
					<c:set var="showyn" value="Y" />
					<c:set var="showyntotal" value="Y" />
				</c:if>
			</c:forEach>
			<c:if test='${showyn eq "Y" }'>
				<li class="<c:if test='${item2.nowthen ne "P" and (item2.weekname eq "토" or item2.weekname eq "일") }'> weekend</c:if><c:if test='${item2.nowthen eq "P" }'> lastday</c:if>">
					<span class="day"><strong>${item2.num }</strong>(${item2.weekname })</span>
					<span class="eduName">
					<c:forEach items="${courseList }" var="item" varStatus="status">
						<c:if test='${item.startdatestr eq item2.usedate }'>
							<c:if test='${item2.nowthen eq "P" }'>
								<em>[${item.apname }]</em> ${item.coursename } (${item.themename })<br>
							</c:if>
							<c:if test='${item2.nowthen eq "F" }'>
								<a href="#none" data-courseid="${item.courseid }" onclick="fnAccesViewClick('${item.courseid }','request');"><em>[${item.apname }]</em> ${item.coursename }</a><br>
							</c:if>
						</c:if>
					</c:forEach>	
					</span>
				</li>
			</c:if>
		</c:forEach>
			</ul>
		<c:if test='${showyntotal eq "N" }'>
			<p class="comingSoon"><img src="/_ui/mobile/images/academy/img_comingsoon.gif" alt="Coming Soon... 현재 진행중인 교육이 없습니다." /></p>			
		</c:if>
		<c:if test='${showyntotal ne "N" }'>
			<div class="acSubWrap">
				<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
			</div>
		</c:if>
		</section>
		<!-- content ##iframe end## -->
</form>

<!-- SNS layer popup -->
<div class="pbLayerPopup" id="uiLayerPop_URLCopy">
	<div class="alertContent">
		<h2 class="hide">URL 복사</h2>
		<em>복사하기 하여, <br>원하는 곳에 붙여넣기 해주세요</em>
		<input type="text" title="URL 주소" class="url" id="pbLayerPopupUrl" value=""><input type="hidden" id="snsCourseid" value="">
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>
<!-- //SNS layer popup -->

</div>
</body>
</html>