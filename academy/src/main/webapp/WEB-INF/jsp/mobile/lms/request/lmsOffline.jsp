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
<script src="/_ui/mobile/common/js/apps/kakao.link.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.min.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>
<script type="text/javascript">
var searchapseqObj = eval("${searchapseqArr}");
var oriSearchapseqObj = eval("${searchapseqArr}");
$(document).ready(function() { 
	setTimeout(function(){ abnkorea_resize(); }, 500);
	$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
	var courseid = $("#searchForm > input[name='courseid']").val();
	var back = $("#searchForm > input[name='back']").val();
	if(back != "Y"){
		fnAnchor2();	
	}else{
		//포커스 이동 필요
		fnAnchor2();
	}
	defaultCheck();
});
// 상세보기 호출
function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
	$("#searchForm > input[name='courseid']").val(courseidVal);
	$("#searchForm").attr("action", actionUrl);
	$("#searchForm").submit();
}
// 다음 20개 더보기
function nextPage(){
	var page = $("#searchForm > input[name='page']").val();
	var nextPage = Number(page) + 1;
	$("#searchForm > input[name='page']").val(nextPage);
	var back = $("#searchForm > input[name='back']").val();
	$("#searchForm > input[name='back']").val("");
	var totalPage = $("#searchForm > input[name='totalPage']").val();
	if(nextPage >= totalPage){
		$("#nextPage").hide();
	}
	callList(nextPage, back);
}
function callList(page, back){
	$("#searchForm > input[name='page']").val(page);
	$("#searchForm > input[name='back']").val(back);
	$.ajaxCall({
   		url: "/mobile/lms/request/lmsOffline.do"
   		//, data: {page: page, back: back}
   		, data: $("#searchForm").serialize()
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){
   			$("#articleSection").append($(data).find("#articleSection"));
   			abnkorea_resize();
   			$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
   		}
   	});
}
var defaultCheck = function(){
	if(searchapseqObj.length == 0){
		$("#searchForm input[name=checkAll]").prop("checked", true);
		$("#seq_button_all").addClass("active");
		$("#searchForm input[name=searchapseq]").prop("checked", true);
		$(".seq_button").addClass("active");
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
</script>
</head>
<body class="uiGnbM3">
<form name="searchForm" id="searchForm">
<input type="hidden" name="courseid" value="${scrData.courseid }">
<input type="hidden" name="page" value="${scrData.page }">
<input type="hidden" name="back" value="${scrData.back }">
<input type="hidden" name="totalPage" value="${scrData.totalPage }">
<input type="hidden" name="viewtype" value="">
<input type="hidden" name="searchyear" value="${searchyear}">
<input type="hidden" name="searchmonth" value="${searchmonth }">
<input type="hidden" name="searchday" value="01">
<input type="hidden" name="searchYn" value="Y">
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			
			<div class="tabWrap">
				<span class="hide">탭 메뉴</span>
				<ul class="tabDepth1 tNum2">
					<li class="on"><strong>강의목록</strong></li>
					<li><a href="javascript:;" onclick="searchTab('2');">스케줄목록</a></li>
				</ul>
			</div>
			
			<div class="selectArea">
				<a href="#none"  id="seq_button_all"><label for="checkAll">전체보기</label></a>
			<c:forEach items="${apList }" var="data" varStatus="status">
				<a href="#none" class="seq_button" id="seq_button_${data.apseq }"><label for="check${data.apseq }">${data.apname }</label></a>
			</c:forEach>
				<div style="display:none">
					<input type="checkbox" name="checkAll" id="checkAll"  onclick="allCheck(this)" value="Y" <c:if test="${param.checkAll eq 'Y' }">checked</c:if>/>
			<c:forEach items="${apList }" var="data" varStatus="status">
					<input type="checkbox" name="searchapseq" id="check${data.apseq }"  value="${data.apseq }"  onclick="searchGo();" />
			</c:forEach>
				</div>				
			</div>
			
			<div class="acSubWrap" id="articleDiv">
				<p class="textConnent">※ 신청이 종료된 교육은 리스트에 표기되지 않습니다.</p>
				<section class="acItems" id="articleSection">
				<c:if test="${empty courseList and (scrData.page eq '1' or scrData.page eq '0')  }">
					<article class="item">
						<div class="nodata">
							<c:choose>
								<c:when test="${ searchapseqArr eq '[99999999]' }">
									선택된 지역이 없습니다. 지역을 선택해주세요.
								</c:when>
								<c:otherwise>
									등록된 오프라인강의가 없습니다.
								</c:otherwise>
							</c:choose>	
						</div>
					</article>
				</c:if>
				<c:forEach items="${courseList }" var="item" varStatus="status">
					<article class="item<c:if test='${item.requestflag eq "Y" }'> selected</c:if>" id="data${item.courseid }">
						<a href="javascript:;" onclick="fnAccesViewClick('${item.courseid }', 'request');">
							<strong class="tit">[${item.apname }]  ${item.coursename }</strong>
							<span class="category">${item.themename }</span>
							<span class="img">
								<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course" alt="${item.courseimagenote}" />
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecount }</em>
						<c:if test="${item.snsflag eq 'Y' }"	>
							<a href="#none" class="share" data-url="${httpDomain }/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
						<div class="itemCont">
							<p>
								<span class="tit">대상</span>${item.target }<br>
								<span class="tit">교육</span>${item.startdate4 } ~ ${item.enddate4 }<br />
								<span class="tit">신청</span>${item.requeststartdate5 } ~ ${item.requestdiff }<br />
							</p>
							<!-- <p class="date">등록일 2013-02-01</p> -->
						</div>
					</article>
				</c:forEach>
				</section><!-- //.acItems -->
				
				<c:if test="${scrData.totalPage ne scrData.page and scrData.page ne '0'  }">
				<a href="#none" class="listMore" id="nextPage" onclick="nextPage();"><span>20개 더보기</span></a>
				</c:if>
				<c:if test="${scrData.totalCount ne '0'  }">
					<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
				</c:if>
			</div>
				
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

</body>
</html>