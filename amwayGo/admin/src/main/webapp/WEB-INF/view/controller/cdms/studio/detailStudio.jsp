<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/studio/list.do"/>";
	
	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/cdms/studio/edit.do"/>";
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchStudio.jsp"/>
	</div>

	<div class="lybox-tbl">
		<h4 class="title"><c:out value="${detailStudio.studio.studioName}"/></h4>
		<div class="right">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'studioSeq' : '<c:out value="${detailStudio.studio.studioSeq}"/>'});" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<table class="tbl-layout">
	<colgroup>
		<col style="width:50%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<td class="first">
				<h4 class="section-title mt10"><spring:message code="글:CDMS:기본정보" /></h4>

				<table class="tbl-detail mt10">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:CDMS:스튜디오명"/></th>
						<td><c:out value="${detailStudio.studio.studioName}"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:가용요일"/></th>
						<td>
							<ul class="list-bullet">
								<c:forEach var="row" items="${aoffn:toList(detailStudio.studio.weekDay, ',')}" varStatus="i">
									<c:choose>
										<c:when test="${row eq 0}"><li><spring:message code="글:CDMS:일" /></li></c:when>
										<c:when test="${row eq 1}"><li><spring:message code="글:CDMS:월" /></li></c:when>
										<c:when test="${row eq 2}"><li><spring:message code="글:CDMS:화" /></li></c:when>
										<c:when test="${row eq 3}"><li><spring:message code="글:CDMS:수" /></li></c:when>
										<c:when test="${row eq 4}"><li><spring:message code="글:CDMS:목" /></li></c:when>
										<c:when test="${row eq 5}"><li><spring:message code="글:CDMS:금" /></li></c:when>
										<c:when test="${row eq 6}"><li><spring:message code="글:CDMS:토" /></li></c:when>
									</c:choose>
								</c:forEach>
							</ul>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:스튜디오담당자"/></th>
						<td>
							<ul class="list-bullet">
								<c:forEach var="rowSub" items="${detailStudio.listStudioMember}" varStatus="iSub">
									<li><c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)</li>
								</c:forEach>
							</ul>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:사용여부"/></th>
						<td><aof:code type="print" codeGroup="YESNO" selected="${detailStudio.studio.useYn}" removeCodePrefix="true" ref="2"/></td>
					</tr>
				</tbody>
				</table>

			</td>
			<td>
				<h4 class="section-title mt10"><spring:message code="글:CDMS:스튜디오시간정보" /></h4>
				<table class="tbl-detail mt10">
				<colgroup>
					<col style="width: 45px" />
					<col style="width: auto" />
					<col style="width: auto" />
				</colgroup>
				<thead>
					<tr>
						<th class="align-c"><spring:message code="필드:번호" /></th>
						<th class="align-c"><spring:message code="필드:CDMS:시작시간" /></th>
						<th class="align-c"><spring:message code="필드:CDMS:종료시간" /></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${listStudioTime}" varStatus="i">
					<c:set var="startTime" value="20000101${row.studioTime.startTime}00"/>
					<c:set var="endTime" value="20000101${row.studioTime.endTime}00"/>
					<tr>
				        <td class="align-c">
				        	<c:out value="${i.count}"/>
				        	<input type="hidden" name="studioTimeSeqs" value="<c:out value="${row.studioTime.studioTimeSeq}"/>"/>
				        </td>
						<td class="align-c"><aof:date datetime="${startTime}" pattern="HH : mm"/></td>
						<td class="align-c"><aof:date datetime="${endTime}" pattern="HH : mm"/></td>
					</tr>
				</c:forEach>
				<c:if test="${empty listStudioTime}">
					<tr>
						<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</table>

			</td>
		</tr>
	</tbody>
	</table>

</body>
</html>