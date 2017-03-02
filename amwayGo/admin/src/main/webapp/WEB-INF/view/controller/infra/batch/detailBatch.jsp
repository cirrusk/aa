<%@page pageEncoding="UTF-8"%><%@include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_BATCH_STATUS_RUN"  value="${aoffn:code('CD.BATCH_STATUS.RUN')}"/>
<c:set var="CD_BATCH_STATUS_STOP" value="${aoffn:code('CD.BATCH_STATUS.STOP')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate = null;
var forListHistory = null;

initPage = function() {
	doInitializeLocal();
	doHistoryList();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url = "<c:url value="/infra/batch/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"});
	forUpdate.config.url = "<c:url value="/infra/batch/update.do"/>";
	forUpdate.config.target = "updateframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>";
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete = function() {
		doList();
	};
	
	forListHistory = $.action("submit", {formId : "FormHistoryList"});
	forListHistory.config.url	= "<c:url value="/infra/batch/history/list.do"/>";
	forListHistory.config.target = "historyIframe";
	
	setValidate();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 저장
 */
doUpdate = function() {
	forUpdate.run();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:배치:작업명"/>"
		,name : "batchName"
		,data : ["!null"]
		,check : {
			maxlength : 300
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:배치:스케줄"/>"
		,name : "batchSchedule"
		,check : {
			maxlength : 100
		}
	});
};
/**
 * 배치 수행 이력 목록 조회
 */
doHistoryList = function() {
	forListHistory.run();
};
/**
 * 배치 수행 이력 목록 조회
 */
doUpdateStatus = function(status) {
	$("#FormUpdate input[name=batchStatusCd]").val(status);
	forUpdate.run();
};
/**
 * 스케줄 작성 도움말 영역 제어
 */
doDisplayScheduleInfo = function() {
	if($("#scheduleInfo").css("display") != "none"){
		$("#scheduleInfo").hide();
		$("#scheduleInfoBtn").text("<spring:message code="버튼:배치:스케줄도움말보기"/>");
	}else{
		$("#scheduleInfo").show();
		$("#scheduleInfoBtn").text("<spring:message code="버튼:배치:스케줄도움말닫기"/>");	
	}
};
</script>
</head>
<body>

	<c:set var="runStatus">Y=<spring:message code="필드:배치:성공"/>,N=<spring:message code="필드:배치:실패"/></c:set>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보"/></c:param>
	</c:import>
	
	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="필드:배치:기본정보"/></h4>
	</div>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="batchSeq" value="<c:out value="${batchDetail.batch.batchSeq}"/>"/>
		<input type="hidden" name="batchStatusCd" value="<c:out value="${batchDetail.batch.batchStatusCd}"/>"/>
		<input type="hidden" name="editYn" value="Y"/>
	
		<table class="tbl-detail">
			<colgroup>
				<col style="width: 10%;">
				<col style="width: 40%;">
				<col style="width: 10%;">
				<col style="width: 40%;">
			</colgroup>
			<tbody>
				<tr>
					<th><spring:message code="필드:배치:작업명"/></th>
					<td colspan="3">
						<input type="text" name="batchName" style="width: 100%;" value="<c:out value="${batchDetail.batch.batchName}"/>"
							<c:if test="${batchDetail.batch.batchStatusCd eq CD_BATCH_STATUS_RUN or batchDetail.batch.batchId eq aoffn:config('migration.job')}">disabled="disabled"</c:if>
						/>
					</td>
				</tr>
				<tr>
					<th><spring:message code="필드:배치:최근수행시간"/></th>
					<td><aof:date datetime="${batchDetail.batch.batchCompletetionDtime}" pattern="${aoffn:config('format.datetime')}"/> (<aof:code type="print" codeGroup="${runStatus}" selected="${batchDetail.batch.batchYn}"/>)</td>
					<th><spring:message code="필드:배치:최근소요시간"/></th>
					<td><c:out value="${batchDetail.batch.displayRunningTime}"/></td>
				</tr>
				<tr>
					<th><spring:message code="필드:배치:총수행횟수"/></th>
					<td><c:out value="${batchDetail.batch.batchCount}"/></td>
					<th><spring:message code="필드:배치:BINID"/></th>
					<td><c:out value="${batchDetail.batch.batchId}"/></td>
				</tr>		
				<tr>
					<th><spring:message code="필드:배치:작업상태"/></th>
					<td><aof:code type="print" codeGroup="BATCH_STATUS" selected="${batchDetail.batch.batchStatusCd}"/></td>
					<th><spring:message code="필드:배치:스케줄"/></th>
					<td>
						<input type="text" name="batchSchedule" style="width: 100%;" value="<c:out value="${batchDetail.batch.batchSchedule}"/>"
							<c:if test="${batchDetail.batch.batchStatusCd eq CD_BATCH_STATUS_RUN or batchDetail.batch.batchId eq aoffn:config('migration.job')}">disabled="disabled"</c:if>
						/>
					</td>
				</tr>
			</tbody>
		</table>
	
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${batchDetail.batch.batchId ne aoffn:config('migration.job')}">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<c:choose>
						<c:when test="${batchDetail.batch.batchStatusCd eq CD_BATCH_STATUS_RUN}">
							<a href="#" onclick="doUpdateStatus('<c:out value="${CD_BATCH_STATUS_STOP}"/>');" class="btn blue"><span class="mid"><spring:message code="필드:배치:작업중지"/></span></a>
						</c:when>
						<c:otherwise>
							<a href="#" onclick="doUpdateStatus('<c:out value="${CD_BATCH_STATUS_RUN}"/>');" class="btn blue"><span class="mid"><spring:message code="필드:배치:작업재개"/></span></a>
							<a href="#" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:otherwise>
					</c:choose>
				</c:if>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue">
				<span class="mid"><spring:message code="버튼:목록"/></span>
			</a>
			<a href="#" onclick="doDisplayScheduleInfo(); return false;" class="btn blue">
				<span class="mid" id="scheduleInfoBtn"><spring:message code="버튼:배치:스케줄도움말보기"/></span>
			</a>
		</div>
	</div>

	<div id="scheduleInfo" style="display: none;">
		<table class="tbl-detail">
			<colgroup>
				<col style="width: auto;">
			</colgroup>
			<tbody>
				<tr>
					<td>
						<div class="comment"><spring:message code="글:설정:스케줄러도움말"/></div>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="vspace"></div>
		<div class="vspace"></div>
	</div>	
	
	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="필드:배치:수행이력"/></h4>
	</div>
	
	<iframe name="historyIframe" id="historyIframe" frameborder="0" width="100%" scrolling="no" style="height: 600px; max-height: 100%"></iframe>
	<iframe name="updateframe" id="updateframe" frameborder="0" style="display: none;"></iframe>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;"></form>
	<form name="FormHistoryList" id="FormHistoryList" method="post" onsubmit="return false;">
		<input type="hidden" name="srchBatchSeq" value="<c:out value="${batchDetail.batch.batchSeq}"/>"/>
	</form>
	
</body>
</html>
