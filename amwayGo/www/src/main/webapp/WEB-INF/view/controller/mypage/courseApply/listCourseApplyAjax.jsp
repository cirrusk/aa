<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<div id="date" style="display: none;"><aof:date datetime="${srchYearTerm.univYearTerm.studyStartDate }" /> ~ <aof:date datetime="${srchYearTerm.univYearTerm.studyEndDate }" /></div>
<table class="lecture-list"> 
	<colgroup> 
	    <col style="width:50%;" /> 
	    <col style="width:25%;" /> 
	    <col style="width:10%;" /> 
	</colgroup> 
	<tbody>
		<c:forEach var="row1" items="${paginate.itemList}" varStatus="i">
	    <tr> 
			<td> 
			    <dl class="lecture-info"> 
				<dt></dt> 
				<dd>
					<c:out value="${row1.active.courseActiveTitle }" /> - <span><c:out value="${row1.active.division }" /><spring:message code="글:수강:분반" /></span>
					<span><aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row1.active.completeDivisionCd }" /></span>
					<span><c:out value="${row1.active.completeDivisionPoint }" /><spring:message code="글:수강:학점" /></span>
					<span><c:out value="${row1.lecturer.profMemberName }" /></span>
				</dd> 
				<dd><spring:message code="필드:수강:학습기간" /> -  <aof:date datetime="${row1.apply.studyStartDate }" /> ~ <aof:date datetime="${row1.apply.studyEndDate }" /></dd> 
			    </dl> 
			</td> 
			<td>
				<aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row1.active.completeDivisionCd }" />
				<div class="vspace"></div><c:out value="${row1.active.completeDivisionPoint }" /><spring:message code="글:수강:학점" />
			</td> 
			<td> 
			    <a href="javascript:void(0)" class="btn gray"><span class="small"><spring:message code="버튼:수강:강의계획서" /></span></a><div class="vspace"></div> 
			    <a href="javascript:void(0)" class="btn blue"><span class="small"><spring:message code="버튼:수강:강의실입장" /></span></a> 
			</td> 
	    </tr>
	    </c:forEach>
	    <c:if test="${empty paginate.itemList }">
		<tr>
			<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>	
		</c:if> 
	</tbody> 
</table>