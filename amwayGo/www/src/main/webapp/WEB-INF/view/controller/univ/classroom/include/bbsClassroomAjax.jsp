<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE"        value="${aoffn:code('CD.BOARD_TYPE')}"/>
<c:set var="CD_BOARD_TYPE_ADDSEP" value="${CD_BOARD_TYPE}::"/>

	<ul>
		<c:if test="${!empty bbsNewsCntList}">
			<c:forEach var="row" items="${bbsNewsCntList}" varStatus="i">
				<c:set var="boardType" value="${fn:toLowerCase(fn:replace(row.board.boardTypeCd, CD_BOARD_TYPE_ADDSEP, '') )}"/>
				<li>
					<a href="javascript:void(0)" 
					   onclick="doOpenBbsLayer(
					       '<c:url value="/usr/classroom/course/bbs/${boardType}/list.do"/>',
					       '${row.board.boardSeq}',
					       '<c:out value="${fn:toUpperCase(boardType)}"/>'
					   );"><span class="icon-area icon-<c:out value="${boardType}"/>"></span><c:out value="${row.board.boardTitle}"/><span> </span><span class="board-count">(<c:out value="${row.board.newsCnt}"/>)</span></a>
				</li>
			</c:forEach>
		</c:if>		
	</ul>