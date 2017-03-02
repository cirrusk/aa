<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appTomarrow"><aof:date datetime="${today}" pattern="${aoffn:config('format.date')}" addDate="1"/></c:set>
<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.datepicker(".datepicker", {minDate : UT.formatStringToDate("<c:out value="${appTomarrow}"/>", "<c:out value="${aoffn:config('format.date')}"/>")});
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/cdms/project/copy/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsert;
	
	setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:과정명"/>",
		name : "projectName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발년도"/>",
		name : "year",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발구분"/>",
		name : "projectTypeCd",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:시작일"/>",
		name : "startDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:종료일"/>",
		name : "endDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:종료일"/>",
		name : "endDate",
		check : {
			gt : {name : "startDate", title : "<spring:message code="필드:CDMS:시작일"/>"}
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:일괄생성"/>",
		name : "copyCount",
		data : ["!null", "number"],
		check : {
			maxlength : 2,
			le : 30
		}
	});
};

/*
 * 개발대상정보 복사
 */
doCopy = function() {
	forInsert.run();
};

/*
 * 복사 완료
 */
doCompleteInsert = function() {
	$layer.dialog("close");
};
</script>
</head>
<body>
<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>" />
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width:100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:과정명"/><span class="star">*</span></th>
			<td><input type="text" name="projectName" style="width:90%;" value="<c:out value="${detailProject.project.projectName}"/>"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발년도"/><span class="star">*</span></th>
			<td>
				<c:set var="startYear"><aof:date datetime="${today}" pattern="yyyy"/></c:set>
				<c:set var="iStartYear" value="${aoffn:toInt(startYear)}"/>
				<c:set var="yearList" value=""/>
				<c:forEach var="row" begin="${iStartYear - 1}" end="${iStartYear + 5}" step="1" varStatus="i">
					<c:if test="${i.first ne true}"><c:set var="yearList" value="${yearList},"/></c:if>
					<c:set var="yearList" value="${yearList}${row}=${row}"/>
				</c:forEach>
				<select name="year">
					<aof:code type="option" codeGroup="${yearList}" selected="${detailProject.project.year}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발구분"/><span class="star">*</span></th>
			<td>
				<select name="projectTypeCd">
					<aof:code type="option" codeGroup="CDMS_PROJECT_TYPE" selected="${detailProject.project.projectTypeCd}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발기간"/><span class="star">*</span></th>
			<td>
				<input type="text" name="startDate" value="<aof:date datetime="${detailProject.project.startDate}"/>" class="datepicker" readonly="readonly"/>
				~
				<input type="text" name="endDate" value="<aof:date datetime="${detailProject.project.endDate}"/>" class="datepicker" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:일괄생성"/><span class="star">*</span></th>
			<td>
				<input type="text" name="copyCount" style="width: 30px" /><spring:message code="글:개"/>
			</td>
		</tr>
	</tbody>
	</table>
</form>
<div class="lybox-btn">
	<div class="lybox-btn-r">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
			<a href="#" onclick="doCopy()" class="btn blue"><span class="mid"><spring:message code="버튼:생성" /></span></a>
		</c:if>
	</div>
</div>
</body>
</html>