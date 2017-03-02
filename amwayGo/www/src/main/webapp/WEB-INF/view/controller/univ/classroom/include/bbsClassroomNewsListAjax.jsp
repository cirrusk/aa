<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE"          value="${aoffn:code('CD.BOARD_TYPE')}"/>
<c:set var="CD_BOARD_TYPE_ADDSEP"   value="${CD_BOARD_TYPE}::"/>
<c:set var="CD_BOARD_TYPE_NOTICE"   value="${aoffn:code('CD.BOARD_TYPE.NOTICE')}"/>
<c:set var="CD_BOARD_TYPE_RESOURCE" value="${aoffn:code('CD.BOARD_TYPE.RESOURCE')}"/>
<c:set var="CD_BOARD_TYPE_QNA"      value="${aoffn:code('CD.BOARD_TYPE.QNA')}"/>
<c:set var="CD_BOARD_TYPE_FREE"     value="${aoffn:code('CD.BOARD_TYPE.FREE')}"/>

<c:set var="evaluateBoardType" value="${CD_BOARD_TYPE_NOTICE},${CD_BOARD_TYPE_RESOURCE},${CD_BOARD_TYPE_QNA},${CD_BOARD_TYPE_FREE}" scope="request"/>

	<div class="article part">
		<div class="board">	
			<h3><span class="news"></span><spring:message code="글:과정:새소식"/></h3>
			<ul>
				<c:if test="${!empty bbsNewsCntList}">				
					<c:forEach var="row" items="${bbsNewsCntList}" varStatus="i">
						<c:if test="${aoffn:contains(evaluateBoardType, row.board.boardTypeCd, ',') eq true}">
						<c:set var="boardType" value="${fn:toLowerCase(fn:replace(row.board.boardTypeCd, CD_BOARD_TYPE_ADDSEP, '') )}"/>
						<c:set var="boardType">board-${boardType}</c:set>
							<li class="${boardType}">
								<span><c:out value="${row.board.boardTitle}"/></span>
								<a href="#" onclick="doMove(2)"><c:out value="${row.board.newsCnt}"/></a>
							</li>
						</c:if>
					</c:forEach>
				</c:if>		
			</ul>
		</div>
		<div class="bg"></div>
	</div>
