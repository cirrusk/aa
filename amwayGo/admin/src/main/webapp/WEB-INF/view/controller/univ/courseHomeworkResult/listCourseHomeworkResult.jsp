<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"       value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"   value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE" value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>

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

<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>

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
    forDetail.config.url    = "<c:url value="/univ/course/homework/result/detail.do"/>";
	
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
	<c:import url="srchCourseHomeworkResult.jsp"/>
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
					<a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/homework/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:설정" /></span></a>
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
		            <th><spring:message code="필드:과제:과제제목" /></th>
		            <th><spring:message code="필드:과제:제출기간" /></th>
		            <th><spring:message code="필드:과제:제출미제출대상자" /></th>
		            <th><spring:message code="필드:과제:평가비율" /></th>
		            <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		            	<th><spring:message code="필드:과제응답:상태" /></th>
		            </c:if>
		        </tr>
	    	</thead>
	    	<tbody>
	    		<c:set var="minusCount" value="0"></c:set>
	    		<c:forEach var="row" items="${itemList}" varStatus="i">
	    			
	    		<c:if test="${row.courseHomework.referenceCount > 0}">
					
					<tr>
	    				<c:if test="${row.courseHomework.referenceCount > 0}">
		    				<td>
			    				<c:out value="${totalCount - minusCount}"/>
			    				<c:set var="minusCount" value="${minusCount + 1}"></c:set>
			            	</td>
	    				</c:if>
		            	
	    				<td class="align-l">
	    				
		            		<c:choose>
		            			<%-- 시험 대체 과제 --%>
			            		<c:when test="${row.courseHomework.replaceYn eq 'Y'}">
			            			<c:choose>
			            				<%-- 중간고사 대체 과제 --%>
			            				<c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
				            				<c:choose>
				            					<%-- 일반 --%>
							            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
							            			<span class="section-btn blue02"><spring:message code="필드:과제:중간고사대체과제" /></span>
							            		</c:when>
							            		<%-- 보충 --%>
							            		<c:otherwise>
							            			<span class="section-btn green"><spring:message code="필드:과제:중간고사보충과제" /></span>
							            		</c:otherwise>
							            	</c:choose>
			            				</c:when>
			            				<%-- 기말고사 대체 과제 --%>
			            				<c:otherwise>
			            					<c:choose>
				            					<%-- 일반 --%>
							            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
							            			<span class="section-btn blue02"><spring:message code="필드:과제:기말고사보충과제" /></span>
							            		</c:when>
							            		<%-- 보충 --%>
							            		<c:otherwise>
							            			<span class="section-btn green"><spring:message code="필드:과제:기말고사보충과제" /></span>
							            		</c:otherwise>
							            	</c:choose>
			            				</c:otherwise>
									</c:choose>			            		
			            		</c:when>
			            		<%-- 과제 --%>
			            		<c:otherwise>
						            <c:choose>
					            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
					            			<span class="section-btn blue02"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
					            		</c:when>
					            		<c:otherwise>
					            			<span class="section-btn green"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
					            		</c:otherwise>
					            	</c:choose>
			            		</c:otherwise>
		            		</c:choose>
		            		<div class="vspace"></div>
		                	<a href="javascript:doDetail({'homeworkSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />'});"><c:out value="${row.courseHomework.homeworkTitle}"/></a>
		                	
		                	<!-- group -->
		                	<c:if test="${row.courseHomework.referenceCount > 1}">
		                		<div class="vspace"></div>
			                	<c:choose>
			            			<%-- 시험 대체 과제 --%>
				            		<c:when test="${itemList[i.index + 1].courseHomework.replaceYn eq 'Y'}">
				            			<c:choose>
				            				<%-- 중간고사 대체 과제 --%>
				            				<c:when test="${itemList[i.index + 1].courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
					            				<c:choose>
					            					<%-- 일반 --%>
								            		<c:when test="${itemList[i.index + 1].courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
								            			<span class="section-btn blue02"><spring:message code="필드:과제:중간고사대체과제" /></span>
								            		</c:when>
								            		<%-- 보충 --%>
								            		<c:otherwise>
								            			<span class="section-btn green"><spring:message code="필드:과제:중간고사보충과제" /></span>
								            		</c:otherwise>
								            	</c:choose>
				            				</c:when>
				            				<%-- 기말고사 대체 과제 --%>
				            				<c:otherwise>
				            					<c:choose>
					            					<%-- 일반 --%>
								            		<c:when test="${itemList[i.index + 1].courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
								            			<span class="section-btn blue02"><spring:message code="필드:과제:기말고사보충과제" /></span>
								            		</c:when>
								            		<%-- 보충 --%>
								            		<c:otherwise>
								            			<span class="section-btn green"><spring:message code="필드:과제:기말고사보충과제" /></span>
								            		</c:otherwise>
								            	</c:choose>
				            				</c:otherwise>
										</c:choose>			            		
				            		</c:when>
				            		<%-- 과제 --%>
				            		<c:otherwise>
							            <c:choose>
						            		<c:when test="${itemList[i.index + 1].courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
						            			<span class="section-btn blue02"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${itemList[i.index + 1].courseHomework.basicSupplementCd}"/></span>
						            		</c:when>
						            		<c:otherwise>
						            			<span class="section-btn green"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${itemList[i.index + 1].courseHomework.basicSupplementCd}"/></span>
						            		</c:otherwise>
						            	</c:choose>
				            		</c:otherwise>
			            		</c:choose>
			            		<div class="vspace"></div>
			                	<a href="javascript:doDetail({'homeworkSeq' : '<c:out value="${itemList[i.index + 1].courseHomework.homeworkSeq}" />'});"><c:out value="${itemList[i.index + 1].courseHomework.homeworkTitle}"/></a>
		                	</c:if>
		                	
		            	</td>
		            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		    				<td class="align-l">
	
				                <spring:message code="필드:과제:1차" />
				                : 
				                <aof:date datetime="${row.courseHomework.startDtime}"/>
				                ~
				                <aof:date datetime="${row.courseHomework.endDtime}"/>
				                <div class="vspace"></div>
				                <spring:message code="필드:과제:2차" /> 
				                : 
				                <c:if test="${row.courseHomework.useYn eq 'Y'}">
					                <aof:date datetime="${row.courseHomework.start2Dtime}"/>
					                ~
					                <aof:date datetime="${row.courseHomework.end2Dtime}"/>
				                </c:if>
				                <c:if test="${row.courseHomework.useYn eq 'N'}">
					                <spring:message code="글:과제:해당없음" /> 
				                </c:if>
				            
				            	<!-- group -->
			                	<c:if test="${row.courseHomework.referenceCount > 1}">
			                		<div class="vspace"></div>
				                	<spring:message code="필드:과제:1차" />
					                : 
					                <aof:date datetime="${itemList[i.index + 1].courseHomework.startDtime}"/>
					                ~
					                <aof:date datetime="${itemList[i.index + 1].courseHomework.endDtime}"/>
					                <div class="vspace"></div>
					                <spring:message code="필드:과제:2차" /> 
					                : 
					                <c:if test="${itemList[i.index + 1].courseHomework.useYn eq 'Y'}">
						                <aof:date datetime="${itemList[i.index + 1].courseHomework.start2Dtime}"/>
						                ~
						                <aof:date datetime="${itemList[i.index + 1].courseHomework.end2Dtime}"/>
					                </c:if>
					                <c:if test="${itemList[i.index + 1].courseHomework.useYn eq 'N'}">
						                <spring:message code="글:과제:해당없음" /> 
					                </c:if>
			                	</c:if>
				                
			            	</td>
		            	</c:if>
		            	<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		            		<td>
		            			<span><spring:message code="글:수강시작" /></span> <c:out value="${row.courseHomework.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${row.courseHomework.endDay}" /> <spring:message code="글:일까지" />
		            		</td>
		            	</c:if>
	    				<td>
	    				
		            		<c:out value="${row.courseHomework.answerSubmitCount}"/>&nbsp;
		            		(<sapn style="color : red;"><c:out value="${row.courseHomework.answerScoreCount}"/></sapn>)&nbsp;
		            		|&nbsp;
		            		<c:out value="${row.summary.memberCount - row.courseHomework.answerSubmitCount}"/>&nbsp;
		            		|&nbsp;
		            		<c:out value="${row.summary.memberCount}"/>
		            		
		            		<!-- group -->
		                	<c:if test="${row.courseHomework.referenceCount > 1}">
		            			<div class="vspace mt20"></div>
		            			<c:out value="${itemList[i.index + 1].courseHomework.answerSubmitCount}"/>&nbsp;
			            		(<sapn style="color : red;"><c:out value="${itemList[i.index + 1].courseHomework.answerScoreCount}"/></sapn>)&nbsp;
			            		|&nbsp;
			            		<c:out value="${itemList[i.index + 1].summary.memberCount - itemList[i.index + 1].courseHomework.answerSubmitCount}"/>&nbsp;
			            		|&nbsp;
			            		<c:out value="${itemList[i.index + 1].summary.memberCount}"/>
		            		</c:if>
		            		
		            	</td>
	    				<td>
		            		<c:out value="${row.courseHomework.rate}"/>%
		            	</td>
		            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		    				<td>
		    					<aof:code type="print" codeGroup="HOMEWORK_STATUS" removeCodePrefix="true" selected="${row.courseHomework.homeworkStatus}"/>
				            	
				            	<!-- group -->
			                	<c:if test="${row.courseHomework.referenceCount > 1}">
			            			<div class="vspace mt20"></div>
			            			<aof:code type="print" codeGroup="HOMEWORK_STATUS" removeCodePrefix="true" selected="${itemList[i.index + 1].courseHomework.homeworkStatus}"/>
			            		</c:if>
			            	</td>
		            	</c:if>
		    		</tr>
						    		
	    		</c:if>
		    	
	    	</c:forEach>
	        <c:if test="${empty itemList}">
	            <tr>
	                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
    
    <div class="vspace"></div>
    <span>※ <spring:message code="글:과제:시험등록과제는각시험별평가비율이적용됩니다" /></span>
	
    <c:if test="${menuSystemMywork.menuId eq appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이면 --%>
        <c:import url="../include/myworkInc.jsp"></c:import>
    </c:if>
	
</body>
</html>