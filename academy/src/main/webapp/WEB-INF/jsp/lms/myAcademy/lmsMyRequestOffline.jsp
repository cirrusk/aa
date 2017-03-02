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
<title>통합교육 신청현황 - ABN Korea</title>
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
	$(document).ready(function() {
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2();
	});
	
	function cancelCourse(courseid){
		if(!confirm("신청취소 하시겠습니까?")){return;}
		$.ajaxCall({
			url: "/lms/myAcademy/lmsMyRequestCancelAjax.do"
			, data: {courseid : courseid}
			, success: function(data, textStatus, jqXHR){
				alert(data.msg);
				if(data.result == "LOGOUT"){
	   				fnSessionCall("");
	   				return;
				}else if(data.result == "OK"){
					$("#cancelCourseSpan").hide();
					$("#statusStr").html("취소");
				}
			},
			error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
			}
		});
	}
	function fileDown(){
		showLoading();
		var defaultParam = {
				name : "불참사유서.docx"
			  , file : "NoAttendenceDocument.docx"
			  , mode : "course"
		};
		postGoto("/lms/common/downloadFile.do", defaultParam);
		hideLoading();
	}
	function goList(){
		var viewtype = $("#searchForm input[name='viewtype']").val();
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestList.do");
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
<body>
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

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030100200.gif" alt="통합교육 신청현황"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030100200.gif" alt="신청한 정규과정, 오프라인, 라이브 신청현황을 확인 할 수 있습니다."></p>
			</div>
			
			<div class="eduStateTitleBox">
				<h2>
				<c:if test="${detail.groupflag eq 'Y' }">
					<a href="#none" onclick="openAmwayGoInfo();" title="새창열림"><img src="/_ui/desktop/images/academy/amwaygo_flag_pc.jpg" alt="AmwayGo!" class="flag" /></a>
				</c:if>
					<span class="menubox">오프라인강의</span>[${detail.apname }] ${detail.coursename } <span class="fcG">[${detail.themename }]</span></h2>
				<c:if test="${detail.requestflag eq 'Y' and detail.cancelpossibleflag eq 'Y' }">
				<%-- <span class="rightWrap" id="cancelCourseSpan"><a href="javascript:;" class="btnBasicAcWS" onclick="cancelCourse('${detail.courseid}');">신청취소</a></span> --%>
				</c:if>
			</div>
			
			<table class="tblDetail">
				<caption>교육안내</caption>
				<colgroup>
					<col width="100px" /><col width="auto" /><col width="100px" /><col width="auto" />
				</colgroup>
				<tbody>
					<tr>
						<th class="tit">일자</th>
						<td>${detail.startdatestr } <c:if test="${detail.startdatestr ne enddatestr }"> ~ ${detail.enddatestr }</c:if></td>
						<th class="tit">신청일</th>
						<td>${detail.requestdatestr }</td>
					</tr>
					<tr>
						<th class="tit">장소</th>
						<td>${detail.apname }(${detail.roomname })</td>
						<th class="tit">나의현황</th>
						<td id="statusStr" class="relative">
							<c:choose>
							<c:when test="${detail.studystatus eq 'S'}">
								교육대기
							</c:when>
							<c:otherwise>
								${detail.studystatusname }
							</c:otherwise>
							</c:choose>

						<c:if test="${detail.requestflag eq 'Y' and detail.cancelpossibleflag eq 'Y' }">
						<span class="rightWrap" id="cancelCourseSpan"><a href="javascript:;" class="btnBasicAcWS" onclick="cancelCourse('${detail.courseid}');">신청취소</a></span>
						</c:if>
							
						</td>
					</tr>
				<c:if test="${not empty detail.seatnumber }">
					<tr>
						<th class="tit">좌석</th>
						<td colspan="3">
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
						</td>
					</tr>
				</c:if>
				</tbody>
			</table>
			
			<h2>교육내용</h2>
			
			<table class="tblList lineLeft">
				<caption>교육상세내용</caption>
				<colgroup>
					<col width="185px" /><col width="auto" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">시간</th>
						<th scope="col">상세내용</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>${detail.startdatehh } ~ ${detail.enddatehh }</td>
						<td class="textL">
							<ul class="listDotFS">
								${detail.detailcontent }
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
		<%--
		AKL ECM 1.5 AI SITAKEAISIT-1250 미수료인 경우 페널티 표시했음
		AKL ECM 1.5 AI UATAEAS-428 로 다시 원상복귀함
		--%>
		<c:if test="${not empty detail.cleardate}">
		<%-- <c:if test="${detail.studystatus eq 'N'}"> --%>
			<div class="lineBox3">
				<strong>미출석 페널티 :  오프라인교육 신청제한  ${detail.enddatestr5 } ~ ${detail.penaltyenddatestr }</strong>
				<p>부득이한 사정으로 교육불참 사유가 있을 시 아래 양식을 다운로드 하여 담당자 이메일 <a href="mailto:edumaster@amway.com" class="u">edumaster@amway.com</a>로 보내주세요.</p>
				<div class="mgtS">
					<a href="#none" class="btnTblDownR" onclick="fileDown()"><span>교육불참 사유 양식 다운로드</span></a>
				</div>
			</div>
		<%-- AKL ECM 1.5 AI SITAKEAISIT-143
			<div class="pinkBox">
				<p class="textC">미출석 페널티 :  오프라인교육 신청제한  ${detail.enddatestr5 } ~ ${detail.penaltyenddatestr }</p>
			</div>
			<p class="listWarning pdtM">※ 부득이한 사정으로 교육불참 사유가 있을 시 아래 양식을 다운로드 하여 담당자 이메일 <a href="mailto:edumaster@Amway.com" class="u">edumaster@Amway.com</a>로 보내주세요.</p>
			<div class="btnWrapR mgtS2">
				<a href="javascript:;" class="btnTblDownR" onclick="fileDown()"><span>교육불참 사유 양식 다운로드</span></a>
			</div>
		 --%>
		</c:if>
			
			<div>
				<table class="tblEduCont mgtL2">
					<caption>강의상세내용</caption>
					<colgroup><col width="100%" /></colgroup>
					<tbody>
					<tr>
						<td>
							<div class="eduContWrap">
								<div class="eduTit vaT"><img src="/_ui/desktop/images/academy/ico_edu_05.gif" alt="유의사항 및 기타안내" /></div>
								<div class="eduCont">
									<ul class="listDotFS">
										${detail.note }
									<c:if test="${not empty detail.linktitle and not empty detail.linkurl }">
										<li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.linkurl}') " class="u">${detail.linktitle }</a></li>
									</c:if>
									</ul>
								</div>
							</div> 
						</td>
					</tr>
					<c:if test="${!empty detail.penaltynote }">
					<tr>
						<td>
							<div class="eduContWrap">
								<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_06.gif" alt="페널티" /></div>
								<div class="eduCont">
									<ul class="listDotFS">
										${detail.penaltynote }</p>
									</ul>
								</div>
							</div> 
						</td>
					</tr>
					</c:if>
					</tbody>
				</table>
				
				<div class="btnWrapC">
					<a href="javascript:;" class="btnBasicAcGL" onclick="goList();"><span>목록</span></a>
				</div>
			</div>


		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
</form>
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>