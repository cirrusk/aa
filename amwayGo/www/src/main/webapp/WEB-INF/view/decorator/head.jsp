<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<div id="haeder"><!--haeder-->
<div class="info-msg"><spring:message code="글:헤더:그리팅"/></div>
    <ul class="join-info">
        <li>ㆍ<spring:message code="필드:로그인:접속IP"/> <span><%=request.getRemoteAddr()%></span></li>
        <li>ㆍ<spring:message code="필드:로그인:접속시간"/> <span><aof:date datetime="${appToday}" pattern="yyyy-MM-dd HH:mm"/></span></li>
    </ul>

    <ul class="quick-link">
        <li><a href="http://www.4csoft.com" target="_blank" title="<spring:message code="메뉴:홈페이지"/>" ><spring:message code="메뉴:홈페이지"/></a></li>
        <li><a href="javascript:void(0)" target="_blank" title="<spring:message code="메뉴:전자도서관"/>"><spring:message code="메뉴:전자도서관"/></a></li>
    </ul>
    
    <c:set var="startPage" scope="request"><c:url value="${aoffn:config('system.startPage')}"/></c:set>
    <h1 class="logo"><a href="<c:out value="${startPage}"/>"><aof:img src="common/t_logo.gif"/></a></h1>

    <c:import url="/WEB-INF/view/decorator/menu.jsp">
        <c:param name="location">top</c:param>
    </c:import>
</div><!--//haeder-->

