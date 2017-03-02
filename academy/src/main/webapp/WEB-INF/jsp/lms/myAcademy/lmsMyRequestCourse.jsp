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
		alert(actionUrl)
		$("#lmsForm > input[name='courseid']").val(courseidVal);
			
		$("#lmsForm").attr("action", actionUrl);
		$("#lmsForm").submit();	
	}

	var fnPopupCourse = function( paramVal ) {
		//window.popup
		var specs = "width="+paramVal.width+"px,height="+paramVal.height+"px,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no";
		
		var coursePopWin = window.open("", paramVal.name ,specs);
		
		var frm = document.popupForm;
		frm.action = paramVal.url;
		frm.target = paramVal.name;
		frm.method = "post";
		frm.submit();
	};
	
	function showTest(courseid, status, stepseq){
		if(status == "A"){
			alert("시험 응시 기간이 아닙니다.");
			return;
		}
		$("#popupForm input[name='stepcourseid']").val(courseid);
		$("#popupForm input[name='stepseq']").val(stepseq);
		var param = {
			url : "/lms/myAcademy/lmsMyTest.do"
			, name : "testPopup"
			, width : "780"
			, height : "680"
		}
		fnPopupCourse(param);
	}
	
	function showSurvey(courseid, status, stepseq){
		if(status == "A"){
			alert("설문 참여 기간이 아닙니다.");
			return;
		}
		 
		$("#popupForm input[name='stepcourseid']").val(courseid);
		$("#popupForm input[name='stepseq']").val(stepseq);
		var param = {
			url : "/lms/myAcademy/lmsMySurvey.do"
			, name : "surveyPopup"
			, width : "780"
			, height : "680"
		}
		fnPopupCourse(param);
	}
	
	function showLive(courseid, status){
		if(status != "Y"){
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
		$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestCourse.do");
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
				<span class="menubox">정규과정</span> ${detail.coursename }</h2>
				
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
						<th class="tit">기간</th>
						<td>${detail.startdatestr } ~ ${detail.enddatestr }</td>
						<th class="tit">신청일</th>
						<td>${detail.requestdatestr }</td>
					</tr>
					<tr>
						<th class="tit">장소</th>
						<td>${detail.apname }</td>
						<th class="tit">나의현황</th>
						<td id="statusStr" class="relative">
					<c:choose>
						<c:when test="${detail.studystatus eq 'Y' }">
						<span class="eduGrade">수료</span>
						</c:when>
						<c:when test="${detail.studystatus eq 'N' }">
						미수료
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
				<h2>진행현황</h2>
				<table class="tblSchedule">
					<caption>진행현황 상세</caption>
					<colgroup>
						<col style="width:37px" />
						<col style="width:85px" />
						<col style="width:auto" />
						<col style="width:136px" />
						<col style="width:80px" />
						<col style="width:92px" />
						<col style="width:72px" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">단계</th>
							<th scope="col">회차</th>
							<th scope="col">교육명</th>
							<th scope="col">일시</th>
							<th scope="col">선택/필수</th>
							<th scope="col">수강</th>
							<th scope="col">단계완료</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${unitList }" var="item" varStatus="stauts">						
						<tr>
						<c:if test="${item.unitordernum eq '1' }">
							<td rowspan="${item.stepordercount }">${item.steporder }</td>
						</c:if>
							<td class="brd">${item.unitordernum }회차<br />(<c:if test="${item.coursetype eq 'O' }">온라인</c:if><c:if test="${item.coursetype eq 'F' }">오프라인</c:if><c:if test="${item.coursetype eq 'D' }">교육자료</c:if><c:if test="${item.coursetype eq 'L' }">라이브</c:if><c:if test="${item.coursetype eq 'V' }">설문</c:if><c:if test="${item.coursetype eq 'T' }">시험</c:if>)</td>
							<td class="title">${item.coursename }</td>
							<td>
								<c:choose>
									<c:when test="${item.startdatestr eq item.enddatestr }">
										${item.startdatestr }<br />${item.startdatehh } ~ ${item.enddatehh }
									</c:when>
									<c:otherwise>
										${item.startdatestr } ${item.startdatehh } ~ <br />${item.enddatestr } ${item.enddatehh }
									</c:otherwise>
								</c:choose>
								
							</td>
					<c:if test="${item.unitordernum eq '1' }">
							<td rowspan="${item.stepordercount }">
						<c:choose>
							<c:when test="${item.stepcount ne '0' }">
							필수<br />
							${item.stepordercount }개 중 ${item.stepcount }개
							</c:when>
							<c:otherwise>
							선택
							</c:otherwise>
						</c:choose>
							</td>
					</c:if>	
							<td>
								<c:if test="${item.coursetype eq 'F' }">
									<c:choose>
									<c:when test="${item.studystatus eq 'S'}">
										교육대기
									</c:when>
									<c:otherwise>
										${item.studystatusname }
									</c:otherwise>
									</c:choose>
										<br />
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
								</c:if>
								<c:if test="${item.coursetype eq 'O' }">
									<c:choose>
										<c:when test="${item.studystatus eq 'A' or item.studystatus eq 'S' or item.showbuttonyn eq 'Y'}">
											<a href="#none" class="btnTblW" onclick="showOnline('${item.courseid}','${item.studystatus}');">시청하기</a>
										</c:when>
										<c:when test="${item.studystatus eq 'Y'}">
											완료
										</c:when>
										<c:otherwise>
											<%-- <a href="#none" class="btnTblW" onclick="showOnline('${item.courseid}','${item.studystatus}');">시청하기</a> AKEAISIT-1505 --%>
											${item.studystatusname }	
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if test="${item.coursetype eq 'T' }">
									<c:choose>
										<c:when test="${ item.studystatus eq 'A' or item.studystatus eq 'S' }">
											<c:if test="${item.testtype eq 'F'}">
												오프라인시험
											</c:if>										
											<c:if test="${item.testtype ne 'F'}">
												<a href="#none" class="btnTblW" onclick="showTest('${item.courseid}','${item.studystatus}','${item.stepseq}');">시험응시</a>
											</c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${empty item.finishdate }">
												${item.studystatusname }<br />(${item.testpoint }점)
											</c:if>
											<c:if test="${ not empty item.finishdate }">
												<c:if test="${item.testflag eq 'N'}">
													채점중
												</c:if>
												<c:if test="${item.testflag eq 'Y'}">												
													<c:if test="${ item.studystatusname eq '미완료' }">불합격</c:if>
													<c:if test="${ item.studystatusname ne '미완료' }">${item.studystatusname }</c:if>
													<br />(${item.testpoint }점)
												</c:if>
											</c:if>
										</c:otherwise>
									</c:choose>								
								</c:if>
								<c:if test="${item.coursetype eq 'V' }">
									<c:choose>
										<c:when test="${item.studystatus eq 'A' or item.studystatus eq 'S'}">
											<a href="#none" class="btnTblW" onclick="showSurvey('${item.courseid}','${item.studystatus}','${item.stepseq}');">설문참여</a>
										</c:when>
										<c:otherwise>
											${item.studystatusname }	
										</c:otherwise>
									</c:choose>								
								</c:if>
								<c:if test="${item.coursetype eq 'L' }">
									<c:choose>
										<c:when test="${item.studystatus eq 'S' or item.liveshowbuttonyn eq 'Y'}">
											<a href="#none" class="btnTblW" onclick="showLive('${item.courseid}','${item.liveshowbuttonyn}');">시청하기</a>
										</c:when>
										<c:when test="${item.replaystudystatus eq 'S' or item.replayshowbuttonyn eq 'Y'}">
											<a href="#none" class="btnTblW" onclick="showLive('${item.courseid}','${item.replayshowbuttonyn}');">시청하기</a>
										</c:when>
										<c:otherwise>
											${item.studystatusname }	
										</c:otherwise>
									</c:choose>							
								</c:if>
								<c:if test="${item.coursetype eq 'D' }">
									<c:choose>
										<c:when test="${item.studystatus eq 'A' or item.studystatus eq 'S' or item.showbuttonyn eq 'Y'}">
											<a href="#none" class="btnTblW" onclick="showData('${item.courseid}','${item.studystatus}');">자료확인</a>
										</c:when>
										<c:otherwise>
											${item.studystatusname }	
										</c:otherwise>
									</c:choose>							
								</c:if>
							</td>
						<c:if test="${item.unitordernum eq '1' }">
							<td rowspan="${item.stepordercount }">
							${item.stepfinishflagstr }
							<%-- 
							<c:choose>
								<c:when test="${item.stepcount eq '0' }">
									-
								</c:when>
								<c:when test="${item.stepfinishflag eq 'Y' }">
									완료
								</c:when>
								<c:otherwise>
									미완료
								</c:otherwise>
							</c:choose>
							 --%>
							</td>
						</c:if>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<p class="listWarning">※ 온라인 교육 시청 후 수강 결과는 다음날 완료로 적용 됩니다.</p>
				
				<table class="tblEduCont mgtL2">
					<caption>강의상세내용</caption>
					<colgroup><col width="100%" /></colgroup>
					<tbody>
					<tr>
						<td>
							<div class="eduContWrap">
								<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_07.gif" alt="수료기준" /></div>
								<div class="eduCont">
									${detail.passnote }
								</div>
							</div> 
						</td>
					</tr>
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
									<p>${detail.penaltynote }</p>
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
<form name="popupForm" id="popupForm" method="post">
	<input type="hidden" name="stepcourseid" value="" />
	<input type="hidden" name="courseid" value="${param.courseid }" />
	<input type="hidden" name="stepseq" value="" />
</form>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

</body>
</html>