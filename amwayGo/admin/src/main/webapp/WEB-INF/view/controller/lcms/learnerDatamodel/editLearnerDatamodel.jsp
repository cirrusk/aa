<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CONTENTS_TYPE_SCORM"   value="${aoffn:code('CD.CONTENTS_TYPE.SCORM')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/lcms/learner/datamodel/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/lcms/learner/datamodel/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:진도율"/>",
		name : "progressMeasure",
		data : ["!null", "decimalnumber"],
		check : {
			le : 1.0,
			maxlength : 20
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습완료"/>",
		name : "completionStatus",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchLearnerDatamodel.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="learnerId" value="<c:out value="${detail.learnerDatamodel.learnerId}"/>"/>
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.learnerDatamodel.courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${detail.learnerDatamodel.courseApplySeq}"/>"/>
	<input type="hidden" name="organizationSeq" value="<c:out value="${detail.learnerDatamodel.organizationSeq}"/>"/>
	<input type="hidden" name="itemSeq" value="<c:out value="${detail.learnerDatamodel.itemSeq}"/>"/>
	<input type="hidden" name="adminUpdateYn" value="Y"/>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:주차제목"/></th>
			<td colspan="3"><c:out value="${detail.organization.title}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:교시제목"/></th>
			<td colspan="3"><c:out value="${detail.item.title}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:최종학습일시"/></th>
			<td colspan="3"><aof:date datetime="${detail.learnerDatamodel.updDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:학습횟수"/></th>
			<td colspan="3"><c:out value="${detail.learnerDatamodel.attempt}"/> <spring:message code="글:콘텐츠:회"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:학습시간"/></th>
			<td colspan="3"><aof:number value="${aoffn:toInt(detail.learnerDatamodel.sessionTime / 1000)}"/> <spring:message code="글:콘텐츠:초"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:학습완료기준"/></th>
			<td colspan="3">
				<c:choose>
					<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
						<c:out value="${empty detail.item.completionThreshold ? '0' : (detail.item.completionThreshold * 100)}"/> %
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${!empty detail.item.completionThreshold}">
								<aof:number value="${detail.item.completionThreshold}"/> <spring:message code="글:콘텐츠:초"/>
							</c:when>
							<c:otherwise>
								0 <spring:message code="글:콘텐츠:초"/>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>				
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:진도율"/></th>
			<td>
				<input type="text" name="progressMeasure" value="<c:out value="${detail.learnerDatamodel.progressMeasure}"/>">
			</td>
			<th><spring:message code="필드:콘텐츠:학습완료"/></th>
			<td>
				<input type="radio" name="completionStatus" value="completed" class="radio"
					<c:if test="${detail.learnerDatamodel.completionStatus eq 'completed'}">checked="checked"</c:if>/> <label style="margin-right:5px;"><spring:message code="글:콘텐츠:완료"/></label>
				<input type="radio" name="completionStatus" value="incomplete" class="radio"
					<c:if test="${detail.learnerDatamodel.completionStatus ne 'completed'}">checked="checked"</c:if>/> <label style="margin-right:5px;"><spring:message code="글:콘텐츠:미완료"/></label>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>