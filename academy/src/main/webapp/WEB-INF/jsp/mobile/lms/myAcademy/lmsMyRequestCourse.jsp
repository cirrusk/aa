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
<title>통합교육신청 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<style>
.pbLayerPopup#uiLayerPop_acApp{top:50px !important} /* 팝업위치 */
</style>
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
$(document).ready(function() {
	if(navigator.userAgent.match(/android/i)){
		$("#amwaygo_android").show();
	}
	if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
		$("#amwaygo_iphone").show();
	}
	$(".popCloseConfirm").click(function(){
		$(".btnPopClose").trigger("click");
	});
	setTimeout(function(){ abnkorea_resize(); }, 500);
	fnAnchor2();
});
var resize_iframe = function(){
	setTimeout(function(){ abnkorea_resize(); }, 100);
}
var fnSurvey = function( thisObj, courseidVal, stepcourseidVal, stepSeqVal, statusVal ) {
	if(statusVal == "A"){
		alert("설문 참여 기간이 아닙니다.");
		return;
	}
	//설문 ajax로 읽어서 div에 뿌려준 후 layer 호출하기
	var param = {
		courseid : courseidVal
		, stepcourseid : stepcourseidVal
		, stepseq : stepSeqVal
	}
	$.ajaxCall({
   		url: "/mobile/lms/myAcademy/lmsMySurveyAjax.do"
   		, data: param 
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){
   			if($(data).filter("#result").html() == "LOGOUT"){
   				fnSessionCall("");
   				return;
   			}
   			
   			var status = $(data).filter("#status").html(); 
   			
   			if( status == "END" ) {
   				alert("설문이 종료되었습니다.");
   				layerPopupOpen(thisObj);
   				return;
   			} else if( status == "READY" ) {
   				alert("설문이 준비중입니다.");
   				layerPopupOpen(thisObj);
   				return;
   			}
   			
   			$("#surveyLayerPopup").html($(data).filter("#surveyLayerPopup").html());
   			layerPopupOpen(thisObj);
   			abnkorea_resize();
   			fnAnchor2();
   		}
   	});
}
var fnSurveySubmit = function() {
	//입력되지 않은 설문 체크할 것
	var surveycount = parseInt($("#surveycount").val());
	
	//문제 체크할 것
	for( var i=1; i<=surveycount; i++ ) {
		if($("#surveytype_"+i).val() == "1" || $("#surveytype_"+i).val() == "2") {
			//객관식은 정답을 reponse에 담기
			var samplecount = parseInt($("#samplecount_"+i).val());
			var opinionContent = "";
			for( var k=1; k<=samplecount; k++) {
				if( $("#sampleseq_"+i+"_"+k).is(":checked") ) {
					opinionContent += k + ",";
				}
			}
			if( opinionContent == "" ) {
				alert( i + "번째 설문에 참여해 주세요.");
				return;
			} else {
				$("#response_"+i).val( opinionContent.substring(0,opinionContent.length-1));
			}
		} else {
			if( $("#response_"+i).val() == "" ) {
				alert( i + "번째 설문에 참여해 주세요.");
				return;
			}
		}
	}

	if( !confirm("설문을 제출하겠습니까?")) {
		return;
	}
	
	$.ajaxCall({
		url : "/mobile/lms/myAcademy/lmsMySurveySubmitAjax.do"
		, data : $("#frmSurvey").serialize()
		, success : function(data, textStatus, jqXHR) {
			if( data.session == "F" ) { //세션 끊기면 함수 호출하기
				fnSessionCall("Y");
				return;
			}
			if( data.result < 0 ) {
				alert("설문 제출 중 오류가 발생하였습니다.");
				return;
			}
			
			fnAnchor2();
			
			//설문종료 후 메시지 출력
			$("#surveyCommitArea").show();
			$(".surveyQuest").hide();
			$("#surveyButtonArea").hide();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code="errors.load"/>");
		}
	});	
};
var fnSurveyCancel = function() {
	if( !confirm("취소 시 지금까지 작성된 설문은 제출 및 저장되지 않습니다.\n설문을 종료하시겠습니까?")) {
		return;
	}
	fnAnchor2();
	$(".btnPopClose").trigger("click");
};
var fnSurveyClose = function() {
	$(".btnPopClose").trigger("click");
	fnRefresh();
};
var fnCheckLength = function( idxVal, chkLength ) {
	var objValue = $("#response_"+idxVal).val();
	if( objValue.length > chkLength ) {
		$("#response_"+idxVal).val(objValue.substring(0,chkLength)); 
	}
	$("#responseCheck_"+idxVal).html( $("#response_"+idxVal).val().length + "/" + chkLength + "자" );
};

function cancelCourse(courseid){
	if(!confirm("신청취소 하시겠습니까?")){return;}
	$.ajaxCall({
		url: "/mobile/lms/myAcademy/lmsMyRequestCancelAjax.do"
		, data: {courseid : courseid}
		, success: function(data, textStatus, jqXHR){
			alert(data.msg);
			if(data.result == "LOGOUT"){
   				fnSessionCall("");
   				return;
			}else if(data.result == "OK"){
				$("#cancelCourseDiv").hide();
				$("#statusStr").html("취소");
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
		}
	});
}
function goList(){
	var viewtype = $("#searchForm input[name='viewtype']").val();
	if(viewtype != "1"){
		$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequest.do");
	}else{
		$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestList.do");
	}
	$("#searchForm").submit();
}

function showOnline(courseid, status){
	if(status == "A"){
		alert("온라인강의 교육기간이 아닙니다.");
		return;
	}else{
		fnAccesViewClick(courseid);
	}
}

// 상세보기호출
function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
	$("#lmsForm > input[name='courseid']").val(courseidVal);
		
	$("#lmsForm").attr("action", actionUrl);
	$("#lmsForm").submit();	
}

var fnPopup = function( param ) {
	//window.popup
	var specs = "width="+param.width+"px,height="+param.height+"px,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no";
	
	var testPopup = window.open("", param.name ,specs);
	
	var frm = document.popupForm;
	frm.action = param.url;
	frm.target = param.name;
	frm.method = "post";
	frm.submit();
};

function showLive(courseid, status){
	if(status == "A"){
		alert("방송 시간이 아닙니다.");
		return;
	}else{
		top.document.location.href = "${abnHttpDomain}/lms/liveedu/lmsLiveEdu?courseid=" + courseid;
		/* 
		$("#lmsForm > input[name='courseid']").val(courseid);
		$("#lmsForm").attr("action", "/lms/liveedu/lmsLiveEdu.do");
		$("#lmsForm").submit(); */	
	}
}	

function showData(courseid, status){
	if(status == "A"){
		alert("자료확인 기간이 아닙니다.");
		return;
	}else{
		fnAccesViewClick(courseid);
	}
}

function fnRefresh() {
	$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestCourse.do");
	$("#searchForm").submit();
}
function gotolinkurl(url){
	if(url.indexOf("\:\/\/") < 0){
		url = "http://"+url
	}
	window.open(url);
}
</script>
</head>
<body class="uiGnbM3">
<form name="lmsForm" id="lmsForm" method="post">
<input type="hidden" name="courseid" value="">
<input type="hidden" name="categoryid"  value="" />
</form>
<form name="searchForm" id="searchForm" method="post">
<input type="hidden" name="searchyn"  value="Y" />
<input type="hidden" name="searchClickYn" value="Y" />
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="courseid" value="${param.courseid }">
<input type="hidden" name="coursetype">
<input type="hidden" name="searchyear" value="${param.searchyear}">
<input type="hidden" name="searchmonth" value="${param.searchmonth }">
<input type="hidden" name="searchday" value="01">
<c:forEach items="${paramValues.searchcoursetype }" var="data">
<input type="hidden" name="searchcoursetype" value="${data }">
</c:forEach>
<input type="hidden" name="searchstatus" value="${param.searchstatus }">
<input type="hidden" name="searchstartyear" value="${param.searchstartyear }">
<input type="hidden" name="searchstartmonth" value="${param.searchstartmonth }">
<input type="hidden" name="searchendyear" value="${param.searchendyear }">
<input type="hidden" name="searchendmonth" value="${param.searchendmonth }">
<input type="hidden" name="searchtext" value="${param.searchtext }">
<input type="hidden" name="page"  value="${param.page }" />	
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">통합교육신청현황 상세</h2>

			<div class="eduStateBox">
				<dl class="eduSummary">
					<dt><strong>${detail.coursename }</strong>
						<span class="catebox">정규과정</span>
						<c:if test="${detail.groupflag eq 'Y' }">
						<a href="#uiLayerPop_acApp" onclick="layerPopupOpen(this); return false;"><img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" /></a>
						</c:if>
					</dt>
					<dd>
						<div><span class="tit">신청일</span>${detail.requestdatestr2 }</div>
						<div><span class="tit">기간</span>${detail.startdatestr2 } ~ ${detail.enddatestr2 }</div>
					<c:if test="${not empty detail.apname }">
						<div><span class="tit">장소</span>${detail.apname }</div>
					</c:if>
						<div><span class="tit">나의현황</span>
						<span id="statusStr">
					<c:choose>
						<c:when test="${detail.studystatus eq 'Y' }">
						수료
						</c:when>
						<c:when test="${detail.studystatus eq 'N' }">
						미수료
						</c:when>
						<c:otherwise>
						${detail.studystatusname }
						</c:otherwise>
					</c:choose>
						</div>
						<c:if test="${detail.requestflag eq 'Y' and detail.cancelpossibleflag eq 'Y' }">
						</span>
						<div class="textR" id="cancelCourseDiv"><a href="javascript:;" class="btnBasicWS" onclick="cancelCourse('${detail.courseid}');">신청취소</a></div>
						</c:if>
					
					</dd>
				</dl>
			</div>
			
			<div class="acSubWrap">
				<h3>진행현황</h3>
		<c:forEach items="${unitList }" var="item" varStatus="stauts">
			<c:if test="${item.unitordernum eq '1' }">
				<dl class="eduSummary eduStep">
					<dt><a href="#"  onclick="resize_iframe();" <c:if test="${not empty item.opensteporder}">class="on"</c:if>>${item.steporder }단계 
					[
						<c:choose>
							<c:when test="${item.stepcount ne '0' }">
							필수 : 
							${item.stepordercount }개 중 ${item.stepcount }개
							</c:when>
							<c:otherwise>
							선택
							</c:otherwise>
						</c:choose>
					]
					<span class="fr"><strong class="clear">
					<c:choose><c:when test="${item.stepfinishflagstr ne '미완료' }">${item.stepfinishflagstr }</c:when><c:otherwise><strong class="declear">${item.stepfinishflagstr }</strong></c:otherwise></c:choose>
					</strong><span class="icon">펼침</span></span></a></dt>
					<dd <c:if test="${empty item.opensteporder }">style="display:none"</c:if>>
			</c:if>
				
			<c:if test="${item.coursetype eq 'F' }">
						<div class="eduSubItem">
							<span>[${item.unitmustflagname }]</span> ${item.unitordernum }회차<em>|</em>오프라인강의
							<span class="fr"><strong>
						<c:choose>
						<c:when test="${item.studystatus eq 'S'}">
							교육대기
						</c:when>
						<c:otherwise>
							${item.studystatusname }
						</c:otherwise>
						</c:choose>
							
							</strong></span>
						</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시 및 <br>장소</span>
							${item.startdatestr2 } ${item.startdatehh } ~ <c:if test="${item.startdatestr2 ne item.enddatestr2 }">${item.enddatestr2 }</c:if>${item.enddatehh }<br/>${item.apname }(${item.roomname })
						</div>
						<div><span class="tit">좌석번호</span>
					<c:choose>
						<c:when test="${not empty item.seatnumber }">
						${item.seatnumber }
						</c:when>
						<c:when test="${empty item.seatnumber and (item.studystatus eq 'A' or item.studystatus eq 'S')}">
						현장좌석배정
						</c:when>
						<c:otherwise>
							-
						</c:otherwise>
					</c:choose>
						</div>	
			</c:if>
			
			<c:if test="${item.coursetype eq 'O' }">
						<div class="eduSubItem">
							<span>[${item.unitmustflagname }]</span> ${item.unitordernum }회차<em>|</em>온라인강의 
							<c:choose>
								<c:when test="${item.studystatus eq 'A' or item.studystatus eq 'S' or item.showbuttonyn eq 'Y'}">
									<a href="#none" class="fr btnBasicWS" onclick="showOnline('${item.courseid}','${item.studystatus}');">시청하기</a>
								</c:when>
								<c:when test="${item.studystatus eq 'Y'}">
									<span class="fr"><strong>완료</strong></span>
								</c:when>
								<c:otherwise>
									<%-- <a href="#none" class="fr btnBasicWS" onclick="showOnline('${item.courseid}','${item.studystatus}');">시청하기</a> AKEAISIT-1505 --%>
									<span class="fr"><strong>${item.studystatusname }</strong></span>	
								</c:otherwise>
							</c:choose>
						</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시</span>${item.startdatestr2 } ${item.startdatehh } ~ <c:if test="${item.startdatestr2 ne item.enddatestr2 }">${item.enddatestr2 }</c:if>${item.enddatehh }</div>
			</c:if>
			<c:if test="${item.coursetype eq 'T' }">
						<div class="eduSubItem">
							<span>[${item.unitmustflagname }]</span> ${item.unitordernum }회차<em>|</em> 시험
							<span class="fr"><strong>
								
								
								<c:if test="${empty item.finishdate }">
									${item.studystatusname }
								</c:if>
								<c:if test="${ not empty item.finishdate }">
									<c:if test="${item.testflag eq 'N'}">
										채점중
									</c:if>
									<c:if test="${item.testflag eq 'Y'}">												
										<c:if test="${ item.studystatusname eq '미완료' }">불합격</c:if>
										<c:if test="${ item.studystatusname ne '미완료' }">${item.studystatusname }</c:if>
									</c:if>
								</c:if>
								
								<%-- 
								<c:if test="${empty item.finishdate }">
									${item.studystatusname }
								</c:if>
								<c:if test="${ not empty item.finishdate }">
									<c:if test="${ item.studystatusname eq '미완료' }">불합격</c:if>
									<c:if test="${ item.studystatusname ne '미완료' }">${item.studystatusname }</c:if>
								</c:if>
								 --%>
								
								
							</strong></span>
						</div>
						<div class="eduSubTxt">시험응시는 PC에서 가능합니다.</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시</span>${item.startdatestr2 } ${item.startdatehh } ~ <c:if test="${item.startdatestr2 ne item.enddatestr2 }">${item.enddatestr2 }</c:if>${item.enddatehh }</div>
						<div><span class="tit">시험점수</span><c:if test="${not empty item.testpoint  }">${item.testpoint }점</c:if>&nbsp;</div>
			</c:if>
			
			<c:if test="${item.coursetype eq 'V' }">
						<div class="eduSubItem">
							<span>[${item.unitmustflagname }]</span> ${item.unitordernum }회차<em>|</em> 설문조사
							<c:choose>
								<c:when test="${item.studystatus eq 'A' or item.studystatus eq 'S'}">
									<a href="#uiLayerPop_acSurvey" onclick="fnSurvey(this, '${detail.courseid}', '${item.courseid}', '${item.stepseq}','${item.studystatus}' ); return false;" class="fr btnBasicWS">설문참여</a>
								</c:when>
								<c:otherwise>
									<span class="fr"><strong>${item.studystatusname }</strong></span>	
								</c:otherwise>
							</c:choose>		
						</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시</span>${item.startdatestr2 } ${item.startdatehh } ~ <c:if test="${item.startdatestr2 ne item.enddatestr2 }">${item.enddatestr2 }</c:if>${item.enddatehh }</div>
			</c:if>
			<c:if test="${item.coursetype eq 'L' }">
						<div class="eduSubItem">
							<span>[${item.unitmustflagname }]</span> ${item.unitordernum }회차<em>|</em> 라이브교육
							<c:choose>
								<c:when test="${item.studystatus eq 'S' or item.liveshowbuttonyn eq 'Y'}">
									<a href="#none" class="fr btnBasicWS" onclick="showLive('${item.courseid}','${item.liveshowbuttonyn}');">시청하기</a>
								</c:when>
								<c:when test="${item.replaystudystatus eq 'S' or item.replayshowbuttonyn eq 'Y'}">
									<a href="#none" class="fr btnBasicWS" onclick="showLive('${item.courseid}','${item.replayshowbuttonyn}');">시청하기</a>
								</c:when>
								<c:otherwise>
									<span class="fr"><strong>${item.studystatusname }</strong></span>
								</c:otherwise>
							</c:choose>	
						</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">본방송</span>${item.startdatestr2 } ${item.startdatehh } ~ <c:if test="${item.startdatestr2 ne item.enddatestr2 }">${item.enddatestr2 }</c:if>${item.enddatehh }</div>
					<c:if test="${not empty item.livereplaylink }">
						<div><span class="tit">재방송</span>${item.replaystartstr2 } ${item.replaystarthh } ~ <c:if test="${item.replaystartstr2 ne item.replayendstr2 }">${item.replayendstr2 }</c:if>${item.replayendhh }</div>
					</c:if>
			</c:if>
			<c:if test="${item.coursetype eq 'D' }">
						<div class="eduSubItem">
							<span>[${item.unitmustflagname }]</span> ${item.unitordernum }회차<em>|</em> 교육자료
							<c:choose>
								<c:when test="${item.studystatus eq 'A' or item.studystatus eq 'S' or item.showbuttonyn eq 'Y'}">
									<a href="#none" class="fr btnBasicWS" onclick="showData('${item.courseid}','${item.showbuttonyn}');">자료확인</a>
								</c:when>
								<c:otherwise>
									<span class="fr"><strong>${item.studystatusname }</strong></span>
								</c:otherwise>
							</c:choose>		
						</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시</span>${item.startdatestr2 } ${item.startdatehh } ~ <c:if test="${item.startdatestr2 ne item.enddatestr2 }">${item.enddatestr2 }</c:if>${item.enddatehh }</div>
			</c:if>

			<c:if test="${item.unitordernum eq item.stepordercount  }">
					</dd>
				</dl>
			</c:if>	
		</c:forEach>


				<p class="listWarning">※ 온라인 교육 시청 후 수강 결과는 다음날 완료로 적용 됩니다.</p>
				
				<dl class="eduCont">
					<dt><span class="eduIcon icon8"></span>수료기준</dt>
					<dd>
						<ul class="listDot">
							${detail.passnote }
						</ul>
					</dd>
				</dl>
				
			<c:if test="${not empty detail.note }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon5"></span>유의사항 및 기타안내</dt>
					<dd>
						<ul class="listDot">
							${detail.note }
						<c:if test="${not empty detail.linktitle and not empty detail.linkurl }">
							<li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.linkurl}') " class="u">${detail.linktitle }</a></li>
						</c:if>
						</ul>
					</dd>
				</dl>
			</c:if>
			<c:if test="${not empty detail.note }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon6"></span>페널티</dt>
					<dd>
						<ul class="listDot">
							${detail.penaltynote }
						</ul>
					</dd>
				</dl>
			</c:if>
				<a href="javascript:;" class="btnList" onclick="goList();"><span>목록</span></a>
			</div>
		</section>
		<!-- content ##iframe end## -->
</form>


		<form id="frmSurvey" name="frmSurvey" method="post">
		<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_acSurvey">
			<div class="pbLayerHeader">
				<strong>설문참여</strong>
			</div>
			<div id="surveyLayerPopup" class="pbLayerContent">
			</div>
			<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
		</form>
		
			<!-- Layer Popup: 앱다운로드 -->
			<div class="pbLayerPopup" id="uiLayerPop_acApp" style="top:50px">
				<div class="pbLayerHeader">
					<strong>AmwayGo! 안내</strong>
				</div>
				<div class="pbLayerContent">
					<p>본 교육은 AmwayGo! 모바일 어플리케이션이 활용되는 교육입니다.  
					앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다.</p>
					
					<div class="imgBox">
						<!-- 안드로이드폰일 경우 -->
						<a href="${amwaygo.googleplay }" target="_blank" id="amwaygo_android" style="display:none;"><img src="/_ui/mobile/images/academy/img_googleplay.gif" alt="Google Play" /></a>
						<!-- 아이폰일 경우 -->
						<a href="${amwaygo.appstore }" target="_blank" id="amwaygo_iphone" style="display:none;"><img src="/_ui/mobile/images/academy/img_appstore.gif" alt="Available on the App Store" /></a>
					</div>
					<!-- // AmwayGO! 모바일 어플리케이션 안내 -->
				
					<div class="btnWrap">
						<a href="#none" class="btnBasicGNL popCloseConfirm">확인</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //Layer Popup: 앱다운로드 -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

</body>
</html>