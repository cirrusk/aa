<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"       value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"   value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE" value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>

<c:set var="attachSize" value="10"/>
<c:choose>
	<c:when test="${empty param['exam']}">
		<html>
	</c:when>
	<c:otherwise>
		<html decorator="iframe">
	</c:otherwise>
</c:choose>
<head>
<title></title>
<script type="text/javascript">

var forListdata = null;
var forListMember = null;

initPage = function() {
	doInitializeLocal();
	
	doMemberList();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	<c:choose>
		<c:when test="${empty param['exam']}">
			forListdata.config.url    = "<c:url value="/univ/course/homework/result/list.do"/>";
		</c:when>
		<c:otherwise>
			forListdata.config.url    = "<c:url value="/univ/course/active/${param['examType']}/exampaper/result/list/iframe.do"/>";
		</c:otherwise>
	</c:choose>
	
	forListMember = $.action("submit", {formId : "FormMember"});
	forListMember.config.url	= "<c:url value="/univ/course/homework/member/list.do"/>";
	forListMember.config.target = "memberIframe";

};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 학습자 목록 보기
 */
doMemberList = function() {
	forListMember.run();
};

</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="srchCourseHomeworkResult.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<c:if test="${empty param['exam']}">
	<div class="lybox-title"><!-- lybox-title -->
	    <div class="right">
	        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
	        <c:import url="../include/commonCourseActive.jsp"></c:import>
	        <!-- 년도학기 / 개설과목 Shortcut Area End -->
	    </div>
	</div>
</c:if>

<div id="tabContainer">
	
	 <table class="tbl-detail">
	 <colgroup>
	     <col style="width: 20%" />
	     <col style="width: auto"/>
	 </colgroup>
	 <tbody>
	     <tr>
	         <th><spring:message code="필드:과제:과제유형"/></th>
	         <td>
	             <c:choose>
           			<%-- 시험 대체 과제 --%>
            		<c:when test="${detail.courseHomework.replaceYn eq 'Y'}">
            			<c:choose>
            				<%-- 중간고사 대체 과제 --%>
            				<c:when test="${detail.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
	            				<c:choose>
	            					<%-- 일반 --%>
				            		<c:when test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
				            			<span><spring:message code="필드:과제:중간고사대체과제"/></span>
				            		</c:when>
				            		<%-- 보충 --%>
				            		<c:otherwise>
				            			<span><spring:message code="필드:과제:중간고사보충과제"/></span>
				            		</c:otherwise>
				            	</c:choose>
            				</c:when>
            				<%-- 기말고사 대체 과제 --%>
            				<c:otherwise>
            					<c:choose>
	            					<%-- 일반 --%>
				            		<c:when test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
				            			<span><spring:message code="필드:과제:기말고사대체과제"/></span>
				            		</c:when>
				            		<%-- 보충 --%>
				            		<c:otherwise>
				            			<span><spring:message code="필드:과제:기말고사보충과제"/></span>
				            		</c:otherwise>
				            	</c:choose>
            				</c:otherwise>
						</c:choose>			            		
            		</c:when>
            		<%-- 과제 --%>
            		<c:otherwise>
			            <c:choose>
		            		<c:when test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<span><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${detail.courseHomework.basicSupplementCd}"/></span>
		            		</c:when>
		            		<c:otherwise>
		            			<span><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${detail.courseHomework.basicSupplementCd}"/></span>
		            		</c:otherwise>
		            	</c:choose>
            		</c:otherwise>
           		</c:choose>
	         </td>
	     </tr>	 
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
		         	<aof:date datetime="${detail.courseHomework.startDtime}"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="mm"/><spring:message code="글:분"/>
		         	~
		         	<aof:date datetime="${detail.courseHomework.endDtime}"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="mm"/><spring:message code="글:분"/>
		         </td>
		     </tr>
		     <c:if test="${detail.courseHomework.useYn eq 'Y'}">
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
			         	<c:out value="${detail.courseHomework.rate2}"/>%
			         </td>
			     </tr>
			 </c:if>    
		 </c:if>
		 <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		 	<tr>
		 		<th>
		            <spring:message code="필드:과제:제출기간"/>
		        </th>
		 		<td><span><spring:message code="글:수강시작" /></span> <c:out value="${detail.courseHomework.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${detail.courseHomework.endDay}" /> <spring:message code="글:일까지" /></td>
		 	</tr>
		 </c:if>
	     <tr>
	     	<th><spring:message code="필드:과제:제출미제출대상자"/></th>
	     	<td>
    		        <c:out value="${detail.courseHomework.answerSubmitCount}"/>&nbsp;
           		(<c:out value="${detail.courseHomework.answerScoreCount}"/>)&nbsp;
           		|&nbsp;
           		<c:out value="${detail.summary.memberCount - detail.courseHomework.answerSubmitCount}"/>&nbsp;
           		|&nbsp;
           		<c:out value="${detail.summary.memberCount}"/>
	     	</td>
	     </tr>
	     <tr>
	     	<th><spring:message code="필드:과제:배점비율"/></th>
	     	<td>
	     		<c:out value="${detail.courseHomework.rate}"/>%
	     	</td>
	     </tr>
	     <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		     <tr>
		     	<th><spring:message code="필드:과제응답:상태"/></th>
		     	<td>
		     		<aof:code type="print" codeGroup="HOMEWORK_STATUS" removeCodePrefix="true" selected="${detail.courseHomework.homeworkStatus}"/>
		     	</td>
		     </tr>		   
	     </c:if>  
	 </tbody>
	 </table>
	 
	<div class="lybox-btn">
		<div class="lybox-btn-r">
	    	<a href="javascript:void(0);" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
	   	</div>
	</div>
</div>
	  
<div class="lybox-title"><!-- lybox-title -->
	<h4 class="section-title"><spring:message code="필드:과제:수강자목록"/></h4>
</div>

<iframe name="memberIframe" id="memberIframe" frameborder="0" width="100%" scrolling="no" style="height: 600px;"></iframe>


</body>
</html>