<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE"        value="${aoffn:code('CD.BOARD_TYPE')}"/>
<c:set var="CD_BOARD_TYPE_ADDSEP" value="${CD_BOARD_TYPE}::"/>

<script type="text/javascript">

/**
 * 탭 메뉴 이동
 */
doGoTab = function(code, seq) {
	var action = $.action();
	
	action.config.formId = "FormGoTab";
	actionType = code.toLowerCase();
	
    $("#FormGoTab input[name=selectedElementTypeCd]").val(seq);
    $("#FormGoTab input[name=srchBoardSeq]").val(seq);
	"<c:set var='actionType' value='" + actionType + "' scope='request'/>";
	
	action.config.url = "<c:url value="/univ/course/bbs/result/${actionType}/list.do"/>";
	action.run();
};

</script>

<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
	style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
	
	<form id="FormGoTab" name="FormGoTab" method="post" onsubmit="return false;">
        <input type="hidden" name="shortcutCourseActiveSeq"	value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
        <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>        
        <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
        <input type="hidden" name="shortcutCourseTypeCd"    value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
        
        <input type="hidden" name="selectedElementTypeCd" 	value=""/>
        <input type="hidden" name="srchBoardSeq" 			value=""/>
	</form>
	
	<ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
		<li class="ui-state-default ui-corner-top <c:out value="${empty param['selectedElementTypeCd'] or '0' eq param['selectedElementTypeCd'] or '' eq param['selectedElementTypeCd'] ? 'ui-tabs-selected ui-state-active' : ''}"/>">
			<a onclick="doGoTab('MEMBER', '0');"><spring:message code="필드:참여결과:참여자목록" /></a>
		</li>
		<c:forEach var="row" items="${boardList}" varStatus="i">
			<c:if test="${aoffn:contains(exceptEvaluateBoardType, row.board.boardTypeCd, ',') eq false and row.board.joinYn eq 'Y'}">
				<li class="ui-state-default ui-corner-top <c:out value="${row.board.boardSeq eq param['selectedElementTypeCd'] ? 'ui-tabs-selected ui-state-active' : ''}"/>">
					<a onclick="doGoTab('<c:out value="${fn:replace(row.board.boardTypeCd, CD_BOARD_TYPE_ADDSEP, '')}"/>', '<c:out value="${row.board.boardSeq}"/>');"><c:out value="${row.board.boardTitle}"/></a>
				</li>
			</c:if>
		</c:forEach>
	</ul>
	
</div>
