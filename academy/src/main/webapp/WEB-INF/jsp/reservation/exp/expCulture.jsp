<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">

var typeSeq = "";
var ppSeq = "";
var ppName = "";
var year = "";
var month = "";
var day = "";
var krWeekDay = "";

var getYearPop = "";
var getMonthPop = "";
var getDayPop = "";
var step1Clk = "";

$(document).ready(function () {
	
	setPpInfoList();
	
	$(".brSelectWrap").show();
	$("#stepDone").hide();
	
	/* step1 다음 버튼 클릭 */
	$("#step1Btn").on("click", function(){
		if(ppSeq != "" && day != ""){
			
			/* step1 닫힘 */
			wrapClose($("#step1Btn"));
			
			/* step2 열림 */
			wrapOpen($("#step2Btn"));
			
			
			if(step1Clk == 1){
				/* step1 result 렌더링 */
				step1ResultRender();
				
				/* typeSeq, ppSeq, year, month, day 에 해당하는 프로그램 목록 조회 */
				expCultureProgramListAjax();
				step1Clk = 0;
			}
		}else{
			alert("날짜를 선택해야 다음 step으로 진행 가능합니다.");
		}
	});
	
	/* step2 예약 요청 버튼 클릭 */
	$("#step2Btn").on("click", function(){
		programCheck();
	});
	
	/* 예약계속하기} */
	$(".btnBasicGL").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expCultureForm.do'/>";
	});
	
});

/* pp정보 조회 */
function setPpInfoList(){
	$.ajaxCall({
		url: "<c:url value='/reservation/expCulturePpInfoListAjax.do'/>"
		, type : "POST"
		, async : false
		, success: function(data, textStatus, jqXHR){
			var ppList = data.ppCodeList;
			var lastPp = data.searchLastRsvPp;
			
			if(null == ppList || "" == ppList){
				alert("아직 프로그램이 등록되지 않았습니다. 운영자에 의해 프로그램이 등록 된 이후 사용 바랍니다.");
				return;
			}
			
			typeSeq = ppList[0].typeseq;
			
			getYearPop = ppList[0].getyear;
			getMonthPop = ppList[0].getmonth;
			getDayPop = ppList[0].getday;
			
			var html = "";
			
			for(var i = 0; i < ppList.length; i++){
				if(ppList[i].ppseq == lastPp.ppseq){
					html += "<a href='javascript:void(0);' class = 'on' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:calendar('"+ppList[i].getyear+"', '"+ppList[i].getmonth+"', '"+ppList[i].ppseq+"', '"+ppList[i].ppname+"');\">"+ppList[i].ppname+"</a>";
					calendar(ppList[i].getyear, ppList[i].getmonth, ppList[i].ppseq, ppList[i].ppname);
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:calendar('"+ppList[i].getyear+"', '"+ppList[i].getmonth+"', '"+ppList[i].ppseq+"', '"+ppList[i].ppname+"');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$("#ppAppend").empty();
			$("#ppAppend").append(html);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 날짜 정보 조회 */
function calendar(year, month, ppSeq, ppName){
	step1Clk = 1;
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$("a[name=detailPpSeq]").each(function () {
		$(this).removeClass();
	});
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+ppSeq).prop("class", "on");
	
	this.year = year;
	this.month = month;
	this.ppSeq = ppSeq;
	this.ppName = ppName;
	
	
	var param = {
		  "year" : this.year
		, "month" : this.month < 10 ? "0" + this.month : this.month
		, "ppseq" : this.ppSeq
		, "typeseq" : this.typeSeq
	};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCultureCalendarAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 달력 년, 월 랜더링 */
			var yearMonthList = data.expCultureYearMonth;
			
			/* 예약가능 세션 정보 날짜 조회 */
			var dayInfoList = data.expCultureDayInfoList;
			
			/* 예약가능 세션 정보 날짜 조회 */
			var today = data.expCultureToday;
			
			/* 캘린더 헤더 렌더링 */
			calenderHeaderRender(yearMonthList);
			
			/* 캘린더 렌더링 (예약가능 날짜 정보) */
			calenderRender(dayInfoList, today);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 캘린더 헤더 설정 */
function calenderHeaderRender(yearMonthList){
	
	var html = "";
	var tempMonth = "";
	
	/* html += "<span class=\"year\">"
		+ "<img src=\"/_ui/desktop/images/academy/img_"+yearMonthList[0].year+".gif\" "
		+ " alt=\""+yearMonthList[0].year+"년\" /></span>"
		+ "<div class=\"monthlyWrap\">"; */
		
	html += "<div class=\"monthlyWrap\">";
		
	for(var num in yearMonthList){
		/* 5개월 넘어가면 stop */
		if(7 <= num){
			break;
		}
		
		if(this.month == yearMonthList[num].month){
			tempMonth = yearMonthList[num].month;
			html += "<span><a href=\"javascript:void(0);\" class=\""+yearMonthList[num].engmonth+" on\">"+yearMonthList[num].month+"월</a></span>";
		}else{
			html += "<span><a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"', '"+this.ppSeq+"', '"+this.ppName+"');\" class=\""+yearMonthList[num].engmonth+"\">"+yearMonthList[num].month+"월</a></span>";
		}
	}
	
	if($("#pinvalue").val() != "-99"){
		html += "</div>"
				+ "<div>"
				+ "<span class=\"btnR\"><a href=\"#none\" title=\"새창 열림\" class=\"btnCont\" onclick=\"javascript:viewRsvConfirm();\"><span>체험예약 현황확인</span></a></span>"
				+ "</div>";
	}else{
		
		html += "</div>"
			+ "<div>"
			+ "<span class=\"btnR\"><a href=\"/reservation/expInfoList.do\" class=\"btnCont\"><span>체험예약 현황확인</span></a></span>"
			+ "</div>";
	}
	
	
	
	$(".calenderHeader").empty();
	$(".calenderHeader").append(html);
	
}

/* 캘린더 렌더링 */
function calenderRender(dayInfoList, today){
	
	this.day = "";
	
	var html = "";
	
	var ymd = "";
	var expSessionSeq = "";
	var renderFlag = true;
	var renderCnt = 0;
	for(var num in dayInfoList){
		if(ymd != dayInfoList[num].ymd){
			ymd = dayInfoList[num].ymd;
			expSessionSeq = dayInfoList[num].expsessionseq;
			renderFlag = true;
			renderCnt = 0;
		}
		
		if(ymd == dayInfoList[num].ymd
			&& 1 == dayInfoList[num].standbynumber){
			renderFlag = false;
		}
		
		if(ymd == dayInfoList[num].ymd
			&& 'R01' == dayInfoList[num].adminfirstcode){
			renderFlag = false;
		}
		
		if(ymd == dayInfoList[num].ymd
			&& expSessionSeq != dayInfoList[num].expsessionseq
			&& 1 != dayInfoList[num].standbynumber
			&& 'R01' != dayInfoList[num].adminfirstcode){
			renderFlag = true;
		}
		
		if(renderFlag && renderCnt == 0 && today.ymd <= dayInfoList[num].ymd){
			html += "<a href=\"javascript:void(0);\" id=\"detailDay"+dayInfoList[num].day+"\" name=\"detailDay\" onclick=\"javascript:daySelect('"+dayInfoList[num].day+"', '"+dayInfoList[num].krweekday+"');\">"
				+ dayInfoList[num].ymd.substring(4, 6)
				+ "-"+dayInfoList[num].ymd.substring(6, 8)
				+ " ("+dayInfoList[num].krweekday+")</a>";
			renderCnt++;
		}
	}
	
	$("#calender").empty();
	$("#calender").append(html);
	
}

/* 날짜 선택 이벤트 */
function daySelect(day, krWeekDay) {
	step1Clk = 1;
	
	this.day = day;
	this.krWeekDay = krWeekDay;
	
	$("a[name=detailDay]").each(function () {
		$(this).removeClass();
	});
	
	$("#detailDay"+day).prop("class", "on");
	
}


/* step1Btn 닫기 버튼 클릭시 step1의 결과값 렌더링 */
function step1ResultRender() {
	var tempMonth  = this.month < 10 ? "0"+this.month : this.month;
	var tempDay  = this.day < 10 ? "0"+this.day : this.day;
	$("#step1Btn").parents(".brWrap").find(".req").empty();
	$("#step1Btn").parents(".brWrap").find(".req").append(
			"<p>"+this.ppName+"<em>|</em>"+this.year+"-"+tempMonth+"-"+tempDay+" ("+this.krWeekDay+")</p>"		
		);
}

/* 문화체험 pp별, 날짜별 프로그램 목록 조회 */
function expCultureProgramListAjax() {
	
	var param = {
			  "year" : this.year
			, "month" : this.month < 10 ? "0" + this.month : this.month
			, "day" : this.day < 10 ? "0" + this.day : this.day
			, "ppseq" : this.ppSeq
			, "typeseq" : this.typeSeq
			, "pinvalue" : $("#pinvalue").val()
			, "infoAge" : $("#infoAge").val()
			, "infoCityGroupCode" : $("#infoCityGroupCode").val()
		};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCultureProgramListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var programList = data.expCultureProgramList;
			/* 프로그램 목록 생성 */
			programListRender(programList);
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 프로그램 목록 생성 */
function programListRender(programList) {
	
	var html = "";
	
	var reservationDate = this.year + "" + (this.month < 10 ? "0"+this.month : this.month) + "" + (this.day < 10 ? "0"+this.day : this.day);
	
	var expSeq = "";
	var expSessionSeq = "";
	var weekDay = "";
	if(isNull(programList[0].weekday)) {
		var week = ['일', '월', '화', '수', '목', '금', '토'];
		weekDay = "("+week[new reservationDate]+")";
	} else {
		weekDay = programList[0].weekday;
	}
	var renderFlag = true;
	var renderCnt = 0;
	
	for(var num in programList){
		if(expSessionSeq != programList[num].expsessionseq
				&& weekDay == programList[num].weekday){
			
			expSessionSeq = programList[num].expsessionseq;
			renderFlag = true;
			renderCnt = 0;
		}
		
		if(renderFlag && renderCnt == 0){
			if(programList[num].standbynumber == 0){
				html += "<tr>"
					+ "<td>"
					+ "<input type=\"checkbox\" id=\""+reservationDate+"_"+programList[num].expsessionseq+"\" name=\"\" onclick=\"javascript:programClick(this);\"/>"
					+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+programList[num].expseq+"\">"
					+ "<input type=\"hidden\" name=\"expSessionSeq\" value=\""+programList[num].expsessionseq+"\">"
					+ "<input type=\"hidden\" name=\"reservationDate\" value=\""+reservationDate+"\">"
					+ "<input type=\"hidden\" name=\"standByNumber\" value=\""+1+"\">"
					+ "<input type=\"hidden\" name=\"paymentStatusCode\" value=\"P01\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+programList[num].productname+"\">"
					+ "<input type=\"hidden\" name=\"krWeekDay\" value=\""+this.krWeekDay+"\">"
					+ "<input type=\"hidden\" name=\"startDateTime\" value=\""+programList[num].startdatetime+"\">"
					+ "<input type=\"hidden\" name=\"endDateTime\" value=\""+programList[num].enddatetime+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\">"
					+ "<a href=\"#none\" title=\"새창열림\" onclick=\"javascript:detailCuultureIntro("+programList[num].expseq+");\">"
					+ "<strong>"+programList[num].themename+"</strong>"
					+ "["+this.ppName+"] "+programList[num].productname
					+ "</a><span class=\"prepare\">★ 준비물 : "+programList[num].preparation+"</span>"
					+ "</td>"
					+ "<td>"+programList[num].startdatetime.substring(0, 2)+":"+programList[num].startdatetime.substring(2, 4)+"</td>"
					+ "<td>대기신청</td>"
					+ "</tr>";
			}else if(programList[num].standbynumber == 1 || programList[num].adminfirstcode == 'R01'){
				html += "<tr>"
					+ "<td>"
					+ "<input type=\"checkbox\" id=\""+reservationDate+"_"+programList[num].expsessionseq+"\" name=\"\" onclick=\"javascript:programClick(this);\" disabled/>"
					+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+programList[num].expseq+"\">"
					+ "<input type=\"hidden\" name=\"expSessionSeq\" value=\""+programList[num].expsessionseq+"\">"
					+ "<input type=\"hidden\" name=\"reservationDate\" value=\""+reservationDate+"\">"
					+ "<input type=\"hidden\" name=\"standByNumber\" value=\""+1+"\">"
					+ "<input type=\"hidden\" name=\"paymentStatusCode\" value=\"P01\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+programList[num].productname+"\">"
					+ "<input type=\"hidden\" name=\"krWeekDay\" value=\""+this.krWeekDay+"\">"
					+ "<input type=\"hidden\" name=\"startDateTime\" value=\""+programList[num].startdatetime+"\">"
					+ "<input type=\"hidden\" name=\"endDateTime\" value=\""+programList[num].enddatetime+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\">"
					+ "<a href=\"#none\" title=\"새창열림\" onclick=\"javascript:detailCuultureIntro("+programList[num].expseq+");\">"
					+ "<strong>"+programList[num].themename+"</strong>"
					+ "["+this.ppName+"] "+programList[num].productname
					+ "</a><span class=\"prepare\">★ 준비물 : "+programList[num].preparation+"</span>"
					+ "</td>"
					+ "<td>"+programList[num].startdatetime.substring(0, 2)+":"+programList[num].startdatetime.substring(2, 4)+"</td>"
					+ "<td>예약마감</td>"
					+ "</tr>";
			}else{
				html += "<tr>"
					+ "<td>"
					+ "<input type=\"checkbox\" id=\""+reservationDate+"_"+programList[num].expsessionseq+"\" name=\"\" onclick=\"javascript:programClick(this);\"/>"
					+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+programList[num].expseq+"\">"
					+ "<input type=\"hidden\" name=\"expSessionSeq\" value=\""+programList[num].expsessionseq+"\">"
					+ "<input type=\"hidden\" name=\"reservationDate\" value=\""+reservationDate+"\">"
					+ "<input type=\"hidden\" name=\"standByNumber\" value=\""+0+"\">"
					+ "<input type=\"hidden\" name=\"paymentStatusCode\" value=\"P02\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+programList[num].productname+"\">"
					+ "<input type=\"hidden\" name=\"krWeekDay\" value=\""+this.krWeekDay+"\">"
					+ "<input type=\"hidden\" name=\"startDateTime\" value=\""+programList[num].startdatetime+"\">"
					+ "<input type=\"hidden\" name=\"endDateTime\" value=\""+programList[num].enddatetime+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\">"
					+ "<a href=\"#none\" title=\"새창열림\" onclick=\"javascript:detailCuultureIntro("+programList[num].expseq+");\">"
					+ "<strong>"+programList[num].themename+"</strong>"
					+ "["+this.ppName+"] "+programList[num].productname
					+ "</a><span class=\"prepare\">★ 준비물 : "+programList[num].preparation+"</span>"
					+ "</td>"
					+ "<td>"+programList[num].startdatetime.substring(0, 2)+":"+programList[num].startdatetime.substring(2, 4)+"</td>"
					+ "<td class=\"able\">예약가능</td>"
					+ "</tr>";
			}
			renderCnt++;
		}
	}
	
	$("#programList").empty();
	$("#programList").append(html);
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 프로그램 체크 이벤트 */
function programClick(obj) {
	if($(obj).prop("checked")){
		/* 선택 */
		$(obj).parents("tr").addClass("select");
	}else{
		/* 선택취소 */
		$(obj).parents("tr").removeClass("select");
	}
}

/* 프로그램 예약 여부 체크 */
function programvalidation(typeSeq, expSeq, expSessionSeq) {
	var param = {
			  rsvtypecode:"R02"
			, typeSeq:typeSeq
			, expSeq:expSeq
			, expSessionSeq:expSessionSeq			
	}
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/expBrandRsvAvailabilityCheckAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 선택된 프로그램 form태그에 정리 */
function programCheck() {
	var html = "";
	var cnt = 0;
	$("#checkLimitCount").empty();
	
	$("#programList tr").each(function () {
		
		if($(this).prop("class") == "select"){
			html += "<input type=\"hidden\" name=\"typeSeq\" value=\""+$(this).find("input[name=typeSeq]").val()+"\">"
				+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+$(this).find("input[name=ppSeq]").val()+"\">"
				+ "<input type=\"hidden\" name=\"ppName\" value=\""+$(this).find("input[name=ppName]").val()+"\">"
				+ "<input type=\"hidden\" name=\"expSeq\" value=\""+$(this).find("input[name=expSeq]").val()+"\">"
				+ "<input type=\"hidden\" name=\"expSessionSeq\" value=\""+$(this).find("input[name=expSessionSeq]").val()+"\">"
				+ "<input type=\"hidden\" name=\"reservationDate\" value=\""+$(this).find("input[name=reservationDate]").val()+"\">"
				+ "<input type=\"hidden\" name=\"standByNumber\" value=\""+$(this).find("input[name=standByNumber]").val()+"\">"
				+ "<input type=\"hidden\" name=\"paymentStatusCode\" value=\""+$(this).find("input[name=paymentStatusCode]").val()+"\">"
				+ "<input type=\"hidden\" name=\"productName\" value=\""+$(this).find("input[name=productName]").val()+"\">"
				+ "<input type=\"hidden\" name=\"krWeekDay\" value=\""+$(this).find("input[name=krWeekDay]").val()+"\">"
				+ "<input type=\"hidden\" name=\"startDateTime\" value=\""+$(this).find("input[name=startDateTime]").val()+"\">"
				+ "<input type=\"hidden\" name=\"endDateTime\" value=\""+$(this).find("input[name=endDateTime]").val()+"\">";
				
			$("#checkLimitCount").append("<input type=\"hidden\" name =\"reservationDate\" value=\""+$(this).find("input[name=reservationDate]").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name =\"typeSeq\" value=\""+$(this).find("input[name=typeSeq]").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+$(this).find("input[name=expSeq]").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expSessionSeq\" value=\""+$(this).find("input[name=expSessionSeq]").val()+"\">");
			
			cnt++;
		}
	});

	if(cnt == 0){
		alert("프로그램을 선택 후 다음으로 진행 가능합니다.");
		return;
	}
	
	$("#expCultureForm").empty();
	$("#expCultureForm").append(html);
	
	/* 패널티 유효성 중간 검사 */
	if(middlePenaltyCheck()){
	
		$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeseq\" value=\""+typeSeq+"\">");
		$("#checkLimitCount").append("<input type=\"hidden\" name=\"ppseq\" value=\""+ppSeq+"\">");
		
		/* 프로그램 중복 신청 체크 */
		$.ajaxCall({
			  url: "<c:url value='/reservation/expProgramVailabilityCheckAjax.do'/>"
			, type : "POST"
			, data: $("#checkLimitCount").serialize()
			, success: function(data, textStatus, jqXHR){
				var item = data.ProgramVailability;
				
				if(item.cnt!=0) {
					setTimeout(function(){ abnkorea_resize(); }, 500);
					alert("중복 신청이 불가능 합니다. 확인 후 신청 해 주세요.");
				} else {
					$.ajaxCall({
						  url: "<c:url value='/reservation/expBrandRsvAvailabilityCheckAjax.do'/>"
						, type : "POST"
						, data: $("#checkLimitCount").serialize()
						, success: function(data, textStatus, jqXHR){
							if(data.rsvAvailabilityCheck){
								duplicateCheck();
							}else{
								alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
							}
				
						}, error: function( jqXHR, textStatus, errorThrown) {
							var mag = '<spring:message code="errors.load"/>';
							alert(mag);
						}
					});
				}
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				breakvailabil = true;
				alert(mag);
			}
		});
		
		
	}
	
}

function middlePenaltyCheck() {
	
	var penaltyCheck = true;
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/rsvMiddlePenaltyCheckAjax.do'/>"
		, type : "POST"
		, data: $("#checkLimitCount").serialize()
		, async: false
		, success: function(data, textStatus, jqXHR){
			if(!data.middlePenaltyCheck){
				alert("패널티로 인해서 예약이 불가 합니다.");
				penaltyCheck = false;
			}

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	return penaltyCheck;
}

/* 예약 가능 체크 */
function duplicateCheck() {
	
	var param = $("#expCultureForm").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCultureDuplicateCheckAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var cancelDataList = data.cancelDataList;
			
			if(cancelDataList.length == 0){
				/* 예약 확인 팝업 오픈 */
				expCultureRsvRequestPop();
			}else{
				/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
				expCultureDisablePop(cancelDataList);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 예약요청 팝업 호출 */
function expCultureRsvRequestPop(){
	
	var frm = document.expCultureForm
	var url = "<c:url value='/reservation/expCultureRsvRequestPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=487, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 예약불가 알림 팝업(중복체크) */
function expCultureDisablePop(cancelDataList) {
	var url = "<c:url value='/reservation/expCultureDisablePop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
	$("#cancelList").empty();
    var $form = $('#cancelList');
    $form.attr('action', url);
    $form.attr('method', 'post');
    $form.attr('target', title);
    $form.appendTo('body');
	
	/* 중복 데이터 삭제 */
	for(var num in cancelDataList){
		$form.append("<input type= 'hidden' name = 'reservationdate' value = '"+cancelDataList[num].reservationdate+"'>");
		$form.append("<input type= 'hidden' name = 'expsessionseq' value = '"+cancelDataList[num].expsessionseq+"'>");
		$form.append("<input type= 'hidden' name = 'reservationweek' value = '"+cancelDataList[num].reservationweek+"'>");
		$form.append("<input type= 'hidden' name = 'ppname' value = '"+cancelDataList[num].ppname+"'>");
		$form.append("<input type= 'hidden' name = 'programname' value = '"+cancelDataList[num].programname+"'>");
		$form.append("<input type= 'hidden' name = 'sessionname' value = '"+cancelDataList[num].sessionname+"'>");
		$form.append("<input type= 'hidden' name = 'starttime' value = '"+cancelDataList[num].starttime+"'>");
		$form.append("<input type= 'hidden' name = 'endtime' value = '"+cancelDataList[num].endtime+"'>");
		$form.append("<input type= 'hidden' name = 'standbynumber' value = '"+cancelDataList[num].standbynumber+"'>");
	}
	
	$form.submit();
	
}

/* 회원 예약 완료 후 호출 팝업 */
function expCultureRsvComplete(expCultureCompleteList) {
	/* step2 닫기 */
	
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	wrapClose($("#step2Btn"));
	$("#stepDone").show();
	
	
	var html = "<p class=\"total\">총 "+expCultureCompleteList.length+" 건</p>";
	
	var snsHtml = "[한국암웨이]시설/체험 예약내역 (총 "+expCultureCompleteList.length+"건) \n";
	
	for(var num in expCultureCompleteList){
	
		if(expCultureCompleteList[num].paymentStatusCode == 'P01'){
			html += "<p>"+expCultureCompleteList[num].productName+"<em>|";
			html += "</em>"+expCultureCompleteList[num].startDateTime.substr(0, 2)+":"+expCultureCompleteList[num].startDateTime.substr(2, 2)+" (예약완료)<em>|";
			html += "</em>참석인원 "+expCultureCompleteList[num].visitNumber+"명</p>";
			
			snsHtml += "■"+this.ppName+"("+expCultureCompleteList[num].productName+")";
			snsHtml += expCultureCompleteList[num].reservationDate.substr(0, 4) + "-" + expCultureCompleteList[num].reservationDate.substr(5, 2) + "-" + expCultureCompleteList[num].reservationDate.substr(6, 2) + "("+this.krWeekDay+") | \n" ;
			snsHtml += expCultureCompleteList[num].startDateTime.substr(0, 2)+":"+expCultureCompleteList[num].startDateTime.substr(2, 2) + "(예약완료) | \n";
			snsHtml += "참석인원" + expCultureCompleteList[num].visitNumber + "명 \n";
		}else{
			html += "<p>"+expCultureCompleteList[num].productName+"<em>|";
			html += "</em>"+expCultureCompleteList[num].startDateTime.substr(0, 2)+":"+expCultureCompleteList[num].startDateTime.substr(2, 2)+"<em>|";
			html += "</em>참석인원 "+expCultureCompleteList[num].visitNumber+"명</p>";
			
			snsHtml += "■"+this.ppName+"("+expCultureCompleteList[num].productName+")";
			snsHtml += expCultureCompleteList[num].reservationDate.substr(0, 4) + "-" + expCultureCompleteList[num].reservationDate.substr(5, 2) + "-" + expCultureCompleteList[num].reservationDate.substr(6, 2) + "("+this.krWeekDay+") | \n";
			snsHtml += expCultureCompleteList[num].startDateTime.substr(0, 2)+":"+expCultureCompleteList[num].startDateTime.substr(2, 2) + " | \n" ;
			snsHtml += "참석인원" + expCultureCompleteList[num].visitNumber + "명 \n";
		}
	}
	
	/* step2 result rendering */
	$("#step2Btn").parents(".brWrap").find(".req").empty();
	$("#step2Btn").parents(".brWrap").find(".req").append(html);
	
	$("#snsText").empty();
	$("#snsText").val(snsHtml);
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 비회원 정보 기입 페이지 */
function expCultureNonmemberIdCheckForm(expCultureInfoList) {
	
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});

	
	var url = "<c:url value='/reservation/expCultureNonmemberIdCheckForm.do'/>";
	
    var $form = $('<form></form>');
    $form.attr('action', url);
    $form.attr('method', 'post');
    $form.appendTo('body');
    
	/* 데이터 가공 */
	for(var num in expCultureInfoList){
		$form.append("<input type=\"hidden\" name=\"tempTypeSeq\" value=\""+expCultureInfoList[num].tempTypeSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempPpSeq\" value=\""+expCultureInfoList[num].tempPpSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempPpName\" value=\""+expCultureInfoList[num].tempPpName+"\">");
		$form.append("<input type=\"hidden\" name=\"tempExpSeq\" value=\""+expCultureInfoList[num].tempExpSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempExpSessionSeq\" value=\""+expCultureInfoList[num].tempExpSessionSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempReservationDate\" value=\""+expCultureInfoList[num].tempReservationDate+"\">");
		$form.append("<input type=\"hidden\" name=\"tempStandByNumber\" value=\""+expCultureInfoList[num].tempStandByNumber+"\">");
		$form.append("<input type=\"hidden\" name=\"tempPaymentStatusCode\" value=\""+expCultureInfoList[num].tempPaymentStatusCode+"\">");
		$form.append("<input type=\"hidden\" name=\"tempProductName\" value=\""+expCultureInfoList[num].tempProductName+"\">");
		$form.append("<input type=\"hidden\" name=\"tempStartDateTime\" value=\""+expCultureInfoList[num].tempStartDateTime+"\">");
		$form.append("<input type=\"hidden\" name=\"tempEndDateTime\" value=\""+expCultureInfoList[num].tempEndDateTime+"\">");
		$form.append("<input type=\"hidden\" name=\"tempVisitNumber\" value=\""+expCultureInfoList[num].tempVisitNumber+"\">");
		$form.append("<input type=\"hidden\" name=\"tempKrWeekDay\" value=\""+expCultureInfoList[num].tempKrWeekDay+"\">");
		
	}

	$form.append("<input type=\"hidden\" name=\"tempParentFlag\" value=\"date\">");
	$form.submit();
}

/* 문화체험 소개 팝업 */
function expCultureIntroduce() {
	var url = "<c:url value='/reservation/expCultureIntroducePop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=523, height=645, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
    var $form = $('<form></form>');
    $form.attr('method', 'post');
    $form.attr('target', title);
    $form.attr('action', url);
    $form.appendTo('body');

	$form.append("<input type=\"hidden\" name=\"typeseq\" value=\""+this.typeSeq+"\">");
	$form.submit();
	
}

/* ap 안내 */
function showApInfo(){
	var firstApSeq = "";
	var firstApName = "";
	var html = "";

	$("#apInfoList").empty();
	
	
	$.ajaxCall({
		url: "<c:url value='/reservation/searchApInfoAjax.do'/>"
		, type : "POST"
		, success: function(data, textStatus, jqXHR){
			var ppCodeList = data.ppCodeList;
			
		 	for(var i = 0; i < ppCodeList.length; i++){
		 		firstApSeq = ppCodeList[0].commonCodeSeq;
		 		firstApName = ppCodeList[0].codeName;
				
		 		if(i == 0){
			 		html += "<li class='on'><a href='javascript:void(0);' id = 'ap"+ppCodeList[i].commonCodeSeq+"' onclick=\"javascript:showApInfoDatail('"+ppCodeList[i].commonCodeSeq+"', '"+ppCodeList[i].codeName+"');\">"+ppCodeList[i].codeName+"</a></li>"
		 		}else{
			 		html += "<li><a href='javascript:void(0);' id = 'ap"+ppCodeList[i].commonCodeSeq+"' onclick=\"javascript:showApInfoDatail('"+ppCodeList[i].commonCodeSeq+"', '"+ppCodeList[i].codeName+"');\">"+ppCodeList[i].codeName+"</a></li>"
		 		}
			}
			showApInfoDatail(firstApSeq, firstApName);
			$("#apInfoList").append(html);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 해당 다음버튼의 wrap 열기 */
function wrapOpen(obj) {
	$(obj).parents('.brWrap').find('.modifyBtn').hide();
	$(obj).parents('.brWrap').find('.result').hide();
	$(obj).parents('.brWrap').find('.sectionWrap').stop().slideDown(function(){
		$(obj).parents('.brWrap').find('.stepTit').find('.close').hide();
		$(obj).parents('.brWrap').find('.stepTit').find('.open').show();
		$(obj).parents('.brWrap').removeClass('finish').addClass('current');
	});
}

/* 해당 다음버튼의 wrap 닫기 */
function wrapClose(obj) {
	$(obj).parents('.brWrap').find('.sectionWrap').stop().slideUp(function(){
		$(obj).parents('.brWrap').find('.stepTit').find('.close').show();
		$(obj).parents('.brWrap').find('.stepTit').find('.open').hide();
		
		$(obj).parents('.brWrap').find('.modifyBtn').show();
		$(obj).parents('.brWrap').find('.req').show(); //결과값 보기
		$(obj).parents('.brWrap').removeClass('current').addClass('finish');
	});
}

function viewRsvConfirm(){
	
	$("#getYearPop").val("");
	$("#getMonthPop").val("");
	
	$("#getYearPop").val(getYearPop);
	
	if(getMonthPop < 10){
		$("#getMonthPop").val("0"+getMonthPop);
	}else{
		$("#getMonthPop").val(getMonthPop);
	}
	
	$("#getDayPop").val(this.getDayPop);
	
	var frm = document.expCultureForm
	var url = "<c:url value="/reservation/expHealthRsvConfirmPop.do"/>";
	var title = "testpop";
	var status = "toolbar=no, width=754, height=900, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 문화체험 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}


function showStep1(){
	$("#step2Result").show();
}

function detailCuultureIntro(expseq){
	
	var url = "<c:url value='/reservation/expCultureIntroducePop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=523, height=645, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
    var $form = $('<form></form>');
    $form.attr('method', 'post');
    $form.attr('target', title);
    $form.attr('action', url);
    $form.appendTo('body');

	$form.append("<input type=\"hidden\" name=\"typeseq\" value=\""+this.typeSeq+"\">");
	$form.append("<input type=\"hidden\" name=\"tempexpseq\" value=\""+expseq+"\">");
	$form.submit();
}

/* 예약 현황 확인 페이지 이동 */
function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}
</script>
</head>
<body>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<form id="expCultureForm" name="expCultureForm" method="post">
		<input type="hidden" name="getYearPop" id="getYearPop">
		<input type="hidden" name="getMonthPop" id="getMonthPop">
		<input type="hidden" name="getDayPop" id="getDayPop">
		<input type="hidden" id="pinvalue" name="pinvalue" value="${srcData.pinvalue}">
		<input type="hidden" id="infoAge" name="infoAge" value="${srcData.infoAge}">
		<input type="hidden" id="infoCityGroupCode" name="infoCityGroupCode" value="${srcData.infoCityGroupCode}">
	</form>
	
	<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
	<form id="cancelList" name="cancelList" method="post"></form>

	<input type="hidden" id="transactionTime" value="" />	
	<input type="hidden" id="snsText" name="snsText">
	
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500290.gif" alt="문화체험 예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500290.gif" alt="전국 Amway Plaza에서 운영되고 있는 문화 체험을 예약하실 수 있습니다."></p>
	</div>
	<div class="brIntro">
		<!-- @edit 20160701 인트로 토글 링크영역 변경 -->
		<h2 class="hide">문화체험 예약 필수 안내</h2>
		<a href="#uiToggle_01" class="toggleTitle"><strong>문화체험 예약 필수 안내</strong> <span class="btnArrow"><em class="hide">내용보기</em></span></a>
		<div id="uiToggle_01" class="toggleDetail"> <!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</div>
	
	<div class="tabWrap">
		<span class="hide">문화체험 예약</span>
		<ul class="tabDepth1 widthL">
			<li class="on"><strong>날짜 먼저선택</strong></li>
			<li><a href="/reservation/expCultureProgramForm.do">프로그램 먼저선택</a></li>
		</ul>
		<span class="btnR"><a href="#none" class="btnCont" onclick="javascript:expCultureIntroduce();"><span>문화체험 소개</span></a></span>
	</div>
	
	<div class="brWrapAll">
		<span class="hide">문화체험 예약 스텝</span>
		<!-- 스텝1 -->
		<div class="brWrap current" id="step1">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_apexp2_01.gif" alt="Step1/지역, 날짜" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_apexp2_01_current.gif" alt="Step1/지역, 날짜 - 지역 선택 후 날짜를 선택하세요" /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="brSelectWrap">
						<div class="relative">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_01.gif" alt="지역 선택"></h3>
<!-- 							<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen" onclick="javascript:showApInfo();"><span>AP 안내</span></a></span> -->
							<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen"><span>AP 안내</span></a></span>
						</div>
						
						<!-- layer popup -->
						<%@ include file="/WEB-INF/jsp/reservation/exp/apInfoPop.jsp" %>
						<!--// layer popup -->
						
						<div class="brselectArea" id="ppAppend">

						</div>
						
					</section>
					<section class="brSelectWrap">
						<div class="calenderWrap">
							<!-- 1월 jan, 2월 feb, 3월 mar, 4월 apr, 5월 may, 6월 june, 7월 july, 8월 aug, 9월 sep, 10월 oct, 11월 nov, 12월 dec -->
							<div class="calenderHeader">
<!-- 								<span class="year"><img src="/_ui/desktop/images/academy/img_2016.gif" alt="2016년" /></span>
								<div class="monthlyWrap">
									<span><a href="#none" class="may on">5월</a></span>
									<span><a href="#none" class="june">6월</a></span>
									<span><a href="#none" class="july">7월</a></span>
								</div> -->
								<div>
								
<%-- 									<c:out value=""></c:out> --%>
									<c:if test="${srcData.account ne ''}">
									<span class="btnR"><a href="#none" title="새창 열림" class="btnCont"><span>체험예약 현황확인</span></a></span>
									</c:if>
								</div>
							</div>
						</div>
						<div class="brselectArea" id="calender">
<!-- 							<a href="#none">05-05 (목)</a><a href="#none">05-13 (토)</a><a href="#none">05-14 (일)</a><a href="#none" class="on">05-21 (토)</a><a href="#none">05-22 (일)</a><a href="#none">05-23 (월)</a><a href="#none">05-24 (화)</a> -->
						</div>
					</section>
					
					<div class="btnWrapR">
						<a href="#step1" id="step1Btn" class="btnBasicBS">다음</a>
					</div>
				</div>
				<div class="result req"><!-- <p>분당ABC<em>|</em>2016-05-25 (수)</p> --></div>
			</div>
			<%//<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
			
		</div>
		<!-- //스텝1 -->
		<!-- 스텝2 -->
		<div class="brWrap" id="step2">
			<h2 class="stepTit">
				<!-- @edit 이미지명 -->
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_apexp_04.gif" alt="Step2/ 프로그램" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_apexp_04_current.gif" alt="Step2/ 프로그램 - 프로그램을 선택하세요." /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="programWrap">
						<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w020500290.gif" alt="프로그램 선택" /></h3>
						
						<table class="tblProgram mgNone">
							<caption>프로그램 선택</caption>
							<colgroup>
								<col width="5%" />
								<col width="*" />
								<col width="12%" />
								<col width="15%" />
							</colgroup>
							<tbody id="programList">
<!-- 								<tr class="select">checked 되면 tr class="select" 삽입
									<td><input type="checkbox" id="" name="" checked /></td>
									<td class="programTitle"><a href="#none" title="새창열림"><strong>암웨이 칠드런스데이</strong>[강서 AP] 빗물 똑똑 우산 만들기</a><span class="prepare">★ 준비물 : 태블릿PC</span></td>
									<td>13:00</td>
									<td class="able">예약가능</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="" name="" /></td>
									<td class="programTitle"><a href="#none" title="새창열림"><strong>암웨이 칠드런스데이</strong>[강서 AP] 빗물 똑똑 우산 만들기</a><span class="prepare">★ 준비물 : 태블릿PC</span></td>
									<td>13:00</td>
									<td class="able">예약가능</td>
								</tr>
								<tr>
									<td><input type="checkbox" id="" name="" /></td>
									<td class="programTitle"><a href="#none" title="새창열림"><strong>5월 가족의 달 맞이, 부모님 대상 체험 프로그램</strong>[분당ABC] 가족이 대를 잇는 추억놀이</a><span class="prepare">★ 준비물 : 태블릿PC</span></td>
									<td>13:00</td>
									@edit 20160701 예약대기를 대기신청으로 문구 변경 (전체)
									<td>대기신청</td>
								</tr> -->
							</tbody>
						</table>
						<ul class="listWarning">
							<li>※ 취소 없이 참여하지 않는 경우, 패널티가 적용되어 모든 문화체험 체험월의 익월까지 예약 불가합니다.</li>
						</ul>
					</section>
					
					<div class="btnWrapR">
						<a href="#step2" class="btnBasicGS" onclick="javascirpt:showStep1();">이전</a>
						<a href="#none" id="step2Btn" class="btnBasicBS">예약요청</a>
					</div>
				</div>
				<div class="result" id="step2Result"><p>프로그램을 선택해 주세요.</p></div>
				<div class="result lines req" style="display:none">
<!-- 					<p class="total">총 2 건</p> -->
<!-- 					<p>가족이 대를 잇는 추억놀이<em>|</em>14:00<em>|</em>참석인원 1명</p> -->
<!-- 					<p>신나는 ABC 마술쇼<em>|</em>15:00 (대기신청)<em>|</em>참석인원 1명</p> -->
				</div>
				
			</div>
<!-- 			<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> -->
		</div>
		<!-- //스텝2 -->
		<!-- 예약완료 -->
		<div class="brWrap" id="stepDone">
			<p><img src="/_ui/desktop/images/academy/brTextDone.gif" alt="예약이 완료 되었습니다. 이용해 주셔서 감사합니다." /></p>
			<div class="snsWrap">
				<!-- 20150313 : SNS영역 수정 -->
				<span class="snsLink">
					<!-- @eidt 20160627 URL 복사 삭제 -->
					<a href="#" id="snsKs" class="snsCs" onclick="javascript:tempSharing('${httpDomain}', 'kakaoStory');" title="새창열림"><span class="hide">카카오스토리</span></a>
					<a href="#" class="snsBand" onclick="javascript:tempSharing('${httpDomain}', 'band');" title="새창열림"><span class="hide">밴드</span></a>
					<a href="#" id="snsFb" class="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');" title="새창열림"><span class="hide">페이스북</span></a>
				</span>
				<!-- //20150313 : SNS영역 수정 -->
				<span class="snsText"><img src="/_ui/desktop/images/academy/sns_text.gif" alt="예약내역공유" /></span>
			</div>
			<div class="btnWrapC">
				<a href="/reservation/expCultureForm.do" class="btnBasicGL">예약계속하기</a>
				<a href="javascript:void(0);" onclick="javascript:accessParentPage();" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</div>
</section>
<!-- //content area | ### academy IFRAME End ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
