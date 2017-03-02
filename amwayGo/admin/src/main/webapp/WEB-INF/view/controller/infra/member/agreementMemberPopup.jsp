<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forDetail     = null;
var forSearch     = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	FN.doSortList("listTable2", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
    forSearch.config.formId = "FormSrch";
    forSearch.config.url    = "<c:url value="/member/detail/popup.do"/>";	
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function() {
	forDetail.run();
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
 doSearch = function(rows) {
/* 	    var form = UT.getById(forSearch.config.formId);
	    
	    // 목록갯수 셀렉트박스의 값을 변경 했을 때
	    if (rows != null && form.elements["perPage"] != null) {  
	        form.elements["perPage"].value = rows;
	    } */
	    forSearch.run();
	};

</script>
</head>
<body>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="1" /> 
		<%-- <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" /> --%>
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		
		<input type="hidden" name="srchMemberSeq" value="<c:out value="${condition.srchMemberSeq}"/>" />
		<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
		<input type="hidden" name="memberSeq" value="<c:out value="${condition.srchMemberSeq}"/>" />
	</form>

	<table id="listTable2" class="tbl-list">
	    	<colgroup>
	        <!-- <col style="width: 20px" /> -->
	        <col style="width: 80px" />
	        <col style="width: 120px" />
	        <col style="width: 40px" />
	        <col style="width: 40px" />
	        <col style="width: 70px" />
	        <col style="width: 70px" />
	  		</colgroup>
	    <thead>
	        <tr>
	            <%-- <th><spring:message code="필드:약관동의:번호" /></th> --%>
	            <%-- <th><span class="sort" sortid="1"><spring:message code="필드:약관동의:타입" /></span></th>
	            <th><span class="sort" sortid="2"><spring:message code="필드:약관동의:제목" /></span></th> --%>
	            <th><spring:message code="필드:약관동의:타입" /></th>
	            <th><spring:message code="필드:약관동의:제목" /></th>	            
	            <th>
	                <spring:message code="필드:약관동의:버전" />
	            </th>
	            <th>
	            	<spring:message code="필드:약관동의:여부" />
	            </th>
	            <th>
	                <spring:message code="필드:약관동의:동의일시" />
	            </th>
	            <th>
	                <spring:message code="필드:약관동의:수정일시" />
	            </th>
	        </tr>
	    </thead>    		
		<tbody>
		        <c:forEach var="row" items="${detail}" varStatus="i">
		            <tr>
		               <%--  <td><c:out value="${paginate.descIndex - i.index}"/></td> --%>
		                <td>
		                	<aof:code type="print" codeGroup="AGREEMENT_TYPE" defaultSelected="${row.agreement.agreementType}"/>
		                </td>
		                <td>
		                	<c:out value="${row.agreement.agreementTitle}" />
		                </td>
		                <td>
		                	<c:out value="${row.agreement.agreementVersion}" />
		                </td>
		                <td>
		                	<%-- <aof:code type="print" codeGroup="AGREEMENT_STATUS" defaultSelected="AGREEMENT_STATUS::${row.agreement.applyCheck}"/> --%>
		                	<c:choose>
		                		<c:when test="${row.agreement.applyCheck == 1}">
		                			동의
		                		</c:when>
		                		<c:when test="${row.agreement.applyCheck == 2}">
		                			미동의
		                		</c:when>
		                		<c:otherwise>
		                			미선택
		                		</c:otherwise>
		                	</c:choose>        
		                </td>
		                <td>        
		                	<aof:date datetime="${row.agreement.regApplyDtime}" />
		                </td>
		                <td>
		                		<aof:date datetime="${row.agreement.updApplyDtime}" />
		                </td>
		            </tr>
		        </c:forEach>
		        <c:if test="${empty detail}">
		            <tr>
		                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
		            </tr>
		        </c:if>
		</tbody>
	</table>
</body>
</html>