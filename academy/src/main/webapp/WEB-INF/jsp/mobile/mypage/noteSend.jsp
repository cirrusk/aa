<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	var lfirstIndex = 0;
	$(document.body).ready(function() {

		setTimeout(function(){ abnkorea_resize(); }, 500);

		$("#condition").on("click",function(){
			if($(".tggCnt").css("display") == "none"){
				$(".tggCnt").show();
			}else{
				$(".tggCnt").hide();
			}
		});

		//글이 20개보다 적을경우 더보기 버튼 하이드
		if($("#searchForm dl").length<20){
			$("#addplus").hide();
		};

		if($("#checkDT").val() == ""){
			search.setToday();
			search.research();
		}
	});

	function linkPage(pageIndex){
		lfirstIndex = $("#pageCheck").val()-0;
		if(pageIndex == 'top'){
			$("#condition").focus();
		}else{
		lfirstIndex+=1;

		var schDt1 = $("#dateStart").val();
		var schDt2 = $("#dateEnd").val();
		var noteservice = $("#serchList").val();
		var notecontent = $("[name='noteContent']").val();

		$('#searchForm').attr('action', '/mobile/mypage/noteSend.do').attr('method', 'post')
		.append('<input type="hidden" name="pageIndex" value="'+lfirstIndex+'"/>')
		.append('<input type="hidden" name="schDt1" value="'+schDt1+'"/>')
		.append('<input type="hidden" name="schDt2" value="'+schDt2+'"/>')
		.append('<input type="hidden" name="noteservice" value="'+noteservice+'"/>')
		.append('<input type="hidden" name="notecontent" value="'+notecontent+'"/>')
		.submit();
		}
	}
	
	var search = {
		setToday : function() {
			var getDate = new Date();
			var smonth = getDate.getMonth()+1;
			var sday = getDate.getDate();
			
			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			if(getDate.getDate()<10) sday = "0"+sday;
			
			$("#dateStart").val(getDate.getFullYear()+"-"+smonth+"-"+sday);
			$("#dateEnd").val(getDate.getFullYear()+"-"+smonth+"-"+sday);
		},
		nowMonth : function() {
			var getDate = new Date();
			var smonth = getDate.getMonth()+1;
			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			
			$("#dateStart").val(getDate.getFullYear()+"-"+smonth+"-01");
			$("#dateEnd").val(getDate.getFullYear()+"-"+smonth+"-"+LastDayOfMonth(getDate.getFullYear(), getDate.getMonth()+1));
		},
		preMonth : function(){
			var getDate = new Date();
			getDate = new Date(getDate.getFullYear(),getDate.getMonth(),getDate.getDate() - 31);
			var smonth = getDate.getMonth()+1;
			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			
			$("#dateStart").val(getDate.getFullYear()+"-"+smonth+"-01");
			$("#dateEnd").val(getDate.getFullYear()+"-"+smonth+"-"+LastDayOfMonth(getDate.getFullYear(), getDate.getMonth()+1));
		},
		reset : function() {
			$("#dateStart").val("");
			$("#dateEnd").val("");
			$("#serchList").val("");
			$("input[name='noteContent']").val("");
			search.setToday();
		},
		research : function() {
			var getDate = new Date();
			var smonth = getDate.getMonth()+1;
			var sday = getDate.getDate();

			if(getDate.getMonth()+1<10) smonth = "0"+smonth;
			if(getDate.getDate()<10) sday = "0"+sday;

			var todate = getDate.getFullYear()+"-"+smonth+"-"+sday;

			var schDt1 = $("#dateStart").val();
			var schDt2 = $("#dateEnd").val();
			var noteservice = $("#serchList").val();
			var notecontent = $("[name='noteContent']").val();

			var startday = $("#dateStart").val().replace("-","").replace("-","");
			var endday = $("#dateEnd").val().replace("-","").replace("-","");

			if(schDt2 > todate) {
				alert("기간일자를 당일 이후로 검색할수 없습니다.");
				$("#dateEnd").val(getDate.getFullYear()+"-"+smonth+"-"+sday);
				return;
			}

			if(startday>endday){
				alert("종료 연월일이 시작 연월일보다 이전일 수는 없습니다.");
				return;
			};

			$('#searchForm').attr('action', '/mobile/mypage/noteSend.do').attr('method', 'post')
			.append('<input type="hidden" name="pageIndex" value="1"/>')
			.append('<input type="hidden" name="schDt1" value="'+schDt1+'"/>')
			.append('<input type="hidden" name="schDt2" value="'+schDt2+'"/>')
			.append('<input type="hidden" name="noteservice" value="'+noteservice+'"/>')
			.append('<input type="hidden" name="notecontent" value="'+notecontent+'"/>')
			.submit();
		}
	}
	
</script>

	<!-- content area | ### academy IFRAME Start ### -->
	<section id="pbContent" class="bizroom">
		<input type="hidden" id="checkDT" value="${search.schDt1}"/>
		<input type="hidden" id="pageCheck" value="${search.pageIndex}"/>
		<h1 class="hide">맞춤쪽지</h1>
			
		<div class="toggleBox acToggleBox">
			<h2 class="tggTit"><a href="#none" id="condition" title="자세히보기 닫기">조건검색</a></h2>
			<div class="tggCnt" style="display: none;">
				<div class="srcBox">
					<div class="acSerchWrap">
						<div class="btnGrp">
							<a href="javascript:search.setToday();" class="btnTbl"><span>당일</span></a>
							<a href="javascript:search.nowMonth();" class="btnTbl"><span>당월</span></a> 
							<a href="javascript:search.preMonth();" class="btnTbl"><span>전월</span></a>
						</div>
						
						<p class="titS">기간선택</p>
						<div class="inputSel">
							<label for="dateStart">시작</label>
							<span><input type="date" id="dateStart" title="시작일"value="${search.schDt1}"/></span>
						</div>
						<div class="inputSel">
							<label for="dateEnd">종료</label>
							<span><input type="date" id="dateEnd" title="종료일" value="${search.schDt2}"/></span>
						</div>
						<div class="inputSel">
							<label for="serchList">구분</label>
							<span>
								<select id="serchList" title="검색조건 선택">
									<option value="" <c:if test="${search.noteservice eq ''}">selected="selected"</c:if>>전체</option>
									<option value="3" <c:if test="${search.noteservice eq '3'}">selected="selected"</c:if>>쇼핑</option>
									<option value="2" <c:if test="${search.noteservice eq '2'}">selected="selected"</c:if>>비즈니스</option>
									<option value="1" <c:if test="${search.noteservice eq '1'}">selected="selected"</c:if>>아카데미</option>
								</select>
							</span>
						</div>
						<div class="inputSel">
							<label>내용</label>
							<span><input type="text" name="noteContent" title="검색내용" value="${search.notecontent }"/></span>
						</div>
					</div>
					<div class="btnWrap aNumb2 mgtSs">
						<span><a href="javascript:search.reset();" class="btnBasicGL">초기화</a></span>
						<span><a href="javascript:search.research();" class="btnBasicBL">조회</a></span>
					</div>
				</div>
			</div>
		</div>
		<!-- //search -->
		<div class="acNote">
		  <form id="searchForm" name="searchForm"  method="post">
			<c:forEach var="items" items="${msgList}" varStatus="status">
				<dl>
					<c:if test="${items.gubun eq 'NEW' }"><dt class="new">${items.senddate }</dt></c:if>
					<c:if test="${items.gubun ne 'NEW' }"><dt>${items.senddate }</dt></c:if>
					<dd>[${items.noteservicename }] ${items.notecontent }</dd>
				</dl>
			</c:forEach>
			<c:if test="${empty msgList}">
				<!-- 20160803 추가 -->
				<c:choose>
					<c:when test="${checkList.uid eq 0 }">
						<dl>수신된 맞춤쪽지가 없습니다.</dl>
					</c:when>
					<c:otherwise>
						<dl>조회결과가 없습니다.</dl>
					</c:otherwise>
				</c:choose>
			</c:if>
		  </form>
		</div>
		<c:if test="${totCnt.totcnt eq 'TOO'}">
			<a href="javascript:linkPage('pageIndex');" class="listMore" id="addplus"><span>더보기</span></a>
		</c:if>
		<c:if test="${totCnt.totcnt eq 'END'}">
			<a href="javascript:linkPage('top');" class="listMoreTop"><span>TOP</span></a>
		</c:if>
	</section>
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/mobile/footer.jsp"%>
