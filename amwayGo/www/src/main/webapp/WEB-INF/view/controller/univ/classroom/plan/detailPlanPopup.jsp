<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom-popup">
<head>

<title><spring:message code="필드:개설과목:강의계획서"/></title>
<script type="text/javascript">

initPage = function() {
	doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
};

</script>
</head>

<body>
	<div class="lybox-title"><!-- lybox-title -->
        <h4 class="section-title"><spring:message code="필드:강의계획서:강의계획서상세" /></h4>
    </div>
    
    <div class="vspace"></div>
    
	<aof:text type="whiteTag" value="${detail.courseActivePlan.courseActivePlan}"/>
	
	<c:if test="${empty detail.courseActivePlan.courseActivePlan}">
		<table class="tbl-detail">
			<colgroup>
				<col/>
			</colgroup>
			<tbody>
			<tr>
				<td class="align-c"><spring:message code="글:강의계획서:강의계획서가등록되지않았습니다"/></td>
			</tr>
			</tbody>
		</table>
	</c:if>
</body>
</html>