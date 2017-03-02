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
<title>최근 본 콘텐츠 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
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
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	$("#selectYear").on("change", function(){
		$("#searchForm input[name='searchyear']").val($("#selectYear").val());
		$("#searchForm input[name='searchmonth']").val($("#selectMonth").val());
		searchGo();
	});
	$("#selectMonth").on("change", function(){
		$("#searchForm input[name='searchyear']").val($("#selectYear").val());
		$("#searchForm input[name='searchmonth']").val($("#selectMonth").val());
		searchGo();
	});

	var $calScroll = $(".tblBookCalendar td a");
	$calScroll.click(function(){
		$calScroll.removeClass("on");
		if(!$(this).hasClass("selcOn")){ $(this).addClass("on");}
	});

});


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
		$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequest.do");
	}else{
		$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestList.do");
	}
	$("#searchForm").submit();
};
var searchTab = function(viewtype){
	var oldviewtype = $("#searchForm input[name='viewtype']").val();
	$("#searchForm input[name='viewtype']").val(viewtype);
	if(viewtype != "1"){
		$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequest.do");
	}else{
		$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestList.do");
	}
	$("#searchForm > input[name='page']").val(""); 
	$("#searchForm").submit();
	//searchGo();
};
var viewDetail = function(coursetype, courseid, regularcourseid){
	$("#searchForm input[name=courseid]").val(courseid);
	var url = "/mobile/lms/myAcademy/lmsMyRequestOffline.do";
	if(coursetype == "R"){
		$("#searchForm input[name=courseid]").val(regularcourseid);
		url = "/mobile/lms/myAcademy/lmsMyRequestCourse.do";
	}else if(coursetype == "L"){
		url = "/mobile/lms/myAcademy/lmsMyRequestLive.do";
	}
	$("#searchForm").attr("action", url);
	$("#searchForm").submit();
};
var fnDayConfirm = function( varToday ){
	//오늘 날자에 해당하는 일정 보여주기
	var param = {
		searchtoday : $("#selectYear").val() + $("#selectMonth").val() + varToday
	}
	$.ajaxCall({
   		url: "/mobile/lms/myAcademy/lmsMyRequestAjax.do"
   		, data: param 
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){
   			if($(data).filter("#result").html() == "LOGOUT"){
   				fnSessionCall("");
   				return;
   			}
   			
   			$("#toDayArea").html($(data).filter("#toDayArea").html());
   			abnkorea_resize();
   			
   			var $pos = $("#posScroll");
   			var iframeTop = parent.$("#IframeComponent").offset().top
   			parent.$('html, body').animate({
   			    scrollTop:$pos.offset().top + iframeTop
   			}, 300);
   			setTimeout(function(){ abnkorea_resize(); }, 500);
   			
   		}
   	});
};
</script>
</head>
<body class="uiGnbM3">
		
<form name="searchForm" id="searchForm">
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="courseid">
<input type="hidden" name="coursetype">
<input type="hidden" name="searchyear" value="${searchyear}">
<input type="hidden" name="searchmonth" value="${searchmonth }">
<input type="hidden" name="searchday" value="01">
<input type="hidden" name="searchtoday" value="${searchtoday}">
		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			
			<div class="tabWrap">
				<span class="hide">탭 메뉴</span>
				<ul class="tabDepth1 tNum2">
					<li onclick="searchTab('')" class="on"><strong>캘린더보기</strong></li>
					<li onclick="searchTab('1')"><a href="#none">교육목록</a></li>
				</ul>
			</div>
			<div class="scheduleMonth">
				<a href="#" class="monthPrev" onclick="changeMonth('prev');"><span class="hide">이전달</span></a>
				<select id="selectYear" class="year" title="년도">
					<c:forEach var="item" begin="${baseyear}" end="${nowyear}" varStatus="status">
						<option value="${nowyear - item + baseyear}" <c:if test="${searchyear eq (nowyear - item + baseyear) }">selected</c:if>>${nowyear - item + baseyear}</option>						
					</c:forEach>
				</select>
				<select id="selectMonth" class="month" title="월">
					<c:forEach var="item" begin="1" end="12" varStatus="status">
						<c:set var="monthVal" value="${item}"></c:set>
						<c:if test="${item < 10}">
							<c:set var="monthVal" value="0${item}"></c:set>
						</c:if>
						<option value="${monthVal}" <c:if test="${searchmonth eq monthVal }">selected</c:if>>${monthVal}</option>						
					</c:forEach>				
				</select>
				<a href="#" class="monthNext" onclick="changeMonth('next');"><span class="hide">다음달</span></a>
			</div>
			
			<div class="calendarWrapper">
				<table class="tblBookCalendar">
					<caption>캘린더형 - 날짜별 시설예약가능 시간</caption>
					<colgroup>
						<col style="width:13.5%">
						<col style="width:14.5%" span="5">
						<col style="width:auto">
					</colgroup>
					<thead>
						<tr>
							<th scope="col" class="weekSun">일</th>
							<th scope="col" class="weekMon">월</th>
							<th scope="col" class="weekTue">화</th>
							<th scope="col" class="weekWed">수</th>
							<th scope="col" class="weekThur">목</th>
							<th scope="col" class="weekFri">금</th>
							<th scope="col" class="weekSat">토</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="item" items="${calList}" varStatus="status">
						<tr>
							<td class="weekSun <c:if test="${item.useyn_0 eq 'E'}">late</c:if>">
								<c:if test="${item.day_0 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_0}')" <c:if test="${item.useyn_0 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth }">class="selcOn"</c:if>>${item.day_0}
										<c:if test="${item.coursetypeR_0 eq 'Y' or item.coursetypeF_0 eq 'Y' or item.coursetypeL_0 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_0 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_0 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_0 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
							<td class="<c:if test="${item.useyn_1 eq 'E'}">late</c:if>">
								<c:if test="${item.day_1 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_1}')" <c:if test="${item.useyn_1 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth}">class="selcOn"</c:if>>${item.day_1}
										<c:if test="${item.coursetypeR_1 eq 'Y' or item.coursetypeF_1 eq 'Y' or item.coursetypeL_1 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_1 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_1 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_1 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
							<td class="<c:if test="${item.useyn_2 eq 'E'}">late</c:if>">
								<c:if test="${item.day_2 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_2}')" <c:if test="${item.useyn_2 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth}">class="selcOn"</c:if>>${item.day_2}
										<c:if test="${item.coursetypeR_2 eq 'Y' or item.coursetypeF_2 eq 'Y' or item.coursetypeL_2 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_2 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_2 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_2 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
							<td class="<c:if test="${item.useyn_3 eq 'E'}">late</c:if>">
								<c:if test="${item.day_3 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_3}')" <c:if test="${item.useyn_3 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth}">class="selcOn"</c:if>>${item.day_3}
										<c:if test="${item.coursetypeR_3 eq 'Y' or item.coursetypeF_3 eq 'Y' or item.coursetypeL_3 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_3 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_3 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_3 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
							<td class="<c:if test="${item.useyn_4 eq 'E'}">late</c:if>">
								<c:if test="${item.day_4 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_4}')" <c:if test="${item.useyn_4 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth}">class="selcOn"</c:if>>${item.day_4}
										<c:if test="${item.coursetypeR_4 eq 'Y' or item.coursetypeF_4 eq 'Y' or item.coursetypeL_4 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_4 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_4 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_4 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
							<td class="<c:if test="${item.useyn_5 eq 'E'}">late</c:if>">
								<c:if test="${item.day_5 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_5}')" <c:if test="${item.useyn_5 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth}">class="selcOn"</c:if>>${item.day_5}
										<c:if test="${item.coursetypeR_5 eq 'Y' or item.coursetypeF_5 eq 'Y' or item.coursetypeL_5 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_5 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_5 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_5 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
							<td class="weekSat <c:if test="${item.useyn_6 eq 'E'}">late</c:if>">
								<c:if test="${item.day_6 ne '' }">
									<a href="#none" onclick="fnDayConfirm('${item.day_6}')" <c:if test="${item.useyn_6 eq 'Y' and nowyear eq searchyear and nowmonth eq searchmonth}">class="selcOn"</c:if>>${item.day_6}
										<c:if test="${item.coursetypeR_6 eq 'Y' or item.coursetypeF_6 eq 'Y' or item.coursetypeL_6 eq 'Y'}">
										<span>
											<c:if test="${item.coursetypeL_6 eq 'Y'}"><em class="calIcon2 red">예약</em></c:if>
											<c:if test="${item.coursetypeF_6 eq 'Y'}"><em class="calIcon2 green">예약</em></c:if>
											<c:if test="${item.coursetypeR_6 eq 'Y'}"><em class="calIcon2 blue">예약</em></c:if>
										</span>
										</c:if>
									</a>
								</c:if>
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
				
				<div class="resrState">
					<span class="calIcon2 blue"></span>정규과정
					<span class="calIcon2 green"></span>오프라인강의
					<span class="calIcon2 red"></span>라이브교육
				</div>
			</div>
			
			<div id="posScroll"></div>
			<div id="toDayArea" class="acSubWrap">
				<c:forEach var="item" items="${courseList}" varStatus="status">
				<c:if test="${item.coursetype eq 'F'}">
				<dl class="eduSummary">
					<dt>
						<a href="#none" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')">
						<strong>
							[${item.apname}] ${item.coursename}
						</strong>
						<c:if test='${item.groupflag eq "Y" }'>
							<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.startdatestr} ~ ${item.enddatestr2}</div>
						<div><span class="tit">교육종류</span>${item.coursetypename}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						<div><span class="tit">좌석번호</span>
							<strong class="fcR"><c:if test='${not empty item.seatnumber }'>${item.seatnumber }</c:if><c:if test='${empty item.seatnumber }'>현장배정</c:if></strong></div>
					</dd>
				</dl>
				</c:if>
				
				<c:if test="${item.coursetype eq 'L'}">
				<dl class="eduSummary">
					<dt>
						<a href="#none" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')">
						<strong>${item.liverealstr} ${item.coursename}</strong>
						<span class="category">${item.themename}</span>
						<c:if test='${item.groupflag eq "Y" }'> 
						<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.startdatestr}</div>
						<div><span class="tit">교육종류</span>${item.coursetypename}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
					</dd>
				</dl>
				</c:if>
				
				<c:if test="${item.coursetype eq 'R'}">
				<dl class="eduSummary">
					<dt>
						<a href="#none" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')">
						<strong>${item.regularcoursename }</strong>
						<c:if test='${item.regulargroupflag eq "Y" }'> 
						<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.coursestartdatestr} ~ ${item.courseenddatestr}</div>
						<div><span class="tit">교육종류</span>${item.coursetypename}</div>
						<div><span class="tit">나의현황</span>${item.regularstudystatusname}</div>
						
						<c:if test="${item.realcoursetype eq 'O' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">교육일</span>${item.startdatestr} ~ ${item.enddatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>

						<c:if test="${item.realcoursetype eq 'F' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시 및 <br/>장소</span>${item.startdatestr} ~ ${item.enddatestr2}<br/>${item.apname}(${item.roomname})</div>
						<div><span class="tit">좌석번호</span><strong class="fcR"><c:if test='${not empty item.seatnumber }'>${item.seatnumber }</c:if><c:if test='${empty item.seatnumber }'>현장배정</c:if></strong></div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'L' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.liverealstr } ${item.coursename }</div>
						<div><span class="tit">교육일</span>${item.startdatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'D' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">교육일</span>${item.startdatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'T' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">시험일</span>${item.startdatestr} ~ ${item.enddatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'V' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">설문일</span>${item.startdatestr} ~ ${item.enddatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
					</dd>
				</dl>
				</c:if>
				
				</c:forEach>
				
				<p class="listWarning">※  캘린더 보기에서는 완료 및 진행중인 교육만 확인 하실 수 있습니다.</p>
			</div>
				
		</section>

		<!-- content ##iframe end## -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>