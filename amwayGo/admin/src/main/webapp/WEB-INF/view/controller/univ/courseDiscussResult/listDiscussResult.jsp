<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
    <c:if test="${row.menu.url eq '/mypage/course/active/lecturer/mywork/list.do'}"> <%-- 마이페이지의 '나의할일' 메뉴를 찾는다 --%>
        <c:set var="menuSystemMywork" value="${row.menu}" scope="request"/>
    </c:if>
</c:forEach>

<!-- 오늘 날짜 가져오기 -->
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript">

var forDetail = null;

initPage = function() {
	doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/discuss/result/detail.do"/>";
	
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
    UT.getById(forDetail.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    forDetail.run();
};

</script>
</head>

<body>
	
<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="discussSeq" 			/>
	<input type="hidden" name="postType" 			    value="discuss"/>
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<c:if test="${menuSystemMywork.menuId ne appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이 아니면 --%>
		<div class="lybox-title"><!-- lybox-title -->
		    <div class="right">
		        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
		        <c:import url="../include/commonCourseActive.jsp"></c:import>
		        <!-- 년도학기 / 개설과목 Shortcut Area End -->
		    </div>
		</div>
		<div class="lybox-title">
		    <div class="right">
		    	<c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
					<a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/discuss/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:설정" /></span></a>
		    	</c:if>
		    </div>
		</div>
	</c:if>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list">
		    <colgroup>
		        <col style="width: 5%" />
		        <col style="width: auto" />
		        <col style="width: 20%" />
		        <col style="width: 20%" />
		        <col style="width: 10%" />
		        <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		        	<col style="width: 10%" />
		        </c:if>
		    </colgroup>
	    	<thead>
		        <tr>
		            <th><spring:message code="필드:번호" /></th>
		            <th><spring:message code="필드:토론:토론주제" /></th>
		            <th><spring:message code="필드:토론:토론기간" /></th>
		            <th><spring:message code="필드:토론:참여" /> | <spring:message code="필드:토론:미참여" /> | <spring:message code="필드:토론:대상인원" /></th>
		            <th><spring:message code="필드:토론:평가비율" /></th>
		            <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		            	<th><spring:message code="필드:토론:상태" /></th>
		            </c:if>
		        </tr>
	    	</thead>
	    	<tbody>
	    	<c:set var="minusCount" value="0"></c:set>
	    	<c:forEach var="row" items="${itemList}" varStatus="i">
	    		<tr>
		    		<td>
				    	<c:out value="${fn:length(itemList) - minusCount}"/>
				    	<c:set var="minusCount" value="${minusCount + 1}"></c:set>
				    </td>
				    <td class="align-l">
				    	<a href="javascript:doDetail({'discussSeq' : '<c:out value="${row.discuss.discussSeq}" />'});"><c:out value="${row.discuss.discussTitle}"/></a>
				    </td>
				    <td>
				    	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
					    	<aof:date datetime="${row.discuss.startDtime}"/>
			                ~
			                <aof:date datetime="${row.discuss.endDtime}"/>
		                </c:if>
		                <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		                	<span><spring:message code="글:수강시작" /></span> <c:out value="${row.discuss.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${row.discuss.endDay}" /> <spring:message code="글:일까지" />
				    	</c:if>
				    </td>
				    <td>
				    	<c:out value="${empty row.discuss.regMemberCount ? 0:row.discuss.regMemberCount}"/> &nbsp;|&nbsp; 
				    	<c:out value="${empty row.discuss.nonMemberCount ? 0:row.discuss.nonMemberCount}"/> &nbsp;|&nbsp; 
				    	<c:out value="${empty row.discuss.memberCount ? 0:row.discuss.memberCount}"/>
				    </td>
				    <td>
				    	<c:out value="${row.discuss.rate}"/> %
				    </td>
				    <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
					    <td>
					    	<c:choose>
			            		<c:when test="${row.discuss.startDtime <= appToday and row.discuss.endDtime > appToday}">
			            			<spring:message code="글:토론:진행중" />
			            		</c:when>
			            		<c:when test="${row.discuss.startDtime <= appToday and row.discuss.endDtime < appToday}">
			            			<spring:message code="글:토론:종료" />
			            		</c:when>
			            		<c:otherwise>
			            			<spring:message code="글:토론:대기" />
			            		</c:otherwise>
			            	</c:choose>
					    </td>
				    </c:if>
			    </tr>
	    	</c:forEach>
	        <c:if test="${empty itemList}">
	            <tr>
	                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
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