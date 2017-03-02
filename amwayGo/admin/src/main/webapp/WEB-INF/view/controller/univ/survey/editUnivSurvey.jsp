<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_TYPE_GENERAL" value="${aoffn:code('CD.SURVEY_TYPE.GENERAL')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER"    value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.ESSAY_ANSWER')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doChangeExampleCount();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/survey/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/survey/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before = function() {
		jQuery("#" + forUpdate.config.formId + " :input[name='surveyExampleTitles']").filter(":disabled").val("");
		jQuery(".exists").find(":input").attr("disabled", false);
		return true;
	};
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/univ/survey/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:설문:설문제목"/>",
		name : "surveyTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 1000
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:설문:보기"/>",
		name : "surveyExampleTitles",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		}
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 보기수 변경
 */
doChangeExampleCount = function() {
	var $examples = jQuery("#examples");
	var generalExampleCount = $examples.find(":input[name='generalExampleCount']").val();
	$examples.find(":input[name='exampleCount']").val(generalExampleCount);
	var count = $examples.find(":input[name='exampleCount']").val();
	count = parseInt(count, 10);
	$examples.find(".example").each(function(index){
		if (index < count) {
			jQuery(this).show().find(":input").attr("disabled", false);
		} else {
			jQuery(this).hide().find(":input").attr("disabled", true);
		}
	});
	if (jQuery("#selectCount").is(":visible") == true) {
		jQuery(".satisfy_score").hide();
	} else {
		jQuery(".satisfy_score").show();
	}
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchUnivSurvey.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="surveySeq" value="<c:out value="${detail.univSurvey.surveySeq}"/>">
	<input type="hidden" name="surveyTypeCd" value="<c:out value="${detail.univSurvey.surveyTypeCd}"/>">
	<input type="hidden" name="surveyItemTypeCd" value="<c:out value="${detail.univSurvey.surveyItemTypeCd}"/>">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:설문:설문유형"/></th>
			<td><aof:code type="print" codeGroup="SURVEY_TYPE" selected="${detail.univSurvey.surveyTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문문항유형"/></th>
			<td>
				<c:choose>
					<c:when test="${detail.univSurvey.surveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
						<aof:code type="print" codeGroup="SURVEY_GENERAL_TYPE" selected="${detail.univSurvey.surveyItemTypeCd}"/>
					</c:when>
					<c:otherwise>
						<aof:code type="print" codeGroup="SURVEY_SATISFY_TYPE" selected="${detail.univSurvey.surveyItemTypeCd}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문제목"/></th>
			<td>
				<textarea name="surveyTitle" style="width:65%;height:15px;"><c:out value="${detail.univSurvey.surveyTitle}"/></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:사용여부"/></th>
			<td><aof:code type="radio" name="useYn" codeGroup="YESNO" ref="2" selected="${detail.univSurvey.useYn}" removeCodePrefix="true" labelStyleClass="radioLabel"/></td>
		</tr>
		<c:if test="${detail.univSurvey.surveyItemTypeCd ne CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER}">
			<tr id="examples">
				<td colspan="2">
					<ul>
						<li id="selectCount" style="line-height:25px;
							<c:if test="${detail.univSurvey.surveyTypeCd ne CD_SURVEY_TYPE_GENERAL}">
								display:none;
							</c:if>
						">
							<spring:message code="필드:설문:보기수"/>&nbsp;&nbsp;
							<input type="hidden" name="exampleCount" value="${aoffn:size(detail.listSurveyExample)}">
							<select name="generalExampleCount" onchange="doChangeExampleCount(this)" style="width:50px;">
								<c:choose>
									<c:when test="${detail.univSurvey.surveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
										<aof:code type="option" codeGroup="2=2,3=3,4=4,5=5" defaultSelected="${aoffn:size(detail.listSurveyExample)}"/>
									</c:when>
									<c:otherwise>
										<aof:code type="option" codeGroup="2=2,3=3,4=4,5=5,6=6,7=7" defaultSelected="${aoffn:size(detail.listSurveyExample)}"/>
									</c:otherwise>
								</c:choose>
							</select>
						</li>
						
						<c:if test="${detail.univSurvey.surveyTypeCd ne CD_SURVEY_TYPE_GENERAL}">
							<spring:message code="필드:설문:보기수"/>&nbsp;&nbsp;<c:out value="${aoffn:size(detail.listSurveyExample)}"/>
						</c:if>

						<c:forEach var="row" items="${detail.listSurveyExample}" varStatus="i">
							<li style="line-height:25px;" class="example exists">
								<spring:message code="글:설문:${i.count}"/>
								<input type="hidden" name="surveyExampleSeqs" value="<c:out value="${row.univSurveyExample.surveyExampleSeq}"/>">
								<input type="hidden" name="sortOrders" value="<c:out value="${i.count}"/>">
								<input type="text" name="surveyExampleTitles" value="<c:out value="${row.univSurveyExample.surveyExampleTitle}"/>" style="width:480px;">
								<span class="satisfy_score">
									<spring:message code="필드:설문:점수"/>
									<input type="text" name="measureScores" value="<c:out value="${row.univSurveyExample.measureScore}"/>" class="notedit" style="width:30px;text-align:center;" >
								</span>
							</li>
						</c:forEach>
						<c:forEach var="row" begin="${aoffn:size(detail.listSurveyExample) + 1}" end="5" step="1" varStatus="i">
							<li style="line-height:25px;" class="example">
								<spring:message code="글:설문:${row}"/>
								<input type="hidden" name="surveyExampleSeqs">
								<input type="hidden" name="sortOrders" value="<c:out value="${row}"/>">
								<input type="text" name="surveyExampleTitles" style="width:480px;">
								<span class="satisfy_score">
									<spring:message code="필드:설문:점수"/>
									<input type="text" name="measureScores" value="1" class="notedit" style="width:30px;text-align:center;" >
								</span>
							</li>
						</c:forEach>
					</ul>
				</td>
			</tr>
		</c:if>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="surveySeq" value="<c:out value="${detail.univSurvey.surveySeq}"/>">
		<c:forEach var="row" items="${detail.listSurveyExample}" varStatus="i">
			<input type="hidden" name="surveyExampleSeqs" value="<c:out value="${row.univSurveyExample.surveyExampleSeq}"/>">
		</c:forEach>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<c:choose>
					<c:when test="${detail.univSurvey.useCount gt 0}">
						<div class="comment"><spring:message code="글:설문:활용중인데이터는수정및삭제를할수없습니다"/></div>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
					</c:otherwise>
				</c:choose>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>