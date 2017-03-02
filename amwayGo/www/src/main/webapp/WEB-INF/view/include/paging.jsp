<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="styleClass" value="paginate"/>
<c:if test="${!empty param['styleClass']}">
	<c:set var="styleClass" value="${param['styleClass']}"/>
</c:if>

<c:set var="func" value="doPage"/>
<c:if test="${!empty param['func']}">
	<c:set var="func" value="${param['func']}"/>
</c:if>

<c:set var="pageLimit" value="10"/>
<c:if test="${!empty param['pageLimit']}">
	<c:set var="pageLimit" value="${param['pageLimit']}"/>
</c:if>

<c:set var="paginate" value="paginate"/>
<c:if test="${!empty param['paginate']}">
	<c:set var="paginate" value="${param['paginate']}"/>
</c:if>
<c:set var="paginate" value="${requestScope[paginate]}"/>

<c:set var="total"><spring:message code="글:총"/></c:set>
<c:set var="ea"><spring:message code="글:건"/></c:set>
<c:if test="${!empty param['ea']}">
	<c:set var="ea" value="${param['ea']}"/>
</c:if>

<c:if test="${!empty paginate and paginate.condition.currentPage gt 0}">
	<div class="<c:out value="${styleClass}"/>">

		<c:set var="startPage" value="${aoffn:toInt('0')}"/>
		<c:set var="endPage" value="${aoffn:toInt('0')}"/>
		<c:set var="currentPage" value="${paginate.condition.currentPage}"/>
		<c:set var="lastPage" value="${aoffn:toInt(paginate.totalCount / paginate.condition.perPage)}"/>
		<c:if test="${paginate.totalCount % paginate.condition.perPage gt 0}">
			<c:set var="lastPage" value="${lastPage + 1}"/>
		</c:if>
	
		<c:choose>
			<c:when test="${currentPage % pageLimit gt 0}">
				<c:set var="startPage" value="${aoffn:toInt(currentPage / pageLimit) * pageLimit + 1}"/>
			</c:when>
			<c:otherwise>
				<c:set var="startPage" value="${aoffn:toInt(currentPage - pageLimit) + 1}"/>
			</c:otherwise>
		</c:choose>
		<c:set var="endPage" value="${aoffn:toInt(startPage + (pageLimit - 1))}"/>
	
		<c:if test="${endPage gt lastPage}">
			<c:set var="endPage" value="${lastPage}"/>
		</c:if>	
	
		<span class="info-l">
			<c:out value="${total}"/> <c:out value="${paginate.totalCount}"/> <c:out value="${ea}"/> (<span><c:out value="${currentPage}"/></span> / <c:out value="${lastPage}"/>)
		</span>
		
		<c:choose>
			<c:when test="${startPage gt pageLimit}">
				<a onclick="<c:out value="${func}" escapeXml="false"/>(1);" class="prev"><span>‹‹ </span><spring:message code="버튼:처음"/></a>			
				<a onclick="<c:out value="${func}" escapeXml="false"/>(<c:out value="${startPage - 1}"/>);" class="prev"><span>‹ </span><spring:message code="버튼:이전"/></a>			
			</c:when>
			<c:otherwise>
				<a class="prev" style="cursor:default"><span>‹‹ </span><spring:message code="버튼:처음"/></a>
				<a class="prev" style="cursor:default"><span>‹ </span><spring:message code="버튼:이전"/></a>
			</c:otherwise>
		</c:choose>
	
		<c:forEach var="page" begin="${startPage}" end="${endPage}" step="1" varStatus="i">
			<c:if test="${i.first eq false}">

			</c:if>
			<c:choose>
				<c:when test="${page eq currentPage}">
					<strong><c:out value="${page}"/></strong>
				</c:when>
				<c:otherwise>
					<a onclick="<c:out value="${func}" escapeXml="false"/>(<c:out value="${page}"/>);" style="cursor:pointer"><c:out value="${page}"/></a>			
				</c:otherwise>
			</c:choose>
		</c:forEach>
	
		<c:choose>
			<c:when test="${lastPage gt endPage}">
				<a onclick="<c:out value="${func}" escapeXml="false"/>(<c:out value="${endPage + 1}"/>);" class="next"><spring:message code="버튼:다음"/><span> ›</span></a>			
				<a onclick="<c:out value="${func}" escapeXml="false"/>(<c:out value="${lastPage}"/>);" class="next"><spring:message code="버튼:끝"/><span> ››</span></a>			
			</c:when>
			<c:otherwise>
				<a class="next" style="cursor:default"><spring:message code="버튼:다음"/><span> ›</span></a>
				<a class="next" style="cursor:default"><spring:message code="버튼:끝"/><span> ››</span></a>
			</c:otherwise>
		</c:choose>
	</div>

</c:if>

