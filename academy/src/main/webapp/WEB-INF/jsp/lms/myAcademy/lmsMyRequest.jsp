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
		setTimeout(function(){ goNowDay(); }, 600);
	});
	var viewDetail = function(coursetype, courseid, regularcourseid){
		$("#searchForm input[name=courseid]").val(courseid);
		var url = "/lms/myAcademy/lmsMyRequestOffline.do";
		if(coursetype == "R"){
			$("#searchForm input[name=courseid]").val(regularcourseid);
			url = "/lms/myAcademy/lmsMyRequestCourse.do";
		}else if(coursetype == "L"){
			url = "/lms/myAcademy/lmsMyRequestLive.do";
		}
		$("#searchForm").attr("action", url);
		$("#searchForm").submit();
	};
	var changeMonth = function(type){
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
	};
	var lpad = function(str){
		if(str < 10 ){
			str = "0"+str;
		}
		return str;
	};
	
	var searchGo = function(){
		var viewtype = $("#searchForm input[name='viewtype']").val();
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm").submit();
	};
	var searchTab = function(viewtype){
		var oldviewtype = $("#searchForm input[name='viewtype']").val();
		$("#searchForm input[name='viewtype']").val(viewtype);
		//searchGo();
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm").submit();
	};
	function goNowDay(){
		var nowyear = "${nowyear }";
		var nowmonth = "${nowmonth }";
		var nowday = "${nowday }";
		var searchyear = $("#searchForm input[name='searchyear']").val();
		var searchmonth = $("#searchForm input[name='searchmonth']").val();
		if(nowyear == searchyear && nowmonth == searchmonth){
			var targetid = "day"+Number(nowday);
			var $pos = $("#"+targetid);
			var iframeTop = parent.$("#IframeComponent").offset().top
			parent.$('html, body').animate({
			    scrollTop:$pos.offset().top + iframeTop
			}, 300);			
		}
	}
</script>
</head>
<body>
<form name="searchForm" id="searchForm">
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="courseid">
<input type="hidden" name="coursetype">
<input type="hidden" name="searchyear" value="${searchyear}">
<input type="hidden" name="searchmonth" value="${searchmonth }">
<input type="hidden" name="searchday" value="01">
		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030100200.gif" alt="통합교육 신청현황"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030100200.gif" alt="신청한 정규과정, 오프라인, 라이브 신청현황을 확인 할 수 있습니다."></p>
			</div>
			
			
			
			<!-- 상세복기-간략보기 -->
			<div class="toggleViewBox">
				<div class="viewTypeBox">
					<div class="viewTypeSet">
						<a href="#viewTypeCalender" onclick="searchTab('')" class="calender on">캘린더보기</a>
						<a href="#viewTypeList" onclick="searchTab('1')" class="list2">리스트보기</a>
					</div>
				</div>
				
				<!-- 목록 -->
				<!-- 캘린더보기 -->
				<div class="viewWrapper viewTypeCalender" id="viewTypeCalender">
					<div class="hrLine"></div>
					<div class="monthlySchedule">
						<a href="#" class="prev" onclick="changeMonth('prev');">이전달</a>
						<strong>${searchyear }년</strong><strong>${searchmonth }월</strong>
						<a href="#" class="next" onclick="changeMonth('next');">다음달</a>
					</div>
					<div class="numTop">
						<span>총 ${fn:length(courseList)} 개</span>
					</div>
					<table class="tblSchedule">
						<caption>일정표</caption>
						<colgroup>
							<col width="50px" span="2" /><col width="100px" /><col width="auto" /><col width="100px" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">일</th><th scope="col">요일</th><th scope="col">교육종류</th><th scope="col">교육명</th><th scope="col">상세보기</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${monthList }" var="item2" varStatus="status2">
							<c:set var="grayRed" value="R"></c:set>
							<c:if test='${item2.nowthen eq "P" }'>
								<c:set var="grayRed" value="G"></c:set>
							</c:if>
							<c:set var="rownum" value="0"></c:set>
							<c:forEach items="${courseList}" var="item" varStatus="status">
								<c:if test='${item.startdate eq item2.usedate }'>
									<c:set var="rownum" value="${ rownum + 1 }" ></c:set>
								</c:if>
							</c:forEach>
							
							<c:set var="rowspan" value=""></c:set>
							<c:if test='${rownum ne "0" && rownum ne "1" }'>
								<c:set var="rowspan" value=" rowspan='${rownum }'"></c:set>
							</c:if>
							<tr id="day${item2.num }" class="<c:if test='${item2.nowthen ne "P" and (item2.weekname eq "토" or item2.weekname eq "일") }'> weekend</c:if><c:if test='${item2.nowthen eq "P" }'>lastday</c:if>">
								<td ${rowspan }>${item2.num }</td>
								<td ${rowspan }>${item2.weekname }</td>
							<c:choose>
								<c:when test="${rownum > 0 }">
									<c:forEach items="${courseList}" var="item" varStatus="status">
										<c:if test='${item.startdate eq item2.usedate }' >
										<c:if test='${item.rndate ne "1" }' >
											<tr class="<c:if test='${item2.nowthen ne "P" and (item2.weekname eq "토" or item2.weekname eq "일") }'> weekend</c:if><c:if test='${item2.nowthen eq "P" }'>lastday</c:if>">
										</c:if>
											<td class="brd">${item.coursetypename}</td>
											<td class="title">
											<c:if test='${item.coursetype ne "R" }'>
												<c:if test='${item.groupflag eq "Y" }'>
												<img src="/_ui/desktop/images/academy/amwaygo_flag_pc<c:if test='${item2.nowthen eq "P" }'>_gray</c:if>.jpg" alt="AmwayGo!" class="flag" />
												</c:if>
												<c:if test='${item.coursetype eq "F" }'>
													[${item.apname}]
												</c:if>
												<c:if test='${item.coursetype eq "L" }'>
													${item.liverealstr}
												</c:if>
												${item.coursename} 
												<span class="fcG">[${item.themename}]</span>
												<c:if test='${item.realcoursetype eq "F" }'>
												<br/><span class="b fc${grayRed }">- ${item.apname}(${item.roomname})
																<c:if test='${not empty item.seatnumber }'>
												 	| 좌석번호 ${item.seatnumber }
												 	</c:if>
												 </span>
												</c:if>
											</c:if>
											<c:if test='${item.coursetype eq "R" }'>
												<c:if test='${item.groupflag eq "Y" }'>
												<img src="/_ui/desktop/images/academy/amwaygo_flag_pc<c:if test='${item2.nowthen eq "P" }'>_gray</c:if>.jpg" alt="AmwayGo!" class="flag" />
												</c:if>
												${item.regularcoursename}<br/>
												- ${item.stepseq}회차(${item.realcoursetypename}) : 
												<c:if test='${item.realcoursetype eq "L" }'>
												${item.liverealstr}
												</c:if>
												${item.coursename}<br/>
												<c:if test='${item.realcoursetype eq "F" }'>
												<span class="b fc${grayRed }">- ${item.apname}(${item.roomname})
												 	<c:if test='${not empty item.seatnumber }'>
												 		| 좌석번호 ${item.seatnumber }
												 	</c:if>
												 </span>
												</c:if>
											</c:if>
											</td>
											<td><a href="javascript:;" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')" class="btnTblW">상세보기</a></td>
										<c:if test='${item.rndate ne "1" }' >
											</tr>
										</c:if>
											
										</c:if>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<td></td>
									<td class="title"></td>
									<td></td>
								</c:otherwise>
							</c:choose>
							</tr>
						</c:forEach>
						</tbody>
					</table>
					<p class="listWarning">※ 캘린더 보기에서는 완료 및 진행중인 교육만 확인 하실 수 있습니다. (자세한 신청현황은 리스트보기에서 확인)</p>
				</div>
				<!-- //캘린더보기 -->
				
			</div>
			<!-- //상세보기-간략보기 -->

		</section>
		
</form>		
		<!-- //content area | ### academy IFRAME Start ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>