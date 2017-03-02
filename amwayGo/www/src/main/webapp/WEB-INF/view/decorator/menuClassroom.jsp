<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE"        value="${aoffn:code('CD.BOARD_TYPE')}"/>
<c:set var="CD_BOARD_TYPE_ADDSEP" value="${CD_BOARD_TYPE}::"/>

<form id="FormGoTab" name="FormGoTab" method="post" onsubmit="return false;">
    <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
</form>

<c:set var="currentMenuId" value="${param['currentMenuId']}" scope="request"/>
<!-- snb(section_west) -->
<div id="section_west" class="aside">
	<div class="snb">
		<h2 class="tit"><spring:message code="메뉴:강의실"/></h2>
		<ul>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009001') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value="/usr/classroom/main.do"/>','009001','FormGoTab','');"><spring:message code="메뉴:강의실:강의실홈"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009002') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value="/usr/classroom/course/active/element/organization/list.do"/>','009002','FormGoTab','');"><spring:message code="메뉴:강의실:온라인학습"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009003') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value=""/>','009003','FormGoTab','');"><spring:message code="메뉴:강의실:시험응시"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009004') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value=""/>','009004','FormGoTab','');"><spring:message code="메뉴:강의실:퀴즈응시"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009005') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value="/usr/classroom/homework/list.do"/>','009005','FormGoTab','');"><spring:message code="메뉴:강의실:과제제출"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009006') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value="/usr/classroom/teamproject/list.do"/>','009006','FormGoTab','');"><spring:message code="메뉴:강의실:팀프로젝트"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009007') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value="/usr/classroom/discuss/list.do"/>','009007','FormGoTab','');"><spring:message code="메뉴:강의실:토론실"/></a></li>
			<li class="<c:out value="${fn:startsWith(currentMenuId, '009008') eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenu('<c:url value="/usr/classroom/surveypaper/test/list.do"/>','009008','FormGoTab','');"><spring:message code="메뉴:강의실:설문참여"/></a></li>
			
			<!-- 동적 게시판 메뉴 -->
			<c:if test="${!empty _CLASS_boardInfo.itemList}">
				<c:forEach var="row" items="${_CLASS_boardInfo.itemList}" varStatus="i">
					<li class="<c:out value="${fn:startsWith(currentMenuId, row.board.boardSeq) eq true ? 'on' : ''}"/>"><a href="#" onclick="FN.doGoMenuBbs('<c:url value="/usr/classroom/course/bbs/${fn:toLowerCase( fn:replace(row.board.boardTypeCd, CD_BOARD_TYPE_ADDSEP, '') )}/list.do"/>', '${row.board.boardSeq}', 'FormGoTab', '${row.board.boardSeq}', '${row.board.boardTitle}', '');"><c:out value="${row.board.boardTitle}"/></a></li>
				</c:forEach>
			</c:if>
		</ul>
	</div>
</div>
<!-- //snb(section_west) -->
