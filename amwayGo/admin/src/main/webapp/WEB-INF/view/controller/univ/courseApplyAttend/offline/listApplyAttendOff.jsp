<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_OFF"  value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>
<c:set var="CD_ATTEND_TYPE_001" value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002" value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003" value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forEdit = null;
var forAttendRegist = null;
var forAttendScore = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.tabs("#tabs").show();

	doTab(0);
	
};
	
doInitializeLocal = function() {	
	
	forEdit = $.action();
	forEdit.config.formId = "FormSub";
	forEdit.config.url    = "<c:url value="/univ/course/active/offline/attend/result/edit.do"/>";
	
	forAttendRegist = $.action();
	forAttendRegist.config.formId = "FormSub";
	forAttendRegist.config.url = "<c:url value="/univ/course/active/offline/attend/result/regist/list/iframe.do"/>";
	forAttendRegist.config.target = "frame-attend-regist";
	forAttendRegist.config.fn.complete = function() {};
	
	forAttendScore = $.action();
	forAttendScore.config.formId = "FormSub";
	forAttendScore.config.url = "<c:url value="/univ/course/active/offline/attend/result/Score/list/iframe.do"/>";
	forAttendScore.config.target = "frame-attend-score";
	forAttendScore.config.fn.complete = function() {};
	
};

/**
 * 탭열기
 */
doTab = function(index) {
	$('#tabs').tabs({selected : index});
};

/**
 * 출석부입력
 */
doAttendRegist = function() {
	forAttendRegist.run();
};
/**
 * 출석점수
 */
doAttendScore = function() {
	forAttendScore.run();
};

/**
 * 오프라인 수업결과 수정페이지
 */
doEdit = function(){
	forEdit.run();
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<div class="lybox-title"><!-- lybox-title -->
	    <div class="right">
	        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
	        <c:import url="../../include/commonCourseActive.jsp"></c:import>
	        <!-- 년도학기 / 개설과목 Shortcut Area End -->
	    </div>
	</div>
	
	<c:set var="elementCheck" value="N" />
	<c:if test="${!empty listElement }">
		<c:set var="elementCheck" value="Y" />
	</c:if>
	
	<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" 		 value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="srchCourseActiveSeq" 		 value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>

	<form name="FormDetailList" id="FormUpdateList" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="onoffCd" value="<c:out value="${CD_ONOFF_TYPE_OFF}"/>"/>
		
		<div class="vspace"></div>
		<div class="vspace"></div>

		<table class="tbl-layout">
			<tbody>
				<tr>
					<td class="first">
						<div class="lybox-tbl">
							<h4 class="title"><spring:message code="글:오프라인출석결과:주차별수업횟수"/></h4>
						</div>
						<!-- 항목 -->
						<table class="tbl-detail">
							<tbody>
								<tr>
									<th class="align-c">1<spring:message code="글:주"/></th>
									<th class="align-c">2<spring:message code="글:주"/></th>
									<th class="align-c">3<spring:message code="글:주"/></th>
									<th class="align-c">4<spring:message code="글:주"/></th>
									<th class="align-c">5<spring:message code="글:주"/></th>
								</tr>
								<tr>
									<c:if test="${!empty listElement }">
										<c:set var="count" value="5" />
										<c:forEach var="row1" items="${listElement}" varStatus="i">
											<c:if test="${i.index <= 4 }">
												<c:set var="count" value="${count -1}" />
												<td class="align-c">
													<c:out value="${row1.element.offlineLessonCount }" />
												</td>
											</c:if>
										</c:forEach>
										<c:forEach begin="1" end="${count}" step="1">
											<td class="align-c">
												-
											</td>
										</c:forEach>
									</c:if>
									<c:if test="${empty listElement }">
										<c:forEach begin="1" end="5" step="1">
											<td class="align-c">
												-
											</td>
										</c:forEach>
									</c:if>
								</tr>
								<tr>
									<th class="align-c">6<spring:message code="글:주"/></th>
									<th class="align-c">7<spring:message code="글:주"/></th>
									<th class="align-c">8<spring:message code="글:주"/></th>
									<th class="align-c">9<spring:message code="글:주"/></th>
									<th class="align-c">10<spring:message code="글:주"/></th>
								</tr>
								<tr>
									<c:if test="${!empty listElement }">
										<c:set var="count2" value="5" />
										<c:forEach var="row1" items="${listElement}" varStatus="i">
											<c:if test="${i.index >= 5 && i.index <= 9 }">
												<c:set var="count2" value="${count2 - 1}" />		
												<td class="align-c">
													<c:out value="${row1.element.offlineLessonCount }" />
												</td>
											</c:if>
										</c:forEach>
										<c:forEach begin="1" end="${count2}" step="1">
											<td class="align-c">
												-
											</td>
										</c:forEach>
									</c:if>
									<c:if test="${empty listElement }">
										<c:forEach begin="1" end="5" step="1">
											<td class="align-c">
												-
											</td>
										</c:forEach>
									</c:if>
								</tr>
								<tr>
									<th class="align-c">11<spring:message code="글:주"/></th>
									<th class="align-c">12<spring:message code="글:주"/></th>
									<th class="align-c">13<spring:message code="글:주"/></th>
									<th class="align-c">14<spring:message code="글:주"/></th>
									<th class="align-c">15<spring:message code="글:주"/></th>
								</tr>
								<tr>
									<c:if test="${!empty listElement }">
										<c:set var="count3" value="5" />
										<c:forEach var="row1" items="${listElement}" varStatus="i">
											<c:if test="${i.index >= 10 }">
												<c:set var="count3" value="${count3 - 1}" />		
												<td class="align-c">
													<c:out value="${row1.element.offlineLessonCount }" />
												</td>
											</c:if>
										</c:forEach>
										<c:forEach begin="1" end="${count3}" step="1">
											<td class="align-c">
												-
											</td>
										</c:forEach>
									</c:if>
									<c:if test="${empty listElement }">
										<c:forEach begin="1" end="5" step="1">
											<td class="align-c">
												-
											</td>
										</c:forEach>
									</c:if>
								</tr>
							</tbody>
						</table>
						<!-- 항목 -->
					</td>
				</tr>
			</tbody>
		</table>
		
		<div class="vspace"> </div>
		<div class="vspace"> </div>
		
		<table class="tbl-layout">
			<tbody>
				<tr>
					<td class="first">
						<div class="lybox-tbl">
							<h4 class="title"><spring:message code="필드:출석:결석허용횟수" /> / <spring:message code="필드:출석:감점정보" /></h4>
						</div>
						<!-- 항목 -->
						<table class="tbl-detail">
							<thead>
								<colgroup>
									<col style="width: 120px" />
									<col/>
									<col/>
									<col/>
								</colgroup>
							</thead>
							<tbody>
								<tr>
									<th class="align-c"><spring:message code="필드:출석:항목" /></th>
									<th class="align-c"><spring:message code="필드:출석:결석허용횟수" /></th>
									<th class="align-c"><spring:message code="필드:출석:감점" /></th>
									<th class="align-c"><spring:message code="필드:출석:결석전환처리" /></th>
								</tr>
								
								<c:forEach var="row" items="${list}" varStatus="i">
									<tr>
										<th class="align-c">
											<input type="hidden" name="attendTypeCds" value="<c:out value="${row.code.code}"/>" />
											<c:out value="${row.code.codeName}"/>
										</th>
										<td class="align-c">
											<c:if test="${row.code.code eq CD_ATTEND_TYPE_002}">
												<c:out value="${empty row.attendEvaluate.permissionCount ? 0:row.attendEvaluate.permissionCount}"/><spring:message code="필드:출석:회" />
											</c:if>
											<c:if test="${row.code.code ne CD_ATTEND_TYPE_002}">
												-
											</c:if>
										</td>
										<td class="align-c">
											<fmt:formatNumber value="${empty row.attendEvaluate.minusScore ? 0:row.attendEvaluate.minusScore}" /> <spring:message code="필드:출석:점" />
										</td>
										<td class="align-c">
											<c:if test="${row.code.code eq CD_ATTEND_TYPE_003}">
												<c:out value="${empty row.attendEvaluate.count ? 0:row.attendEvaluate.count}"/><spring:message code="필드:출석:회" />
											</c:if>
											<c:if test="${row.code.code ne CD_ATTEND_TYPE_003}">
												-
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<!-- 항목 -->
					</td>
				</tr>
			</tbody>
		</table>
		
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<c:if test="${elementCheck eq 'Y'}" >
					<a href="javascript:void(0)" onclick="doEdit();" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
				</c:if>
			</c:if>
		</div>
	</div>
	
	<div class="vspace"></div>
	<div class="vspace"></div>

	<div id="tabs" style="display:none;"> 
		<ul class="ui-widget-header-tab-custom">
			<li><a href="#tabContainer1" onclick="doAttendRegist()"><spring:message code="버튼:오프라인출석결과:출석부입력"/></a></li>
			<li><a href="#tabContainer2" onclick="doAttendScore()"><spring:message code="버튼:오프라인출석결과:출석점수"/></a></li>
		</ul>
		<div id="tabContainer1">
			<iframe id="frame-attend-regist" name="frame-attend-regist" 
				frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</div>
		<div id="tabContainer2">
			<iframe id="frame-attend-score" name="frame-attend-score" 
					frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</div>
	</div>

</body>
</html>