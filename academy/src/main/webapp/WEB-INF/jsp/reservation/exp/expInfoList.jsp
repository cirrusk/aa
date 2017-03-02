<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">
/* 뒤로가기 제어 */
history.pushState(null, null, location.href); 
window.onpopstate = function(event) { 
	history.go(1);
}

var today;
var flag;

$(document).ready(function(){
	
	/* 조회 버튼 활성화 delay */
	setTimeout(function(){
	    $('#searchBtn').addClass("btnBasicRS");
	    $('#searchBtn').click(doSearch);
	 }, 1000); 
	
});

function tempViewTypeCalendar(getYear, getMonth, popDay){
	this.today = getYear;
	this.today += getMonth;
	this.today += popDay;
	
	viewTypeCalendar(getYear, getMonth, popDay, "P");
}

function viewTypeCalendar(getYear, getMonth, popDay, dayFlag){
	
	var param;
	
	/* 클릭해서 호출 : P */
	if("P" == dayFlag){

		param = {
				  getYear : getYear
				, getMonth : getMonth
				, rsvtypecode : "R02"
			};
		
	} else {

		param = {
			  getYear : $("#viewYear").val()
			, getMonth : $("#viewMonth").val()
			, rsvtypecode : "R02"
		};

	}
	
	$.ajaxCall({
		url: "<c:url value="/reservation/viewTypeCalendarAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var getCalendar = data.nowMonthCalList;
			var expRsvInfoList = data.expReservationInfoDetailList;
			var searchMonthRsvCount = data.searchMonthRsvCount;
			$("#appendCal").empty();
			
			/* 취소 팝업에서 호출했을 경우 flag를 전역변수에 저장한다 */
			if(dayFlag == "A" || dayFlag == "S"){
				flag = dayFlag;
			}
			$("#rsvCalTotalCnt").empty();
			$("#rsvCalTotalCnt").append("<strong>총 "+searchMonthRsvCount.thismonthcnt+" 개</strong>의 체험예약 내역이 있습니다.")
			
			setCalendarList(getCalendar, expRsvInfoList);
			
			monthPrePostCntCheck(searchMonthRsvCount);
			
// 			if((popDay != null || popDay != "undefined" || popDay != "" ) || ($("#viewYear").val() == today.substr(0,4) && $("#viewMonth").val() == today.substr(4,2))){
// 				detailRsvInfo("", popDay, dayFlag);
// 			}

			if(popDay != null || popDay != "undefined" || popDay != ""){
				detailRsvInfo("", popDay, dayFlag);
			}
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});

	
}

function setCalendarList(getCalendar, expRsvInfoList){
	
	var yymm = $("#viewYear option:selected").val();
	yymm += $("#viewMonth option:selected").val();
	
	var html = "";
	 
	for(var i = 0; i < getCalendar.length; i++){
		html += "<tr>";
		html += "	<td class='weekSun'><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekSun+"'>"+getCalendar[i].weekSun.replace(/(^0+)/, "");+"</em></div></td>";
		html += "	<td><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekMon+"'>"+getCalendar[i].weekMon.replace(/(^0+)/, "");+"</em></div></td>";
		html += "	<td><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekTue+"'>"+getCalendar[i].weekTue.replace(/(^0+)/, "");+"</em></div></td>";
		html += "	<td><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekWed+"'>"+getCalendar[i].weekWed.replace(/(^0+)/, "");+"</em></div></td>";
		html += "	<td><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekThur+"'>"+getCalendar[i].weekThur.replace(/(^0+)/, "");+"</em></div></td>";
		html += "	<td><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekFri+"'>"+getCalendar[i].weekFri.replace(/(^0+)/, "");+"</em></div></td>";
		html += "	<td class='weekSat'><div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+getCalendar[i].weekSat+"'>"+getCalendar[i].weekSat.replace(/(^0+)/, "");+"</em></div></td>";
		html += "</tr>";
	}
	$("#appendCal").append(html);
	
	/* 날짜 하단에 들어갈 데이터 그리기 */
	calendarSetData(expRsvInfoList);
}

function calendarSetData(expRsvInfoList){
	
	var yymm = $("#viewYear option:selected").val();
	yymm += $("#viewMonth option:selected").val();
	//console.log(expRsvInfoList);
	
	var html = "";
	var typeName = "";
	 
	for(var i = 1; i <= 31; i++){
		
		if(i < 10){
			tempI = "0"+i;
		}else{
			tempI = i;
		}
		
		html = "<div class='roomRerv'>"
		for(var j = 0; j < expRsvInfoList.length; j++){
// 			if($("#"+yymm+tempI).text().trim() == expRsvInfoList[j].reservationday){
			if($("#"+yymm+tempI).text().replace(/\s/gi, '') == expRsvInfoList[j].reservationday){
				if(typeName != expRsvInfoList[j].typename
						&& 'P03' != expRsvInfoList[j].paymentstatuscode){
					typeName = expRsvInfoList[j].typename;
					if(expRsvInfoList[j].typename.substr(0, 1) == "체"){
						html += "<span class='calIcon2 blueL'><em>체성분측정</em></span>"
					}else if(expRsvInfoList[j].typename.substr(0, 1) == "피"){
						html += "<span class='calIcon2 greenL'><em>피부측정</em></span>"
					}else if(expRsvInfoList[j].typename.substr(0, 1) == "브"){
						html += "<span class='calIcon2 redL'><em>브랜드처헴</em></span>"
					}else{
						html += "<span class='calIcon2 grayL'><em>문화체험</em></span>"
					}
				}
			}
		}
		html += "</div>"
		$("#"+yymm+tempI).parent().append(html);
		typeName = "";
	}
}

function detailRsvInfo(obj, popDay, dayFlag){
	
	this.flag = dayFlag;
	
	var yymm = $("#viewYear option:selected").val();
	yymm += $("#viewMonth option:selected").val();
	
	//console.log(popDay);
	
	var tempDay = ""
	
// 	console.log($(obj).find("id").length);
	
	if(($.trim($(obj).find("em").text()).length == "0"|| $(obj).find("em").text() == null || $(obj).find("em").text() == "") && (popDay == null || popDay == "undefined")){
		if(obj == ""){
			$("#rsvExpTbody").empty();
			$("#rsvExpTbody").append("<tr><td colspan='7'>예약내역이 없습니다.</td></tr>");
			
			return false;
		}else{
			return false;
		}
	}else{
		
		/* 클릭이벤트 로 함수 호출 시 */
		if(popDay == null || popDay == "undefined"){
			$("#appendCal").children().find("td").each(function(){
				
				if($(this).is(".weekSun") === true){
					$(this).removeClass();
					$(this).addClass("weekSun");
					
				}else if($(this).is(".weekSat") === true){
					$(this).removeClass();
					$(this).addClass("weekSat");
				}else{
					$(this).removeClass();
				}
				
			});
			
			$(obj).parent().addClass("on");
			
			tempDay = $(obj).children("em").prop("id");
			tempDay = tempDay.substr(6, 2);
			
			/* 취소 팝업에서 사용될 파라미터값 셋팅 */
			$("input[name = popDay]").val("");
			$("input[name = popDay]").val(tempDay);
			
			flag = "S";
			
		/* 취소 팝업에서 호출 하였을 경우 */
		}else{
			
			/* 현황보기 리스트 에서 캘린더보기 아이콘 클릭 하였을떼 */
			if(dayFlag == "P"){
				$("#"+this.today).parent().parent().addClass("on");
				this.flag = "S";
			}else{
				$("#"+yymm+popDay).parent().parent().addClass("on");
			}
			
			tempDay = popDay;
			
		}
		
	}
	
	rsvExpDetailInfo(tempDay, flag);

}

function rsvExpDetailInfo(tempDay, dayFlag){
	
	if(tempDay != "N"){
		if(dayFlag != "S"){
			param = {
				  getYear : $("#viewYear").val()
				, getMonth : $("#viewMonth").val()
				, rsvtypecode : "R02"
			};
		}else{
			param = {
				  getYear : $("#viewYear").val()
				, getMonth : $("#viewMonth").val()
				, getDay : tempDay
				, rsvtypecode : "R02"
			};
		}
			
		
	}else{
		param = {
			  getYear : $("#viewYear").val()
			, getMonth : $("#viewMonth").val()
			, rsvtypecode : "R02"
		};
		
		flag = "A";
		
		$("#appendCal").find("td").each(function(){
			if($(this).is(".on") === true){
				$(this).removeClass("on");
			}
		});
	}
	
	
	$.ajax({
		url: "<c:url value="/reservation/rsvExpDetailInfoAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var expRsvInfoList = data.expReservationInfoDetailList;
			
			//하단
			rsvExpDetailInfoListTable(expRsvInfoList);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}


function rsvExpDetailInfoListTable(expRsvInfoList){
	
	var expRsvHtml = "";
	
	if(flag == "C"){
		/* 예약 취소후 캘린더 상에 해당 날짜 파란색 테두리 활성화*/
		$("#"+expRsvInfoList[0].reservationdate).parent().parent().addClass("on");
	}
	
	$("#rsvExpTbody").empty();
	
	//console.log(expRsvInfoList.length);
	
	if(expRsvInfoList.length > 0){
		for(var i = 0; i < expRsvInfoList.length; i++){
			
// 			console.log(expRsvInfoList[i]);
			
			expRsvHtml	+= "<tr>"
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].rsvdate + expRsvInfoList[i].week + '<br/>' + expRsvInfoList[i].sessiontime + "</td>"
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].typename+"</td>"
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].productname+"</td>"
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].ppname+"</td>"
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].partnertype+"</td>"
			if(expRsvInfoList[i].paymentstatuscode == "P03"){
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].paymentname+"<br/>("+expRsvInfoList[i].canceldatetime+")</td>"
			}else{
			expRsvHtml	+= "	<td>"+expRsvInfoList[i].paymentname+"</td>"
			}
			if(expRsvInfoList[i].rsvcancel == "-" || expRsvInfoList[i].gettoday == expRsvInfoList[i].reservationdate){
				expRsvHtml	+= "	<td>-</td>"
			}else{
				expRsvHtml	+= "	<td><a href='javascript:void(0);' class='btnTbl' onclick=\"javascript:expInfoRsvCancel('"+expRsvInfoList[i].rsvseq+"', '"+expRsvInfoList[i].expsessionseq+"', '"+expRsvInfoList[i].reservationdate+"', '"+expRsvInfoList[i].ppseq+"', '"+expRsvInfoList[i].expseq+"', '"+expRsvInfoList[i].typecode+"');\"><span>예약취소</span></a></td>"
			}
			expRsvHtml	+= "</tr>"
		}
	}else{
		expRsvHtml	+= "<tr>"
		expRsvHtml	+= "	<td colspan='7'>예약내역이 없습니다.</td>"
		expRsvHtml	+= "</tr>"
	}
	
	$("#rsvExpTbody").append(expRsvHtml);
}


function expInfoRsvCancel(rsvseq, expsessionseq, reservationdate, ppseq, expseq, typecode){
	
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
	
	$("input[name = popFlag]").val("");
	$("input[name = popFlag]").val(flag);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	
	var frm = document.expInfoForm
	var url = "<c:url value="/reservation/expInfoRsvCanselPop.do"/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

function expInfoDetailList(purchasedate,  typeseq, ppseq, transactiontime, expsessionseq){
	
	$("input[name = purchasedate]").val(purchasedate);
	$("input[name = typeseq]").val(typeseq);
	$("input[name = ppseq]").val(ppseq);
	
	// 20170117 수정 arg 추가  transactiontime
	$("input[name = transactiontime]").val(transactiontime);
	$("input[name = expsessionseq]").val("");
	
	
	$("#expInfoForm").attr("action", "${pageContext.request.contextPath}/reservation/expInfoDetailList.do");
	$("#expInfoForm").submit();
}

function clearBtn() {
// 	$("#strYear").val("");
// 	$("#strMonth").val("");
// 	$("#endYear").val("");
// 	$("#endMonth").val("");
// 	$("#clearBtn").val("");
	
// 	$('input:checkbox[name="expType"]').each(function() {
// 	      this.checked = false;
// 	 });

	location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expInfoList.do'/>";
}

//검색호출
function doSearch() {
	
	$('#searchBtn').unbind("click");
	
	$("#expInfoForm").append("<input type='hidden' name='searchStrYear'  value='"+ $("#strYear option:selected").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchStrMonth'  value='"+ $("#strMonth option:selected").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchEndYear'  value='"+ $("#endYear option:selected").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchEndMonth'  value='"+ $("#endMonth option:selected").val() +"'>");
	$("input[name=ppseq]").val("");
	$("input[name=ppseq]").val($("#searchPpseq option:selected").val());
	
	$("input[name=expType]:checked").each(function(){
		$("#expInfoForm").append("<input type='hidden' name='searchexpType'  value='"+$(this).val()+"'>");
	});
	
	//console.log(document.referrer);
	
	$("#expInfoForm").attr("action", "/reservation/expInfoList.do");
	$("#expInfoForm").submit();
}

//페이지 이동
function doPage(page) {
	
	$("#expInfoForm > input[name='page']").val(page);  // 
	
	$("#expInfoForm").append("<input type='hidden' name='searchStrYear'  value='"+ $("#strYear option:selected").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchStrMonth'  value='"+ $("#strMonth option:selected").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchEndYear'  value='"+ $("#endYear option:selected").val() +"'>");
	$("#expInfoForm").append("<input type='hidden' name='searchEndMonth'  value='"+ $("#endMonth option:selected").val() +"'>");
	
	$("input[name=expType]:checked").each(function(){
		$("#expInfoForm").append("<input type='hidden' name='searchexpType'  value='"+$(this).val()+"'>");
	});
	
	$("input[name=ppseq]").val($("#searchPpseq option:selected").val());
	
	$("#expInfoForm").submit();
	

}

function setMonth(flag){
	var tempYear;
	var tempMonth;
	
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
	
	var tempYYMM = tempYear + tempMonth;
	
	$("#viewYear").val(tempYear);
	$("#viewMonth").val(tempMonth);
	
	$("#rsvExpTbody").empty();
	
// 	console.log(this.today.substr(0, 6));
// 	console.log(this.today.substr(6, 2));
	
	if(this.today.substr(0, 6) == tempYYMM){
		viewTypeCalendar(tempYear, tempMonth, this.today.substr(6, 2), "P");
	}else{
		viewTypeCalendar();
	}
// 		viewTypeCalendar();
	
}

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

/* 시설 <-> 체험 */
function accessParentPage(){
	var newUrl = "/reservation/roomInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}

</script>
</head>
<body>
<form id="expInfoForm" name="expInfoForm" method="get">
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	<input type="hidden" name="searchFlag"  value="D" />
	
	<!-- 취소 팝업 에서 사용될 파라미터 -->
	<input type="hidden" name="purchasedate">
	<input type="hidden" name="typeseq">
	<input type="hidden" name="ppseq">
	<input type="hidden" name="expseq">
	
	<input type="hidden" name="transactiontime">
	
	<input type="hidden" name="expsessionseq">
	<input type="hidden" name="reservationdate">
	
	<!-- 취소 팝업(부모창 호출시 필요) 에서 사용될 파라미터 -->
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="parentInfo">
	<input type="hidden" name="popYear">
	<input type="hidden" name="popMonth">
	<input type="hidden" name="popDay">
	<input type="hidden" name="popFlag">
	<input type="hidden" name="typecode">
	
</form>

<form id="expInfoCalendar" name="expInfoCalendar" method="post">
<!-- 	<input type="hidden" id="getMonth" name="getMonth"> -->
<!-- 	<input type="hidden" id="getYear" name="getYear"> -->
</form>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500370.gif" alt="체험예약 현황확인"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500370.gif" alt="체험예약 현황을 확인할 수 있습니다."></p>
	</div>

	<div class="bizroomStateBox">
		<div class="viewTypeBox">
			<div class="viewTypeSet">
				<a href="#viewTypeList" class="list on">리스트보기</a>
				<a href="#viewTypeCalendar" class="calendar" onclick="javascript:tempViewTypeCalendar('${scrData.calEndYeaer}', '${scrData.calEndMonth}', '${scrData.calToday}');">캘린더보기</a>
			</div>
			<div class="btnR"><a href="#" class="btnCont" onclick="javascript:accessParentPage();"><span>시설예약 현황확인</span></a></div>
		</div>
		
		<!-- 목록 -->
		
		<!-- 목록형 -->
		<div class="viewWrapper viewList" id="viewTypeList">
			<!-- 조회 -->
			<table class="tblInput searchTbl">
				<caption>조회옵션설정</caption>
				<colgroup>
					<col style="width:12%">
					<col style="width:58%">
					<col style="width:12%">
					<col style="width:auto">
				</colgroup>
				<tbody>
					<tr>
						<th><label for="periodStartY">등록일자</label></th>
						<td colspan="3">
<%-- 							<c:out value="${scrData.searchStrYear}"></c:out> --%>
							<select id="strYear" name="strYear" title="등록시작 년도 선택">
								<option value="">선택</option>
								<c:forEach items="${reservationYearCodeList}" var="item">
									<option value="${item}" ${item == scrData.searchStrYear ? "selected" :""}>${item}</option>
								</c:forEach>
							</select> 
							년
							<select title="등록시작 월 선택" class="mglSs" id="strMonth" name="strMonth">
								<option value="">선택</option>
								<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
									<option value="${item}" ${item == scrData.searchStrMonth ? "selected" :""}>${item}</option>
								</c:forEach>
							</select>
							월 ~
							<select title="등록종료 년도 선택" class="mglSs" id="endYear" name="endYear">
								<option value="">선택</option>
								<c:forEach items="${reservationYearCodeList}" var="item">
									<option value="${item}" ${item == scrData.searchEndYear ? "selected" :""}>${item}</option>
								</c:forEach>
							</select>
							년
							<select title="등록종료 월 선택" class="mglSs" id="endMonth" name="endMonth">
								<option value="">선택</option>
								<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
									<option value="${item}" ${item == scrData.searchEndMonth ? "selected" :""}>${item}</option>
								</c:forEach>
							</select>
							월
						</td>
					</tr>
					<tr>
						<th><label for="progressState">체험종류</label></th>
						<td>
							<c:if test="${!empty scrData.searchexpType}">
								<c:forEach items="${expRsvTypeInfoCodeList}" var="item">
									<c:set value="0" var="cnt"/>
									<c:forEach items="${scrData.searchexpType}" var="chExpType">
										<c:if test="${chExpType eq item.commonCodeSeq}">
											<label for="room1"><input type="checkbox" name="expType" value="${item.commonCodeSeq}" checked="checked"/>${item.codeName}</label>
										</c:if>
										<c:if test="${chExpType ne item.commonCodeSeq}">
											<c:set value="${cnt + 1}" var="cnt"/>
										</c:if>
									</c:forEach>
									<c:if test="${cnt eq fn:length(scrData.searchexpType)}">
										<label for="room1"><input type="checkbox" name="expType" value="${item.commonCodeSeq}"/>${item.codeName}</label>
									</c:if>
								</c:forEach>
							</c:if>
							<c:if test="${empty scrData.searchexpType}">
								<c:forEach items="${expRsvTypeInfoCodeList}" var="item">
									<label for="room1"><input type="checkbox" name="expType" value="${item.commonCodeSeq}"/>${item.codeName}</label>
								</c:forEach>
							</c:if>
						</td>
						<th><label for="paymentState">지역</label></th>
						<td>
							<select id="searchPpseq" class="selMinSize">
								<option value="">전체</option>
								<c:forEach items="${ppCodeList}" var="item">
									<option value="${item.commonCodeSeq}" ${item.commonCodeSeq == scrData.ppseq ? "selected" :""}>${item.codeName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			
			<div class="btnWrapC">
				<a href="javascript:void(0);" class="btnBasicGS" onClick="javascript:clearBtn();" >초기화</a>
				<a href="javascript:void(0);" id="searchBtn" class="btnBasicGS">조회</a>
				<!-- onclick="javascript:doSearch();" -->
			</div>
			<!-- //조회 -->
		
			<p class="topText"><strong>총 ${scrData.totalCount} 개</strong>의 등록내역이 있습니다.</p>
			<table class="tblList lineLeft">
				<caption>목록형 - 체험예약 등록내역</caption>
				<colgroup>
					<col style="width:120px" span="5">
					<col style="width:auto;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">등록일자</th>
						<th scope="col">체험종류</th>
						<th scope="col">지역</th>
						<th scope="col">예약건수</th>
						<th scope="col">취소건수</th>
						<th scope="col">상세보기</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${expInfoList}" var="item">
					<tr> 
						<c:if test="${fn:length(expInfoList) <= 0 }">
							<tr>
								<td colspan="6">예약내역이 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${fn:length(expInfoList) > 0 }">
							<td>${item.purchasedate}</td>
							<td>${item.typename}</td>
							<td>${item.ppname}</td>
							<td>${item.exprsvtotalcounnt}건</td>
							<c:if test="${item.cancelcodecount eq 0}">
								<td>-</td>
							</c:if>
							<c:if test="${item.cancelcodecount ne 0}">
								<td>${item.cancelcodecount}건</td>
							</c:if>
							<td><a href="#" class="btnTbl" onclick="javascript:expInfoDetailList('${item.purchasedate}', '${item.typeseq}', '${item.ppseq}','${item.transactiontime}')"><span>상세보기 </span></a></td>
						</c:if>
						
					</tr>
				</c:forEach>

				</tbody>
			</table>
			
			<!-- //페이지처리 -->
			<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
				<jsp:param name="rowPerPage" value="${scrData.rowPerPage}"/>
				<jsp:param name="totalCount" value="${scrData.totalCount}"/>
				<jsp:param name="colNumIndex" value="10"/>
				<jsp:param name="thisIndex" value="${scrData.page}"/>
				<jsp:param name="totalPage" value="${scrData.totalPage}"/>
			</jsp:include>
		</div>
		<!-- //목록형 -->
	
		<!-- 캘린더형 -->
		<div class="viewWrapper viewCalendar" id="viewTypeCalendar">
			<p class="topText" id="rsvCalTotalCnt"></p>
<!-- 			<p class="topText" id="rsvCalTotalCnt"><strong>총 00 개</strong>의 체험예약 내역이 있습니다.</p> -->
			<div class="calendarWrapper">
				<div class="monthlyNum">
					<strong>
<%-- 						<c:out value="${expInfoList}"/> --%>
						<select title="년도" class="year" id="viewYear" onchange="javascript:viewTypeCalendar()">
							<c:forEach items="${reservationYearCodeList}" var="item">
								<option value="${item}" ${item == scrData.calEndYeaer ? "selected" :""}>${item}</option>
							</c:forEach>
						</select>
						<select title="월" class="month" id="viewMonth" onchange="javascript:viewTypeCalendar()">
							<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
								<option value="${item}" ${item == scrData.calEndMonth ? "selected" :""}>${item}</option>
							</c:forEach>
						</select>
					</strong>
					<a href="javascript:void(0);" class="monthPrev" onclick="javascript:setMonth('pre')"><span>이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
					<a href="javascript:void(0);" class="monthNext on" onclick="javascript:setMonth('post')"><span>다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
				</div>
				
				<table class="tblCalendar">
					<caption>캘린더형 - 체험예약 내역</caption>
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
					<tbody id="appendCal">
					<!--  append Cal -->
					</tbody>
				</table>
				
				<div class="tblCalendarBottom">
					<div class="orderState"> 
						<span class="calIcon2 blue"></span>체성분측정
						<span class="calIcon2 green"></span>피부측정
						<span class="calIcon2 red"></span>브랜드체험
						<span class="calIcon2 gray"></span>문화체험
						<!-- @edit 20160701 툴팁 제거/텍스트로 변경 -->
						<span class="fcG">(체험종류 별 예약완료된 아이콘 표시)</span>
					</div>
					<div class="btnR"><a href="javascript:void(0);" class="btnCont" onclick="javascript:rsvExpDetailInfo('N');"><span>월 예약 전체보기</span></a></div>
				</div>
			</div>
			
			<!-- 해당 월 상세 테이블 -->
			<table class="tblList lineLeft tblBizroomState">
				<caption>해당 월 상세 테이블</caption>
				<colgroup>
					<col width="17%" />
					<col width="12%" />
					<col width="auto" />
					<col width="12%" />
					<col width="12%" />
					<col width="12%" />
					<col width="12%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">체험일자 </th>
						<th scope="col">체험종류 </th>
						<th scope="col">프로그램 </th>
						<th scope="col">지역 </th>
						<th scope="col">비고</th>
						<th scope="col">상태 </th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody id = "rsvExpTbody">
				</tbody>
			</table>
			<!-- //해당 월 상세 테이블 -->
		</div>
		<!-- //캘린더형 -->
	</div>
</section>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
