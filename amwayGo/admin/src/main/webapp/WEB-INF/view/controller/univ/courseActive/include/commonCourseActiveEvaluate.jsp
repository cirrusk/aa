<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table class="tbl-detail"><!-- tbl-detail --> 
    <colgroup> 
        <col width="20%" /> 
        <col width="80%" /> 
    </colgroup> 
    <tbody> 
        <c:choose>
            <c:when test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                <tr> 
                    <th><spring:message code="필드:평가기준:평가기준" /></th> 
                    <td><aof:code type="print" codeGroup="EVALUATE_METHOD_TYPE" name="evaluateMethodTypeCd" selected="${detail.courseActive.evaluateMethodTypeCd }" /></td> 
                </tr>       
            </c:when>
            <c:otherwise>
                <tr> 
                    <th><spring:message code="필드:평가기준:수료점수" /></th> 
                    <td>
                        <c:out value="${detail.courseActive.completionScore}" />
                        <spring:message code="글:평가기준:점" />
                    </td> 
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody> 
</table> 
<table id="listTable" class="tbl-list mt10">
    <colgroup>
        <col style="width: 100px" />
        <col style="width: 120px" />
        <col style="width: 120px" />
        <col style="width: 80px" />
    </colgroup>
    <thead>
        <tr>
            <th rowspan="2"><spring:message code="필드:평가기준:평가항목" /></th>
            <th colspan="3"><spring:message code="필드:평가기준:평가기준" /></th>
        </tr>
        <tr>
            <th><spring:message code="필드:평가기준:평가비율" /></th>
            <th><spring:message code="필드:평가기준:과락점수" /></th>
            <th><spring:message code="필드:평가기준:등록수" /></th>
        </tr>
    </thead>
    <tbody>
	    <c:set var="scoreSum" value="0" />
		<c:choose>
		    <c:when test="${empty list}">
		    	<tr>
	                <td colspan="4">
	                	<spring:message code="글:데이터가없습니다" />
	                </td>
                </tr>
		    </c:when>
		    <c:otherwise>
		        <c:forEach var="row" items="${list}" varStatus="i">
		            <tr>
		                <td>
		                    <aof:code type="print" codeGroup="COURSE_ELEMENT_TYPE" selected="${row.evaluate.evaluateTypeCd}" />
		                </td>
		                <td>
		                    <c:set var="scoreSum">${scoreSum + row.evaluate.score}</c:set>             
		                    <fmt:formatNumber value="${row.evaluate.score}" />%
		                </td>
		                <td><fmt:formatNumber value="${row.evaluate.limitScore}" /> <spring:message code="글:평가기준:점" /></td>
		                <td>
		                    <c:out value="${row.evaluate.basicCount}" />
		                    <c:if test="${row.evaluate.supplementCount > 0}">
		                        (<c:out value="${row.evaluate.supplementCount}" />)
		                    </c:if>
		                </td>
		            </tr>
		        </c:forEach>
		    </c:otherwise>
		</c:choose>
        <tr>
            <td><spring:message code="필드:평가기준:합계" /></td>
            <td class="align-c" colspan="3"><fmt:formatNumber value="${scoreSum}" /> %</td>
        </tr>
    </tbody>
    </table>