<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
var tableCnt = 0;
var sessionCnt = 0;
var productName = "";
var step1Clk = 0;

$(document.body).ready(function (){
	//카테고리 3셋팅
	setCategorytype3('F');
	$("#stepDone").hide();
	
	$("#choiceCalendar").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expBrandForm.do'/>";
	});
	
	$(".btnBasicGL").on("click", function(){

		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expBrandProgramForm.do'/>";
	});
	
});



function setCategorytype3(paramCategory2){
	step1Clk = 1;
	
	var param;
	
	
	// 브렌드 셀렉트를 선택하거나 디폴트로 브랜드 셀렉트일 경우
	if(paramCategory2 == "E0301" || paramCategory2 == "F" ){
		//디폴트 파라미터 셋팅&카테고리 3 셋팅
		param = {
			  categorytype2 : "E0301"
			, ppseq : $("#ppseq").val()
		};
		$("#categorytype2").val("E0301");
		
		$.ajaxCall({
			url: "<c:url value="/reservation/setBrandCategorytype3Ajax.do"/>"
			, type : "POST"
			, async : false
			, data: param
			, success: function(data, textStatus, jqXHR){
				var brandCategoryType3 = data.searchBrandCategoryType3;
				var html="";
				var fileKeyArray = new Array();
				var categorytype3Array = new Array();
				
				$("#appendBradnCategory").empty();
				
// 				console.log(fileKeyArray);
				
				html = "<h2 class='hide'>"+brandCategoryType3[0].categorytype2name+"</h2>";
				html += "<h3 class='pdNone2'><img src='/_ui/desktop/images/academy/h3_w020500250_02.gif' alt='브랜드 선택'></h3>";
				
				html += "<div class='programImg programImg1'>";
				html += "<span id='appendBrandImage'>";
				/* 브랜드 선택 이미지 셋팅 */
				for(var i = 0; i < brandCategoryType3.length; i++){
					
					if(brandCategoryType3[i].categorytype3 == "E030101"){
						$("#categorytype3").val(brandCategoryType3[i].categorytype3);
					}
					
					categorytype3Array.push(brandCategoryType3[i].categorytype3);
				}
				html += "</span>";
				html += "</div>";
				
				html += "<h3 class='pdNone2'><img src='/_ui/desktop/images/academy/h3_w020500290.gif' alt='프로그램 선택'></h3>";
				
				$("#appendBradnCategory").append(html);
				
				setBrandSelectImage(categorytype3Array);
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
	}else{
		param = {
			  categorytype2 : paramCategory2
			, ppseq : $("#ppseq").val()
// 			, ppSeq : $("#ppseq").val()
		};
		$("#categorytype2").val(paramCategory2);
		$("#categorytype3").val("");
		
		//프로덕트 바로 셋팅 함수 호출
	}
	
	/* 프로그램선택  리스트 셋팅(디폴트값으로  브랜드 셀랙드 일경우) */
	setProductList('F', '', '');
}

function setBrandSelectImage(categorytype3Array){
	var param = {
		 categorytype3Array : categorytype3Array
	};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/searchExpBrandProgramKeyListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandProgramKeyList = data.brandProgramKeyList;
			var html = "";
			
			$("#appendBrandImage").empty();
			
// 			console.log(brandProgramKeyList);
			
			for(var i = 0; i < brandProgramKeyList.length; i++){
// 				console.log(i);
				if(brandProgramKeyList[i].filekey == 0 || brandProgramKeyList[i].filekey == null || brandProgramKeyList[i].filekey == ""){
					
					if(brandProgramKeyList[i].categorytype3 == "E030101"){
						html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" class='active'>";
						html += "	<img src='/_ui/desktop/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
						html += "</a>";
						
					}else{
						html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" >";
						html += "	<img src='/_ui/desktop/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
						html += "</a>";
					}
				}else{
					if(brandProgramKeyList[i].categorytype3 == "E030101"){
						html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" class='active'>";
// 						html += "	<img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'>";
						html += "	<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
						html += "</a>";
						
					}else{
						html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" >";
// 						html += "	<img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'>";
						html += "	<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
						html += "</a>";
					}
					
				}
				
					
			}
			
			$("#appendBrandImage").append(html);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 프로그램 선택  셋팅*/
function setProductList(flag, categorytype3, obj){
	step1Clk = 1;
	
	/* 사용자가 클릭 할경우 */
	if(flag == "C"){
	 	$("#categorytype3").val(categorytype3);
	 	
	 	/** 테두리 활성화 */
	 	$("#appendBradnCategory").find("span").each(function(){
	 		$(this).children().removeClass("active")
			$(obj).addClass("active");
		});
		$("#appendBradnCategory").find("dl").each(function(){
			
			if($(this).is("dl") === true){
				$(this).remove();
			}
		});
	}
	
	var param = {
		  categorytype2 : $("#categorytype2").val()
		, categorytype3 : $("#categorytype3").val()
		, ppseq : $("#ppseq").val()
		, ppSeq : $("#ppseq").val()
	}
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchBrandProductListAjax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandProductList = data.searchBrandProductList;
			var html="";
			
			if(brandProductList.length == 0 || brandProductList == null || brandProductList == ""){
				alert("아직 체험이 등록되지 않았습니다. 운영자에 의해 체험이 등록 된 이후 사용 바랍니다.");
				return;
			}
			
// 			$("#ppseq").val(brandProductList[0].ppseq);
			
			/* 카테고리 3이 있을경우 카테고리 3이름 셋팅 */
			if(brandProductList[0].categorytype3name != "N"){
				html = "<h4 class='hide'>"+brandProductList[0].categorytype3name+"</h4>";	
			}else{
				/* 카테리고 3이 없을경우 카테고리 2가 이름으로 셋팅 */
				$("#appendBradnCategory").empty();
				html = "<h4 class='hide'>"+brandProductList[0].categorytype2name+"</h4>";	
				html += "<h3 class='pdNone2'><img src='/_ui/desktop/images/academy/h3_w020500290.gif' alt='프로그램 선택'></h3>";	
			}
			html += "<dl class='programItem prgSection active' id='programItem'>";
			
			/* 프로그램 이름 셋팅 */
			for(var i = 0; i < brandProductList.length; i++){
				html += "<dt><a href='javascript:void(0);'  onclick = 'javascript:selectProduct(this,"+brandProductList[i].expseq+");'>"+brandProductList[i].productname+"</a>";
				html += "<a href='javascript:void(0);' class='btn_detailView' onclick =\"javascript:showBrandIntro('D', '"+brandProductList[i].expseq+"');\">상세보기</a></dt>";
				html += "<dd></dd>";
			}
			html += "</dl>";
			$("#appendBradnCategory").append(html);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function showBrandIntro(flag, expseq){
	$("#popExpseq").val(expseq);
	
	if(flag == "P"){
		$("#expBrandIntroForm").empty();
		
		$("#expBrandIntroForm").append("<input type='hidden' id='categorytype2' name='categorytype2' value='E0301'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='categorytype3' name='categorytype3' value='E030101'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popExpseq' name='popExpseq' value='"+expseq+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popPpseq' name='popPpseq' value='"+$("#ppseq").val()+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popFlag' name='popFlag' value='"+flag+"'>");
		
		var brandFrm = document.expBrandIntroForm
	}else{
		
		$("#popFlag").val(flag);
		
		var brandFrm = document.expBrandProgramForm
	}
	var url = "<c:url value="/reservation/expBrandIntroPop.do"/>";
	var title = "expBrandProgramForm";
	var status = "toolbar=no, width=600, height=700, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	
	brandFrm.target = title;
	brandFrm.action = url;
	brandFrm.method = "post";
	brandFrm.submit();
}


/* 프로그램 선택시 테두리 활성화& 키값 세팅 */
function selectProduct(obj, expseq){
	step1Clk = 1;
	$("#expseq").val(expseq);
	var  msg = "기존에 선택하신 세션 테이블은 삭제 됩니다.";
	
	$("#programItem").children().each(function(){
		if($(this).children().is(".selected") === true){
			$(this).children().removeClass("selected");
		}
	});
	$(obj).addClass("selected");
}

/* step1에서 다음버튼 클릭시 날짜 선택 유무 확인 */
function showStep2(){
	var cnt = 0;
	var tempProductName;
// 	var productName;
	$("#programItem").children().each(function(){
			
		if($(this).children().is(".selected") === true){
			
			tempProductName = $(this).children().text();
			
			cnt ++;
		}
	});
	
	
	
	if(cnt != 0){
		/* step1 닫기 */
		$("#step1Btn").parents('.brWrap').find('.sectionWrap').stop().slideUp(function(){
			$("#step1Btn").parents('.brWrap').find('.stepTit').find('.close').show();
			$("#step1Btn").parents('.brWrap').find('.stepTit').find('.open').hide();
			
			$("#step1Btn").parents('.brWrap').find('.modifyBtn').show();
			$("#step1Btn").parents('.brWrap').find('.req').show(); //결과값 보기
			$("#step1Btn").parents('.brWrap').removeClass('current').addClass('finish');
		});

		/* step2 열기 */
		$("#step2Btn").parents('.brWrap').find('.modifyBtn').hide();
		$("#step2Btn").parents('.brWrap').find('.result').hide();
		$("#step2Btn").parents('.brWrap').find('.sectionWrap').stop().slideDown(function(){
			$("#step2Btn").parents('.brWrap').find('.stepTit').find('.close').hide();
			$("#step2Btn").parents('.brWrap').find('.stepTit').find('.open').show();
			$("#step2Btn").parents('.brWrap').removeClass('finish').addClass('current');
		});
		
		this.productName = tempProductName.slice(0, -4);
		//console.log(productName);
		
		$("#appendProduct").empty();
		$("#appendProduct").append("<p>분당ABC<em>|</em>"+this.productName+"</p>");
		
		sessionCnt = 0;
		
		if(step1Clk == 1){
			/* 패널티 정보 조회 */
			searchExpPenalty();
			searchNextYearMonth();
			nextMonthCalendar();
			
			var html = "";
			
			$("#appendToSession").children().remove();
			$("#tempResult").show();
			
			html  ="<div class='noSelectDate'>";
			html +="	<span>상단 캘린더에서 날짜를 선택해 주세요.</span>";
			html +="</div>";
			
			$("#appendToSession").append(html);
			
			step1Clk = 0;
		}
		
	}else{
		alert("프로그램을 선택해주십시오.");
		
		/* step2 열기 */
		$("#step1Btn").parents('.brWrap').find('.modifyBtn').hide();
		$("#step1Btn").parents('.brWrap').find('.result').hide();
		$("#step1Btn").parents('.brWrap').find('.sectionWrap').stop().slideDown(function(){
			$("#step1Btn").parents('.brWrap').find('.stepTit').find('.close').hide();
			$("#step1Btn").parents('.brWrap').find('.stepTit').find('.open').show();
			$("#step1Btn").parents('.brWrap').removeClass('finish').addClass('current');
		});
	}
}

function searchExpPenalty(){
	var param = {
			expseq :  $("#expseq").val()
		}
		
		$.ajaxCall({
			url: "<c:url value="/reservation/searchExpPenaltyAjax.do"/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){

			var expPenalty = data.searchExpPenalty;
			
			if(null == data.searchExpPenalty){
				$("#penaltyInfo").hide();
			}else{
				$("#penaltyInfo").show();
				$("#penaltyInfo").empty();
				$("#penaltyInfo").append("※  특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 <strong id='applyTypeValue'>"+expPenalty.applytypevalue+"일</strong>간 예약이 불가합니다.");
// 				$("#penaltyInfo").append("<li id="'penaltyInfo'>※  특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 <strong id='applyTypeValue'>2개월</strong>간 예약이 불가합니다.</li>");
			}
			
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
}

/* step2에 현재달~2개월후 월 셋팅 */
function searchNextYearMonth(){
	var param = {expseq : $("#expseq").val()};
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchNextYearMonthAjax.do"/>"
		, type : "POST"
		, data: param
		, async : false
		, success: function(data, textStatus, jqXHR){
			var setYearMonthData = data.searchNextYearMonth;
			
			/**-----------------------캘린더의 필요한 현재 년,월 파라미터  셋팅-----------------------------*/
			var getMonth;
			var getYear;
			if(setYearMonthData[0].month < 10){
				getMonth  = "0"+setYearMonthData[0].month;
				getYear = setYearMonthData[0].year;
			}else{
				getMonth  = setYearMonthData[0].month;
				getYear = setYearMonthData[0].year;
			}
			
			$("#getYear").val("");
			$("#getMonth").val("");
			
			$("#getYear").val(getYear);
			$("#getMonth").val(getMonth);
			
			$("#getYearPop").val("");
			$("#getMonthPop").val("");

			$("#getYearPop").val(getYear);
			$("#getMonthPop").val(getMonth);
			
			$("#targetcodeorder").val(setYearMonthData[0].targetcodeorder);
			
			/**-----------------------------------------------------------------------------*/
			
			/* step2에 현재달~2개월후 월 셋팅 */
			setYearMonth(setYearMonthData);
			
			getRsvAvailabilityCount();
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


/* 누적 예약 가능 횟수 (월, 주, 일) 조회 */
function getRsvAvailabilityCount() {
	var param = {
			  ppseq : $("#ppseq").val()
			, typeseq : $("#typeseq").val()
			, expseq : $("#expseq").val()
		};

		$.ajaxCall({
			url: "<c:url value='/reservation/getRsvAvailabilityCountAjax.do'/>"
			, type : "POST"
			, data : param
			, async : false
			, success: function(data, textStatus, jqXHR){
				var getRsvAvailabilityCount = data.getRsvAvailabilityCount;
				var getRsvAvailabilityCount = data.getRsvAvailabilityCount;
				
				var cnt = 0;
				
				var html = "<div class=\"hText availabilityCount\">"
					+ "<span>";
				
				if(null != getRsvAvailabilityCount){
					if(null != getRsvAvailabilityCount.ppdailycount
							&& null != getRsvAvailabilityCount.globaldailycount){
						var dailyCount = getRsvAvailabilityCount.ppdailycount > getRsvAvailabilityCount.globaldailycount ? getRsvAvailabilityCount.globaldailycount : getRsvAvailabilityCount.ppdailycount;
						html += "일 <strong>" + dailyCount + "</strong>회 ";
						cnt++;
					}else if(null == getRsvAvailabilityCount.ppdailycount
							&& null != getRsvAvailabilityCount.globaldailycount){
						html += "일 <strong>" + getRsvAvailabilityCount.globaldailycount + "</strong>회 ";
						cnt++;
					}else if(null != getRsvAvailabilityCount.ppdailycount
							&& null == getRsvAvailabilityCount.globaldailycount){
						html += "일 <strong>" + getRsvAvailabilityCount.ppdailycount + "</strong>회 ";
						cnt++;
					}
					
					if(null != getRsvAvailabilityCount.ppweeklycount
							&& null != getRsvAvailabilityCount.globalweeklycount){
						var weeklyCount = getRsvAvailabilityCount.ppweeklycount > getRsvAvailabilityCount.globalweeklycount ? getRsvAvailabilityCount.globalweeklycount : getRsvAvailabilityCount.ppweeklycount;
						html += "주 <strong>" + weeklyCount + "</strong>회 ";
						cnt++;
					}else if(null == getRsvAvailabilityCount.ppweeklycount
							&& null != getRsvAvailabilityCount.globalweeklycount){
						html += "주 <strong>" + getRsvAvailabilityCount.globalweeklycount + "</strong>회 ";
						cnt++;
					}else if(null != getRsvAvailabilityCount.ppweeklycount
							&& null == getRsvAvailabilityCount.globalweeklycount){
						html += "주 <strong>" + getRsvAvailabilityCount.ppweeklycount + "</strong>회 ";
						cnt++;
					}
					
					if(null != getRsvAvailabilityCount.ppmonthlycount
							&& null != getRsvAvailabilityCount.globalmonthlycount){
						var monthlyCount = getRsvAvailabilityCount.ppmonthlycount > getRsvAvailabilityCount.globalmonthlycount ? getRsvAvailabilityCount.globalmonthlycount : getRsvAvailabilityCount.ppmonthlycount;
						html += "월 <strong>" + monthlyCount + "</strong>회 ";
						cnt++;
					}else if(null == getRsvAvailabilityCount.ppmonthlycount
							&& null != getRsvAvailabilityCount.globalmonthlycount){
						html += "월 <strong>" + getRsvAvailabilityCount.globalmonthlycount + "</strong>회 ";
						cnt++;
					}else if(null != getRsvAvailabilityCount.ppmonthlycount
							&& null == getRsvAvailabilityCount.globalmonthlycount){
						html += "월 <strong>" + getRsvAvailabilityCount.ppmonthlycount + "</strong>회 ";
						cnt++;
					}
					
				}
				
				html += "예약가능</span>"
					+ "</div>";
					
				$(".availabilityCount").remove();
				
				if(cnt != 0){
					$(".calenderHeader").append(html);
				}else if(null == getRsvAvailabilityCount){
					$(".calenderHeader").append("<div class=\"hText availabilityCount\"></div>");
				}else{
					$(".calenderHeader").append("<div class=\"hText availabilityCount\">-</div>");
				}
				
			}
			, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
}

/* step2에 현재달~2개월후 월 셋팅 */
function setYearMonth(setYearMonthData){
	var html = "";
	
	//html += "<span class='year'><img src='/_ui/desktop/images/academy/img_2016.gif' alt="+setYearMonthData[0].year+"년/></span>";
	html += "<div class='monthlyWrap' id='viewTempMonth'>";
	for(var i = 0; i < setYearMonthData.length; i++){
		
		if(i >= 7){
			break;
		}
		
		if(i == 0){
			html += "	<span><a href='javascript:void(0);' class='"+setYearMonthData[i].engmonth+" on' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[i].year+"', '"+setYearMonthData[i].month+"');\">"+setYearMonthData[i].month+"월</a></span>";
		}else{
			html += "	<span><a href='javascript:void(0);' class='"+setYearMonthData[i].engmonth+"' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[i].year+"', '"+setYearMonthData[i].month+"');\">"+setYearMonthData[i].month+"월</a></span>";
		}
	}
	html += "</div>";
	
	html += "<div class='hText availabilityCount'>";
	html += "	<span>"+$("#getMonth").val()+"월 예약가능 잔여회수</span><strong>: <span id='remainDay'>0</span>회</strong>";
	html += "</div>";
	
	$("#getYearPop").val(setYearMonthData[0].year);
	
	if(setYearMonthData[0].month < 10){
		$("#getMonthPop").val("0"+setYearMonthData[0].month);
	}else{
		$("#getMonthPop").val(setYearMonthData[0].month);
	}
	
	$(".calenderHeader").empty();
	$(".calenderHeader").append(html);
	
// 	getRemainDayByMonth();
	
}

/* 달력table에 필요한 데이터 호출 함수 */
function nextMonthCalendar(){
	
	this.sessionCnt = 0;
	
	var param = {
		  getYear :  $("#getYear").val()
		, getMonth : $("#getMonth").val()
		, expseq : $("#expseq").val()
		, ppseq : $("#ppseq").val()
		, ppSeq : $("#ppseq").val()
	};
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchNextMonthProgramCalendarAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
		
			/* 다음달 날짜 리스트 */
			var calList = data.nextMonthCalendar;
			
			/* 캘린더에 해당 pp의 휴무일의 정보를 담기 위한 휴무일 데이터 */
			var holiDayList = data.expHealthHoliDayList;
			
			var rsvAbleSession = data.searchRsvProgramAbleSessionList;
		
			/* 다음달 캘린더를 그리는 함수 호출 */
			gridNextMonth(calList, holiDayList);
			
			/* 달력상에 예약가능 아이콘 표현 */
			setRsvAbleSession(rsvAbleSession);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 다음달 캘린더를 그리는 함수 호출 */
function gridNextMonth(calList, holiDayList){
	
	var html = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	
	
	$("#montCalTbody").empty();
	
	for(var i = 0; i < calList.length; i++){
		html += "<tr>"
		html += "		<td class='weekSun'><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekSun+"' onclick=\"javascript:selectOnCal('"+calList[i].weekSun+"');\">"+calList[i].weekSun.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekMon+"' onclick=\"javascript:selectOnCal('"+calList[i].weekMon+"');\">"+calList[i].weekMon.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekTue+"' onclick=\"javascript:selectOnCal('"+calList[i].weekTue+"');\">"+calList[i].weekTue.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekWed+"' onclick=\"javascript:selectOnCal('"+calList[i].weekWed+"');\">"+calList[i].weekWed.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekThur+"' onclick=\"javascript:selectOnCal('"+calList[i].weekThur+"');\">"+calList[i].weekThur.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekFri+"' onclick=\"javascript:selectOnCal('"+calList[i].weekFri+"');\">"+calList[i].weekFri.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class='weekSat'><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekSat+"' onclick=\"javascript:selectOnCal('"+calList[i].weekSat+"');\">"+calList[i].weekSat.replace(/(^0+)/, "");+"</a></td>"
		html += "</tr>";
	}
	$("#montCalTbody").append(html);
	
	/* 캘린더 상에 휴무일 표현  */
	calendarSetData(holiDayList);
// 	getRemainDayByMonth();
}


/* 잔여일 표시 - 달력의 '월'을 클릭 후 우상단에 남은 잔여일을 쿼리 하는 기능 */
function getRemainDayByMonth(){
	var param = {
		  reservationdate : $("#getYear").val() + $("#getMonth").val() + "01"
		, rsvtypecode : "R02"
		, ppseq : $("#ppseq").val()
		, typeseq : $("#typeseq").val()
		, expseq : $("#expseq").val()
	};

	$.ajaxCall({
		url: "<c:url value='/reservation/getRemainDayByMonthAjax.do'/>"
		, type : "GET"
		, data : param
		, async : false
		, success: function(data, textStatus, jqXHR){
			if(data){
				$("#remainDay").empty();
				$("#remainDay").append(data.remainDay);
			}else{
				$("#remainDay").empty();
				$("#remainDay").append("0");
			}
		}
		, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});		
}


/* 캘린더 상에 휴무일 표현  */
function calendarSetData(holiDayList){
	
	//console.log(holiDayList);
	
	var html = "";
	var tempI = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	for(var i = 1; i < 32; i++){
		if(i < 10){
			tempI = "0"+i;
		}else{
			tempI = i;
		}
		for(var j = 0; j < holiDayList.length; j++){
			if($("#cal"+yymm+tempI).text().replace(/\s/gi, '') == Number(holiDayList[j].setdate)){
				
				$("#cal"+yymm+tempI).parent().addClass("late");
				$("#cal"+yymm+tempI).removeAttr("onclick");
				html = "<span><em>휴무</em></span>";
				
				$("#cal"+yymm+tempI).append(html);
				
				sessionCnt++;
			}
		}
	}
}

/* 달력 상에 날짜 클릭시 테두리 활성화&비활성화 */
function selectOnCal(date){
	var tempDate = date;
	var year = $("#getYear").val();
	var month = $("#getMonth").val();
	
	/* 데이터가 없을 경우  */
	if( date == ""){
		return false;
	}else{
		
		/* 캘린더에서 날짜가  이미 선택이 된 경우  해당 날짜의 세션과 캘린의 선택을 지워줌 */
		if($("#cal"+year+month+date).attr("class") == "selcOn"){
			$("#cal"+year+month+date).removeAttr("class");
			$("#"+year+month+tempDate).remove();
			
			if($("#appendToSession").children("table").length == 0){
				$(".noSelectDate").show();
			}
			
		/* 캘린더에 새로운 날짜를 선택한 경우 */
		}else{
			$("#cal"+year+month+date).attr("class", "selcOn");
			$(".brSessionWrap").show();
			
			$(".noSelectDate").hide();
			
			/* 선택 날짜의 세션 정보 상세보기 */
			showSession(tempDate, year, month);
		}
	}
}

/* 선택 날짜의 세션 정보 상세보기 */
function showSession(tempDate, year, month){
	var param = {
		  getYear : year
		, getMonth : month
		, getDay : tempDate
		, expseq : $("#expseq").val()
		, expSeq : $("#expseq").val()
	}
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchProgramSessionListAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
		
			/* 해당 일자의 세션 리스트 */
			var programSessionList = data.searchProgramSessionList;
			
			/* 선택된 날짜의 세션정보 그리기 */
			gridProgramSessionTable(programSessionList);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 프로그램의 해당 일자의 세션 테이블 그림 */
function gridProgramSessionTable(programSessionList){
	//console.log(programSessionList);
	
	var html = "";
	var tempExpSessionSeq;
	var tempWorkTypeCode;
	var tempSetTypeCode;
	
	
	if(tableCnt == 0){
		html  = "<table class='tblProgram mgNone' id ='"+programSessionList[0].ymd+"'>";
	}else{
		html  = "<table class='tblProgram' id ='"+programSessionList[0].ymd+"'>";
	}
	html += "	<caption>시간 선택</caption>";
	html += "	<colgroup>";
	html += "		<col style='width:20%'>";
	html += "		<col style='width:auto'>";
	html += "		<col style='width:25%'>";
	html += "	</colgroup>";
	html += "	<thead>";
	html += "		<tr>";
	html += "			<th scope='col' colspan='3'>"+programSessionList[0].setdateformat+' '+programSessionList[0].korweek+"<a href='#none' class='btnDel' onclick='javascript:deleteSessionDetail(this)'>삭제</a></th>";
	html += "		</tr>";
	html += "	</thead>";
	html += "	<tbody>";
	
// 	console.log(programSessionList[0].seatcount1);
	
	for(var j = 0; j < programSessionList.length; j++){
		
		if(j == 0){
// 			tempExpSessionSeq = programSessionList[j].expsessionseq;
// 			tempWorkTypeCode = programSessionList[j].worktypecode;
			tempSetTypeCode = programSessionList[j].settypecode;
		}
		
		if(programSessionList[j].settypecode == tempSetTypeCode){
		//i가 0 -> 개별, i가1 -> 그룹 
// 		for(var i = 0; i <= 1; i++){
			
				
// 			if(i == 0){
// 			console.log(programSessionList[j].seatcount1);
			if(programSessionList[j].seatcount1 != null && programSessionList[j].seatcount1 != "" ){
				//예약가능
				if(programSessionList[j].rsvflag == 100){
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' title='개별'> 개별</td>";
					html += "	<td>"+programSessionList[j].sessiontime;
					html += "	<input type='hidden' name='tempPpSeq' value='"+$("#ppseq").val()+"'>";
					html += "	<input type='hidden' name='tempExpSessionSeq' value='"+programSessionList[j].expsessionseq+"'>";
					html += "	<input type='hidden' name='tempExpSeq' value='"+programSessionList[j].expseq+"'>";
					html += "	<input type='hidden' name='tempReservationDate' value='"+programSessionList[j].ymd+"'>";
					html += "	<input type='hidden' name='tempSessionTime' value='"+programSessionList[j].sessiontime+"'>";
					html += "	<input type='hidden' name='tempSetDateFormat' value='"+programSessionList[j].setdateformat+"'>";
					html += "	<input type='hidden' name='tempKorWeek' value='"+programSessionList[j].korweek+"'>";
					html += "	<input type='hidden' name='tempAccountType' value='A01'>";
					html += "	<input type='hidden' name='tempRsvFlag' value='"+programSessionList[j].rsvflag+"'>";
					html += "	<input type='hidden' name='tempProductName' value='"+programSessionList[j].productname+"'>";
					html += "	<input type='hidden' name='tempStartDateTime' value='"+programSessionList[j].startdatetime+"'>";
					html += "	<input type='hidden' name='tempEndDateTime' value='"+programSessionList[j].enddatetime+"'>";
					html += "	</td>";
					html += "	<td class='able'>예약가능</td>";
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 200){
				//대기신청
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"'  name='chkBox' title='개별'> 개별</td>";
					html += "	<td>"+programSessionList[j].sessiontime;
					html += "	<input type='hidden' name='tempPpSeq' value='"+$("#ppseq").val()+"'>";
					html += "	<input type='hidden' name='tempExpSessionSeq' value='"+programSessionList[j].expsessionseq+"'>";
					html += "	<input type='hidden' name='tempExpSeq' value='"+programSessionList[j].expseq+"'>";
					html += "	<input type='hidden' name='tempReservationDate' value='"+programSessionList[j].ymd+"'>";
					html += "	<input type='hidden' name='tempSessionTime' value='"+programSessionList[j].sessiontime+"'>";
					html += "	<input type='hidden' name='tempSetDateFormat' value='"+programSessionList[j].setdateformat+"'>";
					html += "	<input type='hidden' name='tempKorWeek' value='"+programSessionList[j].korweek+"'>";
					html += "	<input type='hidden' name='tempAccountType' value='A01'>";
					html += "	<input type='hidden' name='tempRsvFlag' value='"+programSessionList[j].rsvflag+"'>";
					html += "	<input type='hidden' name='tempProductName' value='"+programSessionList[j].productname+"'>";
					html += "	<input type='hidden' name='tempStartDateTime' value='"+programSessionList[j].startdatetime+"'>";
					html += "	<input type='hidden' name='tempEndDateTime' value='"+programSessionList[j].enddatetime+"'>";
					html += "	</td>";
					html += "	<td>대기신청</td>";
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 300){
				//예약마감
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"'  name='chkBox' title='개별' disabled> 개별</td>";
					html += "	<td>"+programSessionList[j].sessiontime;
					html += "	<input type='hidden' name='tempPpSeq' value='"+$("#ppseq").val()+"'>";
					html += "	<input type='hidden' name='tempExpSessionSeq' value='"+programSessionList[j].expsessionseq+"'>";
					html += "	<input type='hidden' name='tempExpSeq' value='"+programSessionList[j].expseq+"'>";
					html += "	<input type='hidden' name='tempReservationDate' value='"+programSessionList[j].ymd+"'>";
					html += "	<input type='hidden' name='tempSessionTime' value='"+programSessionList[j].sessiontime+"'>";
					html += "	<input type='hidden' name='tempSetDateFormat' value='"+programSessionList[j].setdateformat+"'>";
					html += "	<input type='hidden' name='tempKorWeek' value='"+programSessionList[j].korweek+"'>";
					html += "	<input type='hidden' name='tempAccountType' value='A01'>";
					html += "	<input type='hidden' name='tempRsvFlag' value='"+programSessionList[j].rsvflag+"'>";
					html += "	<input type='hidden' name='tempProductName' value='"+programSessionList[j].productname+"'>";
					html += "	<input type='hidden' name='tempStartDateTime' value='"+programSessionList[j].startdatetime+"'>";
					html += "	<input type='hidden' name='tempEndDateTime' value='"+programSessionList[j].enddatetime+"'>";
					html += "	</td>";
					html += "	<td>예약마감</td>";
					html += "</tr>";
				}
			}else{
				//예약가능
				if(programSessionList[j].rsvflag == 100){
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"'  name='chkBox' title='그룹'  onclick='javascript:pinCheck(this);'> 그룹</td>";
					html += "	<td>"+programSessionList[j].sessiontime;
					html += "	<input type='hidden' name='tempPpSeq' value='"+$("#ppseq").val()+"'>";
					html += "	<input type='hidden' name='tempExpSessionSeq' value='"+programSessionList[j].expsessionseq+"'>";
					html += "	<input type='hidden' name='tempExpSeq' value='"+programSessionList[j].expseq+"'>";
					html += "	<input type='hidden' name='tempReservationDate' value='"+programSessionList[j].ymd+"'>";
					html += "	<input type='hidden' name='tempSessionTime' value='"+programSessionList[j].sessiontime+"'>";
					html += "	<input type='hidden' name='tempSetDateFormat' value='"+programSessionList[j].setdateformat+"'>";
					html += "	<input type='hidden' name='tempKorWeek' value='"+programSessionList[j].korweek+"'>";
					html += "	<input type='hidden' name='tempAccountType' value='A02'>";
					html += "	<input type='hidden' name='tempRsvFlag' value='"+programSessionList[j].rsvflag+"'>";
					html += "	<input type='hidden' name='tempProductName' value='"+programSessionList[j].productname+"'>";
					html += "	<input type='hidden' name='tempStartDateTime' value='"+programSessionList[j].startdatetime+"'>";
					html += "	<input type='hidden' name='tempEndDateTime' value='"+programSessionList[j].enddatetime+"'>";
					html += "	</td>";
					html += "	<td class='able'>예약가능</td>";
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 200){
				//대기신청
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"'  name='chkBox' title='그룹'  onclick='javascript:pinCheck(this);'> 그룹</td>";
					html += "	<td>"+programSessionList[j].sessiontime;
					html += "	<input type='hidden' name='tempPpSeq' value='"+$("#ppseq").val()+"'>";
					html += "	<input type='hidden' name='tempExpSessionSeq' value='"+programSessionList[j].expsessionseq+"'>";
					html += "	<input type='hidden' name='tempExpSeq' value='"+programSessionList[j].expseq+"'>";
					html += "	<input type='hidden' name='tempReservationDate' value='"+programSessionList[j].ymd+"'>";
					html += "	<input type='hidden' name='tempSessionTime' value='"+programSessionList[j].sessiontime+"'>";
					html += "	<input type='hidden' name='tempSetDateFormat' value='"+programSessionList[j].setdateformat+"'>";
					html += "	<input type='hidden' name='tempKorWeek' value='"+programSessionList[j].korweek+"'>";
					html += "	<input type='hidden' name='tempAccountType' value='A02'>";
					html += "	<input type='hidden' name='tempRsvFlag' value='"+programSessionList[j].rsvflag+"'>";
					html += "	<input type='hidden' name='tempProductName' value='"+programSessionList[j].productname+"'>";
					html += "	<input type='hidden' name='tempStartDateTime' value='"+programSessionList[j].startdatetime+"'>";
					html += "	<input type='hidden' name='tempEndDateTime' value='"+programSessionList[j].enddatetime+"'>";
					html += "	</td>";
					html += "	<td>대기신청</td>";
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 300){
				//예약마감
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"'  name='chkBox' title='그룹'  onclick='javascript:pinCheck(this);' disabled> 그룹</td>";
					html += "	<td>"+programSessionList[j].sessiontime;
					html += "	<input type='hidden' name='tempPpSeq' value='"+$("#ppseq").val()+"'>";
					html += "	<input type='hidden' name='tempExpSessionSeq' value='"+programSessionList[j].expsessionseq+"'>";
					html += "	<input type='hidden' name='tempExpSeq' value='"+programSessionList[j].expseq+"'>";
					html += "	<input type='hidden' name='tempReservationDate' value='"+programSessionList[j].ymd+"'>";
					html += "	<input type='hidden' name='tempSessionTime' value='"+programSessionList[j].sessiontime+"'>";
					html += "	<input type='hidden' name='tempSetDateFormat' value='"+programSessionList[j].setdateformat+"'>";
					html += "	<input type='hidden' name='tempKorWeek' value='"+programSessionList[j].korweek+"'>";
					html += "	<input type='hidden' name='tempAccountType' value='A02'>";
					html += "	<input type='hidden' name='tempRsvFlag' value='"+programSessionList[j].rsvflag+"'>";
					html += "	<input type='hidden' name='tempProductName' value='"+programSessionList[j].productname+"'>";
					html += "	<input type='hidden' name='tempStartDateTime' value='"+programSessionList[j].startdatetime+"'>";
					html += "	<input type='hidden' name='tempEndDateTime' value='"+programSessionList[j].enddatetime+"'>";
					html += "	</td>";
					html += "	<td>예약마감</td>";
					html += "</tr>";
				}
			}
// 		}
		}
	}
	
	html += "	</tbody>";
	html += "</table>";
	$("#appendToSession").append(html)
	tableCnt ++;
	
	
}

/* 세션 삭제 */
function deleteSessionDetail(obj){
	
	if($("#appendToSession").children("table").length == 1){
		$(".noSelectDate").show();
	}
	
	/* 세션 테이블에 id값 가져오기  */
	var selectedDate = $(obj).parent().parent().parent().parent().attr("id");
	
	/* 달력상에 테듀리 삭제  */
	$("#cal"+selectedDate).removeAttr("class");
	/* 세션 테이블 삭제 */
	$(obj).parent().parent().parent().parent().remove();
	
}


/* 달력상에 예약가능 아이콘 표현 */
function setRsvAbleSession(rsvAbleSession){
	var tempDate;
	var html = "";
	var yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	var tempGetYmd;
	var tempWorkTypeCode;
	var tempSetTypeCode;
	
	if(rsvAbleSession.length == 0){
		$("#montCalTbody").find("td").each(function(){
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
			
		});
		
		var months = $(".monthlyWrap > span").length;
		
        if( 1 < months ) {
			msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
		
		alert(msg);
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		return false;
	}
	
	
	$("#getDayPop").val(rsvAbleSession[0].gettoday.substr(6,2));
	
	for(var i = 0; i < rsvAbleSession.length; i++){
		
		if(tempGetYmd != rsvAbleSession[i].getymd){
			tempGetYmd = rsvAbleSession[i].getymd;
			tempWorkTypeCode = rsvAbleSession[i].worktypecode;
			tempSetTypeCode = rsvAbleSession[i].settypecode;
		}
		
// 		console.log(rsvAbleSession[i].seatcount1.length);
// 		console.log(rsvAbleSession[i].seatcount1);
		
		if(tempSetTypeCode == rsvAbleSession[i].settypecode){
		
// 		if(rsvAbleSession[i].gettoday < rsvAbleSession[i].getymd && rsvAbleSession[i].getymd != tempDate && $("#cal"+rsvAbleSession[i].getymd).children("span").text() == ""){
		if(rsvAbleSession[i].getymd != tempDate && $("#cal"+rsvAbleSession[i].getymd).children("span").text() == ""){
			if(rsvAbleSession[i].rsvsessiontotalcnt != 0){
				
				if(rsvAbleSession[i].seatcount1 != null && rsvAbleSession[i].seatcount1 != ""){
					html = "<span>";
					html += "	<span class='calIcon2 personal'><em>개별</em></span>";
// 					html += "	<span class='calIcon2 group'><em>그룹</em></span>";
					html += "</span>";
					$("#cal"+rsvAbleSession[i].getymd).append(html);
					
					tempDate = rsvAbleSession[i].getymd;
				}else{
					
					html = "<span>";
// 					html += "	<span class='calIcon2 personal'><em>개별</em></span>";
					html += "	<span class='calIcon2 group'><em>그룹</em></span>";
					html += "</span>";
					$("#cal"+rsvAbleSession[i].getymd).append(html);
					
					tempDate = rsvAbleSession[i].getymd;

				}
			
				
			}else if(rsvAbleSession[i].rsvsessiontotalcnt == 0 && rsvAbleSession[i].gettoday <= rsvAbleSession[i].getymd){
				
				if(rsvAbleSession[i].totalsessioncnt == 0){
					$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
					$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
					
					sessionCnt ++;
				}else{
					html = "<span><em>예약마감</em></span>";
					$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
					$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
					$("#cal"+rsvAbleSession[i].getymd).append(html);
				}
				
			}else{
				$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
				$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
				
				sessionCnt ++;
			}
// 		}else if(rsvAbleSession[i].gettoday >= rsvAbleSession[i].getymd){
		}else{
			$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
			$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
			
			sessionCnt ++;
		}
		}
	}
	
	$("#montCalTbody").find("td").each(function(){
		if($(this).find("span").length == 0){
// 			console.log($(this).find("em").length);
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
		}
		
	});
	
		
	if(sessionCnt == Number(rsvAbleSession[0].getlastday)){
		
		var months = $(".monthlyWrap > span").length;
		
        if( 1 < months ) {
			msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
		
		alert(msg);

		return true;
	}
}

/* step2애서 월 변경시 날짜 포맷팅  */
function changeMonth(obj, year, month){
	
	sessionCnt = 0;
	
	var remainDayHtml="";
	var  msg = "해당월에 선택된 세션리스트는 삭제됩니다.";
	if($("#appendToSession").children().length != 1){
		
		if(confirm(msg) == true){
			var html = "";
			
			$("#appendToSession").children().remove();
			
			/* 파라미터로 쓰일 년월 초기화 */
			$("#getYear").val("");
			$("#getMonth").val("");
			
			if(month < 10){
				$("#getMonth").val("0"+month);
				$("#getYear").val(year);
			}else{
				$("#getYear").val(year);
				$("#getMonth").val(month);
			}
			
			
			/* 기존 월에 on을 지우기 */
			$("#viewTempMonth").each(function(){
				if($(this).children().children().is(".on") === true){
					$(this).children().children().removeClass("on");
				}
			});
			
			/* 새로 클릭한 월에 on걸기 */
			$(obj).addClass("on");
			
			html  ="<div class='noSelectDate'>";
			html +="	<span>상단 캘린더에서 날짜를 선택해 주세요.</span>";
			html +="</div>";
			
			$("#appendToSession").append(html);

			/* 달력을 그려주는 함수 호출 */
			nextMonthCalendar();
		}else{
			return false;
		}
	}else{
		/* 선택된 세션이 이 없을경우  */
		
		/* 선택된 세션이 없음  */
		$("#getYear").val("");
		$("#getMonth").val("");
		
		if(month < 10){
			$("#getMonth").val("0"+month);
			$("#getYear").val(year);
		}else{
			$("#getYear").val(year);
			$("#getMonth").val(month);
		}
		
		$("#viewTempMonth").each(function(){
			if($(this).children().children().is(".on") === true){
				$(this).children().children().removeClass("on");
			}
		});
		$(obj).addClass("on");

		$(".hText").empty();
		
		remainDayHtml = "	<span>"+$("#getMonth").val()+"월 예약가능 잔여회수</span><strong>: <span id='remainDay'>0</span>회</strong>";
		$(".hText").append(remainDayHtml);
		
// 		getRemainDayByMonth()
		
		/* 달력을 그려주는 함수 호출 */
		nextMonthCalendar();
		
		getRsvAvailabilityCount();
	}
	
}
	
/* 예약 정보 확인 팝업 호출  */
function reservationReq(){
	var cnt = 0;
	
	$("#expBrandProgramReqForm").empty();
	$("#checkLimitCount").empty();
	
	$("input[name='chkBox']:checked").each(function(){
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='ppSeq' value ='"+$(this).parent().next().find("input[name='tempPpSeq']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='expsessionseq' value ='"+$(this).parent().next().find("input[name='tempExpSessionSeq']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='expseq' value ='"+$(this).parent().next().find("input[name='tempExpSeq']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='reservationDate' value ='"+$(this).parent().next().find("input[name='tempReservationDate']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='sessionTime' value ='"+$(this).parent().next().find("input[name='tempSessionTime']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='setDateFormat' value ='"+$(this).parent().next().find("input[name='tempSetDateFormat']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='korWeek' value ='"+$(this).parent().next().find("input[name='tempKorWeek']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='accountType' value ='"+$(this).parent().next().find("input[name='tempAccountType']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='rsvflag' value ='"+$(this).parent().next().find("input[name='tempRsvFlag']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='productName' value ='"+$(this).parent().next().find("input[name='tempProductName']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='startdatetime' value ='"+$(this).parent().next().find("input[name='tempStartDateTime']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='enddatetime' value ='"+$(this).parent().next().find("input[name='tempEndDateTime']").val()+"'>");
		
		$("#checkLimitCount").append("<input type= 'hidden' name = 'reservationDate' value = '"+$(this).parent().next().find("input[name='tempReservationDate']").val()+"'>");
		$("#checkLimitCount").append("<input type= 'hidden' name = 'typeSeq' value = '"+$("#typeseq").val()+"'>");

		cnt++;
	});
	
	if(cnt == 0){
		alert("세션을 선택해 주십시오.");
	}else{
		
		/* 패널티 유효성 중간 검사 */
		if(middlePenaltyCheck()){
			/* 누적 예약 잔여 횟수 유효성 검사 */
			checkLimitCount();
		}
		
	}
	
}

function checkLimitCount(){
	
	$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeseq\" value=\""+$("#typeseq").val()+"\">");
	$("#checkLimitCount").append("<input type=\"hidden\" name=\"ppseq\" value=\""+$("#ppseq").val()+"\">");
	$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+$("#expseq").val()+"\">");
	
// 	console.log($("#checkLimitCount"));
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/rsvAvailabilityCheckAjax.do'/>"
		, type : "POST"
		, data: $("#checkLimitCount").serialize()
		, success: function(data, textStatus, jqXHR){
		if(data.rsvAvailabilityCheck){
			
			duplicateCheck();
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		}else{
			alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
		}

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

function duplicateCheck(){
	var url = "";
	if("A01" == $("input[name=accountType]").val()){
		url = "<c:url value='/reservation/expBrandCalendarIndividualDuplicateCheckAjax.do'/>"
	}else{
		url = "<c:url value='/reservation/expBrandCalendarGroupDuplicateCheckAjax.do'/>"
	}
	var param = $("#expBrandProgramReqForm").serialize();
	
	$.ajaxCall({
		url: url
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var cancelDataList = data.cancelDataList;
			
			if(cancelDataList.length == 0){
				/* 예약정보 확인 팝업 */
				expBrandProgramRsvRequestPop();
			}else{
				/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
				expBrandDisablePop(cancelDataList);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function expBrandProgramRsvRequestPop(){
	/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
	var frm = document.expBrandProgramReqForm
	var url = "<c:url value="/reservation/expBrandProgramRsvRequestPop.do"/>";
	var title = "expBrandRequestPop";
	var status = "toolbar=no, width=650, height=500, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 예약불가 알림 팝업(중복체크) */
function expBrandDisablePop(cancelDataList) {
	var url = "<c:url value='/reservation/expBrandCalendarDisablePop.do'/>";
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

/* 예약정보 등록후 팝업창에서 등록된 데이터 리턴받음 */
function expBrandProgramRsvDetail(expBrandProgramList, totalCnt){
	
	//console.log(expBrandProgramList);
	
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	/* show box & hide box */
	var $brWrap = $("#step2Btn").parents('.brWrap');
	var stepTit = $brWrap.find('.stepTit');
	var result = $brWrap.find('.result');
	
	$("#stepDone").show();
	
	$brWrap.find('.sectionWrap').stop().slideUp(function(){
		$brWrap.find(stepTit).find('.close').show();
		$brWrap.find(stepTit).find('.open').hide();
		
		$brWrap.find('.modifyBtn').show();
		$brWrap.find('.req').show(); //결과값 보기
		$brWrap.removeClass('current').addClass('finish');
	});
	
	$("#expBrandConfrirm").empty();
	$("#expBrandConfrirm").append("<p class='total'>총  "+totalCnt+" 건</p>");
	
	var snsHtml = "[한국암웨이]시설/체험 예약내역 (총 "+totalCnt+"건) \n";
	
	for(var i = 0; i < expBrandProgramList.length; i++){
		var html = "";
		
		
		//개인
		if(expBrandProgramList[i].accountType == "A01"){
			//파트너 타입코드
			if(expBrandProgramList[i].partnerTypeCode == "R01"){
				
				//예약 가능
				if(expBrandProgramList[i].rsvflag == "100" && expBrandProgramList[i].standbynumber == "0"){
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"<em>|</em>ABO동반</p>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime
							+ "| ABO동반\n";
					
				}else{
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"(대기신청)<em>|</em>ABO동반</p>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime + "(대기신청)"
							+ "| ABO동반\n";
				}
			}else if(expBrandProgramList[i].partnerTypeCode == "R02"){
				//예약 가능
				if(expBrandProgramList[i].rsvflag == "100" && expBrandProgramList[i].standbynumber == "0"){
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"<em>|</em>일반인동반</p>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime
							+ "| 일반인동반\n";
					
				}else{
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"(대기신청)<em>|</em>일반인동반</p>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime + "(대기신청)"
							+ "| 일반인동반\n";
				}
			}else if(expBrandProgramList[i].partnerTypeCode == "R03"){
				if(expBrandProgramList[i].rsvflag == "100" && expBrandProgramList[i].standbynumber == "0"){
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"<em>|</em>비동반</p>";

					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime
							+ "| 비동반\n";
					
				}else{
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"(대기신청)<em>|</em>비동반</p>";

					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime + "(대기신청)"
							+ "| 비동반\n";
				}
			}
			$("#expBrandConfrirm").append(html);
		}else{
		// 그룹
			if(expBrandProgramList[i].rsvflag == "100"){
				html += "<p class='program'><span class='t'>그룹</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"</p>";
				
				snsHtml += "■ 그룹   분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime + "\n";
				
			}else{
				html += "<p class='program'><span class='t'>그룹</span><em>|</em>"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek+"<em>|</em>"+expBrandProgramList[i].sessionTime+"(대기신청)</p>";
				
				snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandProgramList[i].setDateFormat+expBrandProgramList[i].korWeek + "| \n" + expBrandProgramList[i].sessionTime + "(대기신청) \n";
			}
			$("#expBrandConfrirm").append(html);
		}
	}
	
	$("#snsText").empty();
	$("#snsText").val(snsHtml);
}

function stepPre(){
// 	var msg = "이전 버튼 클릭시 선택된 세션 정보는 삭제 됩니다.";
	
// 	if($("#appendToSession").children().length != 1){
// 		if(confirm(msg) == true){
// 			var html = "";
			
// 			$("#appendToSession").children().remove();
// 			$("#tempResult").show();
			
// 			html  ="<div class='noSelectDate'>";
// 			html +="	<span>상단 캘린더에서 날짜를 선택해 주세요.</span>";
// 			html +="</div>";
			
// 			$("#appendToSession").append(html);
			
// 		}else{
// 			return false;
// 		}
// 	}
}


function viewRsvConfirm(){
	
	var frm = document.expBrandProgramForm
	var url = "<c:url value="/reservation/expHealthRsvConfirmPop.do"/>";
	var title = "testpop";
	var status = "toolbar=no, width=754, height=900, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

function pinCheck(obj){
	var msg = "PT이상부터 그룹신청이 가능합니다.";
	if(3 > Number($("#targetcodeorder").val())){
		alert(msg);
		
		$(obj).attr("checked", false);
		
		return false;
	}
}

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 브랜드 체험 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}


/* 예약 현황 확인 페이지 이동 */
function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}
</script>
</head>
<body>
<form id="expBrandProgramForm" name="expBrandProgramForm" method="post">
	<input type="hidden" id="categorytype2" name="categorytype2">
	<input type="hidden" id="categorytype3" name="categorytype3">
	<input type="hidden" id="expseq" name="expseq">
	<input type="hidden" id="popExpseq" name="popExpseq">
	<input type="hidden" id="ppseq" name="ppseq" value="${searchBrandPpInfo.ppseq}">
	<input type="hidden" id="popPpseq" name="popPpseq" value="${searchBrandPpInfo.ppseq}">
	<input type="hidden" id="typeseq" name="typeseq" value="${searchBrandPpInfo.typeseq}">
	<input type="hidden" id="popFlag" name="popFlag">
	<input type="hidden" id="targetcodeorder" name="targetcodeorder">
	<input type="hidden" id="transactionTime" value="" />
	
	<input type="hidden" id="getYear" name="getYear">
	<input type="hidden" id="getMonth" name="getMonth">
	<input type="hidden" id="getDay" name="getDay">
	
	<input type="hidden" id="getMonthPop" name="getMonthPop">
	<input type="hidden" id="getYearPop" name="getYearPop">
	<input type="hidden" id="getDayPop" name="getDayPop">
</form>
<form id="expBrandProgramReqForm" name="expBrandProgramReqForm" method="post"></form>
<form id="expBrandIntroForm" name="expBrandIntroForm" method="post"></form>
<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
<form id="cancelList" name="cancelList" method="post"></form>

<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">

	<input type="hidden" id="snsText" name="snsText">

	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500220.gif" alt="브랜드체험 예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500220.gif" alt="암웨이 브랜드 체험센터 에서 진행하는 브랜드 체험을 예약하실 수 있습니다."></p>
	</div>
	<div class="brIntro">
		<!-- @edit 20160701 인트로 토글 링크영역 변경 -->
		<h2 class="hide">브랜드체험 예약 필수 안내</h2>
		<a href="#uiToggle_01" class="toggleTitle"><strong>브랜드체험 예약 필수 안내</strong> <span class="btnArrow"><em class="hide">내용보기</em></span></a>
		<div id="uiToggle_01" class="toggleDetail"> <!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</div>
	<div class="tabWrap">
		<span class="hide">탭 메뉴</span>
		<ul class="tabDepth1 widthL">
			<li><a href="javascript:void(0);" id="choiceCalendar">날짜 먼저선택</a></li>
			<li class="on"><strong>프로그램 먼저선택</strong></li>
		</ul>
		<span class="btnR"><a href="#none" class="btnCont" onclick ="javascript:showBrandIntro('P', '')"><span>브랜드체험 소개</span></a></span>
	</div>
	<div class="brWrapAll">
		<span class="hide">브랜드체험 예약 스텝</span>
		<!-- 스텝1 -->
		<div class="brWrap current" id="step1">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_apexp_05.gif" alt="Step1/프로그램"></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_apexp_05_current.gif" alt="Step1/프로그램-프로그램을 선택하세요."></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="programWrap" style="display: block;">
						<!-- @edit 20160707 전반적인 수정 -->
						<div class="hWrap">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w020500250_01.gif" alt="브랜드 카테고리 선택"></h3>
						</div>
						<div class="brselectArea" id="appendCategoryType2">
							<c:if test="${brandCategoryType2 ne '' || brandCategoryType2 ne null}">
								<c:forEach var="item" items="${brandCategoryType2}">
									<a href="#" ${item.categorytype2 == "E0301" ? "class='on'" : ""} onclick="javascript:setCategorytype3('${item.categorytype2}');">${item.categorytype2name}</a>
								</c:forEach>
							</c:if>
						</div>
						
						<div class="" id="appendBradnCategory" style="display: block;">

						</div>
						<!-- // 20160707 전반적인 수정 -->
					</section>
					<div class="btnWrapR">
						<a href="javascript:void(0);" id="step1Btn" class="btnBasicBS" onclick="javscript:showStep2();">다음</a>
					</div>
				</div>
				<div class="result req" id="appendProduct">
<!-- 					<p>분당ABC<em>|</em>우리아이 식생활 변화 브로젝트1 (키 성장)</p> -->
				</div>
			</div>
			
			<%//<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기"></a></div> %>
			
		</div>
		<!-- //스텝1 -->
		<!-- 스텝2 -->
		<div class="brWrap" id="step2">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_apexp_02.gif" alt="Step2/날짜,시간"></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_apexp_02_current.gif" alt="Step2/날짜,시간-날짜를 선택하세요."></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<!-- @edit 20160627 그룹/개별 아이콘표시, bizroomStateBox 클래스 추가 -->
					<section class="calenderBookWrap">
						<div class="hWrap">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_04.gif" alt="날짜선택"></h3>
							<span class="btnR"><a href="#" title="새창 열림" class="btnCont" onclick="javascript:viewRsvConfirm();"><span>체험예약 현황확인</span></a></span>
						</div>
						<!-- 1월 jan, 2월 feb, 3월 mar, 4월 apr, 5월 may, 6월 june, 7월 july, 8월 aug, 9월 sep, 10월 oct, 11월 nov, 12월 dec -->
						<div class="calenderHeader">

						</div>
						<table class="tblBookCalendar">
							<caption>캘린더형 - 날짜별 체험예약가능 시간</caption>
							<colgroup>
								<col style="width:15%" span="2">
								<col style="width:14%" span="5">
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
							<tbody id="montCalTbody">
								
							</tbody>
						</table>
						<div class=" tblCalendarBottom">
							<div class="orderState"> 
								<span class="calIcon2 personal"></span>개별
								<span class="calIcon2 group"></span>그룹
								<!-- @edit 20160701 툴팁 제거/텍스트로 변경 -->
								<span class="fcG">(개별/그룹 예약가능 아이콘 표시)</span>
							</div>
						</div>
						<!-- //@edit 20160627 그룹/개별 아이콘표시 -->
						<ul class="listWarning">
							<li>※ 날짜를 선택하시면 예약가능 시간을 확인 할 수 있습니다.</li>
<!-- 							<li>※ 예약은 월 5회까지 가능합니다.</li> -->
						</ul>
					</section>
					<section class="brSessionWrap">
						<h3><img src="/_ui/desktop/images/academy/h3_w02_apexp_01.gif" alt="시간 선택"></h3>
						
						<div id="appendToSession">
							<div class="noSelectDate">
								<span>상단 캘린더에서 날짜를 선택해 주세요.</span>
							</div>
						</div>
						
						<ul class="listWarning">
<!-- 							<li>※ 예약은 월 5회까지 가능합니다.</li> -->
<!-- 							<li>※ 특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 3개월간 예약이 불가합니다.</li> -->
							<li id="penaltyInfo">※  특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 <strong id="applyTypeValue">2개월</strong>간 예약이 불가합니다.</li>
							<li>※ PT이상부터 그룹신청이 가능합니다.</li>
						</ul>
					</section>
					
					<div class="btnWrapR">
						<a href="javascript:void(0);" class="btnBasicGS" onclick="javascript:stepPre();">이전</a>
						<a href="javascript:void(0);" id="step2Btn" class="btnBasicBS" onclick="javascript:reservationReq();">예약요청</a>
					</div>
				</div>
				<div class="result" id="tempResult"><p>날짜와 시간을 선택해 주세요.</p></div>
				<div class="result lines req" style="display:none" id="expBrandConfrirm">
<!-- 					<p class="total">총 2 건</p> -->
<!-- 					<p class="program"><span class="t">그룹</span><em>|</em>2016-05-25(수)<em>|</em>13:30~14:00</p> -->
<!-- 					<p class="program"><span class="t">개별</span><em>|</em>2016-05-29(일)<em>|</em>13:30~14:00 (대기신청)<em>|</em>ABO동반</p> -->
				</div>
			</div>
			
			<%//<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기"></a></div> %>
			
		</div>
		<!-- //스텝2 -->
		<!-- 예약완료 -->
		<div class="brWrap" id="stepDone">
			<p><img src="/_ui/desktop/images/academy/brTextDone.gif" alt="예약이 완료 되었습니다. 이용해 주셔서 감사합니다."></p>
			<div class="snsWrap">
				<!-- 20150313 : SNS영역 수정 -->
				<span class="snsLink">
					<!-- @eidt 20160627 URL 복사 삭제 -->
					<a href="#" id="snsKs" class="snsCs" onclick="javascript:tempSharing('${httpDomain}', 'kakaoStory');" title="새창열림"><span class="hide">카카오스토리</span></a>
					<a href="#" class="snsBand" onclick="javascript:tempSharing('${httpDomain}', 'band');" title="새창열림"><span class="hide">밴드</span></a>
					<a href="#" id="snsFb" class="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');" title="새창열림"><span class="hide">페이스북</span></a>
					
				</span>
				<!-- //20150313 : SNS영역 수정 -->
				<span class="snsText"><img src="/_ui/desktop/images/academy/sns_text.gif" alt="예약내역공유"></span>
			</div>
			<div class="btnWrapC">
				<a href="javascript:void(0);" class="btnBasicGL">예약계속하기</a>
				<a href="javascript:void(0);" onclick="javascript:accessParentPage();" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</div>

</section>
<!-- //content area | ### academy IFRAME End ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
