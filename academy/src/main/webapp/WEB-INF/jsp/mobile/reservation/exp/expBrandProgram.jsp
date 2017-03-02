<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
var tableCnt = 0;
var productName = "";

$(document.body).ready(function (){
	//카테고리 3셋팅
// 	setCategorytype3('F');
	
	
	$("#stepDone").hide();
	$("#step1Btn").hide();
	
	$("#choiceCalendar").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/mobile/reservation/expBrandForm.do'/>";
	});
	
	$("input[name='chkBox']").on("click", function(){
		$("input[name='chkBox']:checked").each(function(){
// 			console.log($(this));
		})
	});
	
	
	if($("#selectCategiretType").children().length == 0){
		alert("아직 체험이 등록되지 않았습니다. 운영자에 의해 체험이 등록 된 이후 사용 바랍니다.");
		return;
	}
});


function setCategorytype3(paramCategory2, obj){
	$("#step1Btn").hide();
	$(obj).addClass("active");
	
	var param = {
		  categorytype2 : paramCategory2
		, ppseq : $("#ppseq").val()
	};
	
	$("#categorytype2").val(paramCategory2);
	
		
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/setBrandCategorytype3Ajax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandCategoryType3 = data.searchBrandCategoryType3;
			var html="";
			
			var fileKeyArray = new Array();
			var categorytype3Array = new Array();
			
			
			$("#appendBradnCategory").empty();
			
			if($("#categorytype2").val() == "E0301"){
				html  = "<div class='brandTitleBox type2' id='brandSelectTitle'><h2>브랜드 선택</h2></div>";
				html += "	<div class='mgLR'>";
				html += "	<div class='programSelect'>";
				html += "		<ul class='brandListCate'>";
			
				/* 브랜드 선택 이미지 셋팅 */
				for(var i = 0; i < brandCategoryType3.length; i++){

					if(brandCategoryType3[i].categorytype3 == $("#categorytype3").val()){
						$("#categorytype3").val(brandCategoryType3[i].categorytype3);
					}
					
					categorytype3Array.push(brandCategoryType3[i].categorytype3);

				}
				
				html += "</ul>";
				html += "</div>";
				html += "</div>";
				
				$("#appendBradnCategory").css("display", "block");
				$("#appendBradnCategory").append(html);
				
				setBrandSelectImage(categorytype3Array);
				
			}else{
				html = "<div class='brandTitleBox type2' id='seleProgram'><h2>프로그램 선택</h2></div>";
				
				$("#appendBradnCategory").css("display", "block");
				$("#appendBradnCategory").append(html);
			
				setProductList('' ,'', 'C');
			}
			
			/* resizing */
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			/* move to top */
			var $pos = $("#appendBradnCategory");
   			var iframeTop = parent.$("#IframeComponent").offset().top
   			parent.$('html, body').animate({
   			    scrollTop:$pos.offset().top + iframeTop
   			}, 300);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

function setBrandSelectImage(categorytype3Array){
	
	var param = {
			 categorytype3Array : categorytype3Array
		};
		
		$.ajaxCall({
			url: "<c:url value='/mobile/reservation/searchExpBrandProgramKeyListAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var brandProgramKeyList = data.brandProgramKeyList;
				var html = "";
				
				$(".brandListCate").empty();
				
				for(var i = 0; i < brandProgramKeyList.length; i++){
					if(brandProgramKeyList[i].filekey == 0 || brandProgramKeyList[i].filekey == null || brandProgramKeyList[i].filekey == ""){
						
						if(brandProgramKeyList[i].categorytype3 == "E030101"){
							html += "<li>";
							html += "	<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\">";
							html += "		<span class='img'>";
							html += "			<img src='/_ui/mobile/images/academy/@brand_img.gif' alt='"+brandProgramKeyList[i].categoryname3+"'>";
// 							html += "			<img src='/_ui/mobile/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "		</span>";
							html += "	</a>";
							html += "</li>";
							
						}else{
							html += "<li>";
							html += "	<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\">";
							html += "		<span class='img'>";
							html += "			<img src='/_ui/mobile/images/academy/@brand_img.gif' alt='"+brandProgramKeyList[i].categoryname3+"'>";
// 							html += "			<img src='/_ui/mobile/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "		</span>";
							html += "	</a>";
							html += "</li>";
						
						}
					}else{
						if(brandProgramKeyList[i].categorytype3 == "E030101"){
							html += "<li>";
							html += "	<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\">";
							html += "		<span class='img'>";
							html += "			<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "		</span>";
							html += "	</a>";
							html += "</li>";
						
							
						}else{
							html += "<li>";
							html += "	<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\">";
							html += "		<span class='img'>";
							html += "			<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "		</span>";
							html += "	</a>";
							html += "</li>";
						}
						
					}
					
						
				}
				
				$(".brandListCate").append(html);
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
}

/* 프로그램 선택  셋팅*/
function setProductList(flag, categorytype3, obj){
	
 	$("#categorytype3").val(categorytype3);
	 	
 	/** 테두리 활성화 */
 	$("#appendBradnCategory").find("span").each(function(){
 		$(this).parent().removeClass("on")
		$(obj).addClass("on");
	});
	 	
	$("#appendBradnCategory").find(".programList").each(function(){
		
		if($(this).children().is("li") === true){
			$(this).remove();
		}
	});

	var param = {
		  categorytype2 : $("#categorytype2").val()
		, categorytype3 : $("#categorytype3").val()
		, ppseq : $("#ppseq").val()
	}
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/searchBrandProductListAjax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandProductList = data.searchBrandProductList;
			var html="";
// 			$("#ppseq").val(brandProductList[0].ppseq);
			
			if(brandProductList[0].categorytype3name == "N"){
				$("#appendBradnCategory").empty();
				html = "<div class='brandTitleBox type2' id='seleProgram'><h2>프로그램 선택</h2></div>";
			}else{
				$("#seleProgram").remove();

				html = "<div class='brandTitleBox type2' id='seleProgram'><h2>프로그램 선택</h2></div>";
			}

			
			html += "<ul class='programList' id='programItem'>";
			
			/* 프로그램 이름 셋팅 */
			for(var i = 0; i < brandProductList.length; i++){
				
				html += "<li><a href='javascript:void(0);'  onclick = 'javascript:selectProduct(this,"+brandProductList[i].expseq+");'>"+brandProductList[i].productname;
				html += "</a><a href='#none' class='btn' onclick =\"javascript:showBrandIntro('', '', '"+brandProductList[i].expseq+"', 'D');\">내용보기</a></li>"
			}
			html += "</ul>";
			$("#appendBradnCategory").append(html);
			
			/* resizing */
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			/* move to top */
			var $pos = $("#seleProgram");
   			var iframeTop = parent.$("#IframeComponent").offset().top
   			parent.$('html, body').animate({
   			    scrollTop:$pos.offset().top + iframeTop
   			}, 300);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}



/* 프로그램 선택시 테두리 활성화& 키값 세팅 */
function selectProduct(obj, expseq){
	$("#step1Btn").show();
	$("#expseq").val(expseq);
	var  msg = "기존에 선택하신 세션 테이블은 삭제 됩니다.";
	
	$("#programItem").children().each(function(){
		
		if($(this).children().is(".on") === true){
			$(this).children().removeClass("on");
		}
	});
	
	$(obj).addClass("on");
}


/* step1에서 다음버튼 클릭시 날짜 선택 유무 확인 */
function showStep2(){
	var cnt = 0;
	var tempProductName;
	var productName;
	var html = "";
	$("#programItem").children().each(function(){
			
		if($(this).children().is(".on") === true){
			tempProductName = $(this).children().text();
			cnt ++;
		}
	});
	
	if(cnt != 0){
		$("#appendToSession").empty();
		
		$("#step1Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
		$("#step1Btn").parents('.bizEduPlace').find('.result').show();
		$("#step1Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
		
		$(".tempBrandReserv").show();
		$("#step2Btn").parents("dd").show();
		$("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
		$("#step2Btn").parents(".bizEduPlace").find(".result").hide();
		
		$("#step2Btn").hide();
		
		this.productName = tempProductName.slice(0, -4);
		
		$("#step1AppendProduct").empty();
		
		html  = "<em class='bizIcon step04'></em><strong class='step'>STEP1/ 프로그램</strong>";
		html += "<span>분당 ABC<em class='bar'>|</em>"+this.productName+"</span>";
		
		$("#step1AppendProduct").append(html);
		/* 패널티 정보 조회 */
		searchExpPenalty();
		searchNextYearMonth();
		nextMonthCalendar();
		
	}else{
		alert("프로그램을 선택해주십시오.");
		return false;
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
		url: "<c:url value="/mobile/reservation/searchNextYearMonthAjax.do"/>"
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
			$("#popGetMonth").val("");

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
	var tempYear = "";
	var tempMonth = "";
	
// 	html += "<span class='year'>"+setYearMonthData[0].year+"</span>";
	html += "<div class='monthlyWrap'>";
	
	for(var i = 0; i < setYearMonthData.length; i++){

		if(i >= 7){
			break;
		}
		
		if(i == 0){
			tempYear = setYearMonthData[i].year;
			tempMonth = setYearMonthData[i].month;
			
			html += "<span><span class=\"year\">"+setYearMonthData[i].year+"</span>";
			html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\" class=\"on\">"+setYearMonthData[i].month+"<span>月</span></a></span>";

		}else if(setYearMonthData[i].year != tempMonth && setYearMonthData[i].month == 1){
			
			html += "<span><span class=\"year\">"+setYearMonthData[i].year+"</span>";
			html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\">"+setYearMonthData[i].month+"<span>月</span></a></span>";
			
		}else{
			html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\">"+setYearMonthData[i].month+"<span>月</span></a></span>";
		}
		
		if(setYearMonthData.length != i + 1){
			html += "<em>|</em>";
		}
		
// 		if(i == 0){
// 			html += "<a href='javascript:void(0);' class='on' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[i].year+"', '"+setYearMonthData[i].month+"');\">"+setYearMonthData[i].month+"<span>月</span></a><em>|</em>";
// 		}else{
// 			html += "<a href='javascript:void(0);' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[i].year+"', '"+setYearMonthData[i].month+"');\">"+setYearMonthData[i].month+"<span>月</span></a><em>|</em>";
// 		}
	}
	
// 	html += "<a href='javascript:void(0);' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[2].year+"', '"+setYearMonthData[2].month+"');\">"+setYearMonthData[2].month+"<span>月</span></a>";
	html += "</div>";
	
	html += "<div class='hText availabilityCount'>";
	html += "</div>";
	
	/*-----------------------체험 예약 현황 확인시 필요한 년월 셋팅---------------------------------------*/
	$("#getYearPop").val(setYearMonthData[0].year);
	
	if(setYearMonthData[0].month < 10){
		$("#getMonthPop").val("0"+setYearMonthData[0].month);
	}else{
		$("#getMonthPop").val(setYearMonthData[0].month);
	}
	/*----------------------------------------------------------------------------------*/
	$(".calenderHeader").empty();
	$(".calenderHeader").append(html);

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


/* 달력table에 필요한 데이터 호출 함수 */
function nextMonthCalendar(){
	var param = {
		  getYear :  $("#getYear").val()
		, getMonth : $("#getMonth").val()
		, expseq : $("#expseq").val()
		, ppSeq : $("#ppseq").val()
	};
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/searchNextMonthProgramCalendarAjax.do"/>"
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
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			/* move to top */
			var $pos = $("#pbContent > section.mWrap > div:nth-child(4) > div.selectDiv");
   			var iframeTop = parent.$("#IframeComponent").offset().top
   			parent.$('html, body').animate({
   			    scrollTop:$pos.offset().top + iframeTop
   			}, 300);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 캘린더상에 날짜 셋팅 */
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
	
	/* 캘린더상에 표현할 휴무일 셋팅 */
	calendarSetData(holiDayList);
	
// 	getRemainDayByMonth();
}

/* 캘린더상에 표현할 휴무일 셋팅 */
function calendarSetData(holiDayList){
	
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
			if($("#cal"+yymm+tempI).text() == Number(holiDayList[j].setdate)){
				
				$("#cal"+yymm+tempI).parent().addClass("late");
				$("#cal"+yymm+tempI).removeAttr("onclick");
				html = "<span>휴무</span>";
				
				$("#cal"+yymm+tempI).append(html);
			}
		}
	}
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
		
		var months = $(".monthlyWrap > a").length;
		
        if( 1 < months ) {
			msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
        
        alert(msg);
		
		return false;
	}
	
	
	$("#getDayPop").val(rsvAbleSession[0].gettoday.substr(6,2));
	
	for(var i = 0; i < rsvAbleSession.length; i++){

		if(tempGetYmd != rsvAbleSession[i].getymd){
			tempGetYmd = rsvAbleSession[i].getymd;
			tempWorkTypeCode = rsvAbleSession[i].worktypecode;
			tempSetTypeCode = rsvAbleSession[i].settypecode;
		}
		
		if(tempSetTypeCode == rsvAbleSession[i].settypecode){
// 			if(rsvAbleSession[i].gettoday < rsvAbleSession[i].getymd && rsvAbleSession[i].getymd != tempDate && $("#cal"+rsvAbleSession[i].getymd).children("span").text() == ""){
			if(rsvAbleSession[i].getymd != tempDate && $("#cal"+rsvAbleSession[i].getymd).children("span").text() == ""){
				if(rsvAbleSession[i].rsvsessiontotalcnt != 0){
					
					if(rsvAbleSession[i].seatcount1 != null && rsvAbleSession[i].seatcount1 != ""){
						html = "<span>";
						html += "	<span class='calIcon2 personal'><em>개별</em></span>";
// 						html += "	<span class='calIcon2 group'><em>그룹</em></span>";
						html += "</span>";
						$("#cal"+rsvAbleSession[i].getymd).append(html);
						
						tempDate = rsvAbleSession[i].getymd;
					}else{
						html = "<span>";
// 						html += "	<span class='calIcon2 personal'><em>개별</em></span>";
						html += "	<span class='calIcon2 group'><em>그룹</em></span>";
						html += "</span>";
						$("#cal"+rsvAbleSession[i].getymd).append(html);
						
						tempDate = rsvAbleSession[i].getymd;
					}
					
				}else if(rsvAbleSession[i].rsvsessiontotalcnt == 0 && rsvAbleSession[i].gettoday <= rsvAbleSession[i].getymd){
					
					if(rsvAbleSession[i].totalsessioncnt == 0){
						$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
						$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
					}else{
						html = "<span>마감</span>";
						$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
						$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
						$("#cal"+rsvAbleSession[i].getymd).append(html);
					}
					
				}
			}else if(rsvAbleSession[i].gettoday >= rsvAbleSession[i].getymd){
				$("#cal"+rsvAbleSession[i].getymd).parent().addClass("late");
				$("#cal"+rsvAbleSession[i].getymd).removeAttr("onclick");
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
			
		/* 캘린더에 새로운 날짜를 선택한 경우 */
		}else{
			$("#cal"+year+month+date).attr("class", "selcOn");
			$(".brSessionWrap").show();
			
			/* 선택 날짜의 세션 정보 상세보기 */
			showSession(tempDate, year, month);
		}
	}
	
	if($("#appendToSession").children().length == 0){
		$("#step2Btn").hide();
	}
}

/* 선택 날짜의 세션 정보 상세보기 */
function showSession(tempDate, year, month){
	var param = {
		  getYear : year
		, getMonth : month
		, getDay : tempDate
		, expseq : $("#expseq").val()
		, ppseq : $("#ppseq").val()
	}
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/searchProgramSessionListAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
		
			/* 해당 일자의 세션 리스트 */
			var programSessionList = data.searchProgramSessionList;
			
			/* 선택된 날짜의 세션정보 그리기 */
			if (programSessionList){
				gridProgramSessionTable(programSessionList);
			}
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			/* move to top */
			var $pos = $("#pbContent > section.mWrap > div:nth-child(4) > div.selectDiv > dl > dd:nth-child(3) > div.hWrap.dashed");
   			var iframeTop = parent.$("#IframeComponent").offset().top
   			parent.$('html, body').animate({
   			    scrollTop:$pos.offset().top + iframeTop
   			}, 300);			
			
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
	
	
	html  = "<table class='tblSession' id ='"+programSessionList[0].ymd+"'>";
	html += "	<caption>시간 선택</caption>";
	html += "	<colgroup>";
	html += "		<col style='width:35px' />";
	html += "		<col style='width:auto' />";
	html += "		<col style='width:100px' />";
	html += "	</colgroup>";
	html += "	<thead>";
	html += "		<tr>";
	html += "			<th scope='col' colspan='3'>"+programSessionList[0].setdateformat+' '+programSessionList[0].korweek+"<a href='#none' class='btnDel' onclick='javascript:deleteSessionDetail(this)'>삭제</a></th>";
	html += "		</tr>";
	html += "	</thead>";
	html += "	<tbody>";
	
	
	for(var j = 0; j < programSessionList.length; j++){
		
		if(j == 0){
			tempSetTypeCode = programSessionList[j].settypecode;
		}
	
		if(programSessionList[j].settypecode == tempSetTypeCode){
		//i가 0 -> 개별, i가1 -> 그룹 
// 		for(var i = 0; i <= 1; i++){
// 			if(i == 0){
			if(programSessionList[j].seatcount1 != null && programSessionList[j].seatcount1 != "" ){
				//예약가능
				if(programSessionList[j].rsvflag == 100){
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' onclick=\"javascript:pinCheck(this, 'A01');\"></td>";
					html += "	<td><em class='iconGray'>개별</em>"+programSessionList[j].sessiontime+"</td>";
					html += "	<td class='textR'><span class='rText able'>예약가능</span>";
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
					
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 200){
				//대기신청
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' onclick=\"javascript:pinCheck(this, 'A01');\"></td>";
					html += "	<td><em class='iconGray'>개별</em>"+programSessionList[j].sessiontime+"</td>";
					html += "	<td class='textR'><span class='rText'>대기신청</span>";
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
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 300){
				//예약마감
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' onclick=\"javascript:pinCheck(this, 'A01');\" disabled></td>";
					html += "	<td><em class='iconGray'>개별</em>"+programSessionList[j].sessiontime+"</td>";
					html += "	<td class='textR'><span class='rText'>예약마감</span>";
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
					html += "</tr>";
				}
			}else{
				//예약가능
				if(programSessionList[j].rsvflag == 100){
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' onclick=\"javascript:pinCheck(this, 'A02');\"></td>";
					html += "	<td><em class='iconGray'>그룹</em>"+programSessionList[j].sessiontime+"</td>";
					html += "	<td class='textR'><span class='rText able'>예약가능</span>";
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
					
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 200){
				//대기신청
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' onclick=\"javascript:pinCheck(this, 'A02');\"></td>";
					html += "	<td><em class='iconGray'>그룹</em>"+programSessionList[j].sessiontime+"</td>";
					html += "	<td class='textR'><span class='rText'>대기신청</span>";
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
					html += "</tr>";
				}else if(programSessionList[j].rsvflag == 300){
				//예약마감
					html += "<tr>";
					html += "	<td><input type='checkbox' id='"+programSessionList[j].ymd+"_"+programSessionList[j].expsessionseq+"' name='chkBox' onclick=\"javascript:pinCheck(this, 'A02');\" disabled></td>";
					html += "	<td><em class='iconGray'>그룹</em>"+programSessionList[j].sessiontime+"</td>";
					html += "	<td class='textR'><span class='rText'>예약마감</span>";
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
					html += "</tr>";
				}
			}
		}
// 		}
	}
	
	html += "	</tbody>";
	html += "</table>";
	$("#appendToSession").append(html)
	tableCnt ++;
}

/* 세션 삭제 */
function deleteSessionDetail(obj){
	
	/* 세션 테이블에 id값 가져오기  */
	var selectedDate = $(obj).parent().parent().parent().parent().attr("id");
	
	/* 달력상에 테듀리 삭제  */
	$("#cal"+selectedDate).removeAttr("class");
	/* 세션 테이블 삭제 */
	$(obj).parent().parent().parent().parent().remove();
	
// 	console.log($("#appendToSession").children().length);
	if($("#appendToSession").children().length == 0){
		$("#step2Btn").hide();
	}
}


/* setp1상에 다른 월 클릭시 새로 캘린더 그리주기 */
function changeMonth(obj, year, month){
	
	var  msg = "해당월에 선택된 세션리스트는 삭제됩니다.";
	if($("#appendToSession").children().length != 0 || $("#appendToSession").children().length != ""){
		
		if(confirm(msg) == true){
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
			$(".monthlyWrap").find("a").each(function(){
				if($(this).is(".on") === true){
					$(this).removeClass("on");
				}
			});
			
			/* 새로 클릭한 월에 on걸기 */
			$(obj).addClass("on");
			

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
		
		$(".monthlyWrap").find("a").each(function(){
			if($(this).is(".on") === true){
				$(this).removeClass("on");
			}
		});
		$(obj).addClass("on");

		$(".hText").empty();
		
		remainDayHtml = "	<span>"+$("#getMonth").val()+"월 예약가능 잔여회수</span><strong>: <span id='remainDay'>0</span>회</strong>";
		$(".hText").append(remainDayHtml);
		
// 		getRemainDayByMonth();
		
		/* 달력을 그려주는 함수 호출 */
		nextMonthCalendar();
		
		getRsvAvailabilityCount();
	}
		
	
}

function reservationReq(){
var cnt = 0;
	
	$("#expBrandProgramReqForm").empty();
	$("#checkLimitCount").empty();
	
	$("input[name='chkBox']:checked").each(function(){
		
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='ppSeq' value ='"+$(this).parent().next().next().find("input[name='tempPpSeq']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='expsessionseq' value ='"+$(this).parent().next().next().find("input[name='tempExpSessionSeq']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='expseq' value ='"+$(this).parent().next().next().find("input[name='tempExpSeq']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='reservationDate' value ='"+$(this).parent().next().next().find("input[name='tempReservationDate']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='sessionTime' value ='"+$(this).parent().next().next().find("input[name='tempSessionTime']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='setDateFormat' value ='"+$(this).parent().next().next().find("input[name='tempSetDateFormat']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='korWeek' value ='"+$(this).parent().next().next().find("input[name='tempKorWeek']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='accountType' value ='"+$(this).parent().next().next().find("input[name='tempAccountType']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='rsvflag' value ='"+$(this).parent().next().next().find("input[name='tempRsvFlag']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='productName' value ='"+$(this).parent().next().next().find("input[name='tempProductName']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='startdatetime' value ='"+$(this).parent().next().next().find("input[name='tempStartDateTime']").val()+"'>");
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='enddatetime' value ='"+$(this).parent().next().next().find("input[name='tempEndDateTime']").val()+"'>");

		$("#checkLimitCount").append("<input type= 'hidden' name = 'reservationDate' value = '"+$(this).parent().next().next().find("input[name='tempReservationDate']").val()+"'>");
		$("#checkLimitCount").append("<input type= 'hidden' name = 'typeSeq' value = '"+$("#typeseq").val()+"'>");
		
		cnt++;
	});
	
	if(cnt == 0){
		alert("세션을 선택해 주십싱오");
		return false;
	}else{
		
		/* 패널티 유효성 중간 검사 */
		if(middlePenaltyCheck()){
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeseq\" value=\""+$("#typeseq").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"ppseq\" value=\""+$("#ppseq").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+$("#expseq").val()+"\">");
			 
			$.ajaxCall({
				  url: "<c:url value='/reservation/rsvAvailabilityCheckAjax.do'/>"
				, type : "POST"
				, data: $("#checkLimitCount").serialize()
				, success: function(data, textStatus, jqXHR){
					
						if(data.rsvAvailabilityCheck){
							
							duplicateCheck();
							
			// 				setTimeout(function(){ abnkorea_resize(); }, 500);
						}else{
							alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
						}
	
				}, error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}
			});
		}
		
		
		/* move to top */
		var $pos = $("#pbContent");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
		
	}
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

function expBrandProgramRsvRequestPop(){
	
	/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
	var param = $("#expBrandProgramReqForm").serialize();
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/expBrandProgramRsvRequestPopAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){

		var expBrandProgramList = data.expBrandProgramList;
		var totalCnt = data.totalCnt;
		var partnerTypeCodeList = data.partnerTypeCodeList;
		
		
		setReservationReq(expBrandProgramList, totalCnt, partnerTypeCodeList);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function expBrandDisablePop(cancelDataList){
	
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

function setReservationReq(expBrandProgramList, totalCnt, partnerTypeCodeList){
	var html = "";
	$(".tblResrConform").empty();
	
// 	$("#stepDone").show();
	
	html  = "<colgroup><col width='30%' /><col width='70%' /></colgroup>";
	html += "<thead>";
	html += "	<tr><th scope='col' colspan='2'><span class='title'>분당ABC <em>|</em></span> <span class='subject'>"+expBrandProgramList[0].productName+"</span></th></tr>";
	html += "</thead>";
	html += "<tfoot>";
	html += "	<tr>";
	html += "		<td colspan='2'>총 "+totalCnt+"건</td>";
	html += "	</tr>";
	html += "</tfoot>";
	html += "<tbody>";
	for(var i = 0; i < expBrandProgramList.length; i++){
		$("#expBrandProgramReqForm").append("<input type='hidden' name ='typeseq' value ='"+expBrandProgramList[i].typeseq+"'>");
		
		html +="<tr>";
		html +="<th class='bdTop'>구분</th>";
		if(expBrandProgramList[i].accountType == "A01"){
			html +="<td class='bdTop'>개별</td>";
		}else{
			html +="<td class='bdTop'>그룹</td>";
		}
		html +="</tr>";
		html +="<tr>";
		html +="	<th>날짜</th>";
		html +="	<td>"+expBrandProgramList[i].setDateFormat+" "+expBrandProgramList[i].korWeek+"</td>";
		html +="</tr>";
		html +="<tr>";
		html +="	<th>체험시간</th>";
		if(expBrandProgramList[i].rsvflag == "100"){
			html +="	<td>"+expBrandProgramList[i].sessionTime+"</td>";
		}else if(expBrandProgramList[i].rsvflag == "200"){
			html +="	<td>"+expBrandProgramList[i].setDateFormat+" (대기신청)</td>";
		}
		html +="</tr>";
		
		html +="<tr>";
		html +="<th>동반여부</th>"
		if(expBrandProgramList[i].accountType == "A01"){
			html +="<td>"
			html +="<select title='동반여부' name='partnerTypeCode'>"
			html +="<option value=''>선택해주세요</option>"
			for(var j = 0; j < partnerTypeCodeList.length; j++){
				html += "<option value="+partnerTypeCodeList[j].commonCodeSeq+">"+partnerTypeCodeList[j].codeName+"</option>"
			}
			html +="</select>"
			html +="</td>"
		}else{
			html +="<td>-</td>";
		}
		html +="</tr>";
	}
	html += "</tbody>";
	$(".tblResrConform").append(html);
	
	layerPopupOpen("<a href='#uiLayerPop_confirm' class='btnBasicBL'>예약요청</a>");
	/* 예약확정 버튼 */
	$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:expBrandReservation(this);");
	
	rsvConfirmPop_resize();
}

function closePop(){
	$("#uiLayerPop_confirm").css("display", "none");
	$(".tempBrandReserv").css("display", "block");
	$(".tempBrandReserv").parent().parent().css("display", "block");
	$(".tempBrandReserv").parent().parent().prev().css("display", "none");

	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/*
* 필수 입력값 체크 및 확인
*/
var mendatoryCheck = {
		
	partnerSelectbox : function(){
		
		var mendatoryCheckForSelectBox = false;
		
		$("select[name=partnerTypeCode]").each(function(){
			
			if(0 == $(this).val().length){
				mendatoryCheckForSelectBox = true;
			}
		});
		
		if(mendatoryCheckForSelectBox){
			alert("동반여부는필수 선택 입니다.");
			return false;
		}else{
			return true;
		}
	}
};

function expBrandReservation(obj){
	
	if(!mendatoryCheck.partnerSelectbox()){
		return;
	}
	
	$(obj).removeAttr("onclick");

	$("#stepDone").show();
	
	$("select[name=partnerTypeCode]").each(function(){
		$("#expBrandProgramReqForm").append("<input type= 'hidden' name = 'partnerTypeCode' value = '"+$(this).children("option:selected").val()+"'>")
	});
	
	var param = $("#expBrandProgramReqForm").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expBrandProgramInsertAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
		
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				
				$("#transactionTime").val(data.transactionTime);
				
				var expBrandRsvInfoList = data.expBrandProgramList;
				var totalCnt = data.totalCnt;
				
				if(expBrandRsvInfoList[0].msg == "false"){
					alert(expBrandRsvInfoList[0].reason);
					return false;
				}else{
					
					if( 0 < expBrandRsvInfoList.length ){
						setExpBrandReservation(expBrandRsvInfoList, totalCnt);
					}
				}
				
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			$(obj).attr("onclick", "javascript:expBrandReservation(this);");
		}
	});
	
}

function setExpBrandReservation(expBrandRsvInfoList, totalCnt){
	$("#uiLayerPop_confirm").css("display", "none");
	$("#layerMask").remove();
	
	$("#step2Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
	$("#step2Btn").parents('.bizEduPlace').find('.result').show();
	$("#step2Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
	$("#stepDone").show();
	
	var html = "";
	var snsHtml = "[한국암웨이]시설/체험 예약내역 (총 "+totalCnt+"건) \n";
	
	html  = "<em class='bizIcon step02'></em><strong class='step'>STEP2/ 프로그램</strong>";
	html += "<span>총"+totalCnt+"건</span>";
	html += "<div class='resultDetail'>";
	for(var i = 0; i < expBrandRsvInfoList.length; i++){
		if(expBrandRsvInfoList[i].accountType == "A01"){
			if(expBrandRsvInfoList[i].partnerTypeCode =="R01"){
				if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
					html += "<span>개별<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em class='bar'>|</em>ABO</span>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
							+ "| \n" + expBrandRsvInfoList[i].sessionTime
							+ "| ABO동반\n";
					
				}else{
					html += "<span>개별<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"(예약 대기)<em class='bar'>|</em>ABO</span>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
							+ "| \n" + expBrandRsvInfoList[i].sessionTime
							+ "(대기신청)| ABO동반\n";
					
				}
			}else if(expBrandRsvInfoList[i].partnerTypeCode == "R02"){
				if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
					html += "<span>개별<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em class='bar'>|</em>일반인</span>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
							+ "| \n" + expBrandRsvInfoList[i].sessionTime
							+ "| 일반인\n";
					
				}else{
					html += "<span>개별<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"(예약 대기)<em class='bar'>|</em>일반인</span>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
							+ "| \n" + expBrandRsvInfoList[i].sessionTime
							+ "(대기신청)| 일반인\n";
				}
			}else {
				if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
					html += "<span>개별<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em class='bar'>|</em>비동반</span>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
							+ "| \n" + expBrandRsvInfoList[i].sessionTime
							+ "| 비동반\n";
					
				}else{
					html += "<span>개별<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"(예약 대기)<em class='bar'>|</em>비동반</span>";
					
					snsHtml += "■ 개별 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
							+ "| \n" + expBrandRsvInfoList[i].sessionTime
							+ "(대기신청)| 비동반\n";
				}
			}
		}else{
			if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
				html += "<span>그룹<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em class='bar'>";
				
				snsHtml += "■ 그룹 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
						+ "| \n" + expBrandRsvInfoList[i].sessionTime
						+ "\n";
				
			}else{
				html += "<span>그룹<em class='bar'>|</em><br/>"+expBrandRsvInfoList[i].setDateFormat+expBrandRsvInfoList[i].korWeek+"<em class='bar'>|</em>"+expBrandRsvInfoList[i].sessionTime+"(예약 대기)<em class='bar'>";
				
				snsHtml += "■ 그룹 분당ABC ("+this.productName+")"+expBrandRsvInfoList[i].setDateFormat + expBrandRsvInfoList[i].korWeek 
						+ "| \n" + expBrandRsvInfoList[i].sessionTime
						+ "(대기신청) \n";
			}
		}
	}
	html += "</div>";
	
	$("#snsText").empty();
	$("#snsText").val(snsHtml);
	
	$("#stepDone").show();
	
	$("#appendResultDetail").append(html);
}

function showBrandIntro(categorytype2, categorytype3, expseq, flag){
	setTimeout(function(){ abnkorea_resize(); }, 1000);
	$("#categorytype3Pop").val("");
	$("#categorytype2Pop").val("");
	$("#expseqPop").val("");
	
	
	//falg -> I: 프로그램 소개 버튼/ flag->D : 해당프로그램 디테일
	
	if(flag == "I"){
		$("#categorytype3Pop").val(categorytype3);
		$("#categorytype2Pop").val(categorytype2);
		$("#expseqPop").val(expseq);
		
		$("#appendBradnCategoryLayer").css("display", "none");
		//카테고리 3셋팅
// 		setCategorytype3Layer('I', '');
	}else{
		//카테고리 3셋팅
		$("#categorytype3Pop").val($("#categorytype3").val());
		$("#categorytype2Pop").val($("#categorytype2").val());
		$("#expseqPop").val(expseq);
		setCategorytype3Layer('D', $("#categorytype2Pop").val());
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 1000);	
	layerPopupOpen("<a href='#uiLayerPop_brandExp' class='btnTbl'>예약요청</a>");return false;
	setTimeout(function(){ abnkorea_resize(); }, 1000);
}

function showExpRsvComfirmPop(){
	
	$("#getYearLayer").val($("#getYearPop").val());
	$("#getMonthLayer").val($("#getMonthPop").val());
	
	searchCalLayer();
	setToday();
	
	layerPopupOpen("<a href='#uiLayerPop_calender2' class='btnTbl'>체험예약 현황확인</a>");return false;
}

function pinCheck(obj, accountType){
	
	if("A02" == accountType){
		var msg = "PT이상부터 그룹신청이 가능합니다.";
		if(3 > Number($("#targetcodeorder").val())){
			alert(msg);
			
			$(obj).attr("checked", false);
			
			return false;
		}else if($('input:checkbox[name="chkBox"]:checked').length > 0){
			$("#step2Btn").show();
		}
	}
	
	if($('input:checkbox[name="chkBox"]:checked').length > 0){
		$("#step2Btn").show();
	}else if($('input:checkbox[name="chkBox"]:checked').length <= 0){
		$("#step2Btn").hide();
	}
	
	
}

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 브랜드체험 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}

function closeBrandRsvLayer(){

	$("#uiLayerPop_confirm").hide();
	$("#layerMask").remove();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 예약불가 팝업 확인 이벤트 */
function eduCultureDisabledConfirm(){
	
	var selectChoice = $("input:radio[name='resConfirm']:checked").val();
	
	if( selectChoice == "sessionSelect1"){
		
		/* 발견된 중복건수를 opener 페이지의 세션선택 상자에서 찾은 후 해제 시키는 기능 */
		$("#uiLayerPop_cannot input[type='hidden']").each(function(){
			$("#" + $(this).val()).prop("checked", false);
		});
	
		/* 세션 갱신 후 재예약 요청 */
		reservationReq();
		
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

/**
 * 이전 버튼 클릭시 화면 이동
 */
function backStep(destStep){
	
	if('1' == destStep ){

		/* move to step 1 */
		var $pos = $("#pbContent > section.mWrap > div.bizEduPlace");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
		
	}else if( '2' == destStep ){

		/* move to step 2 */
		var $pos = $("#pbContent > section.mWrap > div:nth-child(4) > div.selectDiv");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
		
	}
		
}
</script>
<!-- </head> -->
<!-- <body class="uiGnbM3"> -->

<form id="expBrandProgramForm" name="expBrandProgramForm" method="post">
	<input type="hidden" id="categorytype2" name="categorytype2">
	<input type="hidden" id="categorytype3" name="categorytype3">
	<input type="hidden" id="expseq" name="expseq">
	<input type="hidden" id="popExpseq" name="popExpseq">
	<input type="hidden" id="ppseq" name="ppseq" value="${searchBrandPpInfo.ppseq}">
	<input type="hidden" id="typeseq" name="typeseq" value="${searchBrandPpInfo.typeseq}">
	<input type="hidden" id="targetcodeorder" name="targetcodeorder">
	
	
	<input type="hidden" id="getYear" name="getYear">
	<input type="hidden" id="getMonth" name="getMonth">
	<input type="hidden" id="getDay" name="getDay">
	
	<input type="hidden" id="getMonthPop" name="getMonthPop">
	<input type="hidden" id="getYearPop" name="getYearPop">
	<input type="hidden" id="getDayPop" name="getDayPop">
	
	<input type="hidden" id="categorytype2Pop" name="categorytype2Pop">
	<input type="hidden" id="categorytype3Pop" name="categorytype3Pop">
	<input type="hidden" id="expseqPop" name="expseq">
</form>
<form id="expBrandProgramReqForm" name="expBrandProgramReqForm" method="post"></form>
<form id="checkLimitCount" name="checkLimitCount" method="post"></form>


<div id="pbContainer">
	<section id="pbContent" class="bizroom">
	
		<input type="hidden" id="transactionTime" />
		<input type="hidden" id="snsText" name="snsText">
		
		<section class="brIntro">
			<h2><a href="#uiToggle_01">브랜드체험 예약 필수 안내</a></h2>
			<div id="uiToggle_01" class="toggleDetail">
				<c:out value="${reservationInfo}" escapeXml="false" />
			</div>
		</section>
		
		<section class="mWrap">
			<ul class="tabDepth1 tNum2">
				<li><a href="#none" id="choiceCalendar">날짜 먼저선택</a></li>
				<li class="on"><strong>프로그램 먼저선택</strong></li>
			</ul>
			<div class="blankR">
	<!-- 			<a href="#none" class="btnTbl">브랜드체험 소개</a> -->
				<a href="#" class="btnTbl" onclick="javscript:showBrandIntro('E0301', 'E030101', '', 'I');">브랜드체험 소개</a>
			</div>
			<!-- 스텝1 -->
			<div class="bizEduPlace">
				<div class="result">
					<div class="tWrap" id="step1AppendProduct">
					</div>
				</div>
				<!-- 펼쳤을 때 -->
				<div class="selectDiv">
					<dl class="selcWrap">
						<dt><div class="tWrap"><em class="bizIcon step04"></em><strong class="step">STEP1/ 프로그램</strong><span>프로그램을 선택하세요.</span></div></dt>
						<dd>
							<div class="programWrap">
								
								<div class="brandTitleBox"><h2>브랜드 카테고리 선택</h2></div>
								
								<div class="selectArea sizeM" id="selectCategiretType">
									<c:forEach var="item" items="${brandCategoryType2}">
										<a href="#" onclick="javascript:setCategorytype3('${item.categorytype2}', this);">${item.categorytype2name}</a>
									</c:forEach>
								</div>
							
								<div class="" id="appendBradnCategory" style="display: block;">
									
									
								</div>
							</div>
							<!-- //programWrap -->
							<div class="btnWrap">
								<a href="#none" class="btnBasicBL" id="step1Btn" onclick="javascript:showStep2();">다음</a>
							</div>
						</dd>
					</dl>
				</div>
				<!-- //펼쳤을 때 -->
			</div>
			<!-- 스텝2 -->
			<div class="bizEduPlace">
				<div class="result">
					<div class="tWrap" id="appendResultDetail">

					</div>
				</div>
				<!-- 펼쳤을 때 -->
				<div class="selectDiv">
					<dl class="selcWrap">
						<dt><div class="tWrap"><em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜, 시간</strong><span>날짜와 시간을 선택해 주세요.</span></div></dt>
						<dd class="tempBrandReserv">
							<div class="hWrap">
								<p class="tit">날짜 선택</p>
	<!-- 							<a href="#uiLayerPop_calender" class="btnTbl" onclick="layerPopupOpen(this);return false;">체험예약 현황확인</a> -->
								<a href="#" class="btnTbl" onclick="javascript:showExpRsvComfirmPop();">체험예약 현황확인</a>
							</div>
							<section class="calenderBookWrap">
								<div class="calenderHeader">
	
								</div>
		
								<table class="tblBookCalendar">
									<caption>캘린더형 - 날짜별 체험예약가능 시간</caption>
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
									<tbody id="montCalTbody">
										
									</tbody>
								</table>
								<div class="tblCalendarBottom pdbNone">
									<div class="resrState"> 
										<span class="calIcon2 personal"></span>개인
										<span class="calIcon2 group"></span>그룹
									</div>
								</div>
								<ul class="listWarning mgWrap">
									<li>※ 날짜를 선택하시면 예약가능 시간(세션)을 확인 할 수 있습니다.</li>
<!-- 									<li>※ 예약은 월 5회까지 가능합니다. </li> -->
								</ul>
							</section>
						</dd>
						<dd>
							<div class="hWrap dashed">
								<p class="tit">시간 선택</p>
							</div>
							<div class="tblWrap">
								
								<div id="appendToSession"></div>
								
								<ul class="listWarning">
<!-- 									<li>※ 예약은 월 5회까지 가능합니다.</li> -->
<!-- 									<li>※ 특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 3개월간 예약이 불가합니다.</li> -->
									<li id="penaltyInfo">※  특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 <strong id="applyTypeValue">2개월</strong>간 예약이 불가합니다.</li>
									<li>※ PT이상부터 그룹신청이 가능합니다. </li>
								</ul>
							</div>
							
							<div class="btnWrap aNumb2">
								<a href="#none" class="btnBasicGL" onclick="javascript:backStep(1);" >이전</a>
	<!-- 							<a href="#uiLayerPop_confirm" class="btnBasicBL" onclick="layerPopupOpen(this);return false;">예약요청</a> -->
								<a href="#" class="btnBasicBL" id="step2Btn" onclick="javscript:reservationReq();">예약요청</a>
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
					<a href="/mobile/reservation/expBrandProgramForm.do" class="btnBasicGL">예약계속하기</a>
					<a href="/mobile/reservation/expInfoList.do" class="btnBasicBL">예약현황확인</a>
				</div>
			</div>
			<!-- //예약완료 -->
		</section>
		
		<!-- layer popoup -->
		<!-- 예약정보 확인 -->
		<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_confirm">
			<div class="pbLayerHeader">
				<strong>예약정보 확인</strong>
			</div>
			<div class="pbLayerContent">
		
				<table class="tblResrConform">
					
				</table>
				
				<div class="grayBox">
					위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>
					<span class="point3">[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</span>
				</div>
				
				<div class="btnWrap aNumb2">
					<span><a href="#" class="btnBasicGL" onclick="javascript:closeBrandRsvLayer();">예약취소</a></span>
					<span><a href="#" class="btnBasicBL">예약확정</a></span>
				</div>
<!-- 				<div class="btnWrap bNumb1"> -->
<!-- 					<a href="#none" class="btnBasicBL">다음</a> -->
<!-- 				</div> -->
			</div>
			<a href="#none" class="btnPopClose" onclick="javascript:closePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
		<!-- //예약정보 확인 -->
		
		<!-- 예약불가 알림 -->
		<div class="pbLayerPopup" id="uiLayerPop_cannot">
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
		<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expBrandIntroPop.jsp" %>
		<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expRsvConfirmPop.jsp" %>
	
	</section>
</div>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
<!-- </body> -->
<!-- </html> -->
