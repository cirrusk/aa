<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<!-- 오늘 날짜 가져오기 -->
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="discussStatus" value=""/><!-- 토론 상태값(DB에 없음) 대기, 진행, 종료 -->
<c:choose>
	<c:when test="${detail.discuss.startDtime <= appToday and detail.discuss.endDtime > appToday}">
		<c:set var="discussStatus" value="PROGRESS"/>
	</c:when>
	<c:when test="${detail.discuss.startDtime <= appToday and detail.discuss.endDtime < appToday}">
		<c:set var="discussStatus" value="FINISH"/>
	</c:when>
	<c:otherwise>
		<c:set var="discussStatus" value="WAIT"/>
	</c:otherwise>
</c:choose>

<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="글:토론:토론정보" />
    </h4>
</div>

<table class="tbl-detail">
    <colgroup>
        <col style="width:120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:토론:토론주제" />
            </th>
            <td class="align-l">
                <c:out value="${detail.discuss.discussTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:내용" />
            </th>
            <td class="align-l">
                <aof:text type="whiteTag" value="${detail.discuss.description}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:토론기간" />
            </th>
            <td class="align-l">
                <aof:date datetime="${detail.discuss.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
                ~
                <aof:date datetime="${detail.discuss.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
            </td>
        </tr>
        <c:if test="${not empty detail.discuss.attachList}">
	        <tr>
	            <th>
	                <spring:message code="필드:토론:첨부파일" />
	            </th>
	            <td class="align-l">
	                <c:forEach var="row" items="${detail.discuss.attachList}" varStatus="i">
	                    <a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
	                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
	                </c:forEach>
	            </td>
	        </tr>
        </c:if>
        <tr>
            <th>
                <spring:message code="필드:토론:상태" />
            </th>
            <td class="align-l">
            	<c:choose>
					<c:when test="${discussStatus eq 'PROGRESS'}">
						<spring:message code="글:토론:진행중" />
					</c:when>
					<c:when test="${discussStatus eq 'FINISH'}">
						<spring:message code="글:토론:종료" />
					</c:when>
					<c:otherwise>
						<spring:message code="글:토론:대기" />
					</c:otherwise>
				</c:choose>
            </td>
        </tr>
    </tbody>
</table>

<div class="vspace"></div>
<div class="vspace"></div>
