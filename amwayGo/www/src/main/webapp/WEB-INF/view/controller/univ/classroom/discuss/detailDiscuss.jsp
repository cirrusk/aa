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

<html decorator="classroom-layer">
<head>
<title>토론</title>
<script type="text/javascript">
var forParentList = null;
var forBbsList = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    forBbsList.run();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forBbsList = $.action();
	forBbsList.config.formId = "FormBbsList";
	forBbsList.config.url    = "<c:url value="/usr/classroom/bbs/discuss/list/iframe.do"/>";
	forBbsList.config.target = "listFrame";
    
    forParentList = $.action();
	forParentList.config.formId = "FormParentList";
	forParentList.config.url    = "<c:url value="/usr/classroom/discuss/list.do"/>";
};
/**
 * 첨부파일 다운로드
 */
doAttachDownload = function(attachSeq) {
    var action = $.action();
    action.config.formId = "FormParameters";
    action.config.url = "<c:url value="/attach/file/response.do"/>";
    jQuery("#" + action.config.formId).find(":input[name='attachSeq']").remove();
    jQuery("#" + action.config.formId).find(":input[name='module']").remove();
    var param = [];
    param.push("attachSeq=" + attachSeq);
    param.push("module=discuss");
    action.config.parameters = param.join("&");
    action.run();
};

/**
 * 토론 목록으로 이동
 */
doParentList = function(){
	forParentList.run();
};

</script>
</head>

<body>

<form name="FormParentList" id="FormParentList" method="post" onsubmit="return false;">
    <input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>"/>
</form>

<form name="FormBbsList" id="FormBbsList" method="post" onsubmit="return false;">
    <input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${courseApply.courseActiveSeq}"/>"/>
    <input type="hidden" name="discussSeq" value="<c:out value="${detail.discuss.discussSeq}"/>"/>
    <input type="hidden" name="discussStatus" value="<c:out value="${discussStatus}"/>"/>
</form>

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
                <span><aof:date datetime="${detail.discuss.startDtime}"/></span>
                <span><aof:date datetime="${detail.discuss.startDtime}" pattern="HH"/><spring:message code="글:시"/></span>
	         	<span><aof:date datetime="${detail.discuss.startDtime}" pattern="mm"/><spring:message code="글:분"/></span>
                ~
                <span><aof:date datetime="${detail.discuss.endDtime}"/></span>
                <span><aof:date datetime="${detail.discuss.endDtime}" pattern="HH"/><spring:message code="글:시"/></span>
	         	<span><aof:date datetime="${detail.discuss.endDtime}" pattern="mm"/><spring:message code="글:분"/></span>
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

<iframe id="listFrame" name="listFrame" frameborder="no" scrolling="no" style="width:100%; height: 400px " onload="UT.noscrollIframe(this); parent.doNoscrollIframeClassroom();"></iframe>
</body>
</html>