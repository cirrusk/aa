<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON"               value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ONLINE"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ONLINE')}"/>
<c:set var="CD_ATTEND_TYPE"                 value="${aoffn:code('CD.ATTEND_TYPE')}"/>
<c:set var="CD_ATTEND_TYPE_ADDSEP"          value="${CD_ATTEND_TYPE}::"/>
<c:set var="CD_ATTEND_TYPE_001"             value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002"             value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003"             value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ONLINE'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

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
	forUpdateList.config.url             = "<c:url value="/univ/course/active/online/update.do"/>";
	forUpdateList.config.target          = "hiddenframe";
	forUpdateList.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdateList.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdateList.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateList.config.fn.complete     = function() {
		doEdit();
	};
	
	forEdit = $.action();
	forEdit.config.formId = "FormList";
	forEdit.config.url    = "<c:url value="/univ/course/active/online/edit.do"/>";
	
	setValidate();
};

doUpdateList = function() {
	
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
}

doEdit = function() {
	forEdit.run();
}

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forUpdateList.validator.set({
		title : "<spring:message code="필드:출석:감점"/>",
		name : "minusScores",
		data : ["!null", "decimalnumber"],
		check : {
			maxlength : 20
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
	
};

</script>
</head>

<body>

    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
    </c:import>

	<c:import url="../../include/commonCourseActive.jsp"></c:import>

	<c:set var="elementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_ONLINE}"/>
	<c:import url="../include/commonCourseActiveElement.jsp">
		<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>
	
	<!-- 평가기준 Start Area -->
    <c:import url="../include/commonCourseActiveEvaluate.jsp">
    	<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
    </c:import>
    <!-- 평가기준 Start End -->
    
    <form name="FormList" id="FormList" method="post" onsubmit="return false;">
    	<input type="hidden" name="courseActiveSeq" 		 value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    </form>

	<form name="FormUpdateList" id="FormUpdateList" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="onoffCd" value="<c:out value="${CD_ONOFF_TYPE_ON}"/>"/>
		
		<div class="lybox-title mt20">
		    <div class="right">
		    	<c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
					<a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:출석:온라인수업결과" /></span></a>
		    	</c:if>
		    </div>
		</div>
		
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
									<th class="align-c"><spring:message code="필드:출석:감점" /></th>
									<th class="align-c"><spring:message code="필드:출석:결석허용횟수" /></th>
									<th class="align-c"><spring:message code="필드:출석:결석전환처리" /></th>
								</tr>
								
								<c:forEach var="row" items="${list}" varStatus="i">
									<tr>
										<th class="align-c">
											<input type="hidden" name="attendTypeCds" value="<c:out value="${row.code.code}"/>">
											<c:out value="${row.code.codeName}"/>
										</th>
										<td class="align-c">
											<input id="minusScores<c:out value="${fn:replace(row.code.code, CD_ATTEND_TYPE_ADDSEP,'')}"/>" name="minusScores" type="text" value="<c:out value="${empty row.attendEvaluate.minusScore ? 0:row.attendEvaluate.minusScore}"/>" size="5" class="align-r"/> <spring:message code="필드:출석:점" />
										</td>
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