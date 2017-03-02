<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_WEEK_TYPE_LECTURE" value="${aoffn:code('CD.COURSE_WEEK_TYPE.LECTURE')}"/>
<c:set var="CD_COURSE_TYPE_PERIOD"       value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<c:set var="itemCount" value="0" />
    <div id="listElement">
    <c:forEach var="row" items="${list}" varStatus="i">
        <div class="week-type <c:if test="${!i.first}">mt20</c:if>">
        <table class="tbl-detail-row"><!-- tbl-detail-row -->
            <colgroup>
                <col style="width:80px;" />
                <col style="width:auto;" />
                <col style="width:200px;" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="필드:주차:주차" /></th>
                    <th><spring:message code="필드:주차:주차제목" /></th>
                    <th><spring:message code="필드:주차:학습기간" /></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <c:out value="${row.element.sortOrder}" />
                        <spring:message code="필드:주차:주차" />
                    </td>
                    <td class="align-l">
                        [<aof:code type="print" codeGroup="COURSE_WEEK_TYPE" selected="${row.element.courseWeekTypeCd}" defaultSelected="${CD_COURSE_WEEK_TYPE_LECTURE}" />]
                        <c:out value="${row.element.activeElementTitle}" /> 
                    </td>
                    <td>
                    	<c:choose>
		               		<c:when test="${not empty courseActive.courseTypeCd && courseActive.courseTypeCd ne CD_COURSE_TYPE_PERIOD}">
	               				<c:out value="${row.element.startDay}"/><spring:message code="글:일부터"/> ~
	            				<c:out value="${row.element.endDay}"/><spring:message code="글:일까지"/>
		               		</c:when>
		               		<c:otherwise>
		               			<aof:date datetime="${row.element.startDtime}"/>
	                        	~
	                        	<aof:date datetime="${row.element.endDtime}"/>
		               		</c:otherwise>
		               	</c:choose>
                    </td>
                </tr>
            </tbody>
        </table>
        <c:if test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_LECTURE and !empty row.element.referenceSeq}">
        <table id="itemTable" class="tbl-detail-row add">
            <colgroup>
                <col style="width:12%;" />
                <col style="width:auto;" />
                <col style="width:33%;" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="필드:주차:교시강" /></th>
                    <th><spring:message code="필드:주차:교시강제목" /></th>
                    <th><spring:message code="필드:주차:학습보조자료" /></th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="row1" items="${row.element.itemList}" varStatus="i">
                <tr>
                    <td><c:out value="${row1.item.sortOrder+1}" /><spring:message code="필드:주차:교시" /></td>
                    <td class="align-l"><c:out value="${row1.item.title}"/></td>
                    <td class="align-l">
                        <div id="uploader-<c:out value="${itemCount}"/>" class="uploader">
                            <c:if test="${!empty row1.activeItem.attachList}">
                                <c:forEach var="row" items="${row1.activeItem.attachList}" varStatus="i">
                                    <c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                                </c:forEach>
                            </c:if>
                        </div>
                    </td>
                </tr>
                <c:set var="itemCount" value="${itemCount + 1}" />
            </c:forEach>
            </tbody>
        </table>
        </c:if>
        </div>
    </c:forEach>
    <c:if test="${empty list}">
    	<table class="tbl-detail-row"><!-- tbl-detail-row -->
            <colgroup>
                <col style="width:80px;" />
                <col style="width:auto;" />
                <col style="width:200px;" />
            </colgroup>
            <thead>
                <tr>
                    <th><spring:message code="필드:주차:주차" /></th>
                    <th><spring:message code="필드:주차:주차제목" /></th>
                    <th><spring:message code="필드:주차:학습기간" /></th>
                </tr>
            </thead>
            <tbody>
            	<tr>
            		<td colspan="3">
            			<spring:message code="글:데이터가없습니다" />
            		</td>
            	</tr>
            </tbody>
           </table>
    </c:if>
    </div>