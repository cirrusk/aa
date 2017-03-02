<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BATCH_SCHEDULE_CRON" value="${aoffn:code('CD.BATCH_SCHEDULE.CRON')}"/>
<c:set var="CD_BATCH_SCHEDULE_TIME" value="${aoffn:code('CD.BATCH_SCHEDULE.TIME')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_BATCH_SCHEDULE_CRON = "<c:out value="${CD_BATCH_SCHEDULE_CRON}"/>";

var forDetail     = null;
var forUpdate   = null;
var forSynchronize   = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]datepicker
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
	
	//데몬 활성 여부 확인
	doCheckDemonYn();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/migemsdb/detail.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/migemsdb/udpate.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		dodDetail();
	};
	
	forSynchronize = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forSynchronize.config.url             = "<c:url value="/univ/migemsdb/synchronize.do"/>";
	forSynchronize.config.target          = "hiddenframe";
	forSynchronize.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forSynchronize.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSynchronize.config.fn.complete     = function(data) {
		dodDetail();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:학사연동:시작일"/>",
		name : "startDtime",
		data : ["!null"],
		check : {
            le : {name : "endDtime", title : "<spring:message code="필드:학사연동:종료일"/>"}
        }
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:학사연동:종료일"/>",
		name : "endDtime",
		data : ["!null"],
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:학사연동:연동정보"/>",
		name : "migInfoItem",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:학사연동:년도"/>/<spring:message code="필드:학사연동:학기"/>",
		name : "yearTerm",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doUpdate = function() {
	var form = UT.getById(forUpdate.config.formId);
	var demonStatusYn = form.elements["demonStatusYn"].value;
	
	if (demonStatusYn == 'Y') {
		jQuery(".demonCheck").each(function() {
			this.disabled = false;
			});
		form.elements["demonStatusYn"].value = 'N';
		forUpdate.config.message.confirm = "<spring:message code='글:학사연동:학사DB연동데몬을종료하시겠습니까?'/>";
	} else {
		form.elements["demonStatusYn"].value = 'Y';
		forUpdate.config.message.confirm = "<spring:message code='글:학사연동:학사DB연동데몬을시작하시겠습니까?'/>";
	}
	
	forUpdate.run();
};
/**
 * 상세 보기
 */
dodDetail = function() {
	forDetail.run();
};
/**
 * 즉시 반영
 */
doActive = function() {
	doSeMigInfoItemYn();
	forSynchronize.run();
};
/**
 * 연동정보 변경 시 고정되는 값
 */
 doClickMigInfoItem = function(element) {
	var $element = jQuery(element);
	var checkedValue = $element.val();
	
	if (element.checked == true) {
		$element.siblings(":checkbox").each(function() {
			if (checkedValue == '03') {
				if (this.value == '02') {
					this.checked = true;
					this.disabled = true;
				}
			} else if (checkedValue > 3) {
				if (this.value < checkedValue) {
					this.checked = true;
					this.disabled = true;
				}
			} 
		});
	} else {
		$element.siblings(":checkbox").each(function() {
			if (checkedValue == '03') {
				if (this.value == '02') {
					this.checked = false;
					this.disabled = false;
				}
			} else if (checkedValue > 3) {
				if (this.value < checkedValue) {
					this.checked = false;
					this.disabled = false;
				}
			} 
		});
	};
	
};
/**
 * 데몬사용 여부 확인
 */
 doCheckDemonYn = function() {
	var form = UT.getById(forUpdate.config.formId);
	var demonStatusYn = form.elements["demonStatusYn"].value;
	
	if (demonStatusYn == 'Y') {
		$("#linkage").hide();
		jQuery(".demonCheck").each(function() {
			this.disabled = true;
			});
		};
};
/**
 * 저장하기전에 연동정보 값 세팅 - procedure 용 데이터 
 */
doSeMigInfoItemYn = function() {
	$(":input[name='migInfoItem']").each(function() {
		if (this.checked){
			switch(this.value){
			case "01":
				$(":input[name='memberInfoYn']").val("Y");
				break;
			case "02":
				$(":input[name='categoryInfoYn']").val("Y");
				break;
			case "03":
				$(":input[name='masterInfoYn']").val("Y");
				break;
			case "04":
				$(":input[name='courseInfoYn']").val("Y");
				break;
			case "05":
				$(":input[name='applyInfoYn']").val("Y");
				break;
				
			}
		}
	});
};
/**
 * 저장하기전에 연동정보 값 세팅 - procedure 용 데이터 
 */
doBatchScheduleChange = function(hour, min) {
	if($("#batchScheduleCd").val() == CD_BATCH_SCHEDULE_CRON){
		var selectHour = "<select class='demonCheck' name='batchHour'>";
		for(var i = 1; i <= 24; i++){
			selectHour += "<option value='" + i + "'";
			selectHour += i == hour ? " selected='selected'" : "";
			selectHour += ">" + i + "</option>";
		}
		selectHour += "</select>";
			
		var selectMin = "<select class='demonCheck' name='batchMin'>";
		for(var i = 1; i <= 59; i++){
			selectMin += "<option value='" + i + "'";
			selectMin += i == min ? " selected='selected'" : "";
			selectMin += ">" + i + "</option>";
		}
		selectMin += "</select>";
		
		selectHtml = selectHour + "시 " + selectMin + "<spring:message code="필드:학사연동:분"/>";
		
		$("#timeArea").empty();
		$("#timeArea").append(selectHtml);	
	}else if($("#batchScheduleCd").val() == CD_BATCH_SCHEDULE_TIME){
		"<c:set var='timeRange'>5=5,10=10,30=30,60=60,120=120,180=180</c:set>";
		
		var selectMin = "<select class='demonCheck' name='batchMin'>";
		selectMin += "<aof:code type='option' codeGroup='${timeRange}'/>";
		selectMin += "</select>";
		
		selectHtml = selectMin + "<spring:message code="필드:학사연동:분"/>";
		
		$("#timeArea").empty();
		$("#timeArea").append(selectHtml);
		$("#FormUpdate select[name=batchMin]").val(min);
	}
}
</script>
</head>
<c:set var="migInfoItemCode">01=<spring:message code="필드:학사연동:회원정보"/>,02=<spring:message code="필드:학사연동:교과목분류"/>,03=<spring:message code="필드:학사연동:교과목정보"/>,04=<spring:message code="필드:학사연동:개설과목정보"/>,05=<spring:message code="필드:학사연동:수강정보"/></c:set>
<c:set var="timeRange">5=5,10=10,30=30,60=60,120=120,180=180</c:set>
<c:set var="activeYn">Y=<spring:message code="필드:학사연동:활성"/>,N=<spring:message code="필드:학사연동:비활성"/></c:set>
<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"></c:param>
	</c:import>

	<form id="FormDetail" name="FormDetail" method="post" onsubmit="return false;">
	</form>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="migEmsSeq" value="1"/>
	<input type="hidden" name="demonStatusYn" value="<c:out value="${detail.univMigEmsDb.demonStatusYn}"/>"/>
	<input type="hidden" name="memberInfoYn" value="N"/>
	<input type="hidden" name="categoryInfoYn" value="N"/>
	<input type="hidden" name="masterInfoYn" value="N"/>
	<input type="hidden" name="courseInfoYn" value="N"/>
	<input type="hidden" name="applyInfoYn" value="N"/>
	
	<table class="tbl-detail">
		<colgroup>
			<col style="width: 150px"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:학사연동:연동기간"/></th>
				<td>
					<input type="text" name="startDtime" id="startDtime" class="datepicker demonCheck" value="<aof:date datetime="${detail.univMigEmsDb.startDtime}"/>" readonly="readonly"> ~
					<input type="text" name="endDtime" id="endDtime" class="datepicker demonCheck" value="<aof:date datetime="${detail.univMigEmsDb.endDtime}"/>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:학사연동:연동정보"/></th>
				<td>
					<aof:code type="checkbox" codeGroup="${migInfoItemCode}" name="migInfoItem" selected="${detail.univMigEmsDb.migInfoItem}" onclick="doClickMigInfoItem(this)"  styleClass="demonCheck" labelStyle="margin-right:3px;"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:학사연동:작업간격"/></th>
				<td>
					<select class="demonCheck" name="batchScheduleCd" id="batchScheduleCd" onchange="javascript:doBatchScheduleChange();">
						<aof:code type="option" codeGroup="BATCH_SCHEDULE" selected="${detail.univMigEmsDb.batchScheduleCd}"/>
					</select>
					<span id="timeArea"></span>
					<script type="text/javascript">doBatchScheduleChange('<c:out value="${detail.univMigEmsDb.batchHour}"/>', '<c:out value="${detail.univMigEmsDb.batchMin}"/>');</script>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:학사연동:년도"/>/<spring:message code="필드:학사연동:학기"/></th>
				<td>
					<!-- 년도학기 Select Include Area Start -->
			        <select name="yearTerm" class="demonCheck">
			        	<c:import url="../include/yearTermInc.jsp"/>
			        </select>
			        <!-- 년도학기 Select Include Area End -->
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:학사연동:최종동기화일시"/></th>
				<td>
					<aof:date datetime="${detail.univMigEmsDbHistory.migLastTime}" />
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:학사연동:데몬상태"/></th>
				<td>
					<aof:code type="print" codeGroup="${activeYn}" selected="${detail.univMigEmsDb.demonStatusYn}" defaultSelected="N"></aof:code>
				</td>
			</tr>
		</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<span class="comment"><font color="red">*<spring:message code="글:학사연동:주차를설정하지않으면학사DB연동할수없습니다.주차를생성하시고학사DB를연동하시기바랍니다."/></font></span>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<c:choose>
					<c:when test="${detail.univMigEmsDb.demonStatusYn eq 'N' or empty detail.univMigEmsDb.demonStatusYn}">
						<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:학사연동:데몬시작"/></span></a>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:학사연동:데몬종료"/></span></a>
					</c:otherwise>
				</c:choose>
				<span id="linkage"><a href="#" onclick="doActive();" class="btn blue"><span class="mid"><spring:message code="버튼:학사연동:즉시연동"/></span></a></span>
			</c:if>
		</div>
	</div>
	
</body>
</html>