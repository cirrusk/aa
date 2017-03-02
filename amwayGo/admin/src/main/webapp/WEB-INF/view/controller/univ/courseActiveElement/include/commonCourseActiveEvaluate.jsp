<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"              value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"            value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_PLAN"        value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.PLAN')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EVALUATE"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EVALUATE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EXAM"        value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"   value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_OFFLINE"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.OFFLINE')}"/>

<%-- 학위와 비학위일때의 교과목 구성항목이 다르다. --%>
<c:choose>
    <c:when test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
        <c:set var="codeExcept"><c:out value="${CD_COURSE_ELEMENT_TYPE_PLAN},${CD_COURSE_ELEMENT_TYPE_EVALUATE},${CD_COURSE_ELEMENT_TYPE_EXAM}"/></c:set>
    </c:when>
    <c:otherwise>
        <c:choose>
    		<c:when test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_PERIOD}">
    			<c:set var="codeExcept"><c:out value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM},${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/></c:set>
    		</c:when>
    		<c:otherwise>
				<c:set var="codeExcept"><c:out value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM},${CD_COURSE_ELEMENT_TYPE_FINALEXAM},${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT},${CD_COURSE_ELEMENT_TYPE_OFFLINE}"/></c:set>    		
    		</c:otherwise>
    	</c:choose>
    </c:otherwise>
</c:choose>
<aof:code type="set" var="elementType" codeGroup="COURSE_ELEMENT_TYPE" except="${codeExcept}"/>

<div class="lybox-title mt10">
    <h4 class="section-title"><spring:message code="필드:평가기준:평가기준" /></h4>
    <div class="right">
    	<c:choose>
    		<c:when test="${param['completionYn'] eq 'Y' }">
    			<a href="#" onclick="doEvaluatePopup();" class="btn gray"><span class="small"><spring:message code="버튼:평가기준:평가등급" /></span></a>
    		</c:when>
    		<c:otherwise>
				<a href="#" onclick="doGoTab('<c:out value="${CD_COURSE_ELEMENT_TYPE_EVALUATE}"/>');" class="btn gray"><span class="small"><spring:message code="버튼:평가기준:설정" /></span></a>    		
    		</c:otherwise>
    	</c:choose>
    </div>
</div>
<c:choose>
	<c:when test="${!empty listActiveEvaluate}">
		<c:set var="totalSum" value="0" />
		<c:set var="limitTotalSum" value="0" />
		<table class="tbl-detail">
		<colgroup>
            <col style="width: 10%" />
            <c:set var="evalWidth" value="${84/fn:length(listActiveEvaluate)}"/>
			<c:forEach var="row" items="${listActiveEvaluate}" varStatus="i">
                <col style="width: <c:out value='${evalWidth}'/>%" />
			</c:forEach>
            <col style="width: auto" />
		</colgroup>
		<thead>
		<tr>
			<th class="align-c"><spring:message code="필드:평가기준:항목" /></th>
				<c:forEach var="row" items="${listActiveEvaluate}" varStatus="i">
		        	<th class="align-c"><aof:code type="print" codeGroup="COURSE_ELEMENT_TYPE" selected="${row.evaluate.evaluateTypeCd }" /></th>
			    </c:forEach>
			<th class="align-c"><spring:message code="필드:평가기준:합계" /></th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<th class="align-c"><spring:message code="필드:평가기준:평가비율" /></th>
				<c:forEach var="row" items="${listActiveEvaluate}" varStatus="i">
			        <td class="align-c">
			        	<aof:number value="${row.evaluate.score }" />
			        	<c:set var="totalSum" value="${totalSum + row.evaluate.score }" />
			        </td>
			    </c:forEach>
			<th class="align-c"><aof:number value="${totalSum }" /></th>
		</tr>
		<tr>
			<th class="align-c"><spring:message code="필드:평가기준:과락점수" /></th>
				<c:forEach var="row" items="${listActiveEvaluate}" varStatus="i">
			        <td class="align-c">
			        	<aof:number value="${row.evaluate.limitScore }" />
			        	<c:set var="limitTotalSum" value="${limitTotalSum + row.evaluate.limitScore }" />
			        </td>
			    </c:forEach>
			<th class="align-c"><aof:number value="${limitTotalSum }" /></th>
		</tr>
		</tbody>
		</table>
	</c:when>
	<c:otherwise>
		<table class="tbl-detail">
		<colgroup>
		   	<col style="width: 10%" />
            <c:set var="evalWidth" value="${84/fn:length(elementType)}"/>
			<c:forEach var="row" items="${elementType}" varStatus="i">
                <col style="width: <c:out value='${evalWidth}'/>%" />
			</c:forEach>
		   	<col style="width: auto" />
		</colgroup>
		<thead>
		<tr>
			<th class="align-c"><spring:message code="필드:평가기준:항목" /></th>
				<c:forEach var="row" items="${elementType}" varStatus="i">
			        <th class="align-c <c:out value="${row.code eq param['selectedElementTypeCd'] ? 'selected' : ''}"/>"
			        ><c:out value="${row.codeName}"/></th>
			    </c:forEach>
			<th class="align-c"><spring:message code="필드:평가기준:합계" /></th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<th class="align-c"><spring:message code="필드:평가기준:평가비율" /></th>
				<c:forEach var="row" items="${elementType}" varStatus="i">
			        <td class="align-c">0</td>
			    </c:forEach>
			<th class="align-c">-</th>
		</tr>
		<tr>
			<th class="align-c"><spring:message code="필드:평가기준:과락점수" /></th>
				<c:forEach var="row" items="${elementType}" varStatus="i">
			        <td class="align-c">0</td>
			    </c:forEach>
			<th class="align-c">-</th>
		</tr>
		</tbody>
		</table>
	</c:otherwise>
</c:choose>