<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forTab = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. tab
	var index = "<c:out value="${param['tabIndex']}"/>";
	index = (index == "") ? 0 : parseInt(index, 10);
	UI.tabs("#tabs").tabs('select', index).show();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forTab = $.action();
	forTab.config.formId = "FormSubBoard";
	forTab.config.target = "iframe-bbs";
};
/**
 * 탭이동
 */
doSubBoard = function(seq) {
	forTab.config.url = "<c:url value="/univ/course/bbs/dynamic/{boardSeq}/list/iframe.do"/>";
	forTab.config.url = UT.formatString(forTab.config.url, {boardSeq : seq});
	forTab.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>
	<c:import url="../include/commonCourseActive.jsp"></c:import>

	<c:choose>
		<c:when test="${empty paginateBoard.itemList}">
			<div class="lybox align-c">
				<spring:message code="글:게시판:생성된게시판이존재하지않습니다" />
			</div>
		</c:when>
		<c:otherwise>

			<form name="FormSubBoard" id="FormSubBoard" method="post" onsubmit="return false;">
				<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>">
			</form>

			<div id="tabs">
				<ul class="ui-widget-header-tab-custom">
					<c:forEach var="row" items="${paginateBoard.itemList}" varStatus="i">
						<li><a href="javascript:void(0)" onclick="doSubBoard('<c:out value="${row.board.boardSeq}"/>')"><c:out value="${row.board.boardTitle}"/></a></li>		
					</c:forEach>
				</ul>
			</div>
			<iframe id="iframe-bbs" name="iframe-bbs" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</c:otherwise>
	</c:choose>

</body>
</html>