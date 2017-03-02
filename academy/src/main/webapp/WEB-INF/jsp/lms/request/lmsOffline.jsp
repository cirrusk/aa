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
<!-- page common -->
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- //page common -->
<!-- page unique -->
<meta name="Description" content="설명들어감">
<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>오프라인과정 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script src="/_ui/desktop/common/js/owl.carousel.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsComm.js"></script>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>
<script type="text/javascript">
var searchapseqObj = eval("${searchapseqArr}");
var oriSearchapseqObj = eval("${searchapseqArr}");
$(document).ready(function() {
	setTimeout(function(){ abnkorea_resize(); }, 500);
	fnAnchor2();
	defaultCheck();
	
	$(".goView").on("click",function(){
		goView(this);
	});
	if($("#searchForm input[name='viewtype']").val() == "2"){
		$("#searchForm input[name='viewtype']").val("")
		searchTab('2');
	}
});
var defaultCheck = function(){
	if(searchapseqObj.length == 0){
		if("Y" != "${param.searchYn}"){
			$("#searchForm input[name=checkAll]").prop("checked", true);
			$("#searchForm input[name=searchapseq]").prop("checked", true);
		}
	}else{
		for(var i = 0 ; i < searchapseqObj.length; i++){
			$("#searchForm input[name=searchapseq][value="+searchapseqObj[i]+"]").prop("checked", true);
		}
	}
};
function allCheck(obj){
	$("#searchForm input[name='searchapseq']").prop("checked", $(obj).is(":checked"));
	searchGo();
}
var searchGo = function(){
	var objNum = $("#searchForm input[name=searchapseq]").length;
	var checkedNum = $("#searchForm input[name=searchapseq]:checked").length;
	
	if(checkedNum != objNum){
		$("#checkAll").prop("checked", false);	
	}
	var viewtype = $("#searchForm input[name='viewtype']").val();
	if(viewtype != "2"){
		$("#searchForm").attr("action", "/lms/request/lmsOffline.do");
		$("#searchForm").submit();
	}else{
		$.ajaxCall({
	   		url: "/lms/request/lmsOfflineMonth.do"
	   		, data: $("#searchForm").serialize()
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			if($(data).filter("#result").html() == "LOGOUT"){
	   				fnSessionCall("");
	   				return;
	   			}
	   			$("#viewTypeSchedule").html($(data).filter("#courseList"));
	   			$("#apList").html($(data).filter("#apList"));
	   			searchapseqObj = eval( $(data).filter("#searchapseqArr").html() );
	   			defaultCheck();
	   			abnkorea_resize();
	   		}
	   	});
	}
};
var changeMonth = function(type){
	$("#searchForm > input[name='searchYn']").val("");
	$("#searchForm input[name='searchapseq']").prop("checked", false);
	var searchyear = Number($("#searchForm input[name='searchyear']").val());
	var searchmonth = Number($("#searchForm input[name='searchmonth']").val());
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
	$("#searchForm input[name='searchyear']").val(searchyear);
	$("#searchForm input[name='searchmonth']").val(searchmonth);
	searchGo();
	$("#searchForm > input[name='searchYn']").val("Y");
};
var lpad = function(str){
	if(str < 10 ){
		str = "0"+str;
	}
	return str;
};
var searchMonthGo = function(){
	$("#searchForm input[name='viewtype']").val("2");
	searchGo();
};
var goView = function(obj){
	fnAccesViewClick($(obj).attr("data-courseid"), "request");
};
//상세보기 호출
function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
	$("#searchForm > input[name='courseid']").val(courseidVal);
	$("#searchForm").attr("action", actionUrl);
	$("#searchForm").submit();
}
var searchTab = function(viewtype){
	var oldviewtype = $("#searchForm input[name='viewtype']").val();
	$("#searchForm input[name='viewtype']").val(viewtype);
	if(oldviewtype != "2" && viewtype == "2"){
		$("#searchForm > input[name='searchYn']").val("");
		$("#searchForm input[name='searchapseq']").prop("checked", false);
		$("#searchapseqhidden").html($("#apList").html());
		searchGo();
		$("#searchForm > input[name='searchYn']").val("Y");
	}
	if(oldviewtype == "2" && viewtype != "2"){
		$("#apList").html($("#searchapseqhidden").html());
		searchapseqObj = oriSearchapseqObj;
		defaultCheck();
	}
	setTimeout(function(){ abnkorea_resize(); }, 100);
};
</script>
</head>
<body>


		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030700200.gif" alt="오프라인강의"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030700200.gif" alt="최신 트렌드에 따른 다양한 주제와 전문적인 내용을 현장에서 만나보세요."></p>
			</div>
			
			<!-- 상세복기-간략보기 -->
	
			<div class="toggleViewBox">
<form name="searchForm" id="searchForm">
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="courseid">
<input type="hidden" name="searchyear" value="${searchyear}">
<input type="hidden" name="searchmonth" value="${searchmonth }">
<input type="hidden" name="searchday" value="01">
<input type="hidden" name="searchYn" value="Y">

				<div class="viewTypeBox">
					<div class="viewTypeSet">
						<a href="#viewTypeList" class="list<c:if test='${empty param.viewtype}'> on</c:if>" onclick="searchTab('');">상세보기</a>
						<a href="#viewTypeSimple" class="simple<c:if test='${param.viewtype eq "1"}'> on</c:if>" onclick="searchTab('1');">간략보기</a>
						<a href="#viewTypeSchedule" class="schedule<c:if test='${param.viewtype eq "2"}'> on</c:if>" onclick="searchTab('2');">스케줄보기</a>
					</div>

					<div class="checkboxBox" id="apList">
						<input type="checkbox" name="checkAll" id="checkAll"  value="Y" onclick="allCheck(this)" <c:if test="${param.checkAll eq 'Y' or empty param.searchYn }">checked</c:if> /><label for="checkAll">전체</label>
					<c:forEach items="${apList }" var="data" varStatus="status">
						<input type="checkbox" name="searchapseq" id="check${status.count+1 }"  value="${data.apseq }"  onclick="searchGo();" /><label for="check${status.count+1 }">${data.apname }</label>
					</c:forEach>
					</div>
					<p class="mgtM">※ 신청이 종료된 교육은 리스트에 표기되지 않습니다.</p>
				</div>
</form>
				<!-- 목록 -->
				<!-- 상세목록 -->
				<div class="viewWrapper viewList" id="viewTypeList">
					<table class="tblThumbView">
						<caption>상세목록</caption>
						<colgroup>
							<col style="width:245px" />
							<col style="width:auto" />
						</colgroup>
						<tbody>
						<c:if test="${empty courseList }">
							<tr class="acItems">
								<td colspan="2">
									<div class="noItems">
										<c:choose>
											<c:when test="${ searchapseqArr eq '[99999999]' }">
												선택된 지역이 없습니다. 지역을 선택해주세요.
											</c:when>
											<c:otherwise>
												등록된 오프라인강의가 없습니다.
											</c:otherwise>
										</c:choose>	
									</div>
								</td>
							</tr>
						</c:if>
						<c:forEach items="${courseList }" var="item" varStatus="status">
							<tr class="acItems<c:if test='${item.requestflag eq "Y" }'> finish</c:if>">
								<td><a href="#none" class="acThumbImg goView" data-courseid="${item.courseid }"><img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course" alt="${item.courseimagenote}" /><c:if test='${not empty item.requestflag }'><span class="off">신청완료</span></c:if></a></td>
								<td>
									<div class="contBox">
									<c:set var="coursename" value="[${item.apname }] ${item.coursename }" />
									<c:if test="${fn:length(coursename) > 58}">
										<c:set var="coursename" value="${fn:substring(coursename,0,56) }..." />
									</c:if>
										<span class="title"><a href="javascript:void(0);" data-courseid="${item.courseid }" class="title goView">${coursename }</a></span>
										<p class="subtext">대상 : ${item.target } <br/>
											교육 : ${item.startdate } ~ ${item.enddate }<br/>
											신청 : ${item.requeststartdate } ~ ${item.requestenddate } ${item.requestdiff }
											<%-- <br/>
											등록일 : ${item.registrantdate } --%> 
										</p>
									
										<div class="snsZone">
										<c:if test="${item.snsflag eq 'Y' }">
											<!-- sns module -->
											<div class="snsLink">
												<span class="snsUrlBox">
													<a href="#snsUrlCopy" class="snsUrl" onclick=""><span class="hide">URL 복사</span></a>
													<span class="alert" id="snsUrlCopy" style="display:none;">
														<span class="alertIn">
															<!-- ie, 크롬 일 경우 :
															<em>주소가 복사되었습니다.<br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
															-->
															<!-- 사파리, 파이어폭스 일 경우 -->
															<em>복사하기(Ctrl+C) 하여, <br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
															<input type="text" title="URL 주소" value="${httpDomain }/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }">
															<!-- //사파리, 파이어폭스 일 경우 -->
														</span>
														<a href="#none" class="btnClose"><img src="/_ui/desktop/images/common/btn_close4.gif" alt="URL 복사 안내 닫기"></a>
													</span>
												</span>
												<a href="#none" class="snsCs"><span class="hide">카카오스토리</span></a>
												<a href="#none" class="snsBand"><span class="hide">밴드</span></a>
												<a href="#none" class="snsFb"><span class="hide">페이스북</span></a>
											</div>
											<!-- //sns module -->
											<a href="#none" class="share"><span class="hide">공유</span></a>
										</c:if>
											<a href="#none" class="like <c:if test="${item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlab2${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
											<em id="likecntlab${item.courseid}">${item.likecount }</em>
										</div><!-- //snsZone -->
									
									</div>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- //상세목록 -->
				
				<!-- 간략목록 -->
				<div class="viewWrapper viewTypeSimple" id="viewTypeSimple">
					<div class="simpleViewList">
						<div class="acItems">
						<c:if test="${empty courseList }">
							<div class="noItems">
								<c:choose>
									<c:when test="${ searchapseqArr eq '[99999999]' }">
										선택된 지역이 없습니다. 지역을 선택해주세요.
									</c:when>
									<c:otherwise>
										등록된 오프라인강의가 없습니다.
									</c:otherwise>
								</c:choose>
							</div>
						</c:if>
						<c:if test="${ not empty courseList }">
							<c:forEach items="${courseList }" var="item" varStatus="status">
								<div class="item<c:if test='${not empty item.requestflag }'> finish</c:if>">
									<a href="#none" data-courseid="${item.courseid }" class="acThumbImg goView">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course" alt="${item.courseimagenote}" />
										<c:set var="coursename" value="[${item.apname }] ${item.coursename }" />
										<c:if test="${fn:length(coursename) > 36}">
											<c:set var="coursename" value="${fn:substring(coursename,0,34) }..." />
										</c:if>
										<span class="tit type2">${coursename }</span>
										<span class="period"><strong>신청기간</strong> ${item.requestdiff }<br/>${item.requeststartdate2 } ~ ${item.requestenddate2 }</span>
									<c:if test='${not empty item.requestflag }'>
										<span class="off">신청완료</span>
									</c:if>	
									</a>
									<div>
										<a href="#none" class="scLike <c:if test="${item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlab2${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span><em id="likecntlab2${item.courseid}">${item.likecount }</em></a>
									</div>
								</div>
							</c:forEach>
						</c:if>
						</div>
					</div>
				</div>
				<!-- //간략목록 -->
				
				<!-- 스케줄보기 -->
				<div class="viewWrapper viewTypeSchedule" id="viewTypeSchedule">
				</div>
				<!-- //스케줄보기 -->
				
				
			</div>
			<!-- //상세보기-간략보기 -->

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
<div style="display:none;" id="searchapseqhidden"></div>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>