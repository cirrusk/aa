<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"           value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>

<c:set var="attachSize" value="10"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit        = null;
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
	forListdata.config.url    = "<c:url value="/univ/course/active/homework/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/course/active/homework/edit.do"/>";
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

doEdit = function() {
	forEdit.run();
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

<c:import url="srchHomework.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_HOMEWORK}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">

	<div class="lybox-title"><!-- lybox-title -->
	    <h4 class="section-title"><spring:message code="필드:과제:과제조회" /></h4>
	</div>
	
	 <table class="tbl-detail">
	 <colgroup>
	     <col style="width: 140px" />
	     <col/>
	 </colgroup>
	 <tbody>
	     <tr>
	         <th>
	             <spring:message code="필드:과제:온오프라인"/>
	         </th>
	         <td>
	             <aof:code name="onoffCd" type="print" codeGroup="ONOFF_TYPE" selected="${detail.courseHomework.onoffCd}" ></aof:code>
	         </td>
	     </tr>
	     <tr>
	         <th>
	             <spring:message code="필드:과제:대상자"/>
	         </th>
	         <td>
	             <c:out value="${detail.courseHomework.targetCount}"/>&nbsp;<spring:message code="글:명"/>
	         </td>
	     </tr>
	     <tr>
	         <th>
	             <spring:message code="필드:과제:과제제목"/>
	         </th>
	         <td>
	             <c:out value="${detail.courseHomework.homeworkTitle}"/>
	         </td>
	     </tr>
	     <tr>
	         <th>
	             <spring:message code="필드:과제:과제내용"/>
	         </th>
	         <td>
	             <aof:text type="whiteTag" value="${detail.courseHomework.description}"/>
	         </td>
	     </tr>
	     <c:if test="${!empty detail.courseHomework.attachList}">
			<tr>
				<th><spring:message code="필드:게시판:첨부파일"/></th>
				<td>
					<c:forEach var="row" items="${detail.courseHomework.attachList}" varStatus="i">
						<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					</c:forEach>
				</td>
			</tr>
		</c:if>
	     <tr>
	         <th>
	             <spring:message code="필드:과제:평가비율"/>
	         </th>
	         <td>
	         	<c:out value="${detail.courseHomework.rate}"/> %
	         </td>
	     </tr>
	     <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		     <tr>
		         <th>
		             <spring:message code="필드:과제:1차제출기간"/>
		         </th>
		         <td>
		         	<c:if test="${empty row.courseHomework.startDtime}">
			          	<spring:message code="글:과제:제출기간설정이필요합니다" />
			        </c:if>
				    <c:if test="${not empty row.courseHomework.startDtime}">
			         	<aof:date datetime="${detail.courseHomework.startDtime}"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="mm"/><spring:message code="글:분"/>
			         	~
			         	<aof:date datetime="${detail.courseHomework.endDtime}"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="mm"/><spring:message code="글:분"/>
		         	</c:if>
		         </td>
		     </tr>
		 </c:if>
		 <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		 	<tr>
		 		<th>
		            <spring:message code="필드:과제:제출기간"/>
		        </th>
			 	<td>
				   <span><spring:message code="글:수강시작" /></span> <c:out value="${detail.courseHomework.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${detail.courseHomework.endDay}" /> <spring:message code="글:일까지" />
				</td>
			</tr>
		 </c:if>
	     <c:if test="${detail.courseHomework.useYn eq 'Y' and not empty row.courseHomework.startDtime}">
		     <tr>
		         <th>
		             <spring:message code="필드:과제:2차제출기간"/>
		         </th>
		         <td>
		         	<aof:date datetime="${detail.courseHomework.start2Dtime}"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.start2Dtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.start2Dtime}" pattern="mm"/><spring:message code="글:분"/>
		         	~
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="mm"/><spring:message code="글:분"/>
		         	|
		         	<spring:message code="글:과제:1차대비배점"/> :
		         	<c:out value="${detail.courseHomework.rate2}"/> %
		         </td>
		     </tr>
	     </c:if>
	 </tbody>
	 </table>
	 
	    <div class="lybox-btn">
	        <div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
	                <a href="javascript:void(0)" onclick="doEdit();" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
	            </c:if>
	            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
	        </div>
	    </div>
	  </div>
	</body>
</html>