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

var getYearPop = "";
var getMonthPop = "";
var getDayPop = "";
$(document).ready(function () {
	
	/* step1 다음 버튼 hide */
	$("#step1Btn").parents(".bizEduPlace").find(".btnWrap").hide();
	
	setPpInfoList();
	
	$("#stepDone").hide();
	
	/* step1 다음 버튼 클릭 */
	$("#step1Btn").on("click", function(){
			
		/* step1 result 렌더링 */
		step1ResultRender();
			
		/* typeSeq, ppSeq, year, month, day 에 해당하는 프로그램 목록 조회 */
		expCultureSessionListAjax();
			
	});
	
	/* step2 예약 요청 버튼 클릭 */
	$("#step2Btn").on("click", function(){
		/* 체크된 프로그램 데이터 form태그에 정리 */
		sessionCheck();
	});
	
	$("#expCultureIntroduceBtn").on("click", function () {
		expCultureIntroduce();
	});
	
	/* 예약계속하기} */
// 	$(".btnBasicGL").on("click", function(){
// 		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expCultureProgramForm.do'/>";
// 	});
	
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
					html += "<a href='javascript:void(0);' class = 'active' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:expCulturePpProgramListAjax('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', 'click');\">"+ppList[i].ppname+"</a>";
					expCulturePpProgramListAjax(ppList[i].ppseq, ppList[i].ppname, "load");
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:expCulturePpProgramListAjax('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', 'click');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$(".selectArea.local").empty();
			$(".selectArea.local").append(html);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 pp 프로그램 정보 조회 */
function expCulturePpProgramListAjax(ppSeq, ppName, flag){
		
	/* step1 이전 다음 버튼 hide */
	$("#step1Btn").parents(".btnWrap").hide();
	
	$(".selectArea.local").parent().next().hide();
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$("a[name=detailPpSeq]").each(function () {
		$(this).removeClass("active");
	});
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+ppSeq).addClass("active");
	
	this.ppSeq = ppSeq;
	this.ppName = ppName;
	
	var param = {
		  "ppseq" : this.ppSeq
		, "typeseq" : this.typeSeq
	};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expCulturePpProgramListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 해당 pp 프로그램 목록 */
			var ppProgramList = data.expCulturePpProgramList;
			
			programRender(ppProgramList);
			
			/* 프로그램 선택 목록으로 이동 */
			var $pos = $("#selectProgram");
			var iframeTop = parent.$("#IframeComponent").offset().top;
			if(flag == "click") {
				parent.$('html, body').animate({
					scrollTop: $pos.offset().top + iframeTop
				}, 300);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 프로그램 목록 렌더링 */
function programRender(ppProgramList) {
	var html = "";
	var tempHtml = "";
	var dateCnt = 0;
	
	var expSeq = "";
	for(var num in ppProgramList){
		if(expSeq != ppProgramList[num].expseq){
			expSeq = ppProgramList[num].expseq;
			
			/* 제목 세팅 */
			if(html == ""){
				tempHtml += "<tr>"
					+ "<td class=\"vt\">"
					+ "<input type=\"checkbox\" id=\"\" name=\"programCheck\" onclick=\"javascript:programCheck(this);\"/>"
					+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+expSeq+"\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+ppProgramList[num].productname+"\">"
					+ "<input type=\"hidden\" name=\"preparation\" value=\""+ppProgramList[num].preparation+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\"><a href=\"#none\" onclick=\"programContentOpen(this);\">"+ppProgramList[num].productname+"</a><br/>"
					+ "<span class=\"prepare\"> 준비물 : "+ppProgramList[num].preparation+"</span>";
					if(!isNull(ppProgramList[num].startdatetime)) tempHtml += "<span>"+ppProgramList[num].startdatetime.substring(0, 2)+":"+ppProgramList[num].startdatetime.substring(2, 4)+"</span>";
					tempHtml += "</td>"
					+ "</tr>"
					+ "<tr class=\"programDetailTr\" style=\"display: table-row;\">"
					+ "<td colspan=\"2\">"
					+ "<section class=\"programInfoWrap\">"
					+ "<div class=\"programInfo\">"
					+ "<p>"+ppProgramList[num].intro+"</p>"
					+ "<p>"+ppProgramList[num].content+"</p>"
					+ "</div>"
					+ "<dl class=\"roomTbl\">"	
					+ "<dt><span class=\"bizIcon icon6\"></span>장소</dt>"	
					+ "<dd>"+this.ppName+"</dd>"	
					+ "<dt><span class=\"bizIcon icon7\"></span>일정</dt>"	
					+ "<dd>";
					
					/* 사용가능 일자 */
					var ymd = "";
					var weekDay = "";
					var expSessionSeq = "";
					var setTypeCode = "";
					var renderFlag = true;
					var renderCnt = 0;
					
					for(var i in ppProgramList){
						
						if(expSeq == ppProgramList[i].expseq && !isNull(ppProgramList[i].startdatetime)){
							/* 날짜가 다르면 */
							if(ymd != ppProgramList[i].ymd){
								weekDay = ppProgramList[i].weekday;
							}
							if(ymd != ppProgramList[i].ymd
								|| expSessionSeq != ppProgramList[i].expsessionseq){
								ymd = ppProgramList[i].ymd;
								expSessionSeq = ppProgramList[i].expsessionseq;
								setTypeCode = ppProgramList[i].settypecode;
								renderFlag = true;
								renderCnt = 0;
							}
							if(setTypeCode != ppProgramList[i].settypecode
									|| 'R02' == ppProgramList[i].worktypecode
									|| 1 == ppProgramList[i].standbynumber
									|| 'R01' == ppProgramList[i].adminfirstcode
									|| weekDay != ppProgramList[i].weekday){
								renderFlag = false;
							}
							if(renderFlag && renderCnt == 0){
								tempHtml += ppProgramList[i].month + "월"
									+ ppProgramList[i].day + "일"
									+ "(" + ppProgramList[i].krweekday + ") ";
									+ ppProgramList[i].startdatetime.substring(0, 2) + ":" + ppProgramList[i].startdatetime.substring(2, 4)
									+ "<br/>";
								renderCnt++;
								dateCnt++;
							}
							
						}
					}
				
				tempHtml += "</dd>"
					+ "<dt><span class=\"bizIcon icon1\"></span>인원</dt>"	
					+ "<dd>"+ppProgramList[num].seatcount+"</dd>"	
					+ "<dt><span class=\"bizIcon icon2\"></span>체험시간</dt>"	
					+ "<dd>"+ppProgramList[num].usetime+"</dd>"	
					+ "<dt><span class=\"bizIcon icon3\"></span>예약자격</dt>"	
					+ "<dd>"+ppProgramList[num].role+"<br/><span class=\"fsS\">("+ppProgramList[num].rolenote+")</span></dd>"	
					+ "<dt><span class=\"bizIcon icon5\"></span>준비물</dt>"	
					+ "<dd>"+ppProgramList[num].preparation+"</dd>"	
					+ "</dl>"
					+ "</section>"
					+ "</td>"
					+ "</tr>";	
			}else{
				tempHtml += "<tr>"
					+ "<td class=\"vt\">"
					+ "<input type=\"checkbox\" id=\"\" name=\"programCheck\" onclick=\"javascript:programCheck(this);\"/>"
					+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+expSeq+"\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+ppProgramList[num].productname+"\">"
					+ "<input type=\"hidden\" name=\"preparation\" value=\""+ppProgramList[num].preparation+"\">"
					+ "</td>"
					+ "<td class=\"programTitle\"><a href=\"#none\" onclick=\"programContentOpen(this);\">"+ppProgramList[num].productname+"</a><br/>"
					+ "<span class=\"prepare\" style=\"display:none\"> 준비물 : "+ppProgramList[num].preparation+"</span>";
					if(!isNull(ppProgramList[num].startdatetime)) tempHtml += "<span>"+ppProgramList[num].startdatetime.substring(0, 2)+":"+ppProgramList[num].startdatetime.substring(2, 4)+"</span>";
					tempHtml += "</td>"
					+ "</tr>"
					+ "<tr class=\"programDetailTr\">"
					+ "<td colspan=\"2\">"
					+ "<section class=\"programInfoWrap\">"
					+ "<div class=\"programInfo\">"
					+ "<p>"+ppProgramList[num].intro+"</p>"
					+ "<p>"+ppProgramList[num].content+"</p>"
					+ "</div>"
					
					+ "<dl class=\"roomTbl\">"	
					+ "<dt><span class=\"bizIcon icon6\"></span>장소</dt>"	
					+ "<dd>"+this.ppName+"</dd>"	
					+ "<dt><span class=\"bizIcon icon7\"></span>일정</dt>"	
					+ "<dd>";
					
					/* 사용가능 일자 */
					var ymd = "";
					var weekDay = "";
					var expSessionSeq = "";
					var setTypeCode = "";
					var renderFlag = true;
					var renderCnt = 0;
					for(var i in ppProgramList){
						if(expSeq == ppProgramList[i].expseq && !isNull(ppProgramList[i].startdatetime)){
							if(ymd != ppProgramList[i].ymd){
								weekDay = ppProgramList[i].weekday;
							}
							if(ymd != ppProgramList[i].ymd
									|| expSessionSeq != ppProgramList[i].expsessionseq){
								ymd = ppProgramList[i].ymd;
								expSessionSeq = ppProgramList[i].expsessionseq;
								setTypeCode = ppProgramList[i].settypecode;
								renderFlag = true;
								renderCnt = 0;
							}
							
							if(setTypeCode != ppProgramList[i].settypecode
									|| 'R02' == ppProgramList[i].worktypecode
									|| 1 == ppProgramList[i].standbynumber
									|| weekDay != ppProgramList[i].weekday){
								renderFlag = false;
							}
							
							if(renderFlag && renderCnt == 0){
								tempHtml += ppProgramList[i].month + "월"
									+ ppProgramList[i].day + "일"
									+ "(" + ppProgramList[i].krweekday + ") "
									+ ppProgramList[i].startdatetime.substring(0, 2) + ":" + ppProgramList[i].startdatetime.substring(2, 4)
									+ "<br/>";
								renderCnt++;
								dateCnt++;
							}
							
						}
					}
					
					tempHtml += "</dd>"
						+ "<dt><span class=\"bizIcon icon1\"></span>인원</dt>"	
						+ "<dd>"+ppProgramList[num].seatcount+"</dd>"	
						+ "<dt><span class=\"bizIcon icon2\"></span>체험시간</dt>"	
						+ "<dd>"+ppProgramList[num].usetime+"</dd>"	
						+ "<dt><span class=\"bizIcon icon3\"></span>예약자격</dt>"	
						+ "<dd>"+ppProgramList[num].role+"<br/><span class=\"fsS\">("+ppProgramList[num].rolenote+")</span></dd>"	
						+ "<dt><span class=\"bizIcon icon5\"></span>준비물</dt>"	
						+ "<dd>"+ppProgramList[num].preparation+"</dd>"	
						+ "</dl>"
						+ "</section>"
						+ "</td>"
						+ "</tr>";	
			}
			if(dateCnt != 0){
				html += tempHtml;
				dateCnt = 0;
			}
			tempHtml = "";
		}
	}
	
	$("#step1Btn").parents(".bizEduPlace").find(".bdtNone .tblWrap table tbody").empty();
	$("#step1Btn").parents(".bizEduPlace").find(".bdtNone .tblWrap table tbody").append(html);
	
	$(".selectArea.local").parent().next().slideDown();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
}

/* 프로그램 체크박스 선택 이벤트 */
function programCheck(obj) {
	if($(obj).prop("checked")){
		$(obj).parents("tr").addClass("select");
		$(obj).parents("tr").find(".prepare").show();
	}else{
		$(obj).parents("tr").removeClass("select");
		$(obj).parents("tr").find(".prepare").hide();
	}
	
	var cnt = 0;
	$(obj).parents("tbody").find("tr").each(function () {
		if($(this).hasClass("select")){
			cnt++;
		}
	});
	if(cnt != 0){
		$("#step1Btn").parents(".btnWrap").show();
	}else{
		$("#step1Btn").parents(".btnWrap").hide();
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 프로그램 상세보기 */
function programContentOpen(obj) {
	
	if($(obj).parents("tr").next().css("display") == "table-row"){
		$(obj).parents("tr").next().css("display", "none");
	}else{
		$(".programDetailTr").each(function () {
			$(this).css("display", "none");
		});
		
		$(obj).parents("tr").next().css("display", "table-row");
		
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}



/* step1Btn 닫기 버튼 클릭시 step1의 결과값 렌더링 */
function step1ResultRender() {
	var html = "";
	var cnt = 0;
	$("input[name=programCheck]").each(function () {
		if($(this).prop("checked")){
			html += "<span>"+ppName+"<em class=\"bar\">|</em>"+$(this).parents("tr").find("input[name=productName]").val()+"<em class=\"bar\">|</em>준비물 : "+$(this).parents("tr").find("input[name=preparation]").val()+"</span>";
			cnt++;
		}
	});
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").empty();
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").append("총 " + cnt + "건");
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > .resultDetail").empty();
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > .resultDetail").append(html);
	
}

/* 해당 pp별 프로그램별 예약 가능 세션 정보 조회 */
function expCultureSessionListAjax(){
		
	/* 선택된 프로그램 정보를 배열로 요청 */
	var expSeqArr = ["NULL"];
	$("input[name=programCheck]").each(function () {
		if($(this).prop("checked")){
			expSeqArr.push($(this).parents("tr").find("input[name=expSeq]").val());
		}
	});
	
	var param = {
		  "ppseq" : this.ppSeq
		, "typeseq" : this.typeSeq
		, "expseqarr" : expSeqArr
	};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCultureSessionListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 해당 pp 프로그램 목록 */
			var sessionList = data.expCultureSessionList;
			sessionRender(sessionList);
			
			/* 날짜 선택 목록으로 이동 */
			var $pos = $("#selectStepTwo");
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

/* 세션 정보 렌더링 */
function sessionRender(sessionList) {
	var html = "";
	
	var expSeq = "";
	for(var num in sessionList){
		if(expSeq != sessionList[num].expseq){
			expSeq = sessionList[num].expseq;
			
			/* 제목 세팅 */
			html += "<p class=\"prgtitle\">"+this.ppName+" <em>|</em> "+sessionList[num].productname+"</p>"
			
			/* 누적 예약 가능 횟수 조회 */
			html += getRsvAvailabilityCount(expSeq);
			
			html += "<div class=\"selectArea sizeM\">";
			
			/* 사용가능 일자 */
			var ymd = "";
			var weekDay = "";
			var expSessionSeq = "";
			var setTypeCode = "";
			var renderFlag = true;
			var renderCnt = 0;
			for(var i in sessionList){
				if(expSeq == sessionList[i].expseq){
					if(ymd != sessionList[i].ymd){
						weekDay = sessionList[i].weekday;
					}
					if(ymd != sessionList[i].ymd
							|| expSessionSeq != sessionList[i].expsessionseq){
						ymd = sessionList[i].ymd;
						expSessionSeq = sessionList[i].expsessionseq;
						setTypeCode = sessionList[i].settypecode;
						renderFlag = true;
						renderCnt = 0;
					}
					
					if(setTypeCode != sessionList[i].settypecode
						|| 'S02' == sessionList[i].worktypecode
						|| 1 == sessionList[i].standbynumber
						|| 'R01' == sessionList[i].adminfirstcode
						|| weekDay != sessionList[i].weekday){
						renderFlag = false;
					}
					
					if(renderFlag && renderCnt == 0){
						if(sessionList[i].standbynumber == 0){
							/* 해당세션에 예약자가 있는경우 예약대기 */
							html += "<a href=\"javascript:void(0);\" id=\""+sessionList[i].ymd+"_"+sessionList[i].expsessionseq+"\" onclick=\"javascript:sessionClick(this);\">"
								+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
								+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
								+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
								+ "<input type=\"hidden\" name=\"expSeq\" value=\""+sessionList[i].expseq+"\">"
								+ "<input type=\"hidden\" name=\"reservationDate\" value=\""+sessionList[i].ymd+"\">"
								+ "<input type=\"hidden\" name=\"krWeekDay\" value=\""+sessionList[i].krweekday+"\">"
								+ "<input type=\"hidden\" name=\"startDateTime\" value=\""+sessionList[i].startdatetime+"\">"
								+ "<input type=\"hidden\" name=\"endDateTime\" value=\""+sessionList[i].enddatetime+"\">"
								+ "<input type=\"hidden\" name=\"productName\" value=\""+sessionList[i].productname+"\">"
								+ "<input type=\"hidden\" name=\"expSessionSeq\" value=\""+sessionList[i].expsessionseq+"\">"
								+ "<input type=\"hidden\" name=\"standByNumber\" value=\""+1+"\">"
								+ "<input type=\"hidden\" name=\"paymentStatusCode\" value=\"P01\">"
								+ "<input type=\"hidden\" name=\"seatCount\" value=\""+sessionList[i].seatcount+"\">"
								+ sessionList[i].ymd.substring(0, 4)+"년 "
								+ sessionList[i].ymd.substring(4, 6)+"월 "
								+ sessionList[i].ymd.substring(6, 8)+"일 ("
								+ sessionList[i].krweekday+")<br/>"
								+ sessionList[i].startdatetime.substring(0, 2)+":"+sessionList[i].startdatetime.substring(2, 4)+" (대기신청)</a>";
						}else{
							/* 해당세션에 예약자가 없는경우 정상 예약 */
							html +="<a href=\"javascript:void(0);\" id=\""+sessionList[i].ymd+"_"+sessionList[i].expsessionseq+"\" onclick=\"javascript:sessionClick(this);\">"
								+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
								+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
								+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
								+ "<input type=\"hidden\" name=\"expSeq\" value=\""+sessionList[i].expseq+"\">"
								+ "<input type=\"hidden\" name=\"reservationDate\" value=\""+sessionList[i].ymd+"\">"
								+ "<input type=\"hidden\" name=\"krWeekDay\" value=\""+sessionList[i].krweekday+"\">"
								+ "<input type=\"hidden\" name=\"startDateTime\" value=\""+sessionList[i].startdatetime+"\">"
								+ "<input type=\"hidden\" name=\"endDateTime\" value=\""+sessionList[i].enddatetime+"\">"
								+ "<input type=\"hidden\" name=\"productName\" value=\""+sessionList[i].productname+"\">"
								+ "<input type=\"hidden\" name=\"expSessionSeq\" value=\""+sessionList[i].expsessionseq+"\">"
								+ "<input type=\"hidden\" name=\"standByNumber\" value=\""+0+"\">"
								+ "<input type=\"hidden\" name=\"paymentStatusCode\" value=\"P02\">"
								+ "<input type=\"hidden\" name=\"seatCount\" value=\""+sessionList[i].seatcount+"\">"
								+ sessionList[i].ymd.substring(0, 4)+"년 "
								+ sessionList[i].ymd.substring(4, 6)+"월 "
								+ sessionList[i].ymd.substring(6, 8)+"일 ("
								+ sessionList[i].krweekday+")<br/>"
								+ sessionList[i].startdatetime.substring(0, 2)+":"+sessionList[i].startdatetime.substring(2, 4)+"</a>";
						}
						renderCnt++;
					}
				}
			}
			html += "</div>"
		}
	}
	
	$("#step2Btn").parents(".bizEduPlace").find(".dateSelectWrap").empty();
	$("#step2Btn").parents(".bizEduPlace").find(".dateSelectWrap").append(html);
	
	$("#step2Btn").hide();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 누적 예약 가능 횟수 (월, 주, 일) 조회 */
function getRsvAvailabilityCount(expSeq) {
	var param = {
			  ppseq : ppSeq
			, typeseq : typeSeq
			, expseq : expSeq
		};

	var html = "";
	
	$.ajaxCall({
		url: "<c:url value='/reservation/getRsvAvailabilityCountAjax.do'/>"
		, type : "POST"
		, data : param
		, async : false
		, success: function(data, textStatus, jqXHR){
			var getRsvAvailabilityCount = data.getRsvAvailabilityCount;
			
			var cnt = 0;
			
			var tempHtml = "<div class=\"hText\">"
				+ "<span>";
			
			if(null != getRsvAvailabilityCount){
				if(null != getRsvAvailabilityCount.ppdailycount
						&& null != getRsvAvailabilityCount.globaldailycount){
					var dailyCount = getRsvAvailabilityCount.ppdailycount > getRsvAvailabilityCount.globaldailycount ? getRsvAvailabilityCount.globaldailycount : getRsvAvailabilityCount.ppdailycount;
					tempHtml += "일 <strong>" + dailyCount + "</strong>회 ";
					cnt++;
				}else if(null == getRsvAvailabilityCount.ppdailycount
						&& null != getRsvAvailabilityCount.globaldailycount){
					tempHtml += "일 <strong>" + getRsvAvailabilityCount.globaldailycount + "</strong>회 ";
					cnt++;
				}else if(null != getRsvAvailabilityCount.ppdailycount
						&& null == getRsvAvailabilityCount.globaldailycount){
					tempHtml += "일 <strong>" + getRsvAvailabilityCount.ppdailycount + "</strong>회 ";
					cnt++;
				}
				
				if(null != getRsvAvailabilityCount.ppweeklycount
						&& null != getRsvAvailabilityCount.globalweeklycount){
					var weeklyCount = getRsvAvailabilityCount.ppweeklycount > getRsvAvailabilityCount.globalweeklycount ? getRsvAvailabilityCount.globalweeklycount : getRsvAvailabilityCount.ppweeklycount;
					tempHtml += "주 <strong>" + weeklyCount + "</strong>회 ";
					cnt++;
				}else if(null == getRsvAvailabilityCount.ppweeklycount
						&& null != getRsvAvailabilityCount.globalweeklycount){
					tempHtml += "주 <strong>" + getRsvAvailabilityCount.globalweeklycount + "</strong>회 ";
					cnt++;
				}else if(null != getRsvAvailabilityCount.ppweeklycount
						&& null == getRsvAvailabilityCount.globalweeklycount){
					tempHtml += "주 <strong>" + getRsvAvailabilityCount.ppweeklycount + "</strong>회 ";
					cnt++;
				}
				
				if(null != getRsvAvailabilityCount.ppmonthlycount
						&& null != getRsvAvailabilityCount.globalmonthlycount){
					var monthlyCount = getRsvAvailabilityCount.ppmonthlycount > getRsvAvailabilityCount.globalmonthlycount ? getRsvAvailabilityCount.globalmonthlycount : getRsvAvailabilityCount.ppmonthlycount;
					tempHtml += "월 <strong>" + monthlyCount + "</strong>회 ";
					cnt++;
				}else if(null == getRsvAvailabilityCount.ppmonthlycount
						&& null != getRsvAvailabilityCount.globalmonthlycount){
					tempHtml += "월 <strong>" + getRsvAvailabilityCount.globalmonthlycount + "</strong>회 ";
					cnt++;
				}else if(null != getRsvAvailabilityCount.ppmonthlycount
						&& null == getRsvAvailabilityCount.globalmonthlycount){
					tempHtml += "월 <strong>" + getRsvAvailabilityCount.ppmonthlycount + "</strong>회 ";
					cnt++;
				}
				
			}
			
			tempHtml += "예약가능</span>"
				+ "</div>";
			
			if(cnt != 0){
				html = tempHtml;
			}else if(null == getRsvAvailabilityCount){
				html = "<div class=\"hText\"></div>";
			}else{
				html = "<div class=\"hText\">-</div>";
			}
			
		}
		, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	return html;
}

/* 세션 선택 이벤트 */
function sessionClick(obj) {
	if($(obj).hasClass("active")){
		$(obj).removeClass("active");
	}else{
		$(obj).addClass("active");
	}
	
	/* 예약 요청 버튼 */
	var cnt = 0;
	$("#step2Btn").parents(".bizEduPlace").find(".dateSelectWrap .selectArea a").each(function () {
		if($(this).hasClass("active")){
			cnt++;
		}
	});
	if(cnt != 0 ){
		$("#step2Btn").show();
	}else{
		$("#step2Btn").hide();
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 선택된 세션 form태그에 정리 */
function sessionCheck() {
	
	$("#checkLimitCount").empty();
	$("#cancellist").empty();
	var layerHtml = "";
	var cnt = 0;
	$("#step2Btn").parents(".bizEduPlace").find(".dateSelectWrap .selectArea a").each(function () {
		if($(this).hasClass("active")){
				
			var layerDate = $(this).find("input[name=reservationDate]").val().substring(0, 4) + "-" 
						+ $(this).find("input[name=reservationDate]").val().substring(4, 6) + "-" + 
						+ $(this).find("input[name=reservationDate]").val().substring(6, 8);
			if(cnt == 0){
				$("#uiLayerPop_confirm").find(".tblResrConform thead tr th").empty();
				$("#uiLayerPop_confirm").find(".tblResrConform thead tr th").append($(this).find("input[name=ppName]").val()+" <em>|</em> "+layerDate+" ("+$(this).find("input[name=krWeekDay]").val()+")");
			}
			
			var seatCountHtml = "";
// 			for(var i = 1; i <= parseInt($(this).find("input[name=seatCount]").val()); i++){
			for(var i = 1; i <= 2; i++){
				seatCountHtml += "<option value=\""+i+"\">"+i+"명</option>";
			}
			
			layerHtml += "<tr>"
				       + "<th class=\"bdTop\">프로그램</th>"
				       + "<td class=\"bdTop\">"+$(this).find("input[name=productName]").val()+"</td>"
				       + "</tr>"
				       + "<tr>"
				       + "<th>날짜 및 체험시간</th>"
				       + "<td>"+layerDate+" ("+$(this).find("input[name=krWeekDay]").val()+") "+$(this).find("input[name=startDateTime]").val().substring(0, 2)+":"+$(this).find("input[name=startDateTime]").val().substring(2, 4)+"</td>"
				       + "</tr>"
				       + "<tr>"
				       + "<th>참석인원</th>"
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
			           
		   		$("#checkLimitCount").append("<input type=\"hidden\" name=\"reservationDate\" value=\""+$(this).find("input[name=reservationDate]").val()+"\">");
				$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeSeq\" value=\""+$(this).find("input[name=typeSeq]").val()+"\">");
				$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+$(this).find("input[name=expSeq]").val()+"\">");

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
			$("#" + $(this).val()).removeClass("active");
		});
	
		/* 세션 갱신 후 재예약 요청 */
		sessionCheck();
		
		$("#layerMask").remove();
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
function expCultureNonMemberIdCheckPop() {
	
    $("#expCultureForm").attr('action', "<c:url value='/mobile/reservation/expCultureNonmemberIdCheckForm.do'/>");
    $("#expCultureForm").attr('method', 'post');
	$("#expCultureForm").append("<input type=\"hidden\" name=\"tempParentFlag\" value=\"program\">");
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
		
	$.ajaxCall({
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
				/* step2 result */
				expCultureRsvComplete(completeList);
				/* 예약완료 화면  */
				$("#stepDone").show();
				
				/* move to top */
				var $pos = $("#pbContent");
				var iframeTop = parent.$("#IframeComponent").offset().top
				parent.$('html, body').animate({
				    scrollTop:$pos.offset().top + iframeTop
				}, 300);

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
				

				$("#uiLayerPop_noneculture").hide();
				$(".layerMask").remove();
				
				$('html, body').css({
					overflowX:'',
					overflowY:''
				});
				
				/* step2 result */
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
	
	for(var num in completeList){
		if(completeList[num].paymentStatusCode == 'P01'){
			html += "<span>"+completeList[num].productName+"<em class=\"bar\">|";
			html += "</em>";
			html += completeList[num].reservationDate.substring(0, 4)+"-"+completeList[num].reservationDate.substring(4, 6)+"-"+completeList[num].reservationDate.substring(6, 8)+" ";
			html += completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4)+" (대기신청)<em class=\"bar\">|";
			html += "</em>참석인원 "+completeList[num].visitNumber+"명</span>";
				
			snsHtml += "■"+this.ppName+"("+completeList[num].productName+")";
			snsHtml += completeList[num].reservationDate.substring(0, 4)+"-"+completeList[num].reservationDate.substring(5, 7)+"-"+completeList[num].reservationDate.substring(8, 10) + "("+this.krWeekDay+") | \n"; 
			snsHtml += completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4) + "(대기신청) | \n" ;
			snsHtml += "참석인원" + completeList[num].visitNumber + "명 \n";;
		}else{
			html += "<span>"+completeList[num].productName+"<em class=\"bar\">|";
			html += "</em>";
			html += completeList[num].reservationDate.substring(0, 4)+"-"+completeList[num].reservationDate.substring(4, 6)+"-"+completeList[num].reservationDate.substring(6, 8)+" ";
			html += completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4)+"<em class=\"bar\">|";
			html += "</em>참석인원 "+completeList[num].visitNumber+"명</span>";
				
			snsHtml += "■"+this.ppName+"("+completeList[num].productName+")";
			snsHtml += completeList[num].reservationDate.substring(0, 4)+"-"+completeList[num].reservationDate.substring(5, 7)+"-"+completeList[num].reservationDate.substring(8, 10) + "("+this.krWeekDay+") | \n"; 
			snsHtml += completeList[num].startDateTime.substring(0, 2)+":"+completeList[num].startDateTime.substring(2, 4) + "\n" ;
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

	$form.append("<input type=\"hidden\" name=\"tempParentFlag\" value=\"program\">");
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
			/* 문화체험 소개  렌더링 */
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
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
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

/* ap 안내 */
function showApInfo(thisObj){
	layerPopupOpen(thisObj);

	abnkoreaApInfoPop_resize();
}

function closeApInfo(){
	$("#uiLayerPop_apInfo").hide();
	$("#layerMask").remove();
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


function showExpRsvComfirmPop(){
	
	var tempYear = $("#getYearPop").val();
	var tempMonth = $("#getMonthPop").val();
	
	$("#getYearLayer").val($("#getYearPop").val()).attr("selected", "selected");
	$("#getMonthLayer").val($("#getMonthPop").val()).attr("selected", "selected");
	
	searchCalLayer();
	setToday();
	
	layerPopupOpen("<a href='#uiLayerPop_calender2' class='btnTbl'>체험예약 현황확인</a>");return false;
}

/**
 * 이전 버튼 클릭시 화면 이동
 */
function backStep(destStep){
	
	if('1' == destStep ){

		/* move to step 1 */
		var $pos = $("#selectStepOne");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
		
	}
		
}

</script>
<!-- content -->
<section id="pbContent" class="bizroom">

	<input type="hidden" id="getMonthPop" name="getMonthPop">
	<input type="hidden" id="getYearPop" name="getYearPop">
	<input type="hidden" id="getDayPop" name="getDayPop">
		

	<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
	<form id="cancellist" name="cancellist" method="post"></form>
	
	<input type="hidden" id="transactionTime" />
	<input type="hidden" id="snsText" name="snsText">
	<section class="brIntro">
		<h2><a href="#uiToggle_01">문화체험 예약 필수 안내</a></h2>
		<div id="uiToggle_01" class="toggleDetail">
			<!-- 20160822 수정 -->
			<p class="pTit">예약 안내</p>
			<ul class="listDot">
				<li>예약은 월 2회에 한하여 예약 가능합니다.</li>
				<li>프로그램은 본인 포함 2명 참석이 가능합니다.</li>
				<li>매월 예약 오픈일 오전 10시부터 예약 가능합니다.</li>
			</ul>
			<table class="tblCont">
				<caption>예약 안내</caption>
				<colgroup>
					<col style="width:180px" />
					<col style="width:auto" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="bg">매월 10일(오전 10시) 오픈</th>
						<td>누구나</td>
					</tr>
				</tbody>
			</table>
			<p class="pTit">예약 취소 안내</p>
			<ul class="listDot">
				<li>체험 취소,변경은, 체험 진행일 기준 1일전에 요청해주셔야 페널티 적용이 되지 않습니다.</li>
			</ul>
			<p class="pTit">페널티 프로그램 안내</p>
			<ul class="listDot">
				<li>체험 진행일 당일 취소하시거나,  사전 취소 없이 불참한 경우 다음달 문화 체험 강좌 예약 불가합니다.</li>
			</ul>
			<p class="tiptextR">2016년 9월1일 최종 업데이트 되었습니다.</p>
			<!-- //20160822 수정 -->
		</div>
	</section>

	<section class="mWrap">
		<ul class="tabDepth1 tNum2">
			<li><a href="/mobile/reservation/expCultureForm.do">날짜 먼저선택</a></li>
			<li class="on"><strong>프로그램 먼저선택</strong></li>
		</ul>
		<div class="blankR">
			<a href="#uiLayerPop_culture" id="expCultureIntroduceBtn" class="btnTbl" onclick="layerPopupOpen(this);return false;">문화체험 소개</a>
		</div>
		<!-- 스텝1 -->
		<div class="bizEduPlace" id="selectStepOne">
			<div class="result">
				<div class="tWrap">
					<em class="bizIcon step04"></em><strong class="step">STEP1/ 지역, 프로그램</strong>
					<span>총2건</span>
					<div class="resultDetail">
						<span>분당ABC<em class="bar">|</em>가족이 대를 잇는 추억놀이<em class="bar">|</em>준비물 : 태블릿PC</span>
						<span>분당ABC<em class="bar">|</em>신나는 ABC 마술쇼<em class="bar">|</em>준비물 : 태블릿PC</span>
					</div>
					<%/*<button class="bizIcon showHid">수정</button>*/%>
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step04"></em><strong class="step">STEP1/ 지역, 프로그램</strong><span>지역 선택 후 프로그램을 선택하세요.</span></div></dt>
					<dd>
						<div class="hWrap">
							<p class="tit">지역 선택</p>
<!-- 							<a href="#none" class="btnTbl">AP안내</a> -->
							<a href="#uiLayerPop_apInfo" onclick="javascript:showApInfo(this); return false;" class="btnTbl uiApBtnOpen">
								<span>AP 안내</span>
							</a>
						</div>
						<div class="selectArea local">
							<a href="#none" class="active">강서</a><a href="#none">대전</a><a href="#none">부산</a><a href="#none">대구</a><a href="#none">창원</a><a href="#none">울산</a>
							<a href="#none">광주</a><a href="#none">전주</a><a href="#none">분당ABC</a>
						</div>
					</dd>
					<dd class="bdtNone" id="selectProgram" >
						<div class="hWrap">
							<p class="tit">프로그램 선택</p>
						</div>
						<div class="tblWrap">
							<table class="tblSession mgNone">
								<caption>프로그램 선택</caption>
								<colgroup>
									<col width="5%" />
									<col width="auto" />
								</colgroup>
								<tbody>
									<tr class="select">
										<td class="vt"><input type="checkbox" name="programcheck" checked /></td>
										<td class="programTitle"><a href="#none">우리아이 식생활 변화 프로젝트2 (두뇌 성장)</a><br/>
											<span class="prepare" style="display:block">준비물 : 노트북</span>
											<span>체험시간 : 14:00</span>
										</td>
									</tr>
									<tr class="programDetailTr">
										<td colspan="2">
											<section class="programInfoWrap">
												<div class="programInfo">
													<p>엄마와 함께하는 우산 만들기 체험!!<br/>빗방울이 똑똑 우산을 함께 만들어 봅시다.</p>
													<p>대상 : 5~10세 어린이</p>
												</div>
												<dl class="roomTbl">
													<dt><span class="bizIcon icon6"></span>장소</dt>
													<dd>강서 AP</dd>
													<dt><span class="bizIcon icon7"></span>일정</dt>
													<dd>7월 2일(토) 14시<br/>7월 2일(토) 14시</dd>
													<dt><span class="bizIcon icon1"></span>인원</dt>
													<dd>1~2명 (개인)<br/>15~20명 (그룹)</dd>
													<dt><span class="bizIcon icon2"></span>체험시간</dt>
													<dd>180분</dd>
													<dt><span class="bizIcon icon3"></span>예약자격</dt>
													<dd>PT이상<br><span class="fsS">(일반소비자 동반 가능)</span></dd>
													<dt><span class="bizIcon icon5"></span>준비물</dt>
													<dd>하이드라 V 앰플마스크 1매</dd>
												</dl>
											</section>
										</td>
									</tr>
									<tr>
										<td class="vt"><input type="checkbox" name="programcheck" /></td>
										<td class="programTitle"><a href="#none">신나는 ABC 마술쇼~!!</a><br/>
											<span class="prepare">준비물 : 노트북</span>
											<span>체험시간 : 14:00</span>
										</td>
									</tr>
									<tr class="programDetailTr">
										<td colspan="2">
											<section class="programInfoWrap">
												<div class="programInfo">
													<p>엄마와 함께하는 우산 만들기 체험!!<br/>빗방울이 똑똑 우산을 함께 만들어 봅시다.</p>
													<p>대상 : 5~10세 어린이</p>
												</div>
												<dl class="roomTbl">
													<dt><span class="bizIcon icon6"></span>장소</dt>
													<dd>강서 AP</dd>
													<dt><span class="bizIcon icon7"></span>일정</dt>
													<dd>7월 2일(토) 14시<br/>7월 2일(토) 14시</dd>
													<dt><span class="bizIcon icon1"></span>인원</dt>
													<dd>1~2명 (개인)<br/>15~20명 (그룹)</dd>
													<dt><span class="bizIcon icon2"></span>체험시간</dt>
													<dd>180분</dd>
													<dt><span class="bizIcon icon3"></span>예약자격</dt>
													<dd>PT이상<br><span class="fsS">(일반소비자 동반 가능)</span></dd>
													<dt><span class="bizIcon icon5"></span>준비물</dt>
													<dd>하이드라 V 앰플마스크 1매</dd>
												</dl>
											</section>
										</td>
									</tr>
								</tbody>
							</table>
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
		<div class="bizEduPlace" id="selectStepTwo">
			<div class="result">
				<div class="tWrap">
					<em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜</strong>
					<span>총2건</span>
					<div class="resultDetail">
						<span>분당ABC<em class="bar">|</em>가족이 대를 잇는 추억놀이<em class="bar">|</em><br/>
						준비물 : 태블릿PC<em class="bar">|</em>2016-05-21(토) 14:00<em class="bar">|</em>참석인원 1명</span>
						<span>분당ABC<em class="bar">|</em>신나는 ABC 마술쇼<em class="bar">|</em><br/>
						준비물 : 태블릿PC<em class="bar">|</em>2016-05-21(토) 14:00<em class="bar">|</em>참석인원 1명</span>
					</div>
					<%/*<button class="bizIcon showHid">수정</button>*/%>
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜</strong><span>날짜를 선택해 주세요.</span></div></dt>
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
						<div class="dateSelectWrap">
							<p class="prgtitle">분당ABC <em>|</em> 가족이 대를 잇는 추억놀이</p>
							<div class="selectArea sizeM">
								<a href="#none" class="active">2016년 5월 5일(목)<br/> 14:00</a><a href="#none">2016년 5월 5일(목)<br/> 14:00 (대기신청)</a><a href="#none">2016년 5월 5일(목)<br/> 14:00</a><a href="#none">2016년 5월 5일(목)<br/> 14:00</a>
							</div>
							<p class="prgtitle">분당ABC <em>|</em> 신나는 ABC 마술</p>
							<div class="selectArea sizeM">
								<a href="#none" class="active">2016년 5월 5일(목)<br/> 14:00</a><a href="#none">2016년 5월 5일(목)<br/> 14:00 (대기신청)</a><a href="#none">2016년 5월 5일(목)<br/> 14:00</a><a href="#none">2016년 5월 5일(목)<br/> 14:00</a>
							</div>
							
							<!-- 20160714 페널티 수정 -->
							<p class="listWarning">※ 취소 없이 참여하지 않는 경우,  페널티가 적용되어 모든 문화체험 체험월의 익월까지 예약 불가합니다.</p>
						</div>

						<div class="btnWrap aNumb2">
							<a href="#none" class="btnBasicGL" onclick="javascript:backStep(1);" >이전</a>
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
				<a href="/mobile/reservation/expCultureProgramForm.do" class="btnBasicGL">예약계속하기</a>
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
						<th>날짜 및 체험시간</th>
						<td>2016-05-05 (토) 14:00</td>
					</tr>
					<tr>
						<th>참석인원</th>
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
						<th>날짜 및 체험시간</th>
						<td>2016-05-05 (토) 15:00 (대기신청)</td>
					</tr>
					<tr>
						<th>참석인원</th>
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
				<dt class=""><a href="#none">
					암웨이 칠드런스데이<br/><span class="subject">[강서AP] 가족이 대를 잇는 추억놀이</span>
					<span class="btn">내용보기</span>
				</a></dt>
				<dd class="">
					<section class="programInfoWrap">
						<div class="programInfo">
							<p>엄마와 함께하는 우산 만들기 체험!!<br/>빗방울이 똑똑 우산을 함께 만들어 봅시다.</p>
							<p>대상 : 5~10세 어린이</p>
						</div>
						<dl class="roomTbl">
							<dt><span class="bizIcon icon6"></span>장소</dt>
							<dd>강서 AP</dd>
							<dt><span class="bizIcon icon7"></span>일정</dt>
							<dd>7월 2일(토) 14시<br/>7월 2일(토) 14시</dd>
							<dt><span class="bizIcon icon1"></span>인원</dt>
							<dd>1~2명 (개인)<br/>15~20명 (그룹)</dd>
							<dt><span class="bizIcon icon2"></span>체험시간</dt>
							<dd>180분</dd>
							<dt><span class="bizIcon icon3"></span>예약자격</dt>
							<dd>PT이상<br><span class="fsS">(일반소비자 동반 가능)</span></dd>
							<dt><span class="bizIcon icon5"></span>준비물</dt>
							<dd>하이드라 V 앰플마스크 1매</dd>
						</dl>
					</section>
				</dd>
				<dt><a href="#none">
					암웨이 칠드런스데이<br/><span class="subject">[강서AP] 가족이 대를 잇는 추억놀이</span>
					<span class="btn">내용보기</span>
				</a></dt>
				<dd>
					<section class="programInfoWrap">
						<div class="programInfo">
							<p>엄마와 함께하는 우산 만들기 체험!!<br/>빗방울이 똑똑 우산을 함께 만들어 봅시다.</p>
							<p>대상 : 5~10세 어린이</p>
						</div>
						
						<dl class="roomTbl">
							<dt><span class="bizIcon icon6"></span>장소</dt>
							<dd>강서 AP</dd>
							<dt><span class="bizIcon icon7"></span>일정</dt>
							<dd>7월 2일(토) 14시<br/>7월 2일(토) 14시</dd>
							<dt><span class="bizIcon icon1"></span>인원</dt>
							<dd>1~2명 (개인)<br/>15~20명 (그룹)</dd>
							<dt><span class="bizIcon icon2"></span>체험시간</dt>
							<dd>180분</dd>
							<dt><span class="bizIcon icon3"></span>예약자격</dt>
							<dd>PT이상<br><span class="fsS">(일반소비자 동반 가능)</span></dd>
							<dt><span class="bizIcon icon5"></span>준비물</dt>
							<dd>하이드라 V 앰플마스크 1매</dd>
						</dl>
						
					</section>
				</dd>
				<dt><a href="#none">
					암웨이 칠드런스데이<br/><span class="subject">[강서AP] 가족이 대를 잇는 추억놀이</span>
					<span class="btn">내용보기</span>
				</a></dt>
				<dd>
					<section class="programInfoWrap">
						<div class="programInfo">
							<p>엄마와 함께하는 우산 만들기 체험!!<br/>빗방울이 똑똑 우산을 함께 만들어 봅시다.</p>
							<p>대상 : 5~10세 어린이</p>
						</div>
						<dl class="roomTbl">
							<dt><span class="bizIcon icon6"></span>장소</dt>
							<dd>강서 AP</dd>
							<dt><span class="bizIcon icon7"></span>일정</dt>
							<dd>7월 2일(토) 14시<br/>7월 2일(토) 14시</dd>
							<dt><span class="bizIcon icon1"></span>인원</dt>
							<dd>1~2명 (개인)<br/>15~20명 (그룹)</dd>
							<dt><span class="bizIcon icon2"></span>체험시간</dt>
							<dd>180분</dd>
							<dt><span class="bizIcon icon3"></span>예약자격</dt>
							<dd>PT이상<br><span class="fsS">(일반소비자 동반 가능)</span></dd>
							<dt><span class="bizIcon icon5"></span>준비물</dt>
							<dd>하이드라 V 앰플마스크 1매</dd>
						</dl>
					</section>
				</dd>
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
	<!-- //layer popoup -->
	<!-- ap안내 -->
	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/apInfoPop.jsp" %>
	
	<!-- //예약 및 결제정보 확인 -->
	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expRsvConfirmPop.jsp" %>
</section>
<!-- //content -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/mobile/footer.jsp" %>