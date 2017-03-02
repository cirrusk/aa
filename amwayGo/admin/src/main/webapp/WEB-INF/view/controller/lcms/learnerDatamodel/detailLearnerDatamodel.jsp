<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CONTENTS_TYPE_SCORM"   value="${aoffn:code('CD.CONTENTS_TYPE.SCORM')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
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

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/lcms/learner/datamodel/edit.do"/>";
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchLearnerDatamodel.jsp"/>
	</div>

	<div class="modify">
		<c:if test="${detail.learnerDatamodel.courseApplySeq eq '-1'}">
			<span class="comment">* <spring:message code="글:콘텐츠:관리자의미리보기이력입니다"/></span>
		</c:if>
		<strong><spring:message code="필드:콘텐츠:학습자"/></strong>
		<span><c:out value="${detail.learnerDatamodel.learnerName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.learnerDatamodel.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:주차제목"/></th>
			<td>
				<c:out value="${detail.organization.title}"/>
			
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:교시제목"/></th>
			<td><c:out value="${detail.item.title}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:학습횟수"/></th>
			<td><c:out value="${detail.learnerDatamodel.attempt}"/> <spring:message code="글:콘텐츠:회"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:학습시간"/></th>
			<td><aof:number value="${aoffn:toInt(detail.learnerDatamodel.sessionTime / 1000)}"/> <spring:message code="글:콘텐츠:초"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:진도율"/></th>
			<td>
				<c:out value="${detail.learnerDatamodel.progressMeasure * 100}"/> %
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:학습완료기준"/></th>
			<td>
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
			<th><spring:message code="필드:콘텐츠:학습완료"/></th>
			<td>
				<c:choose>
					<c:when test="${detail.learnerDatamodel.completionStatus eq 'completed'}"><spring:message code="글:콘텐츠:완료"/></c:when>
					<c:otherwise><spring:message code="글:콘텐츠:미완료"/></c:otherwise>
				</c:choose>
			</td>
		</tr>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({
					'learnerId' : '${detail.learnerDatamodel.learnerId}',
					'courseActiveSeq' : '${detail.learnerDatamodel.courseActiveSeq}',
					'courseApplySeq' : '${detail.learnerDatamodel.courseApplySeq}',
					'organizationSeq' : '${detail.learnerDatamodel.organizationSeq}',
					'itemSeq' : '${detail.learnerDatamodel.itemSeq}'
				})" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<c:if test="${!empty dailyProgressList}">
		<div class="vspace"></div>
		<div class="lybox-title">
			<h4 class="section-title"><spring:message code="글:콘텐츠:일일진도율"/></h4>
		</div>
		
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 50px" />
			<col style="width: auto" />
			<col style="width: auto" />
			<col style="width: auto" />
			<col style="width: auto" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:콘텐츠:학습일" /></th>
				<th><spring:message code="필드:콘텐츠:진도율" /></th>
				<th><spring:message code="필드:콘텐츠:학습횟수" /></th>
				<th><spring:message code="필드:콘텐츠:학습시간" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${dailyProgressList}" varStatus="i">
			<tr>
				<td><c:out value="${i.count}"/></td>
				<td><aof:date datetime="${row.dailyProgress.studyDate}"/></td>
				<td><c:out value="${row.dailyProgress.progressMeasure * 100}"/> %</td>
				<td><c:out value="${row.dailyProgress.attempt}"/> <spring:message code="글:콘텐츠:회"/></td>
				<td><c:out value="${aoffn:toInt(row.dailyProgress.sessionTime / 60 / 1000) + 1}"/> <spring:message code="글:콘텐츠:분"/></td>
			</tr>
		</c:forEach>
		</tbody>
		</table>
		
	</c:if>

</body>
</html>