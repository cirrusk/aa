<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"          value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>

<c:set var="attachSize" value="10"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEditPage   = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/discuss/list.do"/>";
	
	forEditPage = $.action();
	forEditPage.config.formId = "FormData";
	forEditPage.config.url    = "<c:url value="/univ/course/active/discuss/edit.do"/>"; 

};


/**
 * 목록보기
 */
doList = function(){
		forListdata.run();
};
/**
 * 상세 페이지 호출
 */
doEdit = function() {
	forEditPage.run();
};

</script>

</head>

<body>

<c:import url="srchDiscuss.jsp"></c:import>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Select Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Select Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${detail.discuss.courseActiveSeq}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_DISCUSS}"/>
</c:import>
<!-- 교과목 구성정보 Tab Area End -->

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.discuss.courseActiveSeq}"/>"/>
    <input type="hidden" name="discussSeq" value="<c:out value="${detail.discuss.discussSeq}"/>"/>
    <input type="hidden" name="postType" value="discuss" />
    <input type="hidden" name="referenceSeq" value="<c:out value="${detail.discuss.discussSeq}"/>" />
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	<div class="lybox-title mt10">
        <h4 class="section-title">
        	<spring:message code="글:토론:토론조회" />
        </h4>
    </div>	
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 140px" />
        <col style="width: auto" />
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:토론:토론주제"/>
            </th>
            <td>
               	<c:out value="${detail.discuss.discussTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:내용"/>
            </th>
            <td style="line-height:22px;">
				<aof:text type="whiteTag" value="${detail.discuss.description}"/>
			</td>
        </tr>
       	<tr>       	
			<th><spring:message code="필드:토론:첨부파일"/></th>
			<td>
				<c:forEach var="row" items="${detail.discuss.attachList}" varStatus="i">
					<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:토론:평가비율"/></th>
			<td>
				<c:out value="${detail.discuss.rate}"/>%
			</td>
		</tr>
        <tr>
            <th>
                <spring:message code="필드:토론:토론기간"/>
            </th>
            <td>
            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	            	<c:if test="${empty detail.discuss.startDtime}">
	            		<spring:message code="글:토론:토론기간설정이필요합니다" />
	            	</c:if>
	            	<c:if test="${not empty detail.discuss.startDtime}">
	            		<aof:date datetime="${detail.discuss.startDtime}"/>&nbsp;<aof:date datetime="${detail.discuss.startDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;<aof:date datetime="${detail.discuss.startDtime}" pattern="mm"/><spring:message code="글:분"/>
					 	~ <aof:date datetime="${detail.discuss.endDtime}"/>&nbsp;<aof:date datetime="${detail.discuss.endDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;<aof:date datetime="${detail.discuss.endDtime}" pattern="mm"/><spring:message code="글:분"/>
	            	</c:if>
	            </c:if>
	            <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	            	<span><spring:message code="글:수강시작" /></span> <c:out value="${detail.discuss.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${detail.discuss.endDay}" /> <spring:message code="글:일까지" />
	            </c:if>
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
  
    </form>
    
    <div class="lybox-btn">
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                <a href="javascript:void(0)" onclick="doEdit();" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>