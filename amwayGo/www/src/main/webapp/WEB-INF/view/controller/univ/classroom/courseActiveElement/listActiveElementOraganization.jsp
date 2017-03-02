<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ATTEND_TYPE_001" value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002" value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>

<!-- 오늘 날짜 가져오기 -->
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forList                = null;
var forLearning              = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forList = $.action();
	forList.config.formId = "FormList";
	forList.config.url    = "<c:url value="/usr/classroom/course/active/element/organization/list.do"/>";
	
	forLearning = $.action("layer");
	forLearning.config.formId = "FormLearning";
	forLearning.config.url    = "<c:url value="/learning/simple/popup.do"/>";
	forLearning.config.options.title = "<spring:message code="글:과정:학습하기"/>";
	forLearning.config.options.width = 1006;
	forLearning.config.options.height = 800;
	forLearning.config.options.draggable = false;
	forLearning.config.options.titlebarHide = false;
	forLearning.config.options.backgroundOpacity = 0.9;
	forLearning.config.options.callback  = doReplace;
	
};

/**
 * 학습창
 */
doLearning = function(mapPKs) {
	// 학습하기화면 form을 reset한다.
	UT.getById(forLearning.config.formId).reset();
	// 학습하기화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forLearning.config.formId);
	// 학습하기화면 실행
	if(forLearning.config.popupWindow != null) { // 팝업윈도우가 이미 존재하면 닫고, 다시 띄운다.
		forLearning.config.popupWindow.close();
		forLearning.config.popupWindow = null;
		setTimeout("forLearning.run()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
	} else {
		forLearning.run();
	}
};

/**
 * 학습기간이 아닐시 안내 문구
 */
doNotStudyAlert = function (){
	$.alert({message : "<spring:message code='글:과정:현재학습기간이아닙니다'/>"});
};

/**
 * 학습창을 닫을시 호출되는 메소드
 */
doReplace = function(){
	forList.run();
};

</script>
</head>
<body>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<form name="FormLearning" id="FormLearning" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="itemSeq" />
	<input type="hidden" name="itemIdentifier" />
	<input type="hidden" name="courseId" value="<c:out value="${courseActive.courseActiveSeq}"/>"/>
	<input type="hidden" name="applyId" value="<c:out value="${courseApply.courseApplySeq}"/>"/>
	<input type="hidden" name="completionStatus"/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${courseActive.courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>"/>
</form>

<table class="tbl-detail">
	 <colgroup>
	     <col style="width: 180px" />
	     <col/>
	 </colgroup>
	 <tbody>
	 	<tr>
	 		<th><spring:message code="글:과정:평균진도율출석전체" /></th>
	 		<td>
	 			<spring:message code="글:과정:진도율" /> : <aof:number value="${totalProgress.element.totalProgressMeasure * 100}" pattern="#,###.#"/> % &nbsp;&nbsp;&nbsp;
	 			<aof:number value="${totalProgress.element.totalAttendMeasure}" pattern="#,###.#"/> / <c:out value="${totalProgress.element.totalItemCnt}"/>
	 		</td>
	 	</tr>
	 	<tr>
	 		<th><spring:message code="글:과정:나의진도율출석전체" /></th>
	 		<td>
	 			<spring:message code="글:과정:진도율" /> : <aof:number value="${applyTotalProgress.element.totalProgressMeasure * 100}" pattern="#,###.#"/> % &nbsp;&nbsp;&nbsp;
	 			<aof:number value="${applyTotalProgress.element.totalAttendMeasure}" pattern="#,###.#"/> / <c:out value="${applyTotalProgress.element.totalItemCnt}"/>&nbsp;&nbsp;&nbsp;
	 			<spring:message code="글:과정:출석" /> : <c:out value="${applyTotalProgress.element.attendTypeAttendCnt}"/> <spring:message code="글:과정:회" />&nbsp;&nbsp;
	 			<spring:message code="글:과정:지각" /> : <c:out value="${applyTotalProgress.element.attendTypePerceptionCnt}"/> <spring:message code="글:과정:회" />&nbsp;&nbsp;
	 			<spring:message code="글:과정:결석" /> : <c:out value="${applyTotalProgress.element.attendTypeAbsenceCnt}"/> <spring:message code="글:과정:회" />
	 		</td>
	 	</tr>
	 </tbody>
</table>

<div class="vspace"></div>

<div class="lybox-title"><!-- lybox-title -->
    <h4 class="section-title"><spring:message code="필드:과정:학습하기" /></h4>
</div>

<c:forEach var="row" items="${itemList}" varStatus="i"><!-- 주차 리스트 -->

	<table id="listTable" class="tbl-layout">
	    <colgroup>
	        <col style="width: auto" />
	    </colgroup>
	    <thead>
	        <tr>
	            <td class="first">
	            	<div class="lybox-tbl">
	            		<h4 class="title">
	            			<c:out value="${row.element.sortOrder}"/>주차 | 
		           	 		<c:out value="${row.element.activeElementTitle}"/>
	            		</h4>
			            <div class="right">
			            ( <aof:date datetime="${row.element.startDtime}"/> ~ <aof:date datetime="${row.element.endDtime}"/> )
			            </div>
		            </div>
		            <table class="tbl-detail">
		            	<colgroup>
							<col style="width:12%;" />
							<col style="width:auto;" />
							<col style="width:10%;" />
						</colgroup>
						<tbody>
		            		<c:forEach var="rowSub" items="${row.itemResultList}"><!-- 강 리스트 -->
								<tr>
									<td>
										<c:out value="${rowSub.item.sortOrder+1}"/>
										<spring:message code="글:과정:교시강"/>
									</td>
									<td>
										<c:out value="${rowSub.item.title}"/>
										<div class="vspace"></div>
										<spring:message code="글:과정:학습횟수"/> | 
										<c:out value="${rowSub.learnerDatamodel.attempt}"/> <spring:message code="글:과정:회"/> &nbsp;&nbsp;&nbsp;
										<spring:message code="글:과정:학습시간"/> | 
											<c:choose>
												<c:when test="${0 < rowSub.learnerDatamodel.sessionTime}">
													<c:set var="hh" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime / (60 * 60 * 1000))}"/>
													<c:set var="mm" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
													<c:set var="ss" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 1000) / 1000 )}"/>
													<c:choose>
														<c:when test="${10 <= hh}">
															<c:out value="${hh}"/><spring:message code="글:시"/>
														</c:when>
														<c:otherwise>
															0<c:out value="${hh}"/><spring:message code="글:시"/>
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${10 <= mm}">
															<c:out value="${mm}"/><spring:message code="글:분"/>
														</c:when>
														<c:otherwise>
															0<c:out value="${mm}"/><spring:message code="글:분"/>
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${10 <= ss}">
															<c:out value="${ss}"/><spring:message code="글:초"/>
														</c:when>
														<c:otherwise>
															0<c:out value="${ss}"/><spring:message code="글:초"/>
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
													00<spring:message code="글:시"/> 00<spring:message code="글:분"/> 00<spring:message code="글:초"/>
												</c:otherwise>
											</c:choose> &nbsp;&nbsp;&nbsp;
										<spring:message code="글:과정:진도율"/> | 
										<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>% &nbsp;&nbsp;&nbsp;
										<spring:message code="글:과정:출결"/> | 
										<c:if test="${appToday > row.element.endDtime}"> 
											<c:choose>
												<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
													○
												</c:when>
												<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
													X
												</c:when>
												<c:otherwise>
													△
												</c:otherwise>
											</c:choose>
										</c:if>
										<c:if test="${appToday <= row.element.endDtime}">
											<c:choose>
												<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
													○
												</c:when>
												<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
													<spring:message code="글:과정:수강전"/>
												</c:when>
												<c:otherwise>
													<spring:message code="글:과정:수강중"/>
												</c:otherwise>
											</c:choose>
										</c:if>
									</td>
									<td class="align-c">
										<c:if test="${appToday > row.element.startDtime}">
											<c:if test="${appToday <= row.element.endDtime}">
												<a href="javascript:void(0)" onclick="doLearning({
																			'organizationSeq' : '<c:out value="${rowSub.item.organizationSeq}"/>',
																			'itemSeq' : '<c:out value="${rowSub.item.itemSeq}"/>',
																			'itemIdentifier' : '<c:out value="${rowSub.item.identifier}"/>',
																			'height' : '<c:out value="${rowSub.organization.height}"/>',
																			'width' : '<c:out value="${rowSub.organization.width}"/>',
																			'completionStatus' : '<c:out value="${rowSub.learnerDatamodel.completionStatus}"/>',
																			'courseId' : '<c:out value="${courseActive.courseActiveSeq}"/>'
																		});" class="btn black"><span class="small"><spring:message code="버튼:과정:학습하기"/></span></a>
											</c:if>
											<c:if test="${appToday > row.element.endDtime}">
												<a href="javascript:void(0)" onclick="doLearning({
																			'organizationSeq' : '<c:out value="${rowSub.item.organizationSeq}"/>',
																			'itemSeq' : '<c:out value="${rowSub.item.itemSeq}"/>',
																			'itemIdentifier' : '<c:out value="${rowSub.item.identifier}"/>',
																			'height' : '<c:out value="${rowSub.organization.height}"/>',
																			'width' : '<c:out value="${rowSub.organization.width}"/>',
																			'completionStatus' : '<c:out value="${rowSub.learnerDatamodel.completionStatus}"/>',
																			'courseId' : 'resume'
																		});" class="btn black"><span class="small"><spring:message code="버튼:과정:복습하기"/></span></a>
											</c:if>
										</c:if>
										<c:if test="${appToday <= row.element.startDtime}">
											<a href="javascript:void(0)" onclick="doNotStudyAlert()" class="btn black"><span class="small"><spring:message code="버튼:과정:학습하기"/></span></a>
										</c:if>
									</td>
								</tr>
							</c:forEach>
		            	</tbody>
		            </table>
	            </td>
	        </tr>
	    </thead>
	    <tbody>
	    
	    </tbody>
	</table>
	
<div class="vspace"></div>
</c:forEach>
</body>
</html>