<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>

<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forParentList = null;
var forBbsList = null;
var forApplyList = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
	UI.tabs("#tabs");
	
	doSub('apply');
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forBbsList = $.action();
	forBbsList.config.formId = "FormBbsList";
	forBbsList.config.url    = "<c:url value="/univ/course/discuss/result/bbs/list/iframe.do"/>";
	forBbsList.config.target = "listFrame";
	
	forApplyList = $.action();
	forApplyList.config.formId = "FormApplyList";
	forApplyList.config.url    = "<c:url value="/univ/course/discuss/result/apply/list/iframe.do"/>";
	forApplyList.config.target = "listFrame";
    
    forParentList = $.action();
	forParentList.config.formId = "FormParentList";
	forParentList.config.url    = "<c:url value="/univ/course/discuss/result/list.do"/>";
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
 * 
 */
doSub = function(type){
	if(type == 'apply'){
		forApplyList.run();
	}else{
		forBbsList.run();
	}
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
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    <input type="hidden" name="activeElementSeq" 		value="<c:out value="${detail.discuss.activeElementSeq}"/>"/>
</form>

<form name="FormBbsList" id="FormBbsList" method="post" onsubmit="return false;">
    <input type="hidden" name="discussSeq" value="<c:out value="${detail.discuss.discussSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    <input type="hidden" name="activeElementSeq" 		value="<c:out value="${detail.discuss.activeElementSeq}"/>"/>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormBbsList" id="FormApplyList" method="post" onsubmit="return false;">
    <input type="hidden" name="discussSeq" value="<c:out value="${detail.discuss.discussSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    <input type="hidden" name="activeElementSeq" 		value="<c:out value="${detail.discuss.activeElementSeq}"/>"/>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>
	
<table class="tbl-detail">
    <colgroup>
        <col style="width:200px" />
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
            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	                <aof:date datetime="${detail.discuss.startDtime}"/>&nbsp;
	                <aof:date datetime="${detail.discuss.startDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.discuss.startDtime}" pattern="mm"/><spring:message code="글:분"/>
	                ~
	                <aof:date datetime="${detail.discuss.endDtime}"/>&nbsp;
	                <aof:date datetime="${detail.discuss.endDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.discuss.endDtime}" pattern="mm"/><spring:message code="글:분"/>
	         	</c:if>
	         	<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	         		<span><spring:message code="글:수강시작" /></span> <c:out value="${detail.discuss.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${detail.discuss.endDay}" /> <spring:message code="글:일까지" />
	         	</c:if>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:첨부파일" />
            </th>
            <td class="align-l">
                <c:forEach var="row" items="${detail.discuss.attachList}" varStatus="i">
                    <a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                </c:forEach>
                <c:if test="${empty detail.discuss.attachList}"><spring:message code="글:토론:없음" /></c:if>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:평가비율" />
            </th>
            <td class="align-l">
            	<c:out value="${detail.discuss.rate}"/> %
            </td>
        </tr>
    </tbody>
</table>

<div class="vspace"></div>
    <div class="vspace"></div>
    
    <!-- 평가 테이블 --> 
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 80px" />
		<col style="width: auto" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th class="align-c"><spring:message code="필드:과정:등급분류"/></th>
			<th class="align-c"><spring:message code="필드:과정:게시글수"/></th>
			<th class="align-c"><spring:message code="필드:과정:배점"/></th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${!empty listBoardPostEvaluate}">
			<c:forEach var="rowSub" items="${listBoardPostEvaluate}" varStatus="iSub">
				<tr>
					<c:choose>
						<c:when test="${iSub.count eq 1}">
							<th class="align-c"><spring:message code="글:과정:상"/></th>
							<td style="padding-left:30px;">
								<c:out value="${rowSub.coursePostEvaluate.fromCount}"/><spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
							</td>
							<td class="align-c">
								<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}"/><spring:message code="글:토론:점수"/>
							</td>
						</c:when>
						<c:when test="${iSub.count eq 2}">
							<th class="align-c"><spring:message code="글:과정:중"/></th>
							<td style="padding-left:30px;">
								<c:out value="${rowSub.coursePostEvaluate.fromCount}"/><spring:message code="글:과정:부터"/>&nbsp;&nbsp;
								<c:out value="${rowSub.coursePostEvaluate.toCount}"/><spring:message code="글:과정:까지"/>
							</td>
							<td class="align-c">
								<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}"/><spring:message code="글:토론:점수"/>
							</td>
						</c:when>
						<c:when test="${iSub.count eq 3}">
							<th class="align-c"><spring:message code="글:과정:하"/></th>
							<td style="padding-left:30px;">								
								<c:out value="${rowSub.coursePostEvaluate.toCount}"/><spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
							</td>
							<td class="align-c">								
								<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}"/><spring:message code="글:토론:점수"/>
							</td>
						</c:when>
					</c:choose>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${empty listBoardPostEvaluate}">
			<c:forEach var="rowSub" begin="1" end="3" varStatus="iSub">
				<tr>
					<c:choose>
						<c:when test="${rowSub eq 1}">
							<th class="align-c"><spring:message code="글:과정:상"/></th>
							<td style="padding-left:30px;">
								<c:out value="0" /><spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
							</td>
							<td class="align-c">
								<c:out value="0" /><spring:message code="글:토론:점수"/>
							</td>
						</c:when>
						<c:when test="${rowSub eq 2}">
							<th class="align-c"><spring:message code="글:과정:중"/></th>
							<td style="padding-left:30px;">
								<c:out value="0" /><spring:message code="글:과정:부터"/>&nbsp;&nbsp;
								<c:out value="0" /><spring:message code="글:과정:까지"/>
							</td>
							<td class="align-c">									
								<c:out value="0" /><spring:message code="글:토론:점수"/>
							</td>
						</c:when>
						<c:when test="${rowSub eq 3}">
							<th class="align-c"><spring:message code="글:과정:하"/></th>
							<td style="padding-left:30px;">
								<c:out value="0" /><spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
							</td>
							<td class="align-c">
								<c:out value="0" /><spring:message code="글:토론:점수"/>
							</td>
						</c:when>
					</c:choose>
				</tr>
			</c:forEach>
		</c:if>
	</tbody>
	</table>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="doParentList()" class="btn blue"><span class="mid"><spring:message code="버튼:목록" /></span></a>
		</div>
	</div>

	<div id="tabs"> 
		<ul class="ui-widget-header-tab-custom">
			<li><a href="#listFrame" 
				onclick="doSub('apply');"><spring:message code="필드:토론:토론자목록"/></a>
			</li>
			<li><a href="#listFrame" 
				onclick="doSub('bbs');"><spring:message code="필드:토론:토론게시판"/></a>
			</li>
		</ul>
		<iframe id="listFrame" name="listFrame" frameborder="no" scrolling="no" style="padding:0px; width:100%; height: 300px " onload="UT.noscrollIframe(this)"></iframe>
	</div>
	
</body>
</html>