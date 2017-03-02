<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_OFFLINE" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.OFFLINE')}"/>
<c:set var="CD_ONOFF_TYPE_OFF"              value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>
<c:set var="CD_ATTEND_TYPE"                 value="${aoffn:code('CD.ATTEND_TYPE')}"/>
<c:set var="CD_ATTEND_TYPE_ADDSEP"          value="${CD_ATTEND_TYPE}::"/>
<c:set var="CD_ATTEND_TYPE_001"             value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002"             value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003"             value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>


<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdateList   = null;
var forEdit   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forUpdateList = $.action("submit", {formId : "FormUpdateList"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdateList.config.url             = "<c:url value="/univ/course/active/offline/update.do"/>";
	forUpdateList.config.target          = "hiddenframe";
	forUpdateList.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdateList.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdateList.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateList.config.fn.complete     = function() {
		doEdit();
	};
	
	forEdit = $.action();
	forEdit.config.formId = "FormList";
	forEdit.config.url    = "<c:url value="/univ/course/active/offline/edit.do"/>";
	
	setValidate();
};

doUpdateList = function() {
	
	var checkElement = jQuery("#checkElement").val();
	
	if(checkElement == 'N'){
		$.alert({
			message : "<spring:message code="글:출석:주차정보를먼저등록하셔야합니다"/>"
		});
		return;
	}
	
	var minus002 = jQuery("#minusScores002").val();
	var minus003 = jQuery("#minusScores003").val();
	var counts003 = jQuery("#counts003").val();
	
	if(parseFloat(minus002) < parseFloat(minus003 * counts003)){
		$.alert({
			message : "<spring:message code="글:출석:설정된지각감점점수가결석감점점수와같거나더높습니다"/>"
		});
		return;
	}else{
		forUpdateList.run();	
	}
};

doEdit = function() {
	forEdit.run();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
		
	forUpdateList.validator.set({
		title : "<spring:message code="글:오프라인출석결과:주차별수업횟수"/>",
		name : "offlineLessonCounts",
		data : ["!null","number"],
		check : {
			maxlength : 1 ,
			le : 5
		}
	});
	
	forUpdateList.validator.set({
		title : "<spring:message code="필드:출석:감점"/>",
		name : "minusScores",
		data : ["!null", "decimalnumber"],
		check : {
			maxlength : 3 ,
			le : 100
		}
	});
	
	forUpdateList.validator.set({
		title : "<spring:message code="필드:출석:결석처리횟수"/>",
		name : "counts",
		data : ["!null", "number"]
	});
	
	forUpdateList.validator.set({
		title : "<spring:message code="필드:출석:결석처리횟수"/>",
		name : "permissionCounts",
		data : ["!null", "number"]
	});
	
	forUpdateList.validator.set({
		title : "",
		name : "fullCount",
		data : ["number"],
		check : {
			maxlength : 1
		}
	});
	
};

/*
 * 주차별 수업횟수 전체적용
 */
doFullapplication = function(){
 	var $form = jQuery("#" + forUpdateList.config.formId);
 	$form.find(":input[name='offlineLessonCounts']").each(function(index) {
 		if($form.find(":input[name='offlineAttendCnts']").eq(index).val() == 0){
 			this.value = jQuery("#fullCount").val();
 		}
 	});
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

	<c:set var="elementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_OFFLINE}"/>
	<!-- 교과목 구성정보 Tab Area Start -->
	<c:import url="../include/commonCourseActiveElement.jsp">
	    <c:param name="courseActiveSeq" value="${element.courseActiveSeq}"></c:param>
	    <c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>
	<!--  교과목 구성정보 Tab Area End -->
		
	<!-- 평가기준 Start Area -->
    <c:import url="../include/commonCourseActiveEvaluate.jsp">
    	<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
    </c:import>
    <!-- 평가기준 Start End -->
    
    <div class="lybox-btn">
		<div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <c:forEach var="row" items="${appMenuList}">
                    <c:choose>
                        <c:when test="${row.menu.cfString eq 'OFFLINE'}">
                            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
                        </c:when>
                    </c:choose>
                </c:forEach>
                <a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>',
                                                                '<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>',
                                                                '<c:out value="${menuActiveDetail.menu.dependent}"/>',
                                                                '<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" >
                                                                <span class="small"><spring:message code="버튼:오프라인출석결과:오프라인출석결과" /></span>
                </a>
            </c:if>
        </div>
    </div>
    
    <!-- 주차정보존재유무체크 -->
    <c:set var="elementCheck" value="N" />
		<c:if test="${!empty listElement }">
			<c:set var="elementCheck" value="Y" />
		</c:if>
	<input type="hidden" id="checkElement" value="${elementCheck}" />
    
    <form name="FormList" id="FormList" method="post" onsubmit="return false;">
    	<input type="hidden" name="courseActiveSeq" 		 value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    </form>

	<form name="FormUpdateList" id="FormUpdateList" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="onoffCd" value="<c:out value="${CD_ONOFF_TYPE_OFF}"/>"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
				
		<table class="tbl-layout">
			<tbody>
				<tr>
					<td class="first">
						<div class="lybox-tbl">
							<h4 class="title"><spring:message code="글:오프라인출석결과:주차별수업횟수"/></h4>
						</div>						 
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
												<c:set var="count" value="${count - 1}" />
												<td class="align-c">
													<c:if test="${row1.applyAttend.offlineAttendCnt eq 0}" >
														<input type="text" name="offlineLessonCounts" value="<c:out value="${row1.element.offlineLessonCount }"/>">
													</c:if>
													<c:if test="${row1.applyAttend.offlineAttendCnt ne 0}" >
														<input type="hidden" name="offlineLessonCounts" value="<c:out value="${row1.element.offlineLessonCount }"/>">
														<c:out value="${row1.element.offlineLessonCount }" />
													</c:if>
													<input type="hidden" name="offlineAttendCnts" value="<c:out value="${row1.applyAttend.offlineAttendCnt}"/>">
													<input type="hidden" name="activeElementSeqs" value="<c:out value="${row1.element.activeElementSeq }" />">
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
													<c:if test="${row1.applyAttend.offlineAttendCnt eq 0}" >
														<input type="text" name="offlineLessonCounts" value="<c:out value="${row1.element.offlineLessonCount }"/>">
													</c:if>
													<c:if test="${row1.applyAttend.offlineAttendCnt ne 0}" >
														<input type="hidden" name="offlineLessonCounts" value="<c:out value="${row1.element.offlineLessonCount }"/>">
													<c:out value="${row1.element.offlineLessonCount }" />
													</c:if>
													<input type="hidden" name="offlineAttendCnts" value="<c:out value="${row1.applyAttend.offlineAttendCnt}"/>">
													<input type="hidden" name="activeElementSeqs" readonly="true" value="<c:out value="${row1.element.activeElementSeq }" />">										
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
													<c:if test="${row1.applyAttend.offlineAttendCnt eq 0}" >
														<input type="text" name="offlineLessonCounts" value="<c:out value="${row1.element.offlineLessonCount }"/>">
													</c:if>
													<c:if test="${row1.applyAttend.offlineAttendCnt ne 0}" >
														<input type="hidden" name="offlineLessonCounts" value="<c:out value="${row1.element.offlineLessonCount }"/>">
														<c:out value="${row1.element.offlineLessonCount }" />
													</c:if>
													<input type="hidden" name="offlineAttendCnts" value="<c:out value="${row1.applyAttend.offlineAttendCnt}"/>">
													<input type="hidden" name="activeElementSeqs" readonly="true" value="<c:out value="${row1.element.activeElementSeq }" />">
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
		<div class="lybox-btn">
			<div class="lybox-btn-r">
				<input type="text" name="fullCount" id="fullCount"> <span><spring:message code="글:회"/></span>  
				<a href="javascript:void(0)" onclick="doFullapplication();" class="btn blue"><span class="mid"><spring:message code="버튼:전체적용"/></span></a>
			</div>
		</div>
		
		<div class="vspace"></div>
		
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
											<input type="hidden" name="attendTypeCds" value="<c:out value="${row.code.code}"/>">
											<c:out value="${row.code.codeName}"/>
										</th>
										<td class="align-c">
											<c:if test="${row.code.code eq CD_ATTEND_TYPE_002}">
												<input name="permissionCounts" type="text" value="<c:out value="${empty row.attendEvaluate.permissionCount ? 0:row.attendEvaluate.permissionCount}"/>" size="5" class="align-r"/> <spring:message code="필드:출석:회" />
											</c:if>
											<c:if test="${row.code.code ne CD_ATTEND_TYPE_002}">
												-
												<input name="permissionCounts" type="hidden" value="<c:out value="${empty row.attendEvaluate.permissionCount ? 0:row.attendEvaluate.permissionCount}"/>" size="5" class="align-r"/>
											</c:if>
										</td>										
										<td class="align-c">
											<input id="minusScores<c:out value="${fn:replace(row.code.code, CD_ATTEND_TYPE_ADDSEP,'')}"/>" name="minusScores" type="text" value="<fmt:formatNumber value="${empty row.attendEvaluate.minusScore ? 0:row.attendEvaluate.minusScore}" />" size="5" class="align-r"/><spring:message code="필드:출석:점" />
										</td>
										<td class="align-c">
											<c:if test="${row.code.code eq CD_ATTEND_TYPE_003}">
												<input name="counts" id="counts003" type="text" value="<c:out value="${empty row.attendEvaluate.count ? 0:row.attendEvaluate.count}"/>" size="5" class="align-r"/> <spring:message code="필드:출석:회" />
											</c:if>
											<c:if test="${row.code.code ne CD_ATTEND_TYPE_003}">
												-
												<input name="counts" type="hidden" value="<c:out value="${empty row.attendEvaluate.count ? 0:row.attendEvaluate.count}"/>"/>
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
				<a href="javascript:void(0)" onclick="doUpdateList();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
		</div>
	</div>
</body>
</html>