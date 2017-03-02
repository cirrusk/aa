<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_APPLY_STATUS_003" value="${aoffn:code('CD.APPLY_STATUS.003')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forClassroom    = null;
var forSearch     	= null;
var forPlanLayer			= null;

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
	forSearch.config.url    = "<c:url value="/usr/mypage/course/apply/review/list.do"/>";
};

/**
 * 상세보기 화면을 호출하는 함수
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
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function() {
	forSearch.run();
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
			<th><spring:message code="필드:수강:수강년도학기" /></th> 
			<td>
				<select name="srchYearTerm" onchange="doSearch();"  class="select float-l">
		        	<option value=""><spring:message code="글:선택" /></option>
		            <c:import url="../include/yearTermInc.jsp"></c:import>
		        </select>
				<span class="float-r"><spring:message code="필드:수강:학습기간" />&nbsp;<aof:date datetime="${srchYearTerm.univYearTerm.studyStartDate }" /> ~ <aof:date datetime="${srchYearTerm.univYearTerm.studyStartDate }" /></span>
			</td>
		</tr>
		</tbody> 
	</table>
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
							<c:out value="${row.active.courseActiveTitle }" /> - <span><c:out value="${row.active.division }" /><spring:message code="글:수강:분반" /></span>
							<span><aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row.active.completeDivisionCd }" /></span>
							<span><c:out value="${row.active.completeDivisionPoint }" /><spring:message code="글:수강:학점" /></span>
							<span><c:out value="${row.lecturer.profMemberName }" /></span>
						</dd> 
						<dd><spring:message code="필드:수강:복습기간" /> -  <aof:date datetime="${row.apply.studyEndDate }" /> ~ <aof:date datetime="${row.active.resumeEndDate }" /></dd> 
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
						<c:if test="${row.apply.applyStatusCd ne CD_APPLY_STATUS_003 }">
						<div class="vspace"></div>
						<dd>
							<span><c:out value="${row.active.completeDivisionPoint }" /><spring:message code="글:수강:학점" /></span>
							<span><spring:message code="글:수강:성적등급" /> : <aof:code type="print" codeGroup="GRADE_LEVEL" selected="${row.apply.gradeLevelCd }" /></span>
						</dd> 
				    </dl> 
				    </div>
				    </c:if>
				</td> 
				<td> 
				    <a href="javascript:void(0);" onclick="doPlanLayer({'courseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq}" />'})" class="btn gray"><span class="small"><spring:message code="버튼:수강:강의계획서" /></span></a><div class="vspace"></div>
				    <c:if test="${row.apply.resumeEndDate > appToday}">
						<a href="javascript:void(0);" onclick="doClassroom({'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq}" />'})" class="btn blue"><span class="small"><spring:message code="버튼:수강:복습하기" /></span></a><div class="vspace"></div>
					</c:if>
				</td> 
		    </tr>
		    </c:forEach>
		    <c:if test="${empty paginate.itemList}">
			<tr>
				<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>	
			</c:if> 
		</tbody> 
	</table>
</body>
</html>