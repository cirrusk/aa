<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_PLAN" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.PLAN')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forEdit        = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/course/active/plan/edit.do"/>";
};

/**
 * 수정화면을 호출하는 함수
 */
doEdit = function() {
	// 수정화면 실행
	forEdit.run();
};

</script>
</head>

<body>

    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
    </c:import>

	<c:import url="../../include/commonCourseActive.jsp"></c:import>

	<c:set var="elementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_PLAN}"/>
	<c:import url="../include/commonCourseActiveElement.jsp">
		<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>
	
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
	
	<div class="lybox-title mt10"><!-- lybox-title -->
        <h4 class="section-title"><spring:message code="필드:강의계획서:강의계획서상세" /></h4>
    </div>
    
	<aof:text type="whiteTag" value="${detail.courseActivePlan.courseActivePlan}"/>

	<c:if test="${empty detail.courseActivePlan.courseActivePlan}">
		<table class="tbl-detail">
			<colgroup>
				<col/>
			</colgroup>
			<tbody>
			<tr>
				<td align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
			</tbody>
		</table>
	</c:if>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doEdit();" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
		</div>
	</div>
</body>
</html>