<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>
<script type="text/javascript">	
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
var fn_totalCount = function(){
	$("#totalCount").html( eval($("#testcount_1").val()) + eval($("#testcount_2").val()) + eval($("#testcount_3").val()));
	$("#totalScore").html( eval($("#testpoint_1").val()) * eval($("#testcount_1").val()) + eval($("#testpoint_2").val()) * eval($("#testcount_2").val()) + eval($("#testpoint_3").val()) * eval($("#testcount_3").val()));
};

var fn_setCount = function( idx ){
	if( !isNumber( $("#testcount_" + idx).val() ) ) {
		$("#testcount_" + idx).val("0");
	} else {
		//입력된 총 문제 수와 비교하여 총 문제수 이하로 출제할 것
		if( eval($("#answercount_"+idx).val()) < eval($("#testcount_"+idx).val()) ) {
			alert("출제 문제수를 확인하세요.");
			$("#testcount_"+idx).val("0");
			fn_totalCount();
			return;
		}
	}
	fn_totalCount();
};
var fn_setPoint = function( idx ){
	if( !isNumber( $("#testpoint_" + idx).val() ) ) {
		$("#testpoint_" + idx).val("0");
	}
	fn_totalCount();
};

$(document).ready(function(){

	//총 출제 문제수 및 총점수 계산
	fn_totalCount();
	
	$("#categoryid").on("change", function(){
		if( this.value != "" ) {
			$.ajaxCall({
				url: "<c:url value='/manager/lms/testMg/lmsTestMgTestPoolAjax.do'/>"
		   		, data: {
		   			categoryid : this.value
		   		}
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		return;
					} else {
						//시험문제출제기준정보 변경하기
						if( data.dataList != null ) {
							for(var i=0;i<data.dataList.length; i++) {
								$("#answercount_"+(i+1)).val( data.dataList[i].answercount );
								$("#answercountText_"+(i+1)).html( data.dataList[i].answercount );
								
								$("#testcount_"+(i+1)).val("0");
								$("#testpoint_"+(i+1)).val("0");
							}
							
							fn_totalCount();
						}
					}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
		   		}
			});			
		}
	});
	
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		if( $("#answertotal").val() != 0 ) {
			alert("시험응시자가 있으므로 시험지를 수정할 수 없습니다.");
			return;
		}
		
		//입력여부 체크
		if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		//입력 로직 처리할 것
		var startdateyymmdd = $("#startdateyymmdd").val(); 
		var startdatehh = $("#startdatehh").val();
		var startdatemm = $("#startdatemm").val();
		var enddateyymmdd = $("#enddateyymmdd").val(); 
		var enddatehh = $("#enddatehh").val();
		var enddatemm = $("#enddatemm").val();
		
		var startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm + ":00"; 
		var enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm + ":00";
			
		if(startdateyymmdd == ""){
			alert("시험시작일을 선택해 주세요.");
			return;
		}
		if(enddateyymmdd == ""){
			alert("시험종료일을 선택해 주세요.");
			return;
		}
		if(startdate > enddate){
			alert("시험시작일시가 시험종료일시보다 이후입니다. \n시험기간을 확인해 주세요.");
			return;
		}
		$("#startdate").val(startdate);
		$("#enddate").val(enddate);
		
		//통과점수를 100점까지 허용
		if( $("#passpoint").val() > 100 ) {
			alert("통과점수는 100점 이하입니다. \n통과점수를 확인해 주세요.");
			return;
		}
		
		//시험문제 출제 기준 정보 확인
		if( $("input:radio[name=testtype]:checked").val() == "O" ) {
			if(eval($("#totalScore").text()) != 100) {
				alert("총 점수는 100점 이어야 합니다.");
				return;
			}
		} 
		
		if( !confirm("시험지를 저장하겠습니까?") ) {
			return;
		}
		
		var param = $("#frm").serialize();
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/testMg/lmsTestMgSaveAjax.do"/>"
	   		, data: param
	   		, type: 'POST'
			, contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.cnt < 1){
	           		alert("<spring:message code="errors.load"/>");
	           		return;
	   			} else {
	   				alert("저장이 완료되었습니다.");
	   				$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.fn_selectList();
					closeManageLayerPopup("searchPopup");
	   			}
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	   		}
	   	});
	});
	
	$("#testtype1").on("click", function(){
		//온라인 클릭
		$("#submitArea").show();
		$("#submitAreaTitle").show();
	});
	$("#testtype2").on("click", function(){
		//오프라인 클릭
		$("#submitArea").hide();
		$("#submitAreaTitle").hide();
	});
	
});
</script>

<div id="popwrap">
	<!--pop_title //-->
	<div class="title clear">
		<h2 class="fl">시험지관리</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	<!--// pop_title -->
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:800px">
<form id="frm" name="frm" method="post">	
		<div id="popcontent">
			<!-- Sub Title -->
			<div class="poptitle clear">
				<h3>시험지 기본정보</h3>
			</div>
			<!--// Sub Title -->
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<!-- <table> -->
					<colgroup>
						<col width="20%" />
						<col width="80%"  />
					</colgroup>
					<tr>
						<th>문제분류</th>
						<td>
							<input type="hidden" id="inputtype" name="inputtype" value="${param.inputtype}" />
							<input type="hidden" id="courseid" name="courseid" value="${param.courseid}" />
							<input type="hidden" id="openflag" name="openflag" value="C" />
							<input type="hidden" id="coursecontent" name="coursecontent" value="" />
							<input type="hidden" id="answertotal" name="answertotal" value="${detail2.answertotal}" />
							
							<select id="categoryid" name="categoryid" class="required" style="width:auto; min-width:200px" >
								<option value="">선택</option>
								<c:forEach items="${lmsCategoryList}" var="item">
									<option value="${item.categoryid}" <c:if test="${ item.categoryid == detail.categoryid }">selected</c:if>>${item.categoryname}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>시험지명</th>
						<td>
							<input type="text" id="coursename" name="coursename" style="width:90%;" value="${detail.coursename}" class="AXInput required" maxlength="50" title="시험지명">		
						</td>
					</tr>
					<tr>
						<th>시험기간</th>
						<td>
							<span class="required"></span>
							<input type="hidden" id="startdate" name="startdate"> 
							<input type="hidden" id="enddate" name="enddate">
							<input type="text" id="startdateyymmdd" name="startdateyymmdd"  value="${detail.startdateyymmdd}" title="설문시작일" class="AXInput datepDay" >
							<select id="startdatehh" name="startdatehh" style="width:auto; min-width:80px"  title="설문시작시" >
								<c:forEach items="${ hourList}" var="data" varStatus="status">
									<option value="${data.value }" <c:if test="${detail.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
								</c:forEach>
							</select>	
							<select id="startdatemm" name="startdatemm" style="width:auto; min-width:100px" title="설문시작분" >
								<c:forEach items="${ minute2List}" var="data" varStatus="status">
									<option value="${data.value }" <c:if test="${detail.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
								</c:forEach>
							</select>	
							 ~  
							<input type="text" id="enddateyymmdd" name="enddateyymmdd"  value="${detail.enddateyymmdd}" title="설문종료일" class="AXInput datepDay" >
							<select id="enddatehh" name="enddatehh" style="width:auto; min-width:80px"  title="설문종료시" >
								<c:forEach items="${ hourList}" var="data" varStatus="status">
									<option value="${data.value }" <c:if test="${detail.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
								</c:forEach>
							</select>
							<select id="enddatemm" name="enddatemm" style="width:auto; min-width:80px" title="설문종료분" >
								<c:forEach items="${ minute2List}" var="data" varStatus="status">
									<option value="${data.value }" <c:if test="${detail.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>제한시간</th>
						<td>
							<input type="text" id="limittime" name="limittime" title="제한시간" class="required isNum" style="width:auto; min-width:30px;" value="${detail2.limittime}" maxlength="5"/> 분
						</td>
					</tr>
					<tr>
						<th>통과점수</th>
						<td>
							<input type="text" id="passpoint" name="passpoint" title="통과점수" class="required isNum" style="width:auto; min-width:30px;" value="${detail2.passpoint}" maxlength="3"/> 점 이상
						</td>
					</tr>
					<tr>
						<th>시험구분</th>
						<td>
							<label class="required" title="시험구분"><input type="radio" id="testtype1" name="testtype" value="O" class="AXInput" <c:if test="${ detail2.testtype == 'O'}">checked</c:if>> 온라인</label> 
							<label><input type="radio" id="testtype2" name="testtype" value="F" class="AXInput" <c:if test="${ detail2.testtype == 'F'}">checked</c:if>> 오프라인</label> 
						</td>
					</tr>
				</table>
			</div>
			<div id="submitAreaTitle" class="poptitle clear" <c:if test="${ detail2.testtype == 'F'}">style="display:none;"</c:if>>
				<h3>시험문제출제기준정보</h3>
			</div>
			<div id="submitArea" class="tbl_write" <c:if test="${ detail2.testtype == 'F'}">style="display:none;"</c:if>>
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="5%" />
						<col width="20%" />
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
					</colgroup>
					<tr height="40">
						<th style="text-align:center;">No</th>
						<th style="text-align:center;">문제유형</th>
						<th style="text-align:center;">총 문제수</th>
						<th style="text-align:center;">출제 문제수</th>
						<th style="text-align:center;">문제별 점수</th>
					</tr>
					<c:forEach items="${testSubmitList}" var="items" varStatus="status">
					<tr>
						<td style="text-align:center;">${status.count}</td>
						<td style="text-align:center;">
							<c:if test='${items.answertype eq "1" }'>선일형</c:if>
							<c:if test='${items.answertype eq "2" }'>선다형</c:if>
							<c:if test='${items.answertype eq "3" }'>주관식</c:if>
							<input type="hidden" id="answertype_${status.count}" name="answertype" value="${items.answertype}" />
						</td>
						<td style="text-align:center;">
							<span id="answercountText_${status.count}">${items.answercount}</span>
							<input type="hidden" id="answercount_${status.count}" name="answercount" value="${items.answercount}" />
						</td>
						<td style="text-align:center;">
							<input type="text" id="testcount_${status.count}" name="testcount" value="${items.testcount}" onblur="fn_setCount('${status.count}');" />
						</td>
						<td style="text-align:center;">
							<input type="text" id="testpoint_${status.count}" name="testpoint" value="${items.testpoint}" onblur="fn_setPoint('${status.count}');"/>
						</td>
					</tr>
					</c:forEach>
					<tr>
						<td colspan="5" align="center">
							<span>총 출제 문제 수 : <span id="totalCount"/>, 총점수 : <span id="totalScore"/></span>
						</td>
					</tr>
				</table>
			</div>
			<div align="center">
				<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>
				<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
			</div>	
		</div>
</form>		
	</div>
	
</div>
