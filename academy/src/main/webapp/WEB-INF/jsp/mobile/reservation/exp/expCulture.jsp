<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

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

var flag = "";
var tempExpseq = "";

var getYearPop = "";
var getMonthPop = "";
var getDayPop = "";

$(document).ready(function () {
	
	/* step1 다음 버튼 hide */
	$("#step1Btn").parents(".bizEduPlace").find(".btnWrap").hide();
	
	setPpInfoList();
	
// 	$(".brSelectWrap").show();
	$("#stepDone").hide();
	
	/* step1 다음 버튼 클릭 */
	$("#step1Btn").on("click", function(){
		/* step1 result 렌더링 */
		step1ResultRender();
		
		/* typeSeq, ppSeq, year, month, day 에 해당하는 프로그램 목록 조회 */
		expCultureProgramListAjax();
	});
	
	/* step2 예약 요청 버튼 클릭 */
	$("#step2Btn").on("click", function(){
		/* 체크된 프로그램 데이터 form태그에 정리, 예약확인 팝업 호출 */
		programCheck();
	});
	
	/* 문화체험 소개 버튼 이벤트 */
	$("#expCultureIntroduceBtn").on("click", function () {
// 		this.flag = "";
// 		expCultureIntroduce();
	});
	
});

/* pp정보 조회 */
function setPpInfoList(){
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expCulturePpInfoListAjax.do'/>"
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
			
			$("#getMonthPop").val("");
			$("#getYearPop").val("");
			$("#getDayPop").val("");
			
			$("#getMonthPop").val(ppList[0].getmonth);
			$("#getYearPop").val(ppList[0].getyear);
			$("#getDayPop").val(ppList[0].getday);
			
			var html = "";
			
			for(var i = 0; i < ppList.length; i++){
				if(ppList[i].ppseq == lastPp.ppseq){
					html += "<a href='javascript:void(0);' class = 'active' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:calendar('"+ppList[i].getyear+"', '"+ppList[i].getmonth+"', '"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', 'click');\">"+ppList[i].ppname+"</a>";
					calendar(ppList[i].getyear, ppList[i].getmonth, ppList[i].ppseq, ppList[i].ppname, "load");
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:calendar('"+ppList[i].getyear+"', '"+ppList[i].getmonth+"', '"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', 'click');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$(".selectArea.local").empty();
			$(".selectArea.local").append(html);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 날짜 정보 조회 */
function calendar(year, month, ppSeq, ppName, flag){
		
	/* step1 이전 다음 버튼 hide */
	$("#step1Btn").parents(".bizEduPlace").find(".btnWrap").hide();
	
	$(".selectArea.local").parent().next().hide();
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$("a[name=detailPpSeq]").each(function () {
		$(this).removeClass();
	});
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+ppSeq).prop("class", "active");
	
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
		url: "<c:url value='/mobile/reservation/expCultureCalendarAjax.do'/>"
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
			
			/* 캘린더 선택 화면으로 이동 */
			var $pos = $("#selectDay");
			var iframeTop = parent.$("#IframeComponent").offset().top;
			if(flag == "click") {
				parent.$('html, body').animate({
					scrollTop: $pos.offset().top + iframeTop
				}, 300);
			}
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
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
	var tempYear = "";
	
// 	html += "<span class=\"year\">"
// 		+ yearMonthList[0].year
// 		+ "</span>"
// 		+ "<span class=\"monthlyWrap\">";

	html += "<div class=\"monthlyWrap\">";
		
	for(var num in yearMonthList){
		/* 5개월 넘어가면 stop */
		if(7 <= num){
			break;
		}
		
		if(num == 0){
			tempMonth = yearMonthList[num].month;
			tempYear = yearMonthList[num].year;
			html += "<span><span class=\"year\">"+yearMonthList[num].year+"</span>"
				 
		}else if(tempYear != yearMonthList[num].year && yearMonthList[num].month == 1){
			html += "<span><span class=\"year\">"+yearMonthList[num].year+"</span>"
		}
		
		if(this.month == yearMonthList[num].month){
			tempMonth = yearMonthList[num].month;
			
			html += "<a href=\"javascript:void(0);\" class=\"on\">"+yearMonthList[num].month+"<span>月</span></a></span>";
		}else{
			html += "<a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"', '"+this.ppSeq+"', '"+this.ppName+"');\" class=\""+yearMonthList[num].engmonth+"\">"+yearMonthList[num].month+"<span>月</span></a></span>";
		}
		
// 		if(this.month == yearMonthList[num].month){
// 			tempMonth = yearMonthList[num].month;
// 			html += "<a href=\"javascript:void(0);\" class=\"on\">"+yearMonthList[num].month+"<span>月</span></a>";
// 		}else{
// 			html += "<a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"', '"+this.ppSeq+"', '"+this.ppName+"');\" class=\""+yearMonthList[num].engmonth+"\">"+yearMonthList[num].month+"<span>月</span></a>";
// 		}
		
		if(yearMonthList.length != num + 1){
			html += "<em>|</em>";
		}
	}
	
	html += "</div>";
	
	
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
	
	$(".selectArea.sizeS").empty();
	$(".selectArea.sizeS").append(html);
	
	$(".selectArea.local").parent().next().slideDown();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 날짜 선택 이벤트 */
function daySelect(day, krWeekDay) {
	
	this.day = day;
	this.krWeekDay = krWeekDay;
	
	$("a[name=detailDay]").each(function () {
		$(this).removeClass("active");
	});
	
	$("#detailDay"+day).addClass("active");
	
	/* step1 이전 다음 버튼 hide */
	$("#step1Btn").parents(".bizEduPlace").find(".btnWrap").show();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
}

/* step1Btn 닫기 버튼 클릭시 step1의 결과값 렌더링 */
function step1ResultRender() {
	var tempMonth  = this.month < 10 ? "0"+this.month : this.month;
	var tempDay  = this.day < 10 ? "0"+this.day : this.day;
	
	var html = this.ppName+"<em class=\"bar\">|</em>"+this.year+"-"+tempMonth+"-"+tempDay+" ("+this.krWeekDay+")";
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").empty();
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").append(html);
}

/* 문화체험 pp별, 날짜별 프로그램 목록 조회 */
function expCultureProgramListAjax() {
	
	var param = {
			  "year" : this.year
			, "month" : this.month < 10 ? "0" + this.month : this.month
			, "day" : this.day < 10 ? "0" + this.day : this.day
			, "ppseq" : this.ppSeq
			, "typeseq" : this.typeSeq
		};
		
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expCultureProgramListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var programList = data.expCultureProgramList;
			/* 프로그램 목록 생성 */
			programListRender(programList);
			
			/* STEP2로 이동 */
			var $pos = $("#pbContent > section.mWrap > div.bizEduPlace");
			var iframeTop = parent.$("#IframeComponent").offset().top
			parent.$('html, body').animate({
			    scrollTop:$pos.offset().top + iframeTop
			}, 300);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 프로그램 목록 생성 */
function programListRender(programList) {
	
	var html = "";

	var reservationDate = this.year + "" +  (this.month < 10 ? "0"+this.month : this.month) + "" + (this.day < 10 ? "0"+this.day : this.day);
	
	var expSeq = "";
	var expSessionSeq = ""
	var weekDay = programList[0].weekday;
	var renderFlag = true;
	var renderCnt = 0;
	for(var num in programList){
		if(expSessionSeq != programList[num].expsessionseq
				&& weekDay == programList[num].weekday){
// 			expSeq = programList[num].expseq;
			expSessionSeq = programList[num].expsessionseq;
			renderFlag = true;
			renderCnt = 0;
		}
		
// 		if(expSessionSeq == programList[num].expSessionSeq
// 			&& 1 == programList[num].standbynumber){
// 			renderFlag = false;
// 		}
		
// 		if(expSessionSeq == programList[num].expSessionSeq
// 			&& expSessionSeq != programList[num].expsessionseq){
// 			renderFlag = true;
// 		}
		
		if(renderFlag && renderCnt == 0){
			if(programList[num].standbynumber == 0){
				html += "<tr>"
					+ "<td class=\"vt\">"
					+ "<input type=\"checkbox\" id=\""+reservationDate+"_"+programList[num].expsessionseq+"\" name=\"programcheck\" onclick=\"javascript:programClick(this);\"/>"
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
					+ "<input type=\"hidden\" name=\"seatCount\" value=\""+programList[num].seatcount+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\">"
					+ "<a href=\"#none\" onclick=\"programContentOpen(this, '"+programList[num].expseq+"');\">"
					+ programList[num].productname
					+ "</a><br/><span class=\"prepare\"> 준비물 : "+programList[num].preparation+"</span>"
					+ "<span>체험시간 : "+programList[num].startdatetime.substring(0, 2)+":"+programList[num].startdatetime.substring(2, 4)+"</span>"
					+ "<span class=\"rText \">대기신청</span>"
					+ "</td>"
					+ "</tr>";
			}else if(programList[num].standbynumber == 1 || programList[num].adminfirstcode == 'R01'){
				html += "<tr>"
					+ "<td class=\"vt\">"
					+ "<input type=\"checkbox\" id=\""+reservationDate+"_"+programList[num].expsessionseq+"\" name=\"programcheck\" onclick=\"javascript:programClick(this);\" disabled/>"
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
					+ "<input type=\"hidden\" name=\"seatCount\" value=\""+programList[num].seatcount+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\">"
					+ "<a href=\"#none\" onclick=\"programContentOpen(this, '"+programList[num].expseq+"');\">"
					+ programList[num].productname
					+ "</a><br/><span class=\"prepare\"> 준비물 : "+programList[num].preparation+"</span>"
					+ "<span>체험시간 : "+programList[num].startdatetime.substring(0, 2)+":"+programList[num].startdatetime.substring(2, 4)+"</span>"
					+ "<span class=\"rText \">예약마감</span>"
					+ "</td>"
					+ "</tr>";
			}else{
				html += "<tr>"
					+ "<td class=\"vt\">"
					+ "<input type=\"checkbox\" id=\""+reservationDate+"_"+programList[num].expsessionseq+"\" name=\"programcheck\" onclick=\"javascript:programClick(this);\"/>"
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
					+ "<input type=\"hidden\" name=\"seatCount\" value=\""+programList[num].seatcount+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\">"
// 					+ "<a href=\"#none\" onclick='programContentOpen(this);'>"
					+ "<a href=\"#none\" onclick=\"programContentOpen(this, '"+programList[num].expseq+"');\">"
					+ programList[num].productname
					+ "</a><br/><span class=\"prepare\"> 준비물 : "+programList[num].preparation+"</span>"
					+ "<span>체험시간 : "+programList[num].startdatetime.substring(0, 2)+":"+programList[num].startdatetime.substring(2, 4)+"</span>"
					+ "<span class=\"rText able\">예약가능</span>"
					+ "</td>"
					+ "</tr>";
			}
			renderCnt++;
		}
	}
	
	$("#step2Btn").parents(".bizEduPlace").find("tbody").empty();
	$("#step2Btn").parents(".bizEduPlace").find("tbody").append(html);
	
	/* step1 이전 다음 버튼 hide */
	$("#step2Btn").parents(".bizEduPlace").find(".btnBasicBL").hide();
	
	/* move to top */
	var $pos = $("#pbContent");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 300);

	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 프로그램 체크 이벤트 */
function programClick(obj) {
	if($(obj).prop("checked")){
		/* 선택 */
		$(obj).parents("tr").addClass("select");
		$(obj).parents("tr").find(".prepare").show();
	}else{
		/* 선택취소 */
		$(obj).parents("tr").removeClass("select");
		$(obj).parents("tr").find(".prepare").hide();
	}
	
	/* 예약 요청 버튼 */
	var cnt = 0;
	$(obj).parents("tbody").find("input[name=programcheck]").each(function () {
		if($(this).prop("checked")){
			cnt++;
		}
	});
	if(cnt != 0 ){
		$("#step2Btn").parents(".bizEduPlace").find(".btnBasicBL").show();
	}else{
		$("#step2Btn").parents(".bizEduPlace").find(".btnBasicBL").hide();
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 선택된 프로그램 form태그에 정리 && 예약요청 layerPopup 태그 정리 */
function programCheck() {
	
	$("#checkLimitCount").empty();
	$("#cancellist").empty();
	
	/* move to top */
	var $pos = $("#pbContent");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 300);
	
	
	var layerHtml = "";
	var cnt = 0;
	$("#step2Btn").parents(".bizEduPlace").find("tbody tr").each(function () {
		if($(this).prop("class") == "select"){
				
			if(cnt == 0){
				var layerDate = $(this).find("input[name=reservationDate]").val().substring(0, 4) + "-" 
							+ $(this).find("input[name=reservationDate]").val().substring(4, 6) + "-" + 
							+ $(this).find("input[name=reservationDate]").val().substring(6, 8);
				$("#uiLayerPop_confirm").find(".tblResrConform thead tr th").empty();
				$("#uiLayerPop_confirm").find(".tblResrConform thead tr th").append($(this).find("input[name=ppName]").val()+" <em>|</em> "+layerDate+" ("+$(this).find("input[name=krWeekDay]").val()+")");
			}
			
			var seatCountHtml = "";
			seatCountHtml += "<option value=\"1\">없음</option>";
			seatCountHtml += "<option value=\"2\">있음</option>";
			
			layerHtml += "<tr>"
				       + "<th class=\"bdTop\">프로그램</th>"
				       + "<td class=\"bdTop\">"+$(this).find("input[name=productName]").val()+"</td>"
				       + "</tr>"
				       + "<tr>"
				       + "<th>체험시간</th>"
				       + "<td>"+$(this).find("input[name=startDateTime]").val().substring(0, 2)+":"+$(this).find("input[name=startDateTime]").val().substring(2, 4)+"</td>"
				       + "</tr>"
				       + "<tr>"
				       + "<th>동반자</th>"
				       + "<td><select name=\"tempVisitNumber\" title=\"참석인원\">"
				       + seatCountHtml
			           + "</select>"
				       + "<input type=\"hidden\" name=\"tempTypeSeq\" value=\""+$(this).find("input[name=typeSeq]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempPpSeq\" value=\""+$(this).find("input[name=ppSeq]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempPpName\" value=\""+$(this).find("input[name=ppName]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempExpSeq\" value=\""+$(this).find("input[name=expSeq]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempExpSessionSeq\" value=\""+$(this).find("input[name=expSessionSeq]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempReservationDate\" value=\""+$(this).find("input[name=reservationDate]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempStandByNumber\" value=\""+$(this).find("input[name=standByNumber]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempPaymentStatusCode\" value=\""+$(this).find("input[name=paymentStatusCode]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempProductName\" value=\""+$(this).find("input[name=productName]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempKrWeekDay\" value=\""+$(this).find("input[name=krWeekDay]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempStartDateTime\" value=\""+$(this).find("input[name=startDateTime]").val()+"\">"
				       + "<input type=\"hidden\" name=\"tempEndDateTime\" value=\""+$(this).find("input[name=endDateTime]").val()+"\">"
				       + "</td>"
			           + "</tr>";

			$("#checkLimitCount").append("<input type=\"hidden\" name =\"reservationDate\" value=\""+$(this).find("input[name=reservationDate]").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name =\"typeSeq\" value=\""+$(this).find("input[name=typeSeq]").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+$(this).find("input[name=expSeq]").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expSessionSeq\" value=\""+$(this).find("input[name=expSessionSeq]").val()+"\">");

			$("#cancellist").append("<input type=\"hidden\" name=\"reservationDate\" value=\""+$(this).find("input[name=reservationDate]").val()+"\">");
			$("#cancellist").append("<input type=\"hidden\" name=\"expSessionSeq\" value=\""+$(this).find("input[name=expSessionSeq]").val()+"\">");
			$("#cancellist").append("<input type=\"hidden\" name=\"standByNumber\" value=\""+$(this).find("input[name=standByNumber]").val()+"\">");

			cnt++;
		}
	});
	$("#uiLayerPop_confirm").find(".tblResrConform tbody").empty();
	$("#uiLayerPop_confirm").find(".tblResrConform tbody").append(layerHtml);
	$("#uiLayerPop_confirm").find(".tblResrConform tfoot tr td").empty();
	$("#uiLayerPop_confirm").find(".tblResrConform tfoot tr td").append("총 " + cnt + "건");
	
	/* 세션 선택이 없을 경우 step2의 달력을 오픈한다 */
	if(cnt == 0){
		alert("세션을 선택해 주십시오.");

		
		return false;

	}else{
		
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
	
	var param = $("#cancellist").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCultureDuplicateCheckAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var cancelDataList = data.cancelDataList;
			
			if(cancelDataList.length == 0){
				/* 예약정보 확인 팝업 */
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

/* 정상 예약 호출*/
function expCultureRsvRequestPop(){
	
	/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
// 	var param = $("#expHealthFormForPopup").serialize();
	
// 	$.ajaxCall({
// 		url: "<c:url value="/mobile/reservation/expHealthRsvRequestPopAjax.do"/>"
// 		, type : "POST"
// 		, data: param
// 		, success: function(data, textStatus, jqXHR){

// 		var expHealthRsvInfoList = data.expHealthRsvInfoList;
// 		var totalCnt = data.totalCnt;
// 		var partnerTypeCodeList = data.partnerTypeCodeList;
		
// 		setReservationReq(expHealthRsvInfoList, totalCnt, partnerTypeCodeList);
		
// 		},
// 		error: function( jqXHR, textStatus, errorThrown) {
// 			alert("처리도중 오류가 발생하였습니다.");
// 		}
// 	});
	/* 예약 확인 팝업 오픈 */
	layerPopupOpen("<a href=\"#uiLayerPop_confirm\"/>");
	
	<c:if test="${scrData.account ne ''}">
	$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:memberRsvInsert(this);");
	</c:if>
	
	rsvConfirmPop_resize();
	
}

/* 예약불가 알림 팝업(중복체크) */
function expCultureDisablePop(cancelDataList) {
	/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
	layerPopupOpen("<a href=\"#uiLayerPop_cannot\">");
	/* 중복 데이터 삭제 */
	var html = "";
	for(var num in cancelDataList){
		var standByNumber = "";
		if(cancelDataList[num].standbynumber == "1"){
			standByNumber = "(대기신청)";
		}
		html += "<span class=\"point1\">";
		html += cancelDataList[num].ppname + " <em>|</em> ";
		html += cancelDataList[num].programname + " <em>|</em> ";
		html += cancelDataList[num].reservationdate + " <em>|</em> ";
		html += cancelDataList[num].sessionname + standByNumber + "<br/>"
		html += "</span>";
		
		html += "<input type='hidden' name='cancelKey' value='" + cancelDataList[num].reservationdate + '_' + cancelDataList[num].expsessionseq + "'>";
		
	}
	$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").empty();
	$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").append(html);
}

/* 예약불가 팝업 확인 이벤트 */
function eduCultureDisabledConfirm(){
	
	var selectChoice = $("input:radio[name='resConfirm']:checked").val();
	
	if( selectChoice == "sessionSelect1"){
		
		/* 발견된 중복건수를 opener 페이지의 세션선택 상자에서 찾은 후 해제 시키는 기능 */
		$("#uiLayerPop_cannot input[type='hidden']").each(function(){
			$("#" + $(this).val()).prop("checked", false);
			$("#" + $(this).val()).parents("tr").removeClass("select");
		});
	
		/* 세션 갱신 후 재예약 요청 */
		programCheck();
		
	}
	
	cannotClosePop();
}

/* 레이어 팝업 닫기 */
function cannotClosePop(){
	$("#uiLayerPop_cannot").fadeOut();
// 	 $("#step2Btn").parents("dd").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 회원 문화체험 예약 */
function memberRsvInsert(obj) {
	
	/* 예약 등록 Ajax */
	expCultureRsvInsertAjax(obj);
	
	/* 레이어 팝업 close */
	$("#uiLayerPop_confirm").hide();
	$("#layerMask").hide();
}

/* 비회원 사용자 정보 확인 문화체험 예약 팝업 */
function expCultureNonMemberIdCheckPop(obj) {
	
	$(obj).removeAttr("onclick");
	
    $("#expCultureForm").attr('action', "<c:url value='/mobile/reservation/expCultureNonmemberIdCheckForm.do'/>");
    $("#expCultureForm").attr('method', 'post');
	$("#expCultureForm").append("<input type=\"hidden\" name=\"tempParentFlag\" value=\"date\">");
	$("#expCultureForm").submit();
	
	/* 예약 등록 Ajax */
// 	expCultureRsvInsertAjax();
	
	/* 레이어 팝업 close */
// 	$("#uiLayerPop_confirm").hide();
// 	$("#layerMask").hide();
	
// 	layerPopupOpen("<a href=\"#uiLayerPop_noneculture\">");
	
}

/* 예약 확정 */
function expCultureRsvInsertAjax(obj) {
	
	$(obj).removeAttr("onclick");
	
	var param = $("#expCultureForm").serialize();
		
	$.ajax({
		url: "<c:url value='/mobile/reservation/expCultureRsvInsertAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				$("#transactionTime").val(data.transactionTime);
				
				var completeList = data.expCultureCompleteList;
				
				$("#uiLayerPop_noneculture").hide();
				$("#layerMask").hide();
				
				/* step2 result */
				expCultureRsvComplete(completeList);
				/* 예약완료 화면  */
				$("#stepDone").show();
			}
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			$(obj).attr("onclick", "javascript:memberRsvInsert(this);");
		}
	});
}

/* 비회원 예약 확정 */
function expCultureNonMemberRsvInsertAjax() {
	
	/* 유효성 검사 */
	if($("#nonMember").val() == "" || $("#nonMember").val() == null){
		alert("이름을 입력해주세요");
		return;
	}
	if($("#nonMemberId1").val() == "" || $("#nonMemberId1").val() == null){
		alert("본인 인증번호를 입력해주세요");
		return;
	}
	if($("#nonMemberId2").val() == "" || $("#nonMemberId2").val() == null){
		alert("본인 인증번호를 입력해주세요");
		return;
	}
	if($("#nonMemberId3").val() == "" || $("#nonMemberId3").val() == null){
		alert("본인 인증번호를 입력해주세요");
		return;
	}
	
	
	var html = "<input type=\"hidden\" name=\"nonMember\" value=\""+$("#nonMember").val()+"\">"
				+ "<input type=\"hidden\" name=\"nonMemberId1\" value=\""+$("#nonMemberId1").val()+"\">"
				+ "<input type=\"hidden\" name=\"nonMemberId2\" value=\""+$("#nonMemberId2").val()+"\">"
				+ "<input type=\"hidden\" name=\"nonMemberId3\" value=\""+$("#nonMemberId3").val()+"\">"
	
	$("#expCultureForm").append(html);
	
	var param = $("#expCultureForm").serialize();
		
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expCultureRsvInsertAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				var completeList = data.expCultureCompleteList;
				/* step2 result */
				
				$("#uiLayerPop_noneculture").hide();
				$(".layerMask").remove();
				
				$('html, body').css({
					overflowX:'',
					overflowY:''
				});
				
				expCultureRsvComplete(completeList);
				/* 예약완료 화면  */
				$("#stepDone").show();
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 회원 예약 완료 후 호출 팝업 */
function expCultureRsvComplete(completeList) {
	
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap").children("span").empty();;
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap").children("span").append("총 " + completeList.length + "건");
	
	var html = "";
	
	var snsHtml = "[한국암웨이]시설/체험 예약내역 (총 "+completeList.length+"건) \n";
	
// 	console.log(completeList);
	
	for(var num in completeList){
		if(completeList[num].paymentStatusCode == 'P01'){
			html += "<span>"+completeList[num].productName+"<em class=\"bar\">|";
			html += "</em>"+completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4)+" (대기신청)<em class=\"bar\">|";
			html += "</em>참석인원 "+completeList[num].visitNumber+"명</span>";
				
			snsHtml += "■"+this.ppName+"("+completeList[num].productName+")";
			snsHtml += completeList[num].reservationDate.substring(0, 4) + "-" + completeList[num].reservationDate.substring(5, 7) + "-" + completeList[num].reservationDate.substring(8, 10) + "("+this.krWeekDay+") | \n"; 
			snsHtml += completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4) + "(대기신청) | \n" ;
			snsHtml += "참석인원" + completeList[num].visitNumber + "명 \n";
			
		}else{
			html += "<span>"+completeList[num].productName+"<em class=\"bar\">|";
			html += "</em>"+completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4)+"<em class=\"bar\">|";
			html += "</em>참석인원 "+completeList[num].visitNumber+"명</span>";
				
			snsHtml += "■"+this.ppName+"("+completeList[num].productName+")";
			snsHtml += completeList[num].reservationDate.substring(0, 4) + "-" + completeList[num].reservationDate.substring(5, 7) + "-" + completeList[num].reservationDate.substring(8, 10) + "("+this.krWeekDay+") | \n";
			snsHtml += completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4) + " | \n" ;
			snsHtml += "참석인원" + completeList[num].visitNumber + "명 \n";
		}
	}
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").empty();
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").append(html);
	
	
	$("#snsText").empty();
	$("#snsText").val(snsHtml);
	
	$("#step2Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
	$("#step2Btn").parents('.bizEduPlace').find('.result').show();
	$("#step2Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
}

/* 비회원 정보 기입 페이지 */
function expCultureNonmemberIdCheckForm(expCultureInfoList) {
	
	var url = "<c:url value='/reservation/expCultureNonmemberIdCheckForm.do'/>";
	
    var $form = $('<form></form>');
    $form.attr('action', url);
    $form.attr('method', 'post');
    $form.appendTo('body');
    
	/* 데이터 가공 */
	for(var num in expCultureInfoList){
		$form.append("<input type=\"hidden\" name=\"tempTypeSeq\" value=\""+expCultureInfoList[num].tempTypeSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempPpSeq\" value=\""+expCultureInfoList[num].tempPpSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempExpSeq\" value=\""+expCultureInfoList[num].tempExpSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempExpSessionSeq\" value=\""+expCultureInfoList[num].tempExpSessionSeq+"\">");
		$form.append("<input type=\"hidden\" name=\"tempReservationDate\" value=\""+expCultureInfoList[num].tempReservationDate+"\">");
		$form.append("<input type=\"hidden\" name=\"tempStandByNumber\" value=\""+expCultureInfoList[num].tempStandByNumber+"\">");
		$form.append("<input type=\"hidden\" name=\"tempPaymentStatusCode\" value=\""+expCultureInfoList[num].tempPaymentStatusCode+"\">");
		$form.append("<input type=\"hidden\" name=\"tempProductName\" value=\""+expCultureInfoList[num].tempProductName+"\">");
		$form.append("<input type=\"hidden\" name=\"tempStartDateTime\" value=\""+expCultureInfoList[num].tempStartDateTime+"\">");
		$form.append("<input type=\"hidden\" name=\"tempEndDateTime\" value=\""+expCultureInfoList[num].tempEndDateTime+"\">");
		$form.append("<input type=\"hidden\" name=\"tempVisitNumber\" value=\""+expCultureInfoList[num].tempVisitNumber+"\">");
		
	}

	$form.append("<input type=\"hidden\" name=\"tempParentFlag\" value=\"date\">");
	$form.submit();
}

/* 문화체험 소개 ajax */
function expCultureIntroduce() {
	
	var param = {"typeseq" : this.typeSeq};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expCultureIntroduceList.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var expCultureIntroduceList = data.expCultureIntroduceList;
			/* 문화체험 소개 렌더링 */
			expCultureIntroduceRender(expCultureIntroduceList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 문화체험 소개 렌더링 */
function expCultureIntroduceRender(expCultureIntroduceList) {
	var html = "";
	var tempHtml = "";
	var dateCnt = 0;
	
	var expSeq = "";
	for(var num in expCultureIntroduceList){
		if(expSeq != expCultureIntroduceList[num].expseq){
			expSeq = expCultureIntroduceList[num].expseq;
			
			/* 제목 세팅 */
			if(this.flag == "D" && this.tempExpseq == expCultureIntroduceList[num].expseq){
				tempHtml += "<dt class=\"active\" onclick=\"javascript:expCultureIntroduceClick(this);\"><a href=\"#none\">"
				+ expCultureIntroduceList[num].themename+"<br/><span class=\"subject\">["+this.ppName+"] "+expCultureIntroduceList[num].productname+"</span>"
				+ "<span class=\"btn\">내용보기</span>"
				+ "</a></dt>"
				+ "<dd class=\"active\">"
				+ "<section class=\"programInfoWrap\">"
				+ "<div class=\"programInfo\">"
				+ "<p>"+expCultureIntroduceList[num].intro+"</p>"
				+ "<p>"+expCultureIntroduceList[num].content+"</p>"
				+ "</div>"
				+ "<dl class=\"roomTbl\">"	
				+ "<dt><span class=\"bizIcon icon6\"></span>장소</dt>"	
				+ "<dd>"+this.ppName+"</dd>"	
				+ "<dt><span class=\"bizIcon icon7\"></span>일정</dt>"	
				+ "<dd>";
				
				/* 사용가능 일자 */
				var ymd = "";
				var expSessionSeq = "";
				var setTypeCode = "";
				var renderFlag = true;
				var renderCnt = 0;
				for(var i in expCultureIntroduceList){
					if(expSeq == expCultureIntroduceList[i].expseq){
						if(ymd != expCultureIntroduceList[i].ymd
							&& expSessionSeq != expCultureIntroduceList[i].expsessionseq){
							expSessionSeq = expCultureIntroduceList[i].expsessionseq;
							setTypeCode = expCultureIntroduceList[i].settypecode;
							renderFlag = true;
							renderCnt = 0;
						}
						
						if(setTypeCode != expCultureIntroduceList[i].settypecode
								|| 'R02' == expCultureIntroduceList[i].worktypecode
								|| 1 == expCultureIntroduceList[i].standbynumber){
							renderFlag = false;
						}
						
						if(renderFlag && renderCnt == 0){
							tempHtml += expCultureIntroduceList[i].month + "월"
								+ expCultureIntroduceList[i].day + "일"
								+ "(" + expCultureIntroduceList[i].krweekday + ") "
								+ expCultureIntroduceList[i].startdatetime.substring(0, 2)+ ":" + expCultureIntroduceList[i].startdatetime.substring(2, 4)
								+ "<br/>";
							renderCnt++;
							dateCnt++;
						}
						
					}
				}
				
			tempHtml += "</dd>"
				+ "<dt><span class=\"bizIcon icon1\"></span>인원</dt>"
				+ "<dd>"+expCultureIntroduceList[num].seatcount+"</dd>"
				+ "<dt><span class=\"bizIcon icon2\"></span>체험시간</dt>"
				+ "<dd>"+expCultureIntroduceList[num].usetime+"</dd>"
				+ "<dt><span class=\"bizIcon icon3\"></span>예약자격</dt>"
				+ "<dd>"+expCultureIntroduceList[num].role+"<br/><span class=\"fsS\">("+expCultureIntroduceList[num].rolenote+")</span></dd>"
				+ "<dt><span class=\"bizIcon icon5\"></span>준비물</dt>"
				+ "<dd>"+expCultureIntroduceList[num].preparation+"</dd>"
				+ "</dl>"
				+ "</section>"
				+ "</dd>";
				
			}else{
				tempHtml += "<dt onclick=\"javascript:expCultureIntroduceClick(this);\"><a href=\"#none\">"	
				+ expCultureIntroduceList[num].themename+"<br/><span class=\"subject\">["+this.ppName+"] "+expCultureIntroduceList[num].productname+"</span>"
				+ "<span class=\"btn\">내용보기</span>"
				+ "</a></dt>"
				+ "<dd>"
				+ "<section class=\"programInfoWrap\">"
				+ "<div class=\"programInfo\">"
				+ "<p>"+expCultureIntroduceList[num].intro+"</p>"
				+ "<p>"+expCultureIntroduceList[num].content+"</p>"
				+ "</div>"
				+ "<dl class=\"roomTbl\">"	
				+ "<dt><span class=\"bizIcon icon6\"></span>장소</dt>"	
				+ "<dd>"+this.ppName+"</dd>"	
				+ "<dt><span class=\"bizIcon icon7\"></span>일정</dt>"	
				+ "<dd>";
				
				/* 사용가능 일자 */
				var ymd = "";
				var expSessionSeq = "";
				var setTypeCode = "";
				var renderFlag = true;
				var renderCnt = 0;
				for(var i in expCultureIntroduceList){
					if(expSeq == expCultureIntroduceList[i].expseq){
						if(ymd != expCultureIntroduceList[i].ymd
							&& expSessionSeq != expCultureIntroduceList[i].expsessionseq){
							expSessionSeq = expCultureIntroduceList[i].expsessionseq;
							setTypeCode = expCultureIntroduceList[i].settypecode;
							renderFlag = true;
							renderCnt = 0;
						}
						
						if(setTypeCode != expCultureIntroduceList[i].settypecode
								|| 'R02' == expCultureIntroduceList[i].worktypecode
								|| 1 == expCultureIntroduceList[i].standbynumber){
							renderFlag = false;
						}
						
						if(renderFlag && renderCnt == 0){
							tempHtml += expCultureIntroduceList[i].month + "월"
								+ expCultureIntroduceList[i].day + "일"
								+ "(" + expCultureIntroduceList[i].krweekday + ") "
								+ expCultureIntroduceList[i].startdatetime.substring(0, 2)+ ":" + expCultureIntroduceList[i].startdatetime.substring(2, 4)
								+ "<br/>";
							renderCnt++;
							dateCnt++;
						}
						
					}
				}
				
			tempHtml += "</dd>"
				+ "<dt><span class=\"bizIcon icon1\"></span>인원</dt>"
				+ "<dd>"+expCultureIntroduceList[num].seatcount+"</dd>"
				+ "<dt><span class=\"bizIcon icon2\"></span>체험시간</dt>"
				+ "<dd>"+expCultureIntroduceList[num].usetime+"</dd>"
				+ "<dt><span class=\"bizIcon icon3\"></span>예약자격</dt>"
				+ "<dd>"+expCultureIntroduceList[num].role+"<br/><span class=\"fsS\">("+expCultureIntroduceList[num].rolenote+")</span></dd>"
				+ "<dt><span class=\"bizIcon icon5\"></span>준비물</dt>"
				+ "<dd>"+expCultureIntroduceList[num].preparation+"</dd>"
				+ "</dl>"
				+ "</section>"
				+ "</dd>";
			}
				

			if(dateCnt != 0){
				html += tempHtml;
				dateCnt = 0;
			}
			tempHtml = "";
		}
	}
	
	$("#uiLayerPop_culture").find(".programList").empty();
	$("#uiLayerPop_culture").find(".programList").append(html);
}

/* 문화체험 소개 선택 이벤트 */
function expCultureIntroduceClick(obj) {
	
	if($(obj).is(".active") == true){
		$(obj).removeClass("active");
		$(obj).next().removeClass("active");
	}else{
		$("#uiLayerPop_culture").find(".programList dt").each(function () {
			$(this).removeClass("active");
		});
		$("#uiLayerPop_culture").find(".programList dd").each(function () {
			$(this).removeClass("active");
		});
		
		$(obj).addClass("active");
		$(obj).next().addClass("active");
	}
	
}


/* ap 안내 */
function showApInfo(thisObj){
	layerPopupOpen(thisObj);

	abnkoreaApInfoPop_resize();
}

function closeApInfo(){
	$("#uiLayerPop_apInfo").hide();
	$("#layerMask").remove();
}

/* 레이어 팝업 닫기 */
function confirmClosePop(){
	$("#uiLayerPop_confirm").hide();
	 $("#step2Btn").parents("dd").show();
	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	 $("#layerMask").remove();
	 
		$('html, body').css({
			overflowX:'',
			overflowY:''
		});
}

/* 문화체험 소개 팝업 닫기 */
function cultureClosePop(){
	$("#uiLayerPop_culture").hide();
	$("#layerMask").remove();
	
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
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


function programContentOpen(obj, expseq){
	this.flag = "D";
	this.tempExpseq = expseq;
	
	expCultureIntroduce();
	
	layerPopupOpen("<a href='#uiLayerPop_culture' class='btnTbl'>체험예약 현황확인</a>");
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
}

function showExpRsvComfirmPop(){
	
	var tempYear = $("#getYearPop").val();
	var tempMonth = $("#getMonthPop").val();
	
	$("#getYearLayer").val($("#getYearPop").val()).attr("selected", "selected");
	$("#getMonthLayer").val($("#getMonthPop").val()).attr("selected", "selected");
	
	searchCalLayer();
	setToday();
	
// 	abnkoreaConfirmPop_resize();
	
	layerPopupOpen("<a href='#uiLayerPop_calender2' class='btnTbl'>체험예약 현황확인</a>");return false;
	
}

function expCultureIntroPop(){
	this.flag = "";
	layerPopupOpen("<a href='#uiLayerPop_culture' class='btnTbl'>체험예약 현황확인</a>");
	expCultureIntroduce();
}


/**
 * 이전 버튼 클릭시 화면 이동
 */
function backStep(destStep){
	
	if('1' == destStep ){

		/* move to step 1 */
		var $pos = $("#step1OpenSelectDiv");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
		
	}
		
}

</script>

		<input type="hidden" id="getMonthPop" name="getMonthPop">
		<input type="hidden" id="getYearPop" name="getYearPop">
		<input type="hidden" id="getDayPop" name="getDayPop">
		
<%-- 		<input type="hidden" id="pinvalue" value="${scrData.pinvalue}"> --%>
		
		<!-- content -->
		<section id="pbContent" class="bizroom">
		<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
		<form id="cancellist" name="cancellist" method="post"></form>
		<input type="hidden" id="transactionTime" />
		<input type="hidden" id="snsText" name="snsText">
		
			<section id="pbContent" class="bizroom">
			
			<section class="brIntro">
				<h2><a href="#uiToggle_01">문화체험 예약 필수 안내</a></h2>
				<div id="uiToggle_01" class="toggleDetail">
<!-- 					<p class="pTit">예약 안내</p> -->
<!-- 					<ul class="listDot"> -->
<!-- 						<li>5/10(화) 13시부터 선착순 마감(프로그램 1회 예약 시 어린이 1~2명 예약가능)</li> -->
<!-- 						<li>최대 2개 프로그램까지 예약 가능합니다. </li> -->
<!-- 					</ul> -->
<!-- 					<p class="pTit">패널티 프로그램 안내</p> -->
<!-- 					<p class="listDot point1">취소 없이 참여하지 않는 경우,  패널티가 적용되어 모든 문화체험 체험월의 익월까지 예약 불가합니다.</p> -->
<!-- 					<p class="tiptextR">2015년 9월1일 최종 업데이트 되었습니다.</p> -->
					<c:out value="${reservationInfo}" escapeXml="false" />
				</div>
			</section>
		
			<section class="mWrap">
				<ul class="tabDepth1 tNum2">
					<li class="on"><strong>날짜 먼저선택</strong></li>
					<li><a href="/mobile/reservation/expCultureProgramForm.do">프로그램 먼저선택</a></li>
				</ul>
				<div class="blankR">
<!-- 					<a href="#uiLayerPop_culture" id="expCultureIntroduceBtn" class="btnTbl" onclick="layerPopupOpen(this);return false;">문화체험 소개</a> -->
					<a href="#" id="expCultureIntroduceBtn" class="btnTbl" onclick="javascript:expCultureIntroPop();">문화체험 소개</a>
				</div>
				<!-- 스텝1 -->
				<div class="bizEduPlace" id="selectDay">
					<div class="result">
						<div class="tWrap">
							<em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 날짜</strong>
							<span>강서 AP<em class="bar">|</em>2016-05-21 (토)</span>
							<%/*<button class="bizIcon showHid">수정</button>*/ %>
						</div>
					</div>
					<!-- 펼쳤을 때 -->
					<div class="selectDiv">
						<dl class="selcWrap">
							<dt><div class="tWrap"><em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 날짜</strong><span>지역 선택 후 날짜를 선택하세요.</span></div></dt>
							<dd>
								<div class="hWrap">
									<p class="tit">지역 선택</p>
<!-- 									<a href="#none" class="btnTbl">AP안내</a> -->
									<a href="#uiLayerPop_apInfo" onclick="javascript:showApInfo(this); return false;" class="btnTbl uiApBtnOpen">
			<!-- 						<a href="#uiLayerPop_apInfo" onclick="javascript:showApInfo(this); return false;" class="btnTbl uiApBtnOpen"> -->
										<span>AP 안내</span>
									</a>
								</div>
								<div class="selectArea local">
								</div>
							</dd>
							<dd>
								<div class="hWrap">
									<p class="tit">날짜 선택</p>
									<c:if test="${scrData.pinvalue ne '-99'}">
										<a href="#" class="btnTbl" onclick="javascript:showExpRsvComfirmPop();">체험예약 현황확인</a>
									</c:if>
									<c:if test="${scrData.pinvalue eq '-99'}">
										<a href="/mobile/reservation/expInfoList.do" class="btnTbl">체험예약 현황확인</a>
									</c:if>
								</div>
								<div class="calenderHeader">
									<span class="year">2016</span>
									<span class="monthlyWrap">
										<a href="#none" class="on">5<span>月</span></a><em>|</em><a href="#none">6<span>月</span></a><em>|</em><a href="#none">7<span>月</span></a>
									</span>
								</div>
								<div class="selectArea sizeS">
									<a href="#none" class="active">5월 5일(목)</a><a href="#none">5월 5일(목)</a><a href="#none">5월 5일(목)</a><a href="#none">5월 5일(목)</a>
								</div>
								<div class="btnWrap">
									<a href="#none" id="step1Btn" class="btnBasicBL stepBtn">다음</a>
								</div>
							</dd>
						</dl>
					</div>
					<!-- //펼쳤을 때 -->
				</div>
				<!-- 스텝2 -->
				<div class="bizEduPlace">
					<div class="result">
						<div class="tWrap">
							<em class="bizIcon step04"></em><strong class="step">STEP2/ 프로그램</strong>
							<span>총2건</span>
							<div class="resultDetail">
								<span>가족이 대를 잇는 추억놀이<em class="bar">|</em>14:00<em class="bar">|</em>참석인원 1명</span>
								<span>신나는 ABC 마술쇼<em class="bar">|</em>14:00(대기신청)<em class="bar">|</em>참석인원 1명</span>
							</div>
							<%/*<button class="bizIcon showHid">수정</button>*/%>
						</div>
					</div>
					<!-- 펼쳤을 때 -->
					<div class="selectDiv">
						<dl class="selcWrap">
							<dt><div class="tWrap"><em class="bizIcon step04"></em><strong class="step">STEP2/ 프로그램</strong><span>프로그램을 선택해 주세요.</span></div></dt>
							<dd>
								<div class="tblWrap">
									<table class="tblSession">
										<caption>프로그램 선택</caption>
										<colgroup>
											<col width="5%" />
											<col width="auto" />
										</colgroup>
										<tbody>
											<tr class="select">
												<td class="vt"><input type="checkbox" id="" name="programcheck" checked /></td>
												<td class="programTitle"><a href="#none">우리아이 식생활 변화 프로젝트2 (두뇌 성장)</a><br/>
													<span class="prepare" style="display:block">준비물 : 노트북</span>
													<span>체험시간 : 14:00</span>
													<span class="rText able">예약가능</span>
												</td>
											</tr>
											<tr>
												<td class="vt"><input type="checkbox" id="" name="programcheck" /></td>
												<td class="programTitle"><a href="#none">신나는 ABC 마술쇼~!!</a><br/>
													<span class="prepare">준비물 : 노트북</span>
													<span>체험시간 : 14:00</span>
													<span class="rText ">대기신청</span>
												</td>
											</tr>
										</tbody>
									</table>
									<p class="listWarning">※ 취소 없이 참여하지 않는 경우,  패널티가 적용되어 모든 문화체험 체험월의 익월까지 예약 불가합니다.</p>
									
								</div>
								<div class="btnWrap aNumb2">
									<a href="#none" class="btnBasicGL">이전</a>
<!-- 									<a href="#uiLayerPop_confirm" id="step2Btn" class="btnBasicBL">예약요청</a> -->
									<a href="#" id="step2Btn" class="btnBasicBL">예약요청</a>
								</div>
							</dd>
						</dl>
					</div>
					<!-- //펼쳤을 때 -->
				</div>
				
				<!-- 예약완료 -->
				<div class="stepDone selcWrap" id="stepDone">
					<div class="doneText"><strong class="point1">예약</strong><strong class="point3">이 완료 되었습니다.</strong><br/>
					이용해 주셔서 감사합니다.</div>
					
					<div class="detailSns">
						<a href="#none" id="snsKt" onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"  title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
						<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
						<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');"       title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
						<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');"   title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
					</div>
					<span class="doneText">예약내역공유</span>
		
					<div class="btnWrap aNumb2">
						<a href="/mobile/reservation/expCultureForm.do" class="btnBasicGL">예약계속하기</a>
						<a href="/mobile/reservation/expInfoList.do" class="btnBasicBL">예약현황확인</a>
					</div>
				</div>
				<!-- //예약완료 -->
			</section>

			<!-- layer popoup -->
			
			<!-- 예약 및 결제정보 확인 -->
			<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_confirm">
			<form id="expCultureForm" name="expCultureForm" method="post">
				<div class="pbLayerHeader">
					<strong>예약정보 확인</strong>
				</div>
				<div class="pbLayerContent">
				
					<table class="tblResrConform">
						<colgroup><col width="30%" /><col width="70%" /></colgroup>
						<thead>
							<tr><th scope="col" colspan="2">강서 AP <em>|</em> 2016-05-05 (토)</th></tr>
						</thead>
						<tfoot>
							<tr>
								<td colspan="2">총 2건</td>
							</tr>
						</tfoot>
						<tbody>
							<tr>
								<th class="bdTop">프로그램</th>
								<td class="bdTop">가족이 대를 잇는 추억놀이</td>
							</tr>
							<tr>
								<th>체험시간</th>
								<td>14:00</td>
							</tr>
							<tr>
								<th>참석인원1</th>
								<td><select title="참석인원">
									<option>1명</option>
									<option>2명</option>
								</select></td>
							</tr>
							<tr>
								<th class="bdTop">프로그램</th>
								<td class="bdTop">신나는 ABC 마술쇼~!!</td>
							</tr>
							<tr>
								<th>체험시간</th>
								<td>15:00 (대기신청)</td>
							</tr>
							<tr>
								<th>참석인원2</th>
								<td><select title="참석인원">
									<option>1명</option>
									<option>2명</option>
								</select></td>
							</tr>
						</tbody>
					</table>
					
					
					<c:if test="${scrData.account ne ''}">
					<div class="grayBox">
						위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>
						<span class="point3">[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</span>
					</div>
					<div class="btnWrap aNumb2">
						<span><a href="#" class="btnBasicGL" onclick="javascript:confirmClosePop();">예약취소</a></span>
						<span><a href="#" class="btnBasicBL">예약확정</a></span>
					</div>
					</c:if>
					<c:if test="${scrData.account eq ''}">
					<div class="btnWrap aNumb2">
						<span><a href="#" class="btnBasicGL" onclick="javascript:confirmClosePop();">예약취소</a></span>
<!-- 					</div> -->
<!-- 					<div class="btnWrap bNumb1"> -->
						<span><a href="#" class="btnBasicBL" onclick="javascript:expCultureNonMemberIdCheckPop(this);">다음</a></span>
					</div>
					</c:if>

				</div>
				<a href="#none" class="btnPopClose" onclick="javascript:confirmClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</form>
			</div>
			<!-- //예약 및 결제정보 확인 -->
	
			<!-- 문화체험 소개 -->
			<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_culture">
				<div class="pbLayerHeader">
					<strong>문화체험 소개</strong>
				</div>
				<div class="pbLayerContent">
					<dl class="programList" id="culture">
					</dl>
					<div class="btnWrap bNumb1">
						<a href="#" class="btnBasicGL" onclick="javascript:cultureClosePop();">닫기</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose" onclick="javascript:cultureClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //문화체험 소개 -->
			
			<!-- 비회원 문화체험 신청자 확인 -->
			<div class="pbLayerPopup" id="uiLayerPop_noneculture">
				<div class="pbLayerHeader">
					<strong>신청자 확인</strong>
				</div>
				<div class="pbLayerContent">
					
					<p>이름과 연락처를 입력하시면 나의 문화체험 예약내역 확인이 가능합니다.</p>
					
					<table class="tblCredit">
						<colgroup><col width="80px"><col width="auto"></colgroup>
						<tbody>
							<tr>
								<th scope="row" class="bdTop">이름</th>
								<td class="bdTop"><input type="text" id="nonMember" title="이름" /></td>
							</tr>
							<tr>
								<th scope="row">휴대폰번호</th>
								<td>
									<select id="nonMemberId1" title="휴대폰 식별번호 선택" style="width:50px">
										<option value="010" selected="selected">010</option>
										<option value="011">011</option>
										<option value="016">016</option>
										<option value="017">017</option>
										<option value="018">018</option>
										<option value="019">019</option>
										<option value="0130">0130</option>
									</select> -
									<input type="text" id="nonMemberId2"  title="휴대폰가운데번호" style="width:50px" /> -
									<input type="text" id="nonMemberId3"  title="휴대폰뒷번호" style="width:50px" />
								</td>
							</tr>
						</tbody>
					</table>
				
					<div class="btnWrap bNumb1">
						<a href="#" class="btnBasicBL" onclick="javascript:expCultureNonMemberRsvInsertAjax();">확인</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //비회원 문화체험 신청자 확인 -->
			
					
		<!-- 예약불가 알림 -->
		<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_cannot">
			<div class="pbLayerHeader">
				<strong>예약불가 알림</strong>
			</div>
			<div class="pbLayerContent">
			
				<div class="cancelWrap">
					예약 진행 중 다른 사용자가 실시간으로 <br/>아래 예약건을 이미 완료하였습니다.
					<div class="bdBox textL">
						<!--  강서 AP <em>|</em> 비전센타 1 <em>|</em> 2016-05-25 (수) <em>|</em> Session 2 (14:00~17:00)
						<strong>예약불가 항목 : </strong>
						 -->
						<span class="point1"></span>
					</div>
				</div>
				<div class="radioList">
					<span><input type="radio" id="sessionSelect1" name="resConfirm" value="sessionSelect1" checked="checked"/><label for="sessionSelect1">예약불가 세션 제외 후 결제 진행</label></span>
					<span><input type="radio" id="sessionSelect2" name="resConfirm" value="sessionSelect2" /><label for="sessionSelect2">날짜 및 세션 다시 선택 후 진행</label></span>
				</div>
				<div class="btnWrap bNumb1">
					<a href="#" class="btnBasicBL" onclick="javascript:eduCultureDisabledConfirm();">확인</a>
				</div>
			</div>
			<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
		<!-- //예약불가 알림 -->
		
			<!-- ap안내 -->
			<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/apInfoPop.jsp" %>
			<!-- //layer popoup -->
			
			<!-- //예약 및 결제정보 확인 -->
			<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expRsvConfirmPop.jsp" %>
			
		</section>
		<!-- //content -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/mobile/footer.jsp" %>
