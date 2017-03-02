<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	$(document.body).ready(function() {
		$("#checkAll").on("click", function(){
			$("input[id='check1']").prop("checked", false);
			$("input[id='check2']").prop("checked", false);
			$("input[id='check3']").prop("checked", false);
			$("input[id='checkAll']").prop("checked", true);
		});
		
		$("input[id='check1']").on("click", function(){
			$("#checkAll").prop("checked", false);
			fnchecked();
		});
		$("input[id='check2']").on("click", function(){
			$("#checkAll").prop("checked", false);
			fnchecked();
		});
		$("input[id='check3']").on("click", function(){
			$("#checkAll").prop("checked", false);
			fnchecked();
		});

		if($("#checkDT").val() == ""){
			search.setToday();
			search.search();
		};
	});

	/* 숫자만 입력받기 */
	function showKeyCode(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || keyID == 8 || keyID == 9 || keyID == 37 || keyID == 39 || keyID == 46 )
		{
			return;
		} else if(keyID == 190){
			alert("소수점은 입력 불가합니다.");
			return false;
		} else {
			return false;
		}
	}
	
	function fnchecked(){
		var $item = $("input[name='noteservice']");
		var chk=0;
		$item.each(function(i){
			if( $(this).is(":checked") ) {
				chk=chk+1;
			}
		});
		if(chk==0) $("input[id='checkAll']").prop("checked", true);
		if(chk!=0) $("input[id='checkAll']").prop("checked", false);
	}
	
	function doPage(pageNo){
		var $item = $("input[name='noteservice']");
		var noteservice = "";
		var schDt1 = $("#year1").val()+$("#month1").val()+$("#day1").val();
		var schDt2 = $("#year2").val()+$("#month2").val()+$("#day2").val();
		var checkAll = "";

		$item.each(function(i){
			if( i !=0 && $(this).is(":checked") ) {
				var chnum = "";
				if(i == 1) chnum ="3";
				if(i == 2) chnum ="2";
				if(i == 3) chnum ="1";
				if(isNull(noteservice)) {
					noteservice = noteservice + "" + chnum;
				} else {
					noteservice = noteservice + ","+chnum;
				}
			}
		});

		if($("input[id='checkAll']").is(":checked")) checkAll="1"; else checkAll="0";

		$('#searchForm').attr('action', '/mypage/noteSend.do').attr('method', 'post')
		.append('<input type="hidden" name="page" value="'+pageNo+'"/>')
		.append('<input type="hidden" name="schDt1" value="'+schDt1+'"/>')
		.append('<input type="hidden" name="schDt2" value="'+schDt2+'"/>')
		.append('<input type="hidden" name="checkAll" value="'+checkAll+'"/>')
		.append('<input type="hidden" name="check1" value="'+$("input[id='check1']").is(":checked")+'"/>')
		.append('<input type="hidden" name="check2" value="'+$("input[id='check2']").is(":checked")+'"/>')
		.append('<input type="hidden" name="check3" value="'+$("input[id='check3']").is(":checked")+'"/>')
		.append('<input type="hidden" name="schNoteservice" value="'+noteservice+'"/>')
		.append('<input type="hidden" name="schNotecontent" value="'+$("input[name='notecontent']").val()+'"/>')
		.submit();
	}
	
	var search = {
		setToday : function() {
			var getDate = new Date();
			var smonth = getDate.getMonth()+1;
			var sday = getDate.getDate();
			
			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			if(getDate.getDate()<10) sday = "0"+sday;
			
			$("#year1").val(getDate.getFullYear());
			$("#month1").val(smonth);
			$("#day1").val(sday);
			$("#year2").val(getDate.getFullYear());
			$("#month2").val(smonth);
			$("#day2").val(sday);
		},
		nowMonth : function() {
			var getDate = new Date();
			var smonth = getDate.getMonth()+1;
			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			
			$("#year1").val(getDate.getFullYear());
			$("#month1").val(smonth);
			$("#day1").val("01");
			$("#year2").val(getDate.getFullYear());
			$("#month2").val(smonth);
			$("#day2").val(LastDayOfMonth(getDate.getFullYear(), getDate.getMonth()+1));
		},
		preMonth : function(){
			var getDate = new Date();
			getDate = new Date(getDate.getFullYear(),getDate.getMonth(),getDate.getDate() - 31)
			var smonth = getDate.getMonth()+1;
			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			
			$("#year1").val(getDate.getFullYear());
			$("#month1").val(smonth);
			$("#day1").val("01");
			$("#year2").val(getDate.getFullYear());
			$("#month2").val(smonth);
			$("#day2").val(LastDayOfMonth(getDate.getFullYear(), getDate.getMonth()+1));
		},
		reset : function() {
			$("#year1").val("");
			$("#month1").val("");
			$("#day1").val("");
			$("#year2").val("");
			$("#month2").val("");
			$("#day2").val("");
			search.setToday();
			$("input[name='noteservice']").prop("checked", false);
			$("#checkAll").prop("checked", true);
			$("input[name='notecontent']").val("");
			
		}, 
		search : function() {
			var getDate = new Date();
			var syear = getDate.getFullYear();
			var smonth = getDate.getMonth()+1;
			var sday = getDate.getDate();

			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			if(getDate.getDate()<10) sday = "0"+sday;

			var todate = syear+""+smonth+sday;

			var $item = $("input[name='noteservice']");
			var noteservice = "";
			var schDt1 = $("#year1").val()+$("#month1").val()+$("#day1").val();
			var schDt2 = $("#year2").val()+$("#month2").val()+$("#day2").val();
			var checkAll = "";

			if(schDt2 > todate) {
				alert("기간일자를 당일 이후로 검색할수 없습니다.");
				$("#year2").val(syear);
				$("#month2").val(smonth);
				$("#day2").val(sday);
				return;
			}

			if(isNull($("#year1").val())){
				alert("연도를 입력해 주십시오.");
				$("#year1").focus();
				return;
			};

			if(isNull($("#year1").val().length>3)){
				alert("연도를 4자리로 입력해 주십시오.");
				$("#year1").focus();
				return;
			};

			if(isNull($("#month1").val())){
				alert("월을 입력해 주십시오.");
				$("#month1").focus();
				return;
			};

			if(isNull($("#month1").val().length>1)){
				alert("월을 2자리로 입력해 주십시오.");
				$("#month1").focus();
				return;
			};

			if($("#month1").val() > 12 || $("#month1").val() == 0){
				alert("1월~12월까지 입력해 주십시오.");
				$("#month1").focus();
				return;
			};

			if(isNull($("#day1").val())){
				alert("일을 입력해 주십시오.");
				$("#day1").focus();
				return;
			};

			if(isNull($("#day1").val().length>1)){
				alert("일을 2자리로 입력해 주십시오.");
				$("#day1").focus();
				return;
			};

			if($("#day1").val() > 31 || $("#day1").val() == 0){
				alert("1일~31일까지 입력해 주십시오.");
				$("#day1").focus();
				return;
			};

			if(isNull($("#year2").val())){
				alert("연도를 입력해 주십시오.");
				$("#year2").focus();
				return;
			};

			if(isNull($("#year2").val().length>3)){
				alert("연도를 4자리로 입력해 주십시오.");
				$("#year2").focus();
				return;
			};

			if(isNull($("#month2").val())){
				alert("월을 입력해 주십시오.");
				$("#month2").focus();
				return;
			};

			if(isNull($("#month2").val().length>1)){
				alert("월을 2자리로 입력해 주십시오.");
				$("#month2").focus();
				return;
			};

			if($("#month2").val() > 12 || $("#month2").val() == 0){
				alert("1월~12월까지 입력해 주십시오.");
				$("#month2").focus();
				return;
			};

			if(isNull($("#day2").val())){
				alert("일을 입력해 주십시오.");
				$("#day2").focus();
				return;
			};

			if(isNull($("#day2").val().length>1)){
				alert("일을 2자리로 입력해 주십시오.");
				$("#day2").focus();
				return;
			};

			if($("#day2").val() > 31 || $("#day2").val() == 0){
				alert("1일~31일까지 입력해 주십시오.");
				$("#day2").focus();
				return;
			};

			if(schDt1>schDt2){
				alert("기간선택에서 종료 연월일이 시작 연월일보다 이전일 수는 없습니다.");
				return;
			};
			
			$item.each(function(i){
				if( i !=0 && $(this).is(":checked") ) {
					var chnum = "";
					if(i == 1) chnum ="3";
					if(i == 2) chnum ="2";
					if(i == 3) chnum ="1";
					if(isNull(noteservice)) {
						noteservice = noteservice + "" + chnum;
					} else {
						noteservice = noteservice + ","+chnum;
					}
				}
			});
			
			if($("input[id='checkAll']").is(":checked")) checkAll="1"; else checkAll="0";
						
			$('#searchForm').attr('action', '/mypage/noteSend.do').attr('method', 'post')
			.append('<input type="hidden" name="page" value="1"/>')
			.append('<input type="hidden" name="schDt1" value="'+schDt1+'"/>')
			.append('<input type="hidden" name="schDt2" value="'+schDt2+'"/>')
			.append('<input type="hidden" name="checkAll" value="'+checkAll+'"/>')
			.append('<input type="hidden" name="check1" value="'+$("input[id='check1']").is(":checked")+'"/>')
			.append('<input type="hidden" name="check2" value="'+$("input[id='check2']").is(":checked")+'"/>')
			.append('<input type="hidden" name="check3" value="'+$("input[id='check3']").is(":checked")+'"/>')
			.append('<input type="hidden" name="schNoteservice" value="'+noteservice+'"/>')
			.append('<input type="hidden" name="schNotecontent" value="'+$("input[name='notecontent']").val()+'"/>')
			.submit();
		}
		
	}
	
</script>
</head>
<body>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<input type="hidden" id="checkDT" value="${search.schDt1}"/>
	<input type="hidden" id="check" value=""/>
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w040900100.gif" alt="맞춤 쪽지"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w040900100.gif" alt="한국암웨이에서 전달하는 제품, 프로모션, 사업, 교육 및 각종 이벤트에 대한 주요 메시지 모음입니다."></p>
	</div>
	<div class="customNote">
		<form id="searchForm" name="searchForm" method="post">
			<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
			<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
			<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
			<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
		<table class="tblList borderT1">
			<caption>맞춤쪽지 검색</caption>
			<colgroup>
				<col style="width:134px">
				<col style="width:auto">
			</colgroup>
			<tbody> 
				<tr>
					<th scope="row">기간선택</th>
					<td class="textL">
						<a href="javascript:search.setToday();" class="btnTbl"><span>당일</span></a>
						<a href="javascript:search.nowMonth();" class="btnTbl"><span>당월</span></a> 
						<a href="javascript:search.preMonth();" class="btnTbl"><span>전월</span></a>
						<p><input type="text" id="year1"  name="year1" onkeydown="return showKeyCode(event)" style="IME-MODE:disabled;" maxlength="4"  value="${search.year1 }" size="4"><label for="year1"> 년</label>
						   <input type="text" id="month1" name="month1" onkeydown="return showKeyCode(event)" style="IME-MODE:disabled;" maxlength="2" value="${search.month1 }" size="2"> <label for="month1">월</label>
						   <input type="text" id="day1"   name="day1" onkeydown="return showKeyCode(event)" style="IME-MODE:disabled;"  maxlength="2" value="${search.day1 }" size="2"> <label for="day1">일</label>~
						   <input type="text" id="year2"  name="year2"  onkeydown="return showKeyCode(event)" style="IME-MODE:disabled;" maxlength="4" value="${search.year2 }" size="4"><label for="year2"> 년</label>
						   <input type="text" id="month2" name="month2" onkeydown="return showKeyCode(event)" style="IME-MODE:disabled;" maxlength="2" value="${search.month2 }" size="2"> <label for="month2">월</label>
						   <input type="text" id="day2"   name="day2" onkeydown="return showKeyCode(event)" style="IME-MODE:disabled;"  maxlength="2" value="${search.day2 }" size="2"> <label for="day2">일</label>
						</p>
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td class="textL">
						<c:if test="${search.checkAll eq '1' || search.checkAll eq null }"></c:if>
						<input type="checkbox" id="checkAll" name="noteservice" <c:if test="${search.checkAll eq '1' || search.checkAll eq null }">checked="checked"</c:if>><label for="checkAll"> 전체</label>
						<input type="checkbox" id="check3" name="noteservice" <c:if test="${search.check3 eq true}">checked="checked"</c:if>><label for="check3"> 쇼핑</label>
						<input type="checkbox" id="check2" name="noteservice" <c:if test="${search.check2 eq true}">checked="checked"</c:if>><label for="check2"> 비즈니스</label>
						<input type="checkbox" id="check1" name="noteservice" <c:if test="${search.check1 eq true}">checked="checked"</c:if>><label for="check1"> 아카데미</label>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td class="textL"><input type="text" name="notecontent" title="내용" size="65" value="${search.schNotecontent }"></td>
				</tr>
			</tbody>
		</table>
	
		<div class="btnWrapC">
			<a href="javascript:search.reset();" class="btnBasicAcGS">초기화</a>
			<a href="javascript:search.search();" class="btnBasicBS">조회</a>
		</div>
		<c:if test="${!empty msgList}">
			<p class="mgtL">총 <strong>${scrData.totalCount}</strong> 건</p>
			<table class="tblList mgtS2">
				<caption>맞춤 쪽지</caption>
				<colgroup>
					<col style="width:45px">
					<col style="width:108px">
					<col style="width:87px">
					<col style="width:auto">
				</colgroup>
				<tbody>
					<c:forEach var="items" items="${msgList}" varStatus="status">
						<tr>
							<th scope="row" class="nobg">
								<c:if test="${items.gubun eq 'NEW' }"><span class="note new">New</span></c:if>
								<c:if test="${items.gubun ne 'NEW' }"><span class="note">쪽지</span></c:if>
							</th>
							<td><span class="line">${items.senddate }<br>${items.sendtime }</span></td>
							<td><span class="line1">${items.noteservicename }</span></td>
							<td class="textL">${items.notecontent }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	<c:if test="${empty msgList}">
	<!-- 20160803 추가 -->
		<c:choose>
			<c:when test="${checkList.uid eq 0 }">
				<div class="borderBox pdtbM mgtL" id="nonlist">
					<p class="textC">수신된 맞춤쪽지가 없습니다.</p>
				</div>
			</c:when>
			<c:otherwise>
				<div class="borderBox pdtbM mgtL" id="uselist">
					<p class="textC">조회결과가 없습니다.</p>
				</div>
			</c:otherwise>
		</c:choose>
	</c:if>
	<c:if test="${!empty msgList}">
		<div class="paging pdbM">
			<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
				<jsp:param name="rowPerPage" value="${scrData.rowPerPage}"/>
				<jsp:param name="totalCount" value="${scrData.totalCount}"/>
				<jsp:param name="colNumIndex" value="10"/>
				<jsp:param name="thisIndex" value="${scrData.page}"/>
				<jsp:param name="totalPage" value="${scrData.totalPage}"/>
			</jsp:include>
		</div>
	</c:if>
	</form>
	
	<div class="lineBox mgtL">
		<ul class="listDot">
			<li>수신된 맞춤메시지는 2년간 보관됩니다.</li>
			<li>더욱 자세한 문의는 <strong>한국암웨이 고객센터 Tel) 1588-0080</strong> 으로 문의 바랍니다.</li>
		</ul>
	</div>
	
</section>
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
