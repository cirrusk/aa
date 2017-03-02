<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forClassroom    = null;
var forListDataWait = null;
var forLearning 	= null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
  
    // [2] 수강대기과목 리스트
    doListWait();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forClassroom = $.action();
	forClassroom.config.formId = "FormClassroom";
	forClassroom.config.url    = "<c:url value="/usr/classroom/main.do"/>";
	
	forListDataWait = $.action("ajax");
	forListDataWait.config.formId      = "FormWaitList";
	forListDataWait.config.type        = "html";
	forListDataWait.config.containerId = "waitList";
	forListDataWait.config.url         = "<c:url value="/usr/mypage/course/apply/list/ajax.do"/>";
	forListDataWait.config.fn.complete = function() {
		jQuery("#studyDate").html("<spring:message code="필드:수강:학습기간" />&nbsp;"+jQuery("#date").html());
	};
	
	forPlanLayer = $.action("layer");
	forPlanLayer.config.formId      = "FormPlanLayer";
	forPlanLayer.config.url = "<c:url value="/usr/common/course/plan/detail/popup.do"/>";
	forPlanLayer.config.options.width = 1006;
	forPlanLayer.config.options.height = 800;
	forPlanLayer.config.options.draggable = false;
	forPlanLayer.config.options.titlebarHide = true;
	forPlanLayer.config.options.backgroundOpacity = 0.9;
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
 * 수강대기목록
 */
doListWait = function() {
	forListDataWait.run();
};
</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:목록" /></c:param>
</c:import>

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
	<table class="tbl-detail"> 
		<colgroup> 
			<col style="width: 10%"/> 
			<col /> 
		</colgroup> 
		<tbody> 
		<tr> 
			<th><spring:message code="필드:수강:수강년도학기" /></th> 
			<td>
				<span class="float-l"><c:out value="${nowYearTerm.yearTermName }" /></span>
				<span class="float-r"><spring:message code="필드:수강:학습기간" />&nbsp;<aof:date datetime="${nowYearTerm.studyStartDate }" /> ~ <aof:date datetime="${nowYearTerm.studyEndDate }" /></span>
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
					<dd><spring:message code="필드:수강:학습기간" /> -  <aof:date datetime="${row.apply.studyStartDate }" /> ~ <aof:date datetime="${row.apply.studyEndDate }" /></dd> 
				    </dl> 
				</td> 
				<td>
					<spring:message code="글:수강:나의진도율" /> : <c:out value="${row.apply.avgProgressMeasure }" />%
				</td> 
				<td> 
				    <a href="javascript:void(0);" class="btn gray" onclick="doPlanLayer({'courseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq}" />'})"><span class="small"><spring:message code="버튼:수강:강의계획서" /></span></a>
				    <div class="vspace"></div>
				    <a href="javascript:void(0);" onclick="doClassroom({'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq}" />'})" class="btn blue"><span class="small"><spring:message code="버튼:수강:강의실입장" /></span></a>
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
	
	<div class="vspace"></div>
	<div class="lybox-title"> 
		<h4 class="section-title"><spring:message code="글:수강:수강대기과목" /></h4> 
	</div>
	<form name="FormWaitList" id="FormWaitList" method="post" onsubmit="return false;">
		
	<table class="tbl-detail"> 
		<colgroup> 
			<col style="width: 10%"/> 
			<col /> 
		</colgroup> 
		<tbody> 
		<tr> 
			<th><spring:message code="필드:수강:수강년도학기" /></th> 
			<td>
				<!-- 년도학기 Select Include Area Start -->
		        <select name="srchYearTerm" onchange="doListWait();" class="select float-l">
		        	<option value=""><spring:message code="글:선택" /></option>
		            <c:import url="../include/yearTermInc.jsp"></c:import>
		        </select>
		        <!-- 년도학기 Select Include Area End -->
		        <span id="studyDate" class="float-r">.</span>
			</td> 
				 
		</tr> 
		</tbody> 
	</table>
	<div class="vspace"></div>
	<div id="waitList"></div>
	</form>
</body>
</html>