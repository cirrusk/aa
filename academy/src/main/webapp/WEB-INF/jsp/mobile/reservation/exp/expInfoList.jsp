<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
/* 뒤로가기 제어 */
history.pushState(null, null, location.href); 
window.onpopstate = function(event) { 
	history.go(1);
}

// var flag;
var today;

$(document.body).ready(function (){
	
	/* 캘린더 형식에서 사용될 날짜(셀렉트 박스, 현재 년, 월) 미리 셋팅 */
	searchDefultDate();
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	/* move function */
	var $pos = $("#pbContent");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 500);
	
	if($("input[name='totalCount']").val() <= 20){
		$("#moreBtn").hide();
	}
	
	/* 체험 예약 현황 리스트 형식 클릭 */
	$(".icolist").on("click", function(){
		setTimeout(function(){ abnkorea_resize(); }, 500);
	})
	
});

/* 캘린더 형식에서 사용될 날짜(셀렉트 박스, 현재 년, 월) 미리 셋팅 */
function searchDefultDate(){
	
	$.ajax({
		url: "<c:url value="/mobile/reservation/searchThreeMonthMobileAjax.do"/>"
		, type : "POST"
// 		, async : false
		, success: function(data, textStatus, jqXHR){
			var searchThreeMonth = data.searchThreeMonthMobile;
			
			
			var tempDate = searchThreeMonth.strdate.split("-");
			/* 캘린더 형에서 사용될 날짜 변수 셋팅 */
// 			$("#viewYear").val(tempDate[0]);
// 			$("#viewMonth").val(tempDate[1]);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

//더보기 
function nextPage(){
	
	var urlVal = "/mobile/reservation/expInfoMoreListAjax.do";
	
	var rowPerPageVal = $("#expInfoForm > input[name='rowPerPage']").val();
	var totalCountVal = $("#expInfoForm > input[name='totalCount']").val();
	var firstIndexVal = $("#expInfoForm > input[name='firstIndex']").val();
	var totalPageVal = $("#expInfoForm > input[name='totalPage']").val();
	var pageVal = $("#expInfoForm > input[name='page']").val();
	
	
	var ppseq = $("#ppCode option:selected").val();
	var searchexpType = new Array();
	
	$("input[name=expType]:checked").each(function(){
		searchexpType.push($(this).val());
	});
	
	
	var nextPage = Number(pageVal) + 1;
	$("#expInfoForm > input[name='page']").val(nextPage);
	if(nextPage >= totalPageVal){ 	$("#nextPage").hide(); }
	
	var params = {
		  page : nextPage
		, rowPerPage : rowPerPageVal
		, totalCount : totalCountVal
		, firstIndex : firstIndexVal
		, totalPage : totalPageVal
		, searchexpType : searchexpType
		, ppseq : ppseq
		, searchStrDateMobile : $("#strDateMobile").val()
		, searchEndDateMobile : $("#endDateMobile").val()
	};
	
	/* 데이터 20개 조회 */
	$.ajaxCall({
   		url: urlVal
   		, data: params
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){

   			$("#rsvInfoTable").append($(data).filter("#rsvInfoTable").html());
//    			$("#articleSection").append($.parseHTML(data)).find("#articleSection");
   			abnkorea_resize();
   		}
   	});
	
	/* 더보기 데이터 셋팅 */
	goPageMoreBtn();
}

//더보기 데이터 셋팅
function goPageMoreBtn() {
	var totalPageVal = $("#expInfoForm > input[name='totalPage']").val();
	var pageVal = $("#expInfoForm > input[name='page']").val();
	
	/* 마지막 페이지 일경우 20개씩 더보기 버튼 숨김 */
	if(totalPageVal == 0 || totalPageVal == pageVal) {
		$("#moreBtn").hide();
	}
}


function expInfoDetailList(purchasedate, typeseq, ppseq, transactiontime, expsessionseq){
	
	$("input[name = purchasedate]").val(purchasedate);
	$("input[name = typeseq]").val(typeseq);
	$("input[name = ppseq]").val(ppseq);
	$("input[name = transactiontime]").val(transactiontime);
	$("input[name = expsessionseq]").val(expsessionseq);
	
	$("#expInfoForm").attr("action", "${pageContext.request.contextPath}/mobile/reservation/expInfoDetailList.do");
	$("#expInfoForm").submit();
}

/* 캘린더 형식으로 보기 버튼 클릭스 오늘 날짜 디폴트로 표현하기 위해 셋팅 */
function tempViewTypeCalendar(getYear, getMonth, popDay){

	/* 전역변수에 오늘 날짜 저장 */
	this.today = getYear + getMonth + popDay;
	
	/* 달력 그리기 */
	viewTypeCalendar();
	/* 오늘 날짜에 예약된 데이터 조회 */
	detailRsvInfo('', popDay);
}

/* 달력 그리기 */
function viewTypeCalendar(){
	
	param = {
		  getYear : $("#viewYear").val()
		, getMonth : $("#viewMonth").val()
		, rsvtypecode : "R02"
	};
	
	$.ajax({
		url: "<c:url value="/mobile/reservation/viewTypeCalendarAjax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var getCalendar = data.nowMonthCalList;
			var expRsvInfoList = data.expReservationInfoDetailList;
			var searchMonthRsvCount = data.searchMonthRsvCount;
			$("#appendCal").empty();

			
			$(".topText").empty();
			$(".topText").append("<strong>총 "+searchMonthRsvCount.thismonthcnt+" 개</strong>의 체험예약 내역이 있습니다.")
			
			/* 캘린더 상에 날짜 셋팅  */
			setCalendarList(getCalendar, expRsvInfoList);
			
			/* 이전, 다음월 데이터 건수 조회(예약 데이터가 있을 경우 css적용) */
			monthPrePostCntCheck(searchMonthRsvCount);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});

}

/* 이전, 다음월 데이터 건수 조회(예약 데이터가 있을 경우 css적용) */
function monthPrePostCntCheck(searchMonthRsvCount){
	if(Number(searchMonthRsvCount.postmonthcnt) == 0){
		$(".monthNext").removeClass("on");
	}else if(Number(searchMonthRsvCount.postmonthcnt) != 0){
		$(".monthNext").removeClass("on");
		$(".monthNext").addClass("on");
	}
	
	if(Number(searchMonthRsvCount.premonthcnt) == 0){
		$(".monthPrev").removeClass("on");
	}else if(Number(searchMonthRsvCount.premonthcnt) != 0){
		$(".monthPrev").removeClass("on");
		$(".monthPrev").addClass("on");
	}
}

/* 캘린더 상에 날짜 셋팅  */
function setCalendarList(getCalendar, expRsvInfoList){
	
	var yymm = $("#viewYear option:selected").val();
	yymm += $("#viewMonth option:selected").val();
	
	var html = "";
	 
	for(var i = 0; i < getCalendar.length; i++){
		html += "<tr>";
		html += "	<td class='weekSun'>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekSun+"'>"+getCalendar[i].weekSun.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekMon+"'>"+getCalendar[i].weekMon.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekTue+"'>"+getCalendar[i].weekTue.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekWed+"'>"+getCalendar[i].weekWed.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekThur+"'>"+getCalendar[i].weekThur.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekFri+"'>"+getCalendar[i].weekFri.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "	<td class='weekSat'>";
		html += "		<a href='#none' onclick='javascript:detailRsvInfo(this)' id ='"+yymm+getCalendar[i].weekSat+"'>"+getCalendar[i].weekSat.replace(/(^0+)/, "");+"</a>";
		html += "	</td>";
		html += "</tr>";
	}
	$("#appendCal").append(html);
	
	/* 날짜 하단에 들어갈 데이터 그리기(아이콘) */
	calendarSetData(expRsvInfoList);
}

/* 날짜 하단에 들어갈 데이터 그리기(아이콘) */
function calendarSetData(expRsvInfoList){
	
	var yymm = $("#viewYear option:selected").val();
	yymm += $("#viewMonth option:selected").val();
	
	var html = "";
	var typeName = "";
	 
	for(var i = 1; i <= 31; i++){
		
		if(i < 10){
			tempI = "0"+i;
		}else{
			tempI = i;
		}
		
		html = "<span>"
		for(var j = 0; j < expRsvInfoList.length; j++){
			if($("#"+yymm+tempI).text() == Number(expRsvInfoList[j].reservationday)){
				if(typeName != expRsvInfoList[j].typename
						&& 'P03' != expRsvInfoList[j].paymentstatuscode){
					
					typeName = expRsvInfoList[j].typename;
					
					if(expRsvInfoList[j].typename == "체성분측정"){
						html += "<em class='calIcon2 blue'>예약</em>"
					}else if(expRsvInfoList[j].typename == "피부측정"){
						html += "<em class='calIcon2 green'>예약</em>"
					}else if(expRsvInfoList[j].typename == "브랜드체험"){
						html += "<em class='calIcon2 red'>예약</em>"
					}else{
						html += "<em class='calIcon2 gray'>예약</em>"
					}
				}
			}
		}
		html += "</span>"
		$("#"+yymm+tempI).append(html);
		typeName = "";
	}
}

/* 해당 날짜의  예약 내역  조회시 캘린더 상에 css적용  && 변수 셋팅 */
function detailRsvInfo(obj, popDay){
	
	var flag;
	var yymm = $("#viewYear option:selected").val();
	yymm += $("#viewMonth option:selected").val();
	
	var tempDay = ""
	
	/* 날짜가 없는곳(빈 공백)클릭시 return */
	if(($.trim($(obj).text()).length == "0" || $(obj).text() == null || $(obj).text() == "") && (popDay == null || popDay == "undefined")){
		return false;
	}else{
		
		/* 클릭이벤트(날짜 클릭) 로 함수 호출 시 */
		if(popDay == null || popDay == "undefined"){
			$("#appendCal").children().find("td").each(function(){
				$(this).children().removeClass("selcOn");
			});
			
			$(obj).addClass("selcOn");
			
			tempDay = $(obj).prop("id");
			tempDay = tempDay.substr(6, 2);
			
			/* 취소 팝업에서 사용될 파라미터값 셋팅 */
			$("input[name = popDay]").val("");
			$("input[name = popDay]").val(tempDay);
			
			falg = "C";
			
		/* 취소 팝업에서 호출 하였을 경우 & 캘린터 형식으로 선택 하였을 경우 변수 셋팅*/
		}else{
			
			flag = "L";
			tempDay = popDay;
		}
	}
	
	/* 해당 날짜에 예약된 데이터 상세 조회 */
	rsvExpDetailInfo(tempDay, flag);

}

/* 해당 날짜에 예약된 데이터 상세 조회 */
function rsvExpDetailInfo(tempDay, flag){
	var param;
	
	/* 월예약 전체 보기 클릭이 아닐 경우 */
	if(tempDay != "N"){
		param = {
			  getYear : $("#viewYear").val()
			, getMonth : $("#viewMonth").val()
			, getDay : tempDay
			, rsvtypecode : "R02"
		};
		
	/* 월예약 전체 버튼 클릭 할 경우 */
	}else{
		param = {
			  getYear : $("#viewYear").val()
			, getMonth : $("#viewMonth").val()
			, rsvtypecode : "R02"
		};
		
		/* 월 예약 전체보기 버튼 클릭시 캘린더 상에 선택 영역 삭제 */
		$("#appendCal").children().find("td").each(function(){
			$(this).children().removeClass("selcOn");
		});
		
	}
	
	$.ajax({
		url: "<c:url value="/mobile/reservation/rsvExpDetailInfoAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var expRsvInfoList = data.expReservationInfoDetailList;
			
			// 해당일에 예약 내역 셋팅
			rsvExpDetailInfoListTable(expRsvInfoList, flag);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}

//해당일에 예약 내역 셋팅
// flag 
//		-> "C" : 클릭이벤트(날짜 클릭)
//		-> "L" : 취소 팝업에서 호출 하였을 경우 || 캘린터 형식으로 선택 하였을 경우 변수 셋팅
function rsvExpDetailInfoListTable(expRsvInfoList, flag){
	
	var expRsvHtml = "";
	
	//취소 팝업에서 호출 하였을 경우 || 캘린터 형식으로 선택 하였을 경우 변수 셋팅
	if(flag == "L"){
		// 취소 팝업에서 호출 하였을 경우 날짜 선택 영역 활성화 
		if(expRsvInfoList.length > 0){
			
			/* 예약 취소후 캘린더 상에 해당 날짜 파란색 테두리 활성화*/
			$("#"+expRsvInfoList[0].reservationdate).addClass("selcOn");
		}else{
		// 캘린더 형식으로 선택 하였을 경우 현재 일자 테두리 활성화
			$("#"+this.today).addClass("selcOn");
		}
		
	}
	
	$("#rsvExpTbody").empty();
	
	
	if(expRsvInfoList.length > 0){
		for(var i = 0; i < expRsvInfoList.length; i++){
			
			expRsvHtml	+= "<dl class='tblBizroomState'>"
			expRsvHtml	+= "	<dt>"
			expRsvHtml	+= "		<span class='block'>체험일자</span>"+expRsvInfoList[i].rsvdate + expRsvInfoList[i].week + expRsvInfoList[i].sessiontime
			if(expRsvInfoList[i].rsvcancel != "-" && expRsvInfoList[i].gettoday != expRsvInfoList[i].reservationdate){
			/* 예약 취소 버튼 활성화 */
				expRsvHtml	+= "	<a href='#uiLayerPop_cancel' class='btnTbl' onclick=\"javascript:expInfoRsvCancelLayer('"+expRsvInfoList[i].rsvseq+"', '"+expRsvInfoList[i].expsessionseq+"', '"+expRsvInfoList[i].reservationdate+"', '"+expRsvInfoList[i].reservationday+"', '"+expRsvInfoList[i].ppseq+"', '"+expRsvInfoList[i].expseq+"', '"+expRsvInfoList[i].typecode+"');\">예약취소</a>"
			}
			expRsvHtml	+= "	</dt>"
			expRsvHtml	+= "	<dd>"
			if(expRsvInfoList[i].accounttype == "A02"){
			/* 브랜드 체험  && 그룹일 경우 그룹으로 표현 */
				expRsvHtml +="			<p>"+expRsvInfoList[i].typename+" | "+expRsvInfoList[i].productname+" | "+expRsvInfoList[i].ppname+" | 그룹</p>"
			
			}else if(expRsvInfoList[i].visitnumber != "N"){
			/* 문화 체험 일경우 참석인원을 표현 */
				expRsvHtml +="			<p>"+expRsvInfoList[i].typename+" | "+expRsvInfoList[i].productname+" | "+expRsvInfoList[i].ppname+" | 참석인원 "+expRsvInfoList[i].visitnumber+"명</p>"
			}else{
			/* (브랜드 체험 && 개별 ) || 체성분측정 || 피부측정 일경우*/
				expRsvHtml +="			<p>"+expRsvInfoList[i].typename+" | "+expRsvInfoList[i].productname+" | "+expRsvInfoList[i].ppname+" | "+expRsvInfoList[i].partnertype+"</p>"
			}
			expRsvHtml +="			<p>상태 : "+expRsvInfoList[i].paymentname+"</p>"
			expRsvHtml	+= "	</dd>"
			expRsvHtml	+= "</dl>"
		}
	}else{
	/* 해당 일자에 예약 내역이 없을 경우 */
		expRsvHtml	= "<p class='noMsg'>예약내역이 없습니다.<!-- 조회결과가 없습니다. --></p>";
	}
	
	$("#rsvExpTbody").append(expRsvHtml);
}

/* 예약 취소 레이어 팝업 활성화   && 취소시 필요 데이터 셋팅 */
function expInfoRsvCancelLayer(rsvseq, expsessionseq, reservationdate,reservationday, ppseq, expseq, typecode){
	
	$("#cancelMsg").show();
	
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	
	$("input[name = expsessionseq]").val("");
	$("input[name = expsessionseq]").val(expsessionseq);
	$("input[name = reservationdate]").val("");
	$("input[name = reservationdate]").val(reservationdate);
	$("input[name = ppseq]").val("");
	$("input[name = ppseq]").val(ppseq);
	
	$("input[name = expseq]").val("");
	$("input[name = expseq]").val(expseq);
	
	$("input[name = parentInfo]").val("");
	$("input[name = parentInfo]").val("CAL");
	
	$("input[name = popYear]").val("");
	$("input[name = popYear]").val($("#viewYear option:selected").val());
	$("input[name = popMonth]").val("");
	$("input[name = popMonth]").val($("#viewMonth option:selected").val());
	
	$("input[name = popDay]").val("");
	$("input[name = popDay]").val(reservationday);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	
	if($("input[name = typecode]").val() == "N"){
		$("#cancelMsg").hide();
	}
	
	layerPopupOpen("<a href='#uiLayerPop_cancel' class='btnTbl'>예약취소</a>");return false;	
}


/* 예약 취소 */
function cancelExpRsvLayerPop(){
	
	var param = {
		  rsvseq : $("input[name = rsvseq]").val()
		, expsessionseq : $("input[name = expsessionseq]").val()
		, reservationdate : $("input[name = reservationdate]").val()
		, ppseq : $("input[name = ppseq]").val()
		, expseq : $("input[name = expseq]").val()
		, typecode : $("input[name = typecode]").val()
	};
	
	var tempDate= $("input[name = reservationdate]").val()
	
	if(confirm("예약 취소를 하시겠습니까?") == true){
		$.ajax({
			url: "<c:url value="/mobile/reservation/updateCancelCodeAjax.do"/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				try{
					alert("예약이 취소되었습니다.");
					/*--------------------부모창 새로고침---------------------------------------*/
					if(data.msg == "success"){
						$("#uiLayerPop_cancel").hide();
						$("#layerMask").remove();
						
						alert("정상적으로 처리 완료 되었습니다.");
						
						/* 취소일 셋팅 */
						var popDay = $("input[name=popDay]").val();
						
						/* 달력 그리기 */
						viewTypeCalendar();
						/* 취소일 데이터 셋팅 */
						detailRsvInfo("", popDay);
					}
					/*-----------------------------------------------------------------*/
					
				}catch(e){
					//console.log(e);
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}else{
		return false;
	}

}

/* 캘린더 형식에  년, 월 변경시 데이터 셋팅 */
function setMonth(flag){
	var tempYear;
	var tempMonth;
	var tempDay;
	
	if(flag == "post"){
		if($("#viewMonth").val() == "12"){
			tempYear = Number($("#viewYear").val())+1;
			tempMonth = "01";
			
			$("#viewYear").val(tempYear);
			$("#viewMonth").val(tempMonth);
		}else if($("#viewMonth").val() != "12"){
			tempYear = $("#viewYear").val();
			tempMonth = Number($("#viewMonth").val())+1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#viewYear").val(tempYear);
				$("#viewMonth").val(tempMonth);
			}else if(tempMonth > 10){
				$("#viewYear").val(tempYear);
				$("#viewMonth").val(tempMonth);
			}
		}
		
		
	}else if(flag == "pre"){
		if($("#viewMonth").val() == "01"){
			tempYear = Number($("#viewYear").val())-1;
			tempMonth = "12";
			
			$("#viewYear").val(tempYear);
			$("#viewMonth").val(tempMonth);
		}else if($("#viewMonth").val() != "01"){
			tempYear = $("#viewYear").val();
			tempMonth = Number($("#viewMonth").val())-1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#viewYear").val(tempYear);
				$("#viewMonth").val(tempMonth);
			}else if(tempMonth > 10){
				$("#viewYear").val(tempYear);
				$("#viewMonth").val(tempMonth);
			}
		}
	}
	
	$("#viewYear").val(tempYear);
	$("#viewMonth").val(tempMonth);
	
	$("#rsvExpTbody").empty();
	
	tempDay = tempYear + tempMonth;
	
	/* 변경된 년,월  == 현재 년월 -> 현재 날짜 디폴트 처리 */
	if(tempDay == this.today.substr(0,6)){
		
		tempViewTypeCalendar(tempYear, tempMonth, this.today.substr(6,2));
	}else{
	/* 변경된 날짜와 현재 년월이 다를 경우 달력만 그리기 */
		viewTypeCalendar();
	}
}

/* 조회 버튼 클릭 */
function doSearch(){

	var tempexpType = new Array();
	
	$("input[name=ppseq]").val($("#ppCode option:selected").val());
	
	$("input[name=expType]:checked").each(function(){
		$("#expInfoForm").append("<input type='hidden' name='searchexpType'  value='"+$(this).val()+"'>");
		tempexpType.push($(this).val());
	});

	if(tempexpType.length != 0 || $("#ppseq").val() != "" || $("#ppseq").val() != null){
		$("input[name='page']").val("");
		$("input[name='page']").val("0");
		
		$("input[name='rowPerPage']").val("");
		
		$("input[name='totalCount']").val("");
		$("input[name='totalCount']").val("0");
	}
	$("#expInfoForm").append("<input type='hidden' name='searchStrDateMobile'  value='"+ $("#strDateMobile").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchEndDateMobile'  value='"+ $("#endDateMobile").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchFlag'  value='D'>");
	
	
	$("#expInfoForm").attr("action", "${pageContext.request.contextPath}/mobile/reservation/expInfoList.do");
	$("#expInfoForm").submit();
}

/* 시설 <-> 체험 */
function accessParentPage(){
	var newUrl = "/reservation/roomInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}

</script>
<!-- </head> -->
<!-- <body class="uiGnbM3"> -->

<form id="expInfoForm" name="expInfoForm" method="post">
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	
	<!-- 켈린더형에서 사용될 변수 -->
<!-- 	<input type="text" id="viewYear" name="viewYear"> -->
<!-- 	<input type="text" id="viewMonth" name="viewMonth"> -->
	
	<!-- 취소 팝업 에서 사용될 파라미터 -->
	<input type="hidden" name="purchasedate">
	<input type="hidden" name="typeseq">
	<input type="hidden" name="ppseq">
	<input type="hidden" name="expseq" value="${scrData.expseq}">
	
	<input type="hidden" name="transactiontime">
	
	<input type="hidden" name="expsessionseq">
	<input type="hidden" name="reservationdate">
	
	<!-- 취소 팝업(부모창 호출시 필요) 에서 사용될 파라미터 -->
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="parentInfo" value="CAL">
	<input type="hidden" name="popYear">
	<input type="hidden" name="popMonth">
	<input type="hidden" name="popDay">
	<input type="hidden" name="typecode">
	
</form>

<form id="expInfoCalendar" name="expInfoCalendar" method="post">
<!-- 	<input type="hidden" id="getMonth" name="getMonth"> -->
<!-- 	<input type="hidden" id="getYear" name="getYear"> -->
</form>
<div id="pbContainer">
	<section id="pbContent" class="bizroom">
			
		<div class="bizroomSwitchBox">
			<div class="listType viewTypeSwitch">
				<a href="#viewTypeList" class="icolist on"><span>리스트형 목록보기</span></a>
				<a href="#viewTypeCalendar" class="icoCalendar" onclick="javascript:tempViewTypeCalendar('${scrData.calStarYeaer}', '${scrData.calStarMonth}', '${scrData.calToday}');"><span>캘린더형 목록보기</span></a>
				<span><a href="#none" class="btnTbl" onclick="javascript:accessParentPage();" >시설예약 현황확인</a></span>
			</div>
			
			<section class="wrapperListType" id="viewTypeList" style="display: block;">
				<h2 class="hide">조회결과 - 리스트형</h2>
				
				<div class="topBox">
					<div class="mInputWrapper">
						<div class="inputWrap">
							<strong class="labelBlock">등록일자</strong>
							<div class="textBox">
								<div class="inputNum2">
									<span class="bgNone">
<%-- 										<input id="strDateMobile" name="strDateMobile" type="date" title="등록일자 시작일" class="inputDate" value="${scrData.searchStrDateMobile}"> --%>
										<input id="strDateMobile" name="strDateMobile" type="date" title="등록일자 시작일" class="inputDate" value="${scrData.strDateMobile}">
									</span>
									<span>
<%-- 										<input type="date" id="endDateMobile" name="endDateMobile" title="등록일자 종료일" class="inputDate" value="${scrData.searchEndDateMobile}"> --%>
										<input type="date" id="endDateMobile" name="endDateMobile" title="등록일자 종료일" class="inputDate" value="${scrData.endDateMobile}">
									</span>
								</div>
							</div>
						</div>
						<div class="inputWrap">
							<strong class="labelBlock">체험종류</strong>
							<div class="textBox">
								<div class="inputNum2 pdbSs">
								<c:if test="${!empty scrData.searchexpType}">
									<c:forEach items="${expRsvTypeInfoCodeList}" var="item">
										<c:set value="0" var="cnt"/>
										<c:forEach items="${scrData.searchexpType}" var="chExpType">
											<c:if test="${chExpType eq item.commonCodeSeq}">
												<input type="checkbox" name="expType" value="${item.commonCodeSeq}" checked="checked"/><label for="room1">${item.codeName}</label>
											</c:if>
											<c:if test="${chExpType ne item.commonCodeSeq}">
												<c:set value="${cnt + 1}" var="cnt"/>
											</c:if>
										</c:forEach>
										<c:if test="${cnt eq fn:length(scrData.searchexpType)}">
											<input type="checkbox" name="expType" value="${item.commonCodeSeq}"/><label for="room1">${item.codeName}</label>
										</c:if>
									</c:forEach>
								</c:if>
								<c:if test="${empty scrData.searchexpType}">
									<c:forEach items="${expRsvTypeInfoCodeList}" var="item">
										<input type="checkbox" name="expType" value="${item.commonCodeSeq}"/><label for="room1">${item.codeName}</label>
									</c:forEach>
								</c:if>
								</div>
							</div>
						</div>
						<div class="inputWrap nobrd">
							<strong class="labelSizeXS">지역</strong>
							<div class="textBox">
								<select id="ppCode" name="ppCode" title="지역 선택" class="sizeM">
									<option value="">전체</option>
									<c:forEach items="${ppCodeList}" var="item">
										<option value="${item.commonCodeSeq}" ${item.commonCodeSeq == scrData.ppseq ? "selected" :""}>${item.codeName}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="btnWrap">
							<a href="/mobile/reservation/expInfoList.do" class="btnBasicGL">초기화</a>
							<a href="#none" class="btnBasicBL" onclick="javascript:doSearch();">조회</a>
						</div>							
					</div>
				</div><!-- //.topBox -->
				
				<p class="totalMsg">총 <strong> ${scrData.totalCount} 개</strong>의 등록내역이 있습니다.</p>
				<div class="stateWrap">
					<dl class="tblBizroomState" id="rsvInfoTable">
						<c:forEach items="${expInfoList}" var="item" varStatus="status">
							<c:if test="${item.cancelcodecount eq 0}">
								<dt> 
									등록일자 : ${item.purchasedate}<em>|</em>총 ${item.exprsvtotalcounnt}건 예약 
									<a href="#none" class="btnTbl" onclick="javascript:expInfoDetailList('${item.purchasedate}', '${item.typeseq}', '${item.ppseq}','${item.transactiontime}','${item.expsessionseq}')">상세보기</a>
								</dt>
							</c:if>
							<c:if test="${item.cancelcodecount ne 0}">
								<dt>
									등록일자 : ${item.purchasedate}<em>|</em>${item.exprsvtotalcounnt}건 예약<em>|</em>${item.cancelcodecount}건 취소 
									<a href="#none" class="btnTbl" onclick="javascript:expInfoDetailList('${item.purchasedate}', '${item.typeseq}', '${item.ppseq}','${item.transactiontime}','${item.expsessionseq}')">상세보기</a>
								</dt>
							</c:if>
							<dd>${item.typename}<em>|</em>${item.ppname}</dd>
						</c:forEach>
					</dl>
					<c:if test="${scrData.totalPage ne scrData.page}">
						<div class="more" id="moreBtn">
							<a href="#none" id="nextPage" onclick="javascript:nextPage();">20개 <span>더보기</span></a>
						</div>
					</c:if>
				</div>
			</section>
			
			<section class="wrapperCalendarType" id="viewTypeCalendar" style="display: none;">
				<h2 class="hide">조회결과- 캘린더형</h2>
				<div class="viewCalendar">
					<p class="topText"></p>
	<!-- 				<p class="topText">총 <strong>00개</strong>의 시설예약 내역이 있습니다.</p> -->
					<div class="calendarWrapper">
						
						<div class="inputBox monthlyNum">
							<p class="selectBox">
								<select class="year" title="년도" id="viewYear" onchange="javascript:viewTypeCalendar()">
									<c:forEach items="${reservationYearCodeList}" var="item">
<%-- 										<option value="${item}">${item}</option> --%>
										<option value="${item}" ${item == expInfoList[0].getyear ? "selected" :""}>${item}</option>
									</c:forEach>
								</select>
								<select class="month" title="월" class="month" id="viewMonth" onchange="javascript:viewTypeCalendar()">
									<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
<%-- 										<option value="${item}">${item}</option> --%>
										<option value="${item}" ${item == expInfoList[0].getmonth ? "selected" :""}>${item}</option>
									</c:forEach>
								</select>
							</p>
							<a href="#" class="monthPrev" onclick="javascript:setMonth('pre')"><span class="hide">이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
							<a href="#" class="monthNext" onclick="javascript:setMonth('post')"><span class="hide">다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
						</div>
						
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
							<tbody id="appendCal">
								
							</tbody>
						</table>
						
						<div class="tblCalendarBottom">
							<div class="resrState"> 
								<p><span class="calIcon2 blue"></span>체성분측정
									<span class="calIcon2 green"></span>피부측정
									<span class="calIcon2 red"></span>브랜드체험
									<span class="calIcon2 gray"></span>문화체험
								</p>
							</div>
							<div class="btnR"> <a href="#none" class="btnTbl" onclick="javascript:rsvExpDetailInfo('N');">월 예약 전체보기</a></div>
						</div>
					</div>
				</div>
			
				<div class="stateWrap" id="rsvExpTbody">
					
				</div>
			</section>
		</div>
		<!-- //체험예약 현황확인 -->
		
		<!-- //layer popoup -->
		<!-- 예약취소 알림 -->
		<div class="pbLayerPopup" id="uiLayerPop_cancel" style="display: none;">
			<div class="pbLayerHeader">
				<strong>예약취소</strong>
			</div>
			<div class="pbLayerContent">
				
				<div class="cancelWrap">
					<p>예약을 취소하시겠습니까?</p>
					
					<p class="bdBox" id="cancelMsg">취소 시 상황에 따라 페널티가 적용될 수 있습니다.</p>
				</div>
				
				<div class="btnWrap aNumb2">
					<span><a href="#none" class="btnBasicGL">취소</a></span>
					<span><a href="#none" class="btnBasicBL" onclick="javascirpt:cancelExpRsvLayerPop();">확인</a></span>
				</div>
			</div>
			
			<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
		<!-- //예약취소 알림 -->
		<!-- 예약취소&동반자 변경 팝업 모음 -->
	<%-- 	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expInfoPop.jsp" %> --%>
	
	</section>
</div>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
<!-- </body> -->
<!-- </html> -->
