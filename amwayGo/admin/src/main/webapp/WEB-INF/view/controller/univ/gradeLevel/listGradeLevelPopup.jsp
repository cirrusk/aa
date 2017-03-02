<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EVALUATE_METHOD_TYPE_ABSOLUTE"    value="${aoffn:code('CD.EVALUATE_METHOD_TYPE.ABSOLUTE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
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
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 30%" />
		<col style="width: 30%" />
		<col style="width: auto" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:성적등급관리:성적등급"/></th>
			<th><spring:message code="필드:성적등급관리:평점"/></th>
	<c:choose>
		<c:when test="${getDetail.courseActive.evaluateMethodTypeCd eq CD_EVALUATE_METHOD_TYPE_ABSOLUTE }">
			<th><spring:message code="필드:성적등급관리:절대평가"/></th>
		</c:when>
		<c:otherwise>
			<th><spring:message code="필드:성적등급관리:상대평가"/></th>
		</c:otherwise>
	</c:choose>
		</tr>
	</thead>
	<tbody>
		<c:set var="evalAbsoluteScore" value="100" />
		<c:set var="evelRelativeScore" value="1" />
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
        <tr>
            <td>
            	<input type="hidden" name="yearTerms" value="<c:out value="${row.univGradeLevel.yearTerm }" />" />
            	<input type="hidden" name="gradeLevelCds" value="<c:out value="${row.univGradeLevel.gradeLevelCd }" />" />
           		<aof:code type="print" codeGroup="GRADE_LEVEL" selected="${row.univGradeLevel.gradeLevelCd }" />
            </td>
            <td><c:out value="${row.univGradeLevel.ratingScore }" /></td>
	<c:choose>
		<c:when test="${getDetail.courseActive.evaluateMethodTypeCd eq CD_EVALUATE_METHOD_TYPE_ABSOLUTE }">
			<td>
            	<c:out value="${row.univGradeLevel.evalAbsoluteScore }" /> <spring:message code="글:성적등급관리:이상점수"/>&nbsp;<c:out value="${evalAbsoluteScore }" /><spring:message code="글:성적등급관리:미만점수"/>
            	<c:set var="evalAbsoluteScore" value="${row.univGradeLevel.evalAbsoluteScore }" />
            </td>
		</c:when>
		<c:otherwise>
			<td>
            	<c:out value="${row.univGradeLevel.evelRelativeScore }" /><spring:message code="글:성적등급관리:이상퍼센트"/>&nbsp;<c:out value="${evelRelativeScore }" /><spring:message code="글:성적등급관리:미만퍼센트"/>
            	<c:set var="evelRelativeScore" value="${row.univGradeLevel.evelRelativeScore }" />
            </td>
		</c:otherwise>
	</c:choose>
        </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
		</c:if>
    </tbody>
	</table>
</body>
</html>