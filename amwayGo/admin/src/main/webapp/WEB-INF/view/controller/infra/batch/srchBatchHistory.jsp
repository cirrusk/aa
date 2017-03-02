<%@page pageEncoding="UTF-8"%><%@include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:set var="timeHour" value="23"/>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage"  			value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      			value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="srchBatchSeq" 			value="<c:out value="${condition.srchBatchSeq}"/>"/>
		
			<spring:message code="필드:배치:작업시간"/> : 
			<input type="text" name="srchStarDate" id="srchStarDate" class="datepicker" value="<aof:date datetime="${condition.srchStartDtime}"/>" readonly="readonly">
			<select name="srchStarHour">
				<c:forEach  begin="0" end="${timeHour}" varStatus="i">
					<option value="${i.index}"
					<c:if test="${i.index eq condition.srchStarHour}">selected="selected"</c:if>
					><c:out value="${i.index}"/></option>
				</c:forEach>
			</select> <spring:message code="필드:배치:시"/>
			&nbsp;~&nbsp;
			<input type="text" name="srchEndDate" id="srchEndDate" class="datepicker" value="<aof:date datetime="${condition.srchEndDtime}"/>" readonly="readonly">
			<select name="srchEndHour">
				<c:forEach begin="0" end="${timeHour}" varStatus="i">
					<option value="${i.index}"
					<c:if test="${i.index eq condition.srchEndHour}">selected="selected"</c:if>
					><c:out value="${i.index}"/></option>
				</c:forEach>
			</select> <spring:message code="필드:배치:시"/>&nbsp;
			
			<a href="#" onclick="doSearch(); return false;" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
		</fieldset>
	</div>
</form>
