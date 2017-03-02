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
	function goList(){
		var viewtype = $("#searchForm input[name='viewtype']").val();
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm").submit();
	}
	function showLive(courseid, status){
		//if(status != "S"){
		if(status != "Y"){
			alert("방송 시간이 아닙니다.");
			return;
		}
		top.document.location.href = "${abnHttpDomain}/lms/liveedu/lmsLiveEdu?courseid=" + courseid;
		
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
				<span class="menubox">라이브교육</span> ${detail.coursename } <span class="fcG">[${detail.themename }]</span></h2>
				<c:if test="${detail.requestflag eq 'Y' and detail.cancelpossibleflag eq 'Y' }">
				<%-- <span class="rightWrap" id="cancelCourseSpan"><a href="javascript:;" class="btnBasicAcWS" onclick="cancelCourse('${detail.courseid}');">신청취소</a></span> --%>
				</c:if>
			</div>
			
			<table class="tblDetail">
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
						<td>ABN & sABN</td>
						<th class="tit">나의현황</th>
						<td id="statusStr" class="relative">
						<c:choose>
							<c:when test="${detail.studystatus eq 'N' and not empty detail.replaystudystatus  }">
								${detail.replaystudystatusname }
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
				</tbody>
			</table>
			
			<div>
				<h2>교육내용</h2>
				<table class="tblDetail lineLeft">
					<caption>교육내용 상세</caption>
					<colgroup>
						<col style="width:25%" />
						<col style="width:auto" />
						<col style="width:25%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">구분</th>
							<th scope="col">일시</th>
							<th scope="col">수강</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>본방송</td>
							<td>${detail.startdatestr } ${detail.startdatehh }  ~ <c:if test="${detail.startdatestr ne enddatestr }">${detail.enddatestr }</c:if> ${detail.enddatehh }</td>
							<td>
						<c:choose>
							<c:when test="${detail.studystatus eq 'S' or detail.studystatus eq 'A' or detail.liveshowbuttonyn eq 'Y'}">
								<a href="javascript:;" class="btnTblW" onclick="showLive('${detail.courseid}', '${detail.liveshowbuttonyn }');">시청하기</a>
							</c:when>
							<c:otherwise>
								${detail.studystatusname }
							</c:otherwise>
						</c:choose>
							</td>
						</tr>
					<c:if test="${not empty detail.livereplaylink }">
						<tr>
							<td>재방송</td>
							<td>${detail.replaystartstr } ${detail.replaystarthh }  ~ <c:if test="${detail.replaystartstr ne replayendstr }">${detail.replayendstr }</c:if> ${detail.replayendhh }</td>
							<td>
						<c:choose>
							<c:when test="${detail.replaystudystatus eq 'S' or detail.replaystudystatus eq 'A' or detail.replayshowbuttonyn eq 'Y'}">
								<a href="javascript:;" class="btnTblW" onclick="showLive('${detail.courseid}','${detail.replayshowbuttonyn }');">시청하기</a>
							</c:when>
							<c:otherwise>
								${detail.replaystudystatusname }
							</c:otherwise>
						</c:choose>
							</td>
						</tr>
					</c:if>
					</tbody>
				</table>
				
				<table class="tblEduCont mgtL2">
					<caption>강의상세내용</caption>
					<colgroup><col width="100%" /></colgroup>
					<tbody>
					<tr>
						<td>
							<div class="eduContWrap">
								<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_05.gif" alt="유의사항 및 기타안내" /></div>
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