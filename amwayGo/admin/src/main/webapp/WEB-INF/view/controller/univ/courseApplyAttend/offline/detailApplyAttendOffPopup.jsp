<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ATTEND_TYPE_004" value="${aoffn:code('CD.ATTEND_TYPE.004')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
	
doInitializeLocal = function() {
};

/**
 * 닫기
 */
doClose = function(){
 $layer.dialog("close");
}; 

</script>
</head>

<body>
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">	
	<div class="vspace"></div>
	
	<aof:code type="set" var="codeGroupAttendType" codeGroup="ATTEND_TYPE" except="${CD_ATTEND_TYPE_004}"/>
	<!-- 이름 정보 테이블 -->
	<div class="lybox-title">
        <h4 class="section-title"><spring:message code="글:오프라인출석결과:이름정보" /></h4>
    </div>
	<table id="detailTable" class="tbl-detail">
		<colgroup>
		<col style="width: 30px" />
		<col style="width: 30px" />
		<col style="width: 30px" />
		<col style="width: 30px" />
		<col style="width: 30px" />
	</colgroup>
	<tbody>
		<tr>
			<th colspan="2"><spring:message code="필드:오프라인출석결과:이름" /></th>
			<th><spring:message code="필드:오프라인출석결과:아이디" /></th>
			<th colspan="2"><spring:message code="필드:오프라인출석결과:학과" /></th>
		</tr>
		<tr>
			<td colspan="2">
				<c:out value="${param['memberName']}"/>
			</td>
			<td>
				<c:out value="${param['memberId']}"/>
			</td>
			<td colspan="2">
				<c:out value="${param['categoryName']}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:오프라인출석결과:총수업진행횟수" /></th>
			<th><spring:message code="필드:오프라인출석결과:출석" /></th>
			<th><spring:message code="필드:오프라인출석결과:결석" /></th>
			<th><spring:message code="필드:오프라인출석결과:지각" /></th>
			<th><spring:message code="필드:오프라인출석결과:공결" /></th>
		</tr>
		<tr>
			<td>${totalAttendCount}</td>
			<td><c:out value="${param['attendTypeAttendCnt']}"/></td>
			<td><c:out value="${param['attendTypeAbsenceCnt']}"/></td>						
			<td><c:out value="${param['attendTypePerceptionCnt']}"/></td>
			<td><c:out value="${param['attendTypeExcuseCnt']}"/></td>		
		</tr>
	</tbody>
	</table>
	
	<div class="vspace"></div>
	<div class="vspace"></div>
	<div class="vspace"></div>
	<div class="vspace"></div>

	<!-- 수강 정보 테이블 -->
	<div class="lybox-title">
        <h4 class="section-title"><spring:message code="글:오프라인출석결과:수강정보" /></h4>
    </div>
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 30px" />
		<col style="width: 30px" />
		<c:forEach var="row" items="${codeGroupAttendType}" varStatus="i">
			<col style="width: 30px" />
		</c:forEach>
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:주차:주차" /></th>
			<th><spring:message code="필드:오프라인출석결과:수업횟수" /></span></th>
			<c:forEach var="row" items="${codeGroupAttendType}" varStatus="i">
				<th><c:out value="${row.codeName}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${listElement}" varStatus="i">
		<c:set var="activeElementSeq" value="${row.element.activeElementSeq}"/>
		<c:set var="subNum" value="${row.element.offlineLessonCount}"></c:set>  
			<c:forEach begin="1" end="${subNum}" step="1" varStatus="j">
			<tr>
				<c:set var="offlineLessonKey"  value="${activeElementSeq}_${j.index}"/>
				<c:if test="${j.index == 1}" >
					<td <c:if test="${j.index == 1}" >rowspan="${subNum}"</c:if>><c:out value="${row.element.sortOrder}" /><spring:message code="필드:주차:주차" /></td>
				</c:if>
				<td><c:out value="${j.index}" /><spring:message code="글:오프라인출석결과:회" /></td>
				<c:forEach var="codeRow" items="${codeGroupAttendType}" varStatus="i">
					<td>
						<c:if test="${applyAttendHash[offlineLessonKey] eq codeRow.code}">
							O
						</c:if>
					</td>
				</c:forEach>			
			</tr>
			</c:forEach>		
		</c:forEach>		
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="doClose()" class="btn blue"><span class="mid"><spring:message code="버튼:닫기" /></span></a>
		</div>
	</div>
</body>
</html>