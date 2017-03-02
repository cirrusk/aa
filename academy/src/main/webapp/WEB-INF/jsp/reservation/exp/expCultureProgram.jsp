<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

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

var step1Clk = 0;
$(document).ready(function () {
	
	setPpInfoList();
	
	$(".brSelectWrap").show();
	$("#stepDone").hide();
	
	/* step1 다음 버튼 클릭 */
	$("#step1Btn").on("click", function(){
		var cnt = 0;
		$("input[name=programCheck]").each(function () {
			if($(this).prop("checked")){
				cnt++;
			}
		});
		if(ppSeq != "" && cnt != 0){
			
			/* step1 닫힘 */
			wrapClose($("#step1Btn"));
			
			/* step2 열림 */
			wrapOpen($("#step2Btn"));
			
		
			if(step1Clk == 1){
				/* step1 result 렌더링 */
				step1ResultRender();
				
				/* typeSeq, ppSeq, year, month, day 에 해당하는 프로그램 목록 조회 */
				expCultureSessionListAjax();
				
				step1Clk = 0;
			}
			
		}else{
			alert("프로그램을 선택해야 다음 step으로 진행 가능합니다.");
		}
	});
	
	/* step2 예약 요청 버튼 클릭 */
	$("#step2Btn").on("click", function(){
		/* 체크된 프로그램 데이터 form태그에 정리, 예약확인 팝업 호출 */
		sessionCheck();
	});
	
	/* 예약계속하기} */
	$(".btnBasicGL").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expCultureProgramForm.do'/>";
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
					html += "<a href='javascript:void(0);' class = 'on' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:expCulturePpProgramListAjax('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"');\">"+ppList[i].ppname+"</a>";
					expCulturePpProgramListAjax(ppList[i].ppseq, ppList[i].ppname);
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' name='detailPpSeq' onclick=\"javascript:expCulturePpProgramListAjax('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"');\">"+ppList[i].ppname+"</a>";
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

/* 해당 pp 프로그램 정보 조회 */
function expCulturePpProgramListAjax(ppSeq, ppName){
	step1Clk = 1;
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$("a[name=detailPpSeq]").each(function () {
		$(this).removeClass();
	});
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+ppSeq).prop("class", "on");
	
	this.ppSeq = ppSeq;
	this.ppName = ppName;
	
	var param = {
		  "ppseq" : this.ppSeq
		, "typeseq" : this.typeSeq
	};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCulturePpProgramListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 해당 pp 프로그램 목록 */
			var ppProgramList = data.expCulturePpProgramList;
			
			programRender(ppProgramList);
			
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
				tempHtml += "<dt class=\"active\">"
					+ "<input type=\"checkbox\" id=\"\" name=\"programCheck\" onclick=\"javascript:programCheck(this);\"/>"
					+ "<input type=\"hidden\" name=\"typeSeq\" value=\""+this.typeSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppSeq\" value=\""+this.ppSeq+"\">"
					+ "<input type=\"hidden\" name=\"ppName\" value=\""+this.ppName+"\">"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+expSeq+"\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+ppProgramList[num].productname+"\">"
					+ "<a href=\"javascript:void(0);\" onclick=\"javascript:programContentOpen(this);\">"
					+ "<strong>"+ppProgramList[num].themename+"</strong><br/>"
					+ "<span class=\"normal\">["+this.ppName+"] "+ppProgramList[num].productname+"</span><br/>"
					+ "<span class=\"prepare\">★ 준비물 : "+ppProgramList[num].preparation+"</span><span class=\"btn\">내용보기</span></a>"
					+ "</dt>"
					+ "<dd class=\"active\">"	
					+ "<section class=\"programInfoWrap\">"	
					+ "<div class=\"programInfo\">"	
					+ "<p>"+ppProgramList[num].intro+"</p>"	
					+ "<p>"+ppProgramList[num].content+"</p>"	
					+ "</div>"	
					+ "<table class=\"roomInfoDetail\">"	
					+ "<colgroup>"	
					+ "<col width=\"20%\" />"	
					+ "<col width=\"auto\" />"	
					+ "<col width=\"20%\" />"	
					+ "<col width=\"auto\" />"	
					+ "</colgroup>"	
					+ "<tr>"	
					+ "<td class=\"title\"><span class=\"icon6\">장소</span></td>"	
					+ "<td>"+this.ppName+"</td>"	
					+ "<td class=\"title\"><span class=\"icon7\">일정</span></td>"	
					+ "<td>";
					
					/* 사용가능 일자 */
					var ymd = "";
					var weekDay = "";
					var expSessionSeq = "";
					var setTypeCode = "";
					var renderFlag = true;
					var renderCnt = 0;
					for(var i in ppProgramList){
						if(expSeq == ppProgramList[i].expseq){
							/* 날짜가 다르면 */
							if(ymd != ppProgramList[i].ymd){
								weekDay = ppProgramList[i].weekday;
							}
							if(ymd != ppProgramList[i].ymd
									|| expSessionSeq != ppProgramList[i].expsessionseq){
								ymd = ppProgramList[i].ymd
								expSessionSeq = ppProgramList[i].expsessionseq;
								setTypeCode = ppProgramList[i].settypecode;
								renderFlag = true;
								renderCnt = 0;
							}

							
							if(setTypeCode != ppProgramList[i].settypecode
									|| 'S02' == ppProgramList[i].worktypecode
									|| 1 == ppProgramList[i].standbynumber
									|| 'R01' == ppProgramList[i].adminfirstcode
									|| weekDay != ppProgramList[i].weekday){
								renderFlag = false;
							}
							
							if(renderFlag && renderCnt == 0 && ppProgramList[i].startdatetime != null){
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
					
				tempHtml += "</td>"
					+ "</tr>"	
					+ "<tr>"	
					+ "<td class=\"title\"><span class=\"icon1\">정원</span></td>"	
					+ "<td>"+ppProgramList[num].seatcount+"</td>"	
					+ "<td class=\"title\"><span class=\"icon2\">이용시간</span></td>"	
					+ "<td>"+ppProgramList[num].usetime+"</td>"	
					+ "</tr>"	
					+ "<tr>"	
					+ "<td class=\"title\"><span class=\"icon3\">예약자격</span></td>"
					
					if("" == ppProgramList[num].rolenote){
						+ "<td>"+ppProgramList[num].role+"</td>"
					}else{
						+ "<td>"+ppProgramList[num].role+"<br/><span class=\"normal\">("+ppProgramList[num].rolenote+")</span></td>"
					}
					
					+ "<td class=\"title\"><span class=\"icon5\">준비물</span></td>"	
					+ "<td>"+ppProgramList[num].preparation+"</td>"	
					+ "</tr>"	
					+ "</table>"	
					+ "</section>"	
					+ "</dd>";
			}else{
				tempHtml += "<dt>"
					+ "<input type=\"checkbox\" id=\"\" name=\"programCheck\" onclick=\"javascript:programCheck(this);\"/>"
					+ "<input type=\"hidden\" name=\"expSeq\" value=\""+expSeq+"\">"
					+ "<input type=\"hidden\" name=\"productName\" value=\""+ppProgramList[num].productname+"\">"
					+ "<a href=\"javascript:void(0);\" onclick=\"javascript:programContentOpen(this);\">"
					+ "<strong>"+ppProgramList[num].themename+"</strong><br/>"
					+ "<span class=\"normal\">["+this.ppName+"] "+ppProgramList[num].productname+"</span><br/>"
					+ "<span class=\"prepare\">★ 준비물 : "+ppProgramList[num].preparation+"</span><span class=\"btn\">내용보기</span></a>"
					+ "</dt>"
					+ "<dd>"	
					+ "<section class=\"programInfoWrap\">"	
					+ "<div class=\"programInfo\">"	
					+ "<p>"+ppProgramList[num].intro+"</p>"	
					+ "<p>"+ppProgramList[num].content+"</p>"	
					+ "</div>"	
					+ "<table class=\"roomInfoDetail\">"	
					+ "<colgroup>"	
					+ "<col width=\"20%\" />"	
					+ "<col width=\"auto\" />"	
					+ "<col width=\"20%\" />"	
					+ "<col width=\"auto\" />"	
					+ "</colgroup>"	
					+ "<tr>"	
					+ "<td class=\"title\"><span class=\"icon6\">장소</span></td>"	
					+ "<td>"+this.ppName+"</td>"	
					+ "<td class=\"title\"><span class=\"icon7\">일정</span></td>"	
					+ "<td>";
					
					/* 사용가능 일자 */
					var ymd = "";
					var weekday = "";
					var expSessionSeq = "";
					var setTypeCode = "";
					var renderFlag = true;
					var renderCnt = 0;
					for(var i in ppProgramList){
						if(expSeq == ppProgramList[i].expseq){
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
							
							if(renderFlag && renderCnt == 0 && ppProgramList[i].startdatetime != null){
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
					
				tempHtml += "</td>"
					+ "</tr>"	
					+ "<tr>"	
					+ "<td class=\"title\"><span class=\"icon1\">정원</span></td>"	
					+ "<td>"+ppProgramList[num].seatcount+"</td>"	
					+ "<td class=\"title\"><span class=\"icon2\">이용시간</span></td>"	
					+ "<td>"+ppProgramList[num].usetime+"</td>"	
					+ "</tr>"	
					+ "<tr>"	
					+ "<td class=\"title\"><span class=\"icon3\">예약자격</span></td>"
					
					if("" == ppProgramList[num].rolenote){
						+ "<td>"+ppProgramList[num].role+"</td>"
					}else{
						+ "<td>"+ppProgramList[num].role+"<br/><span class=\"normal\">("+ppProgramList[num].rolenote+")</span></td>"
					}
					
					+ "<td class=\"title\"><span class=\"icon5\">준비물</span></td>"	
					+ "<td>"+ppProgramList[num].preparation+"</td>"	
					+ "</tr>"	
					+ "</table>"	
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
	
	$("#programList").empty();
	$("#programList").append(html);
	
	$(".programWrap").show();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 프로그램 체크박스 선택 이벤트 */
function programCheck(obj) {
	step1Clk = 1;
	if($(obj).prop("checked")){
		$(obj).parents("dt").find(".prepare").show();
	}else{
		$(obj).parents("dt").find(".prepare").hide();
	}
}

/* 프로그램 상세보기 */
function programContentOpen(obj) {
	
	/* 아코디언 열기 */
	if($(obj).parent().is(".active") == true){
		$(obj).parents("dt").removeClass("active");
		$(obj).parents("dt").next("dd").removeClass("active");
	}else{
		$("#programList dt").each(function () {
			$(this).removeClass("active");
			$(this).next("dd").removeClass("active");
		});
		
		$(obj).parents("dt").addClass("active");
		$(obj).parents("dt").next("dd").addClass("active");
	}
	
}

/* step1Btn 닫기 버튼 클릭시 step1의 결과값 렌더링 */
function step1ResultRender() {
	var html = "";
	
	$("input[name=programCheck]").each(function () {
		if($(this).prop("checked")){
			html += "<p>"+ppName+"<em>|</em>"+$(this).parents("dt").find("input[name=productName]").val()+"</p>";
		}
	});
	$("#step1Btn").parents(".brWrap").find(".req").empty();
	$("#step1Btn").parents(".brWrap").find(".req").append(html);
}

/* 해당 pp별 프로그램별 예약 가능 세션 정보 조회 */
function expCultureSessionListAjax(){
		
	/* 선택된 프로그램 정보를 배열로 요청 */
	var expSeqArr = ["NULL"];
	$("input[name=programCheck]").each(function () {
		if($(this).prop("checked")){
			expSeqArr.push($(this).parents("dt").find("input[name=expSeq]").val());
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
			html += "<p class=\"selectPrgTit\"><span>"+this.ppName+"<em>|</em>"+sessionList[num].productname+"</span></p>";
			
			/* 누적 예약 가능 횟수 조회 */
			html += getRsvAvailabilityCount(expSeq);
			
			html += "<div class=\"brselectArea sizeL\">";
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
							html += "<a href=\"javascript:void(0);\" id=\""+sessionList[i].ymd+"_"+sessionList[i].expsessionseq+"\" class=\"line2\" onclick=\"javascript:sessionClick(this);\">"
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
								+ sessionList[i].ymd.substring(0, 4)+"-"
								+ sessionList[i].ymd.substring(4, 6)+"-"
								+ sessionList[i].ymd.substring(6, 8)+" ("
								+ sessionList[i].krweekday+")<br/>"
								+ sessionList[i].startdatetime.substring(0, 2)+":"+sessionList[i].startdatetime.substring(2, 4)+" (대기신청)</a>";
						}else{
							/* 해당세션에 예약자가 없는경우 정상 예약 */
							html +="<a href=\"javascript:void(0);\" id=\""+sessionList[i].ymd+"_"+sessionList[i].expsessionseq+"\" class=\"line2\" onclick=\"javascript:sessionClick(this);\">"
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
								+ sessionList[i].ymd.substring(0, 4)+"-"
								+ sessionList[i].ymd.substring(4, 6)+"-"
								+ sessionList[i].ymd.substring(6, 8)+" ("
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
	$("#sessionList").empty();
	$("#sessionList").append(html);
	
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
	if($(obj).hasClass("on")){
		$(obj).removeClass("on");
	}else{
		$(obj).addClass("on");
	}
}

/* 선택된 세션 form태그에 정리 */
function sessionCheck() {
	
	var html = "";
	var cnt = 0;
	$("#checkLimitCount").empty();
	
	$("#sessionList div a").each(function () {
		if($(this).hasClass("on")){
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
				
				cnt++;
		}
	});

	if(cnt == 0){
		alert("세션을 선택 후 다음으로 진행 가능합니다.");
		return;
	}
	
	$("#expCultureForm").empty();
	$("#expCultureForm").append(html);
	
	/* 패널티 유효성 중간 검사 */
	if(middlePenaltyCheck()){
	
		/* 누적 예약 잔여 횟수 유효성 검사*/
		/* typeseq, ppseq, roomseq 일, 주, 월 예약 가능 횟수 조회 변수*/
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
				expCultureProgramRsvRequestPop();
			}else{
				/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
				expCultureProgramDisablePop(cancelDataList);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 예약요청 팝업 호출 */
function expCultureProgramRsvRequestPop(){
	
	var frm = document.expCultureForm
	var url = "<c:url value='/reservation/expCultureProgramRsvRequestPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 예약불가 알림 팝업(중복체크) */
function expCultureProgramDisablePop(cancelDataList) {
	var url = "<c:url value='/reservation/expCultureProgramDisablePop.do'/>";
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
	wrapClose($("#step2Btn"));
	$("#stepDone").show();
	

	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	var html = "<p class=\"total\">총 "+expCultureCompleteList.length+" 건</p>";
	var snsHtml = "[한국암웨이]시설/체험 예약내역 (총 "+expCultureCompleteList.length+"건) \n";
	
	for(var num in expCultureCompleteList){
		if(expCultureCompleteList[num].paymentStatusCode == 'P01'){
			html += "<p>"+expCultureCompleteList[num].productName+"<em>|"
				+"</em>"
				+expCultureCompleteList[num].reservationDate.substring(0, 4)+"-"+expCultureCompleteList[num].reservationDate.substring(4, 6)+"-"+expCultureCompleteList[num].reservationDate.substring(6, 8)+" "
				+expCultureCompleteList[num].startDateTime.substring(0, 2)+":"+expCultureCompleteList[num].startDateTime.substring(2, 4)+" (대기신청)<em>|"
				+"</em>참석인원 "+expCultureCompleteList[num].visitNumber+"명</p>";
		
				
			snsHtml += "■"+this.ppName+"("+expCultureCompleteList[num].productName+")"
					+ expCultureCompleteList[num].reservationDate.substring(0, 4)+"-"+expCultureCompleteList[num].reservationDate.substring(4, 6)+"-"+expCultureCompleteList[num].reservationDate.substring(6, 8) + "("+this.krWeekDay+") | \n" 
					+ expCultureCompleteList[num].startDateTime.substring(0, 2)+":"+expCultureCompleteList[num].startDateTime.substring(2, 4) + "(대기신청) | \n" 
					+ "참석인원" + expCultureCompleteList[num].visitNumber + "명 \n";
		}else{
			html += "<p>"+expCultureCompleteList[num].productName+"<em>|"
				+"</em>"
				+expCultureCompleteList[num].reservationDate.substring(0, 4)+"-"+expCultureCompleteList[num].reservationDate.substring(4, 6)+"-"+expCultureCompleteList[num].reservationDate.substring(6, 8)+" "
				+expCultureCompleteList[num].startDateTime.substring(0, 2)+":"+expCultureCompleteList[num].startDateTime.substring(2, 4)+"<em>|"
				+"</em>참석인원 "+expCultureCompleteList[num].visitNumber+"명</p>";
				
				
			snsHtml += "■"+this.ppName+"("+expCultureCompleteList[num].productName+")"
					+ expCultureCompleteList[num].reservationDate.substring(0, 4)+"-"+expCultureCompleteList[num].reservationDate.substring(4, 6)+"-"+expCultureCompleteList[num].reservationDate.substring(6, 8) + "("+this.krWeekDay+") | \n" 
					+ expCultureCompleteList[num].startDateTime.substring(0, 2)+":"+expCultureCompleteList[num].startDateTime.substring(2, 4) + " | \n" 
					+ "참석인원" + expCultureCompleteList[num].visitNumber + "명 \n";
			
		}
	}
	
	/* step2 result rendering */
	$("#step2Btn").parents(".brWrap").find(".req").empty();
	$("#step2Btn").parents(".brWrap").find(".req").append(html);

	$("#snsText").empty();
	$("#snsText").val(snsHtml);
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

	$form.append("<input type=\"hidden\" name=\"tempParentFlag\" value=\"program\">");
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


function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 문화 체험 예약";
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

/* 예약 현황 확인 페이지 이동 */
function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}

</script>
</head>
<body>
<form id="expCultureForm" name="expCultureForm" method="post">
	<input type="hidden" name="getYearPop" id="getYearPop">
	<input type="hidden" name="getMonthPop" id="getMonthPop">
	<input type="hidden" name="getDayPop" id="getDayPop">
	
	<input type="hidden" id="pinvalue" value="${srcData.pinvalue}">
</form>
<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
<form id="cancelList" name="cancelList" method="post"></form>

		<input type="hidden" id="transactionTime" value="" />
		<input type="hidden" id="snsText" name="snsText">
		
		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="bizroom">
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
					<li><a href="/reservation/expCultureForm.do">날짜 먼저선택</a></li>
					<li class="on"><strong>프로그램 먼저선택</strong></li>
				</ul>
				<span class="btnR"><a href="#none" class="btnCont" onclick="javascript:expCultureIntroduce();"><span>문화체험 소개</span></a></span>
			</div>
			
			
			<div class="brWrapAll mgtM">
				<span class="hide">문화체험 예약 스텝</span>
				<!-- 스텝1 -->
				<div class="brWrap current" id="step1">
					<h2 class="stepTit topM">
						<span class="close mglS"><img src="/_ui/desktop/images/academy/h2_w02_apexp3_01.gif" alt="Step1/지역, 프로그램" /></span>
						<span class="open mglS"><img src="/_ui/desktop/images/academy/h2_w02_apexp3_01_current.gif" alt="Step1/지역, 프로그램 - 지역 선택 후 프로그램을 선택하세요" /></span>					</h2>
					<div class="brSelectWrapAll">
						<div class="sectionWrap">
							<section class="brSelectWrap">
								<div class="relative">
									<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_01.gif" alt="지역 선택"></h3>
<!-- 									<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen" onclick="javascript:showApInfo();"><span>AP 안내</span></a></span> -->
									<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen"><span>AP 안내</span></a></span>
								</div>
								
								<!-- layer popup -->
								<%@ include file="/WEB-INF/jsp/reservation/exp/apInfoPop.jsp" %>
								<!--// layer popup -->
						
								<div id="ppAppend" class="brselectArea">
								</div>
							</section>
							<section class="programWrap">
								<h3><img src="/_ui/desktop/images/academy/h3_w020500290.gif" alt="프로그램 선택" /></h3>
								
								<dl id="programList" class="programList type2 mgNone">

								</dl>
							</section>
							<div class="btnWrapR">
								<a href="#step2" id="step1Btn" class="btnBasicBS">다음</a>
							</div>
						</div>
						<div class="result lines req">
<!-- 							<p>분당ABC<em>|</em>가족이 대를 잇는 추억놀이</p>
							<p>분당ABC<em>|</em>신나는 ABC 마술쇼</p> -->
						</div>
					</div>
					<%//<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
					
				</div>
				<!-- //스텝1 -->
				<!-- 스텝2 -->
				<div class="brWrap" id="step2">
					<h2 class="stepTit">
						<span class="close mglS"><img src="/_ui/desktop/images/academy/h2_w02_apexp4_01.gif" alt="Step2/ 날짜" /></span>
						<span class="open mglS"><img src="/_ui/desktop/images/academy/h2_w02_apexp4_01_current.gif" alt="Step2/ 날짜" /></span>
					</h2>
					<div class="brSelectWrapAll">
						<div class="sectionWrap">
							<section class="brSelectWrap">
								<div class="hWrap mgbNone">
									<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_04.gif" alt="날짜 선택"></h3>
									<c:if test="${srcData.pinvalue ne '-99'}">
										<span class="btnR"><a href="#none" class="btnCont" onclick="javascript:viewRsvConfirm();"><span>체험예약 현황확인</span></a></span>
									</c:if>
									<c:if test="${srcData.pinvalue eq '-99'}">
										<span class="btnR"><a href="/reservation/expInfoList.do" class="btnCont"><span>체험예약 현황확인</span></a></span>
									</c:if>
								</div>
								
								<div id="sessionList" class="brselectDateWrap">
<!-- 									<p class="selectPrgTit"><span>분당ABC<em>|</em>가족이 대를 잇는 추억놀이</span></p>
									<div class="brselectArea sizeL">
										@edit 20160701 예약대기를 대기신청으로 문구 변경 (전체)
										<a href="#none" class="line2">2016-05-05 (목)<br/>14:00 (대기신청)</a>
										<a href="#none" class="line2">2016-05-13 (토)<br/>14:00</a>
										<a href="#none" class="line2">2016-05-14 (일)<br/>14:00</a>
										<a href="#none" class="line2 on">2016-05-21 (토)<br/>14:00</a>
									</div>
									<p class="selectPrgTit"><span>분당ABC<em>|</em>가족이 대를 잇는 추억놀이</span></p>
									<div class="brselectArea sizeL">
										<a href="#none" class="line2">2016-05-05 (목)<br/>14:00</a>
										<a href="#none" class="line2">2016-05-13 (토)<br/>14:00</a>
										<a href="#none" class="line2">2016-05-14 (일)<br/>14:00</a>
										<a href="#none" class="line2 on">2016-05-21 (토)<br/>14:00</a>
									</div> -->
								</div>
								<ul class="listWarning">
									<li>※ 취소 없이 참여하지 않는 경우, 패널티가 적용되어 모든 문화체험 체험월의 익월까지 예약 불가합니다.</li>
								</ul>
							</section>
						
							<div class="btnWrapR">
								<a href="#step2" class="btnBasicGS" onclick="javascript:showStep1()">이전</a>
								<a href="#none" id="step2Btn" class="btnBasicBS">예약요청</a>
							</div>
						</div>
						<div class="result" id="step2Result"><p>날짜를 선택해 주세요.</p></div>
						<!-- 결과값이 두 줄 이상일 때 lines클래스를 추가합니다. -->
						<div class="result lines req" style="display:none">
<!-- 							<p class="total">총 2 건</p> -->
<!-- 							<p><span>분당ABC<em>|</em>가족이 대를 잇는 추억놀이<em>|</em></span> 2016-05-21(토) 14:00<em>|</em>참석인원 1명</p> -->
<!-- 							<p><span>분당ABC<em>|</em>신나는 ABC 마술쇼<em>|</em></span> 2016-05-14(일) 15:00(대기신청)<em>|</em>참석인원 1명</p> -->
						</div>
						
					</div>
					<%//<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
					
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
						<a href="javascript:void(0);" onclick="javascript:accessParentPage();"  class="btnBasicBL">예약현황확인</a>
					</div>
				</div>
				<!-- //예약완료 -->
			</div>
		</section>
		<!-- //content area | ### academy IFRAME End ### -->

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
