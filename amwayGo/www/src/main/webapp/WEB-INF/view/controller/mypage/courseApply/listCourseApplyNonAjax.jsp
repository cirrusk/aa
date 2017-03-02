<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_APPLY_STATUS_003"   value="${aoffn:code('CD.APPLY_STATUS.003')}"/>

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
					<c:if test="${row1.active.courseTypeCd eq CD_COURSE_TYPE_PERIOD }">
						<span>[<c:out value="${row.active.periodNumber }" /><spring:message code="글:수강:기" />]</span>
					</c:if>
					<c:out value="${row1.active.courseActiveTitle }" />
					<span><c:out value="${row1.lecturer.profMemberName }" /></span>
				</dd> 
				<dd><spring:message code="필드:수강:학습기간" /> -  <aof:date datetime="${row1.apply.studyStartDate }" /> ~ <aof:date datetime="${row1.apply.studyEndDate }" /></dd> 
			    </dl> 
			</td> 
			<td>
				<aof:code type="print" codeGroup="COURSE_TYPE" selected="${row1.active.courseTypeCd }" />
				<div class="vspace"></div>
				<c:choose>
					<c:when test="${row1.apply.applyStatusCd ne CD_APPLY_STATUS_003 }">
						<a href="#" onclick="doApplyUpdate({'courseApplySeq' : '${row1.apply.courseApplySeq}'});" class="btn gray"><span class="small"><spring:message code="버튼:수강:수강취소" /></span></a>	
					</c:when>
					<c:otherwise>
						<spring:message code="버튼:수강:취소완료" />
					</c:otherwise>
				</c:choose>
				
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