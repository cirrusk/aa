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
	function fileDown(){
		//showLoading();
		var defaultParam = {
				name : "불참사유서.docx"
			  , file : "NoAttendenceDocument.docx"
			  , mode : "course"
		};
		//postGoto("/mobile/lms/common/downloadFile.do", defaultParam);
		location.href = "/mobile/lms/common/downloadFile.do?mode=course&file=NoAttendenceDocument.docx&method=off&name=NoAttendenceDocument.docx";
		//hideLoading();
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
	function gotolinkurl(url){
		if(url.indexOf("\:\/\/") < 0){
			url = "http://"+url
		}
		window.open(url);
	}
</script>
</head>
<body class="uiGnbM3">
<form name="searchForm" id="searchForm" method="post">
<input type="hidden" name="searchyn"  value="Y" />
<input type="hidden" name="searchClickYn" value="Y" />
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="courseid" value="${param.courseid }">
<input type="hidden" name="coursetype">
<input type="hidden" name="back" value="Y">
<input type="hidden" name="searchyear" value="${param.searchyear}">
<input type="hidden" name="searchmonth" value="${param.searchmonth }">
<input type="hidden" name="searchday" value="01">
<c:forEach items="${paramValues.searchcoursetype }" var="data">
<input type="hidden" name="searchcoursetype" value="${data }">
</c:forEach>
<input type="hidden" name="searchstatus" value="${param.searchstatus }">
<input type="hidden" name="searchstartdate" value="${param.searchstartdate }">
<input type="hidden" name="searchenddate" value="${param.searchenddate }">
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
					<dt><strong>[${detail.apname }] ${detail.coursename }</strong>
						<span class="category">${detail.themename }</span> <span class="catebox">오프라인강의</span>
						<c:if test="${detail.groupflag eq 'Y' }">
						<a href="#uiLayerPop_acApp" onclick="layerPopupOpen(this); return false;"><img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" /></a>
						</c:if>
					</dt>
					<dd>
						<div><span class="tit">신청일</span>${detail.requestdatestr2 }</div>
						<div><span class="tit">일시</span>${detail.startdatestr2 } ${detail.startdatehh }  ~ <c:if test="${detail.startdatestr2 ne startdatestr2 }">${detail.enddatestr2 }</c:if> ${detail.enddatehh }</div>
						<div><span class="tit">장소</span>${detail.apname }(${detail.roomname })</div>
						<div><span class="tit">나의현황</span><span id="statusStr">
						<c:choose>
						<c:when test="${detail.studystatus eq 'S'}">
							교육대기
						</c:when>
						<c:otherwise>
							${detail.studystatusname }
						</c:otherwise>
						</c:choose>
						</span></div>
					
						<div><span class="tit">좌석번호</span>
					<c:choose>
						<c:when test="${! empty detail.seatnumber }">
						${detail.seatnumber }
						</c:when>
						<c:when test="${detail.studystatus eq 'A' or detail.studystatus eq 'S'}">
						현장좌석배정
						</c:when>
						<c:when test="${detail.studystatus eq 'Y'}">
						완료
						</c:when>
						<c:otherwise>
						미완료
						</c:otherwise>
					</c:choose>
						</div>
					<c:if test="${detail.requestflag eq 'Y' and detail.cancelpossibleflag eq 'Y' }">
						<div class="textR" id="cancelCourseDiv"><a href="javascript:;" class="btnBasicWS" onclick="cancelCourse('${detail.courseid}');">신청취소</a></div>
					</c:if>
					</dd>
				</dl>
			<%--
			AKL ECM 1.5 AI SITAKEAISIT-1250 미수료인 경우 페널티 표시했음
			AKL ECM 1.5 AI UATAEAS-428 로 다시 원상복귀함
			--%>
			<c:if test="${not empty detail.cleardate }">
			<%-- <c:if test="${detail.studystatus eq 'N'}"> --%>		
				<div class="eduSubTxt textL"><strong>미출석 페널티 :  오프라인교육 신청제한</strong><br/>${detail.enddatestr3 } ~ ${detail.penaltyenddatestr } </div>
				<div class="acwhWrap">
					<p class="listWarning">※ 부득이한 사정으로 교육불참 사유가 있을 시 아래 양식을 다운로드하여 담당자 이메일 <a href="mailto:edumaster@amway.com" class="u">edumaster@amway.com</a>로 보내주세요.</p>
					<div class="btnWrap aNumb1">
						<a href="javascript:;" class="btnBasicGNL" onclick="fileDown()">교육불참 사유 양식 다운로드</a>
					</div>
				</div>
			</c:if>
			</div>
			
			<div class="acSubWrap">
				<dl class="eduCont">
					<dt><span class="eduIcon icon4"></span>교육 상세 내용</dt>
					<dd>
						<ul class="listDot">
							${detail.detailcontent }
						</ul>	
					</dd>
				</dl>
			<c:if test="${!empty detail.note }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon5"></span>유의사항 및 기타안내</dt>
					<dd>
						<strong class="tit">유의사항</strong>
						<ul class="listDot">
							${detail.note }
							<c:if test="${not empty detail.linktitle and not empty detail.linkurl }">
								<li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.linkurl}') " class="u">${detail.linktitle }</a></li>
							</c:if>
						</ul>
					</dd>
				</dl>
			</c:if>
			<c:if test="${!empty detail.penaltynote }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon6"></span>페널티</dt>
					<dd>
						<ul class="listDot">
							${detail.penaltynote }
						</ul>
					</dd>
				</dl>
			</c:if>
				<a href="javascript:;" class="btnList" onclick="goList();">목록</a>
			</div>
			
		</section>
		<!-- content ##iframe end## -->
</form>

			<!-- Layer Popup: 앱다운로드 -->
			<div class="pbLayerPopup" id="uiLayerPop_acApp" style="top:50px !important">
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