<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_LIMIT_STANDARD_YES" value="${aoffn:code('CD.LIMIT_STANDARD.YES')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata 	= null;
var forDetail		= null;
var forExamPaperResultPopup = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [3] comment  
	UI.inputComment("FormSubList");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/course/active/exampaper/result/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormSubList";
    forDetail.config.url    = "<c:url value="/univ/course/active/exampaper/result/detail.do"/>";
    
    forExamPaperResultPopup = $.action("layer");
    forExamPaperResultPopup.config.formId         = "FormExamPaper";
    forExamPaperResultPopup.config.url            = "<c:url value="/univ/course/active/exampaper/result/detail/popup.do"/>";
    forExamPaperResultPopup.config.options.width  = 900;
    forExamPaperResultPopup.config.options.height = 700;
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forDetail.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doDetail();
};
/**
 * 상세보기
 */
doDetail = function(rows) {
	var form = UT.getById(forDetail.config.formId);
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forDetail.run();
};
/**
 * 채점하기 팝업
 */
doExamPaperResultPopup = function(mapPKs) {
	// 상세화면 form을 reset한다.
    UT.getById(forExamPaperResultPopup.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forExamPaperResultPopup.config.formId);
    // 팝업 실행
	forExamPaperResultPopup.run();
}; 
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
    <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
<c:import url="srchCourseActiveExamPaperResult.jsp" />

<div class="vspace"></div>

<div id="tabContainer">
	
	<table class="tbl-detail mt10">
		<colgroup>
		<col style="width: 150px" />
		<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:시험:시험제목"/></th>
				<td>
					<c:out value="${detail.courseExamPaper.examPaperTitle}"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:응시기간"/></th>
				<td>
		         	<c:choose>
            		<c:when test="${courseType eq 'period'}">
			         	<aof:date datetime="${detail.courseActiveExamPaper.startDtime}" />&nbsp;
					    <aof:date datetime="${detail.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
		                <spring:message code="글:시험:부터" /> ~
		                <aof:date datetime="${detail.courseActiveExamPaper.endDtime}" />&nbsp;
					    <aof:date datetime="${detail.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
					    <spring:message code="글:시험:까지" />
            		</c:when>
            		<c:otherwise>
            			<spring:message code="글:수강시작"/><c:out value="${detail.courseActiveExamPaper.startDay}" /><spring:message code="글:일부터"/> ~
           				<c:out value="${detail.courseActiveExamPaper.endDay}" /><spring:message code="글:일까지"/>
            		</c:otherwise>
           		</c:choose>
		         </td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:응시기간"/></th>
				<td>
					<c:out value="${detail.courseActiveExamPaper.examTime}" />&nbsp;<spring:message code="글:분" />
				</td>
			</tr>
			<tr>
	        	<th>
	        		<spring:message code="필드:시험:제한기준"/>
	        	</th>
	        	<td>
	        		<c:choose>
	        			<c:when test="${detail.courseActiveExamPaper.limitStandardCd eq CD_LIMIT_STANDARD_YES}">
			        		<c:out value="${empty detail.courseActiveExamPaper.limitProgress ? 0 : detail.courseActiveExamPaper.limitProgress}" />%<spring:message code="글:시험:이상"/>
	        			</c:when>
	        			<c:otherwise>
	        				<aof:code type="print" codeGroup="LIMIT_STANDARD" selected="${detail.courseActiveExamPaper.limitStandardCd}" />
	        			</c:otherwise>
	        		</c:choose>
	        	</td>
        	</tr>
        	<c:if test="${!empty detail.courseActiveExamPaper.retakeScore}">
		        <tr>
		        	<th>
		                <spring:message code="필드:시험:재응시기준점수"/>
		            </th>
		            <td>
		            	<c:out value="${detail.courseActiveExamPaper.retakeScore}" />
		            </td>
		        </tr>
	        </c:if>
	        <c:if test="${!empty detail.courseActiveExamPaper.retakeCount}">
		        <tr>
		        	<th>
		                <spring:message code="필드:시험:재응시가능횟수"/>
		            </th>
		            <td>
		            	<c:out value="${detail.courseActiveExamPaper.retakeCount}" />
		            </td>
		        </tr>
	        </c:if>
			<tr>
				<th>
					<spring:message code="필드:시험:응시" />(<spring:message code="필드:시험:채점" />)|<spring:message code="필드:시험:미응시" />|<spring:message code="필드:퀴즈:대상자" />
				</th>
				<td>
           			<c:out value="${detail.courseActiveExamPaper.answerCount}" />
           			(<c:out value="${detail.courseActiveExamPaper.scoredCount}" />)&nbsp;&nbsp;|&nbsp;&nbsp;
           			<c:out value="${detail.courseActiveSummary.memberCount - detail.courseActiveExamPaper.answerCount}"/>&nbsp;&nbsp;|&nbsp;&nbsp;
           			<c:out value="${detail.courseActiveSummary.memberCount}" />
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:평가비율" /></th>
				<td>
					<c:out value="${detail.courseActiveExamPaper.rate}" />%
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:성적공개여부"/></th>
				<td>
					<aof:code type="print" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseActiveExamPaper.openYn}" removeCodePrefix="true"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:상태" /></th>
				<td>
					<c:choose>
	            		<c:when test="${appToday ge detail.courseActiveExamPaper.startDtime and appToday le detail.courseActiveExamPaper.endDtime}">
	            			<spring:message code="글:시험:진행중" />
	            		</c:when>
	            		<c:when test="${appToday gt detail.courseActiveExamPaper.endDtime}">
	            			<spring:message code="글:시험:종료" />
	            		</c:when>
	            		<c:when test="${appToday lt detail.courseActiveExamPaper.startDtime}">
	            			<spring:message code="글:시험:진행전" />
	            		</c:when>
	            	</c:choose>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="lybox-btn">
        <div class="lybox-btn-r">
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
        </div>
    </div>

<c:set var="srchKey">memberName=<spring:message code="필드:시험:이름"/>,memberId=<spring:message code="필드:시험:아이디"/></c:set>
	
	<form name="FormSubList" id="FormSubList" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="courseActiveExamPaperSeq"     value="<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>" />
				<input type="hidden" name="courseActiveSeq"     value="<c:out value="${detail.courseActiveExamPaper.courseActiveSeq}"/>" />
			
				<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
			    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
			    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
			    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
				
				<span>
					<input type="text" name="srchCategoryName" value="${condition.srchCategoryName }" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doDetail);" />
					<span class="comment"><spring:message code="글:멤버:교과목분류"/></span>
				</span>
				
				<div class="vspace"></div>
				
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doDetail);"/>
				<a href="#" onclick="doDetail()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
		
		<c:import url="/WEB-INF/view/include/perpage.jsp">
			<c:param name="onchange" value="doDetail"/>
			<c:param name="selected" value="${condition.perPage}"/>
		</c:import>
		
		<table id="listTable" class="tbl-list mt20">
			<colgroup>
				<col style="width: 40px" />
				<col style="width: 40px" />
				<col style="width: 80px" />
				<col style="width: 100px" />
				<col style="width: 100px" />
				<col style="width: 80px" />
				<col style="width: 120px" />
				<col style="width: 120px" />
				<col style="width: 70px" />
				<col style="width: 70px" />
				<col style="width: 70px" />
				<col style="width: 70px" />
				<col style="width: 100px" />
				<col style="width: 80px" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormSubList','checkkeys','checkButton','');" /></th>
					<th><spring:message code="필드:번호"/></th>
					<th><spring:message code="필드:시험:이름"/></th>
					<th><spring:message code="필드:시험:아이디"/></th>
					<th><spring:message code="필드:시험:학과"/></th>
					<th>IP</th>
					<th><spring:message code="필드:시험:시작시간"/></th>
					<th><spring:message code="필드:시험:종료시간"/></th>
					<th><spring:message code="필드:시험:객관식점수"/>(<spring:message code="글:시험:점"/>)</th>
					<th><spring:message code="필드:시험:단답형점수"/>(<spring:message code="글:시험:점"/>)</th>
					<th><spring:message code="필드:시험:서술형점수"/>(<spring:message code="글:시험:점"/>)</th>
					<th><spring:message code="필드:시험:획득점수"/>(<spring:message code="글:시험:점"/>)</th>
					<th><spring:message code="필드:시험:채점일"/></th>
					<th><spring:message code="필드:시험:상세"/></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
					<td>
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', '')">
						<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
						<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
						<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
					</td>
					<td><c:out value="${paginate.descIndex - i.index}"/></td>
					<td><c:out value="${row.member.memberName}"/></td>
					<td><c:out value="${row.member.memberId}"/></td>
					<td><c:out value="${row.category.categoryName}"/></td>
					<td>
						<c:choose>
							<c:when test="${!empty row.courseApplyElement.ip}">
								<c:out value="${row.courseApplyElement.ip}" />
							</c:when>
							<c:otherwise>
							-
							</c:otherwise>
						</c:choose>
					</td>
					<c:choose>
						<c:when test="${row.courseApplyElement.completeYn eq 'Y'}">
							<td>
								<aof:date datetime="${row.courseApplyElement.startDtime}" />&nbsp;
						    	<aof:date datetime="${row.courseApplyElement.startDtime}" pattern="HH:mm:ss"/>
							</td>
							<td>
								<aof:date datetime="${row.courseApplyElement.endDtime}" />&nbsp;
						    	<aof:date datetime="${row.courseApplyElement.endDtime}" pattern="HH:mm:ss"/>
							</td>
							<td>
								<c:out value="${empty row.courseApplyElement.choiceScore ? 0 : row.courseApplyElement.choiceScore}" />
							</td>
							<td>
								<c:out value="${empty row.courseApplyElement.shortScore ? 0 : row.courseApplyElement.shortScore}" />
							</td>
							<td>
								<c:out value="${empty row.courseApplyElement.essayScore ? 0 : row.courseApplyElement.essayScore}" />
							</td>
							<td>
								<c:out value="${empty row.courseApplyElement.takeScore ? 0 : row.courseApplyElement.takeScore}" />
							</td>
							<td>
								<c:choose>
									<c:when test="${!empty row.courseApplyElement.scoreDtime}">
										<aof:date datetime="${row.courseApplyElement.scoreDtime}" />
									</c:when>
									<c:otherwise>
									 -
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<a href="#" onclick="doExamPaperResultPopup({'courseApplySeq' : '<c:out value="${row.courseApplyElement.courseApplySeq}"/>', 'activeElementSeq' : '<c:out value="${row.courseApplyElement.activeElementSeq}"/>',scoreYn : '<c:out value="${empty row.courseActiveExamPaperTarget.scoreYn ? 'W' : row.courseActiveExamPaperTarget.scoreYn}"/>'});" class="btn black"><span class="small"><spring:message code="버튼:시험:보기"/></span></a>
							</td>
						</c:when>
						<c:otherwise>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
							<td>
								<spring:message code="필드:시험:미응시"/>
							</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="14" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			</tbody>
		</table>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r checkButtonBottom" id="checkButton"  style="display: none;">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">				
				<%--
				<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormSubList','doDetail')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateSms('FormSubList','doDetail')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormSubList','doDetail')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일" /></span></a>
				 --%>
			</c:if>
		</div>
	</div>
	
	<form name="FormExamPaper" id="FormExamPaper" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveExamPaperSeq" value="<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>" />
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActiveExamPaper.courseActiveSeq}"/>" />
		<input type="hidden" name="activeElementSeq" />
		<input type="hidden" name="courseApplySeq" />
		<input type="hidden" name="scoreYn" />
		<input type="hidden" name="callback" value="doDetail" />
	</form>
	
</div>
</body>
</html>