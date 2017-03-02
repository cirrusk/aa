<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_APPLY_STATUS_003"   value="${aoffn:code('CD.APPLY_STATUS.003')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch				= null;
var forPlanLayer			= null;
var forClassroom			= null;
var forCertificatePopup		= null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
  
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forClassroom = $.action();
	forClassroom.config.formId = "FormClassroom";
	forClassroom.config.url    = "<c:url value="/usr/classroom/main.do"/>";
	
	forPlanLayer = $.action("layer");
	forPlanLayer.config.formId      = "FormPlanLayer";
	forPlanLayer.config.url = "<c:url value="/usr/common/course/plan/detail/popup.do"/>";
	forPlanLayer.config.options.width = 1006;
	forPlanLayer.config.options.height = 800;
	forPlanLayer.config.options.draggable = false;
	forPlanLayer.config.options.titlebarHide = true;
	forPlanLayer.config.options.backgroundOpacity = 0.9;
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/usr/mypage/course/apply/mooc/review/list.do"/>";
	
	forCertificatePopup = $.action("popup", {formId : "FormPopup"});
	forCertificatePopup.config.url = "<c:url value="/univ/course/apply/certificate/popup.do"/>";
	forCertificatePopup.config.options.width  = 900;
	forCertificatePopup.config.options.height = 750;
	forCertificatePopup.config.options.position = "middle";
	forCertificatePopup.config.options.title  = "<spring:message code="글:성적관리:평가등급"/>";
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function() {
	forSearch.run();
};

/**
 * 강의계획서 팝업 호출
 */
doPlanLayer = function(mapPKs){
	// 상세화면 form을 reset한다.
	UT.getById(forPlanLayer.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPlanLayer.config.formId);
	// 상세화면 실행
	forPlanLayer.run();
};

/**
 * 강의실 입장
 */
doClassroom = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forClassroom.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forClassroom.config.formId);
	// 상세화면 실행
	forClassroom.run();
};

/**
 * 수료증출력팝업
 */
doCertificatePopup = function(mapPKs) {
	// 수료출력 form을 reset한다.
	UT.getById(forCertificatePopup.config.formId).reset();
	// 수료출력 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCertificatePopup.config.formId);
	// 수료출력 실행
	forCertificatePopup.run();
};

</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:목록" /></c:param>
</c:import>
	<c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdatetimeStart')}"/></c:set>
	<c:set var="currentMenuId" value="${param['currentMenuId']}" scope="request"/>
	<form name="FormClassroom" id="FormClassroom" method="post" onsubmit="return false;">
		<input type="hidden" name="currentMenuId" value="<c:out value="${currentMenuId}"/>"/>
		<input type="hidden" name="courseApplySeq"/>
	</form>		
	
	<form name="FormPlanLayer" id="FormPlanLayer" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value=""/>
	</form>
	
	<form id="FormPopup" name="FormPopup" method="post" onsubmit="return false;">
		<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="courseApplySeq" />
	</form>

	<div class="lybox-title"> 
		<h4 class="section-title"><spring:message code="글:수강:수강중인과목" /></h4> 
	</div> 
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<table class="tbl-detail"> 
		<colgroup> 
			<col style="width: 10%"/> 
			<col /> 
		</colgroup> 
		<tbody> 
		<tr> 
			<th><spring:message code="필드:수강:수강년도" /></th> 
			<td>
				<select name="srchYear" onchange="doSearch();" class="select">
					<aof:code type="option" codeGroup="YEAR" selected="${condition.srchYear }" removeCodePrefix="true" />		        	
		        </select>
			</td>
		</tr> 
		</tbody> 
	</table>
	</form>
	<div class="vspace"></div>
	<table class="lecture-list"> 
		<colgroup> 
		    <col style="width:50%;" /> 
		    <col style="width:25%;" /> 
		    <col style="width:10%;" /> 
		</colgroup> 
		<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		    <tr> 
				<td> 
				    <dl class="lecture-info"> 
					<dt></dt> 
					<dd>
						<c:if test="${row.active.courseTypeCd eq CD_COURSE_TYPE_PERIOD }">
							<span>[<c:out value="${row.active.periodNumber }" /><spring:message code="글:수강:기" />]</span>
						</c:if>
						<c:out value="${row.active.courseActiveTitle }" />
						<span><aof:code type="print" codeGroup="COURSE_TYPE" selected="${row.active.courseTypeCd }" /></span>
						<span><c:out value="${row.lecturer.profMemberName }" /></span>
					</dd> 
					<dd>
						<spring:message code="필드:수강:복습기간" /> -  
						<c:choose>
							<c:when test="${row.active.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
								<aof:date datetime="${row.apply.studyEndDate }" /> ~ <aof:date datetime="${row.active.resumeEndDate }" />
							</c:when>
							<c:otherwise>
								<aof:date datetime="${row.apply.studyEndDate }" /> ~ <aof:date datetime="${row.apply.studyEndDate }" addDate="${row.active.resumeDay }" />
							</c:otherwise>
						</c:choose>
					</dd> 
				    </dl> 
				</td> 
				<td>
					<dl class="lecture-info">
						<dt></dt>
						<c:choose>
							<c:when test="${row.apply.applyStatusCd eq CD_APPLY_STATUS_003 }">
								<spring:message code="글:수강:수강취소" />
							</c:when>
							<c:otherwise>
								<spring:message code="글:수강:수강완료" />
							</c:otherwise>
						</c:choose>
						<div class="vspace"></div>
						<spring:message code="글:수강:나의진도율" /> : <c:out value="${row.apply.avgProgressMeasure }" />%
						<div class="vspace"></div>
						<dd>
							<span><c:out value="${row.apply.finalScore }" /><spring:message code="글:수강:점" /></span>
							<c:choose>
								<c:when test="${row.apply.completionYn eq 'Y' }">
									<span><spring:message code="글:수강:이수" /></span>
								</c:when>
								<c:otherwise>
									<span><spring:message code="글:수강:미이수" /></span>
								</c:otherwise>
							</c:choose>
						</dd>
				    </dl>
				</td>
				<td>
				    <a href="javascript:void(0);" onclick="doPlanLayer({'courseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq}" />'})" class="btn gray"><span class="small"><spring:message code="버튼:수강:강의계획서" /></span></a><div class="vspace"></div>
				    <c:choose>
						<c:when test="${row.active.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
							<c:if test="${row.active.resumeEndDate > appToday}">
								<a href="javascript:void(0);" onclick="doClassroom({'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq}" />'})" class="btn blue"><span class="small"><spring:message code="버튼:수강:복습하기" /></span></a><div class="vspace"></div>
							</c:if>
						</c:when>
						<c:otherwise>
							<c:set var="resumeEndDate"><aof:date datetime="${row.apply.studyEndDate }" addDate="${row.active.resumeDay }" pattern="${aoffn:config('format.dbdatetimeStart')}" /></c:set>
							<c:if test="${resumeEndDate > appToday}">
								<a href="javascript:void(0);" onclick="doClassroom({'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq}" />'})" class="btn blue"><span class="small"><spring:message code="버튼:수강:복습하기" /></span></a><div class="vspace"></div>
							</c:if>
						</c:otherwise>
					</c:choose>
				     
				    <a href="javascript:void(0);" onclick="doCertificatePopup({'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq }" />','shortcutCourseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq }" />'});" class="btn black"><span class="small"><spring:message code="버튼:수강:수료증출력" /></span></a> 
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
	
</body>
</html>