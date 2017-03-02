<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:forEach var="row" items="${appMenuList}">
    <c:if test="${row.menu.url eq '/mypage/course/active/lecturer/mywork/list.do'}"> <%-- 마이페이지의 '나의할일' 메뉴를 찾는다 --%>
        <c:set var="menuSystemMywork" value="${row.menu}" scope="request"/>
    </c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forDetail                = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
    forDetail = $.action();
    forDetail.config.formId = "FormTeamProjectResult";
    forDetail.config.url    = "<c:url value="/univ/teamproject/result/detail.do"/>";
    setValidate();
};

setValidate = function() {};

/**
 * 팀프로젝트 상세 조회
 */
doDetail = function(mapPKs){
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    // 상세화면 실행
    forDetail.run();
};
</script>
</head>

<body>
<c:import url="srchTeamProjectResult.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<c:if test="${menuSystemMywork.menuId ne appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이 아니면 --%>
	<div class="lybox-title"><!-- lybox-title -->
	    <div class="right">
	        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
	        <c:import url="../include/commonCourseActive.jsp"></c:import>
	        <!-- 년도학기 / 개설과목 Shortcut Area End -->
	    </div>
	</div>
	
	<div class="lybox-title"><!-- lybox-title -->
	    <div class="right">
	        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	            <c:forEach var="row" items="${appMenuList}">
	                <c:choose>
	                    <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
	                        <c:set var="menuActiveDetail" value="${row}" scope="request"/>
	                    </c:when>
	                </c:choose>
	            </c:forEach>
	            <a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/teamproject/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');">
	                <span class="small"><spring:message code="버튼:설정" /></span>
	            </a>
	        </c:if>
	    </div>
	</div>
</c:if>

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<table id="listTable" class="tbl-list">
<colgroup>
    <col style="width: 50px" />
    <col style="width: auto" />
    <%--<col style="width: 240px" /> --%>
    
    <col style="width: 60px" />
    <col style="width: 100px" />
    <%--<col style="width: 70px" />--%>
</colgroup>
<thead>
    <tr>
        <th><spring:message code="필드:번호" /></th>
        <th><spring:message code="필드:팀프로젝트:프로젝트제목" /></th>
        <%--<th><spring:message code="필드:팀프로젝트:프로젝트기간" /></th> --%>
        <th><spring:message code="필드:팀프로젝트:상태" /></th>
        <th><spring:message code="필드:팀프로젝트:팀구성" /></th>
        <%--<th><spring:message code="필드:팀프로젝트:평가비율" /></th> --%>
    </tr>
</thead>
<tbody>
<c:forEach var="row" items="${itemList}" varStatus="i">
    <tr>
        <td>
            <c:out value="${i.count}"/>
        </td>
        <td class="align-l">
            <%// TODO : 코드 %>
            <a href="javascript:void(0)" onclick="doDetail({courseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>})">
                <c:out value="${row.courseTeamProject.teamProjectTitle}"/>
            </a>
        </td>
        <%--
        <td>
            <spring:message code="필드:팀프로젝트:진행기간" /> 
            : 
            <aof:date datetime="${row.courseTeamProject.startDtime}"/>
            ~
            <aof:date datetime="${row.courseTeamProject.endDtime}"/>
            <br/>
            <spring:message code="필드:팀프로젝트:과제제출" />
            :
            <aof:date datetime="${row.courseTeamProject.homeworkStartDtime}"/>
            ~
            <aof:date datetime="${row.courseTeamProject.homeworkEndDtime}"/>
        </td>
         --%>
        <%/** TODO : 코드*/ %>
        <td><aof:code type="print" codeGroup="TEAM_PROJECT_STATUS" selected="${row.courseTeamProject.teamProjectStatusCd}"/> </td>
        <td>
            <c:out value="${row.courseTeamProject.projectTeamCount}"/><spring:message code="필드:팀프로젝트:팀" />
        </td>
        <%--
        <td>
            <c:out value="${row.courseTeamProject.rate}"/>%
        </td>
         --%>
    </tr>
</c:forEach>
<c:if test="${empty itemList}">
    <tr>
        <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
    </tr>
</c:if>
</tbody>
</table>
</form>

<c:if test="${menuSystemMywork.menuId eq appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이면 --%>
    <c:import url="../include/myworkInc.jsp"></c:import>
</c:if>

</body>
</html>