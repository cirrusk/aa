<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_ORGANIZATION" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ORGANIZATION')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EXAM"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_OFFLINE"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.OFFLINE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_QUIZ"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.QUIZ')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_JOIN"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.JOIN')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ONLINE"       value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ONLINE')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"           value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_ATTEND_TYPE_001"                  value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002"                  value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003"                  value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>
<c:set var="CD_ATTEND_TYPE_004"                  value="${aoffn:code('CD.ATTEND_TYPE.004')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_EXAM"            value="${aoffn:code('CD.COURSE_WEEK_TYPE.EXAM')}"/>


<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="srchKeyBefore"><c:out value="${CD_ATTEND_TYPE_001}"/>=<spring:message code="필드:출석결과:출석"/>,<c:out value="${CD_ATTEND_TYPE_003}"/>=<spring:message code="필드:출석결과:지각"/>,<c:out value="${CD_ATTEND_TYPE_002}"/>=<spring:message code="필드:출석결과:결석"/></c:set>
<c:set var="srchKeyAfter"><c:out value="${CD_ATTEND_TYPE_001}"/>=<spring:message code="필드:출석결과:출석"/>,<c:out value="${CD_ATTEND_TYPE_003}"/>=<spring:message code="글:과정:수강중"/>,<c:out value="${CD_ATTEND_TYPE_002}"/>=<spring:message code="글:과정:수강전"/></c:set>
<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
	
doInitializeLocal = function() {
	
};

/*
 * 세부성적 상세보기
 */
doOpen = function(tableId){
	var table =	jQuery("#"+tableId);
	 if(table.css("display") != "none"){
	 	table.hide();
	 } else {
		 table.show();
	 }
};
</script>
</head>

<body>
<c:set var="onlineEvaluateScore" value="0"/>
<c:set var="organizationEvaluateScore" value="0"/>
<c:set var="homeworkEvaluateScore" value="0"/>
<c:set var="teamprojectEvaluateScore" value="0"/>
<c:set var="discussEvaluateScore" value="0"/>
<c:set var="quizEvaluateScore" value="0"/>
<c:set var="joinEvaluateScore" value="0"/>
<c:set var="offlineEvaluateScore" value="0"/>
<c:set var="examEvaluateScore" value="0"/>
<c:forEach var="row" items="${listActiveEvaluate}" varStatus="i">
	<c:choose>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ONLINE}">
			<c:set var="onlineEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ORGANIZATION}">
			<c:set var="organizationEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_HOMEWORK}">
			<c:set var="homeworkEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}">
			<c:set var="teamprojectEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_DISCUSS}">
			<c:set var="discussEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_QUIZ}">
			<c:set var="quizEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_JOIN}">
			<c:set var="joinEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_OFFLINE}">
			<c:set var="offlineEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
		<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_EXAM}">
			<c:set var="examEvaluateScore" value="${row.evaluate.score}"/>
		</c:when>
	</c:choose>
</c:forEach>
<c:set var="avgProgressMeasure" value="0" />
<c:set var="progressScore" value="0" />

<div class="lybox-title"><h4 class="section-title"><spring:message code="글:성적관리:수강자정보" /></h4></div>
<table class="tbl-detail">
    <colgroup> 
        <col width="25%" /> 
        <col width="25%" /> 
        <col width="25%" /> 
        <col width="25%" /> 
    </colgroup> 
    <tbody> 
        <tr> 
			<th><spring:message code="필드:성적관리:이름" /></th> 
			<th><spring:message code="필드:성적관리:아이디" /></th> 
			<th><spring:message code="필드:성적관리:학과" /></th> 
			<th><spring:message code="필드:성적관리:학년" /></th> 
        </tr>
        <tr>
			<td><c:out value="${detail.member.memberName }" /></td>
			<td><c:out value="${detail.member.memberId }" /></td>
			<td><c:out value="${detail.category.categoryName }" /></td>
			<td><c:out value="${detail.member.studentYear }" /></td>
        </tr>
        <tr>
			<th><spring:message code="필드:성적관리:가산점" /></th> 
			<th><spring:message code="필드:성적관리:최종점수" /></th> 
			<th colspan="2"><spring:message code="필드:성적관리:수료" /></th> 
        </tr>
        <tr> 
			<td><c:out value="${detail.apply.addScore }" default="0" /><spring:message code="글:성적관리:점" /></td>
			<td><c:out value="${detail.apply.finalScore }"  /></td>
			<td colspan="2"><aof:code type="print" codeGroup="COMPLETE_YN" selected="${detail.apply.completionYn }" removeCodePrefix="true" /></td>
        </tr>
    </tbody> 
</table>
<div class="vspace"></div>

<div class="lybox-title"><h4 class="section-title"><spring:message code="글:성적관리:세부성적" /></h4></div>
<table class="tbl-detail">
    <colgroup> 
        <col width="20%" /> 
        <col width="20%" /> 
        <col width="20%" /> 
        <col width="20%" /> 
        <col width="20%" /> 
    </colgroup> 
    <tbody> 
        <tr> 
			<th><spring:message code="필드:성적관리:구성항목" /></th> 
			<th><spring:message code="필드:성적관리:평가비율" /></th> 
			<th><spring:message code="필드:성적관리:결과" /></th> 
			<th><spring:message code="필드:성적관리:취득점수" /></th> 
			<th><spring:message code="필드:성적관리:환산점수" /></th> 
        </tr>
        <c:set var="takeSum" value="0" />
        <c:set var="finalSum" value="0" />
        <c:set var="offlineAttendCnt" value="0" />
        <c:forEach var="row" items="${detailList}" varStatus="i" >
        <c:set var="score" />
        <tr>
        	<td><aof:code type="print" codeGroup="COURSE_ELEMENT_TYPE" selected="${row.evaluate.evaluateTypeCd }" /> </td> 
        	<td><c:out value="${row.evaluate.score }"/></td> 
        	<td>
        		<c:if test="${row.evaluate.evaluateTypeCd ne CD_COURSE_ELEMENT_TYPE_ONLINE and row.evaluate.evaluateTypeCd ne CD_COURSE_ELEMENT_TYPE_ORGANIZATION and row.evaluate.evaluateTypeCd ne CD_COURSE_ELEMENT_TYPE_JOIN and row.evaluate.evaluateTypeCd ne CD_COURSE_ELEMENT_TYPE_OFFLINE }">
        			<c:out value="${row.applyElement.takeCount }"/> / <c:out value="${row.element.setCount }"/>
        		</c:if>
        		<c:if test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ORGANIZATION}">
        			<c:set var="avgProgressMeasure" value="${row.element.totalProgressMeasure }" />
        			<aof:number value="${row.element.totalProgressMeasure }" pattern="#,###.#" />
        		</c:if>
        		<c:if test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ONLINE}">
        			<c:out value="${row.element.onlineAttendTypeCnt }" /> / <c:out value="${row.element.onlineAttendCnt }" />
        		</c:if>
        		<c:if test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_OFFLINE }">
        			<c:out value="${row.element.offlineAttendTypeCnt }" default="0" /> / <c:out value="${row.element.offlineAttendCnt }" default="0" /><c:set var="offlineAttendCnt" value="${row.element.offlineAttendCnt }" />
        		</c:if>
        	</td> 
        	<td>
        		<c:choose>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ONLINE }">
        				<c:set var="score" value="${row.apply.onAttendScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ORGANIZATION }">
        				<c:set var="score" value="${row.apply.progressScore }" />
        				<c:set var="progressScore" value="${row.apply.progressScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_HOMEWORK }">
        				<c:set var="score" value="${row.apply.homeworkScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_TEAMPROJECT }">
        				<c:set var="score" value="${row.apply.teamprojectScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_DISCUSS }">
        				<c:set var="score" value="${row.apply.discussScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_QUIZ }">
        				<c:set var="score" value="${row.apply.quizScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_JOIN }">
        				<c:set var="score" value="${row.apply.joinScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_OFFLINE }">
        				<c:set var="score" value="${row.apply.onAttendScore }" />
        			</c:when>
        			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_EXAM }">
        				<c:set var="score" value="${row.apply.examScore }" />
        			</c:when>
        		</c:choose>
        		<c:out value="${score * 100 / row.evaluate.score }"/>
        		<c:set var="takeSum" value="${takeSum + (score * 100 / row.evaluate.score) }" />
        	</td> 
        	<td>
        		<c:out value="${score  }"/>
        		<c:set var="finalSum" value="${finalSum + score }" />
        	</td> 
        </tr>
        </c:forEach>
        <tr>
        	<th><spring:message code="필드:성적관리:총점" /></th>
        	<th></th>
        	<th></th>
        	<th><c:out value="${takeSum }" /><spring:message code="글:성적관리:점" /></th>
        	<th><c:out value="${finalSum }" /><spring:message code="글:성적관리:점" /></th>
        </tr>
    </tbody> 
</table>
<div class="vspace"></div>
<div class="lybox-title"><h4 class="section-title"><spring:message code="글:성적관리:항목별세부성적" /></h4></div>

<c:if test="${onlineEvaluateScore > 0 }">
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:온라인출석" /></h4> 
		<div class="right"> 
			<a href="javascript:void(0);" onclick="doOpen('onlineTable')" class="btn gray"><span class="small"><spring:message code="버튼:성적관리:상세" /></span></a> 
		</div> 
	</div> 
	<table id="onlineTable" class="tbl-list" style="display: none;">
		<colgroup>
			<col style="width: 70px;" />
			<col style="width: auto;" />
			<col style="width: 70px;" />
			<col style="width: 70;" />
			<col style="width: 70px;" />
			<col style="width: 120px;" />
			<col style="width: 80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:출석결과:주차" /></th>
				<th><spring:message code="필드:출석결과:주차제목" /></th>
				<th><spring:message code="필드:출석결과:교시강" /></th>
				<th><spring:message code="필드:출석결과:강제목" /></th>
				<th><spring:message code="필드:출석결과:학습횟수" /></th>
				<th><spring:message code="필드:출석결과:학습시간" /></th>
				<th><spring:message code="필드:출석결과:출결" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${itemList}" varStatus="i">
			<tr>
				<td rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
					<c:out value="${row.element.sortOrder}"/> <spring:message code="필드:출석결과:주차" />
				</td>
				<td class="align-l" rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
					<c:out value="${row.element.activeElementTitle}"/>
				</td>
				<c:if test="${fn:length(row.itemResultList) eq 0}">
					<td colspan="5">-</td>
				</c:if>
				<c:forEach var="rowSub" items="${row.itemResultList}" varStatus="j"><!-- 강 리스트 -->
					<c:if test="${j.count ne 1}">
					<tr>
					</c:if>				
						<td><c:out value="${rowSub.item.sortOrder+1}"/></td>
						<td class="align-l">
							<a href="javascript:doDetailWeek({'referenceSeq' : '<c:out value="${row.element.referenceSeq}" />','sortOrder' : '<c:out value="${rowSub.item.sortOrder}"/>'});"><c:out value="${rowSub.item.title}"/></a>
						</td>
						<td><c:out value="${rowSub.learnerDatamodel.attempt}"/></td>
						<td>
							<c:choose>
								<c:when test="${0 < rowSub.learnerDatamodel.sessionTime}">
									<c:set var="hh" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime / (60 * 60 * 1000))}"/>
									<c:set var="mm" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
									<c:set var="ss" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 1000) / 1000 )}"/>
									<c:choose>
										<c:when test="${10 <= hh}">
											<c:out value="${hh}"/>:
										</c:when>
										<c:otherwise>
											0<c:out value="${hh}"/>:
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${10 <= mm}">
											<c:out value="${mm}"/>:
										</c:when>
										<c:otherwise>
											0<c:out value="${mm}"/>:
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${10 <= ss}">
											<c:out value="${ss}"/>
										</c:when>
										<c:otherwise>
											0<c:out value="${ss}"/>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									00:00:00
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<input type="hidden" name="oldAttendTypeCds" value="${rowSub.attend.attendTypeCd}"/>
							<c:if test="${appToday > row.element.endDtime}"> 
								<span class="profressPrint">
									<c:choose>
										<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
											<spring:message code="필드:출석결과:출석" />
										</c:when>
										<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
											<spring:message code="필드:출석결과:결석" />
										</c:when>
										<c:otherwise>
											<spring:message code="필드:출석결과:지각" />
										</c:otherwise>
									</c:choose>
								</span>
								<span class="profressText" style="display: none;">
									<select name="attendTypeCds" class="select">
										<aof:code type="option" codeGroup="${srchKeyBefore}" selected="${rowSub.attend.attendTypeCd}"/>
									</select>
								</span>
							</c:if>
							<c:if test="${appToday <= row.element.endDtime}">
								<span class="profressPrint">
									<c:choose>
										<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
											<spring:message code="필드:출석결과:출석" />
										</c:when>
										<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
											<spring:message code="글:과정:수강전"/>
										</c:when>
										<c:otherwise>
											<spring:message code="글:과정:수강중"/>
										</c:otherwise>
									</c:choose>
								</span>
								<span class="profressText" style="display: none;">
									<select name="attendTypeCds" class="select">
										<aof:code type="option" codeGroup="${srchKeyAfter}" selected="${rowSub.attend.attendTypeCd}"/>
									</select>
								</span>
							</c:if>
						</td>
					</tr>
				</c:forEach>
		</c:forEach>
		</tbody>
	</table>
	<table class="tbl-detail">
	    <colgroup> 
	        <col width="25%" /> 
	        <col width="25%" /> 
	        <col width="25%" /> 
	        <col width="25%" /> 
	    </colgroup> 
	    <tbody> 
	        <tr> 
				<th><spring:message code="필드:성적관리:출석" /></th> 
				<th><spring:message code="필드:성적관리:지각" /></th> 
				<th><spring:message code="필드:성적관리:결석" /></th> 
				<th><spring:message code="필드:성적관리:취득점수" /></th> 
	        </tr>
	    <c:forEach var="row" items="${detailOnline.itemList }" varStatus="i">
	        <tr> 
				<td><c:out value="${row.applyAttend.attendTypeAttendCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendTypePerceptionCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendTypeAbsenceCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendScore }" /></td>
	        </tr>
		</c:forEach>
	    </tbody> 
	</table>
</c:if>

<c:if test="${organizationEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:진도" /></h4> 
		<div class="right"> 
			<a href="javascript:void(0);" onclick="doOpen('organizationTable')" class="btn gray"><span class="small"><spring:message code="버튼:성적관리:상세" /></span></a> 
		</div> 
	</div>
	<table id="organizationTable" class="tbl-list" style="display: none;">
		<colgroup>
			<col style="width: 70px;" />
			<col style="width: auto;" />
			<col style="width: 70px;" />
			<col style="width: auto;" />
			<col style="width: 70px;" />
			<col style="width: 70px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:출석결과:주차" /></th>
				<th><spring:message code="필드:출석결과:주차제목" /></th>
				<th><spring:message code="필드:출석결과:교시강" /></th>
				<th><spring:message code="필드:출석결과:강제목" /></th>
				<th><spring:message code="필드:출석결과:학습횟수" /></th>
				<th><spring:message code="필드:출석결과:진도율" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${itemList}" varStatus="i">
			<tr>
				<td rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
					<c:out value="${row.element.sortOrder}"/> <spring:message code="필드:출석결과:주차" />
				</td>
				<td class="align-l" rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
					<c:out value="${row.element.activeElementTitle}"/>
				</td>
				<c:if test="${fn:length(row.itemResultList) eq 0}">
					<td colspan="4">-</td>
				</c:if>
				<c:forEach var="rowSub" items="${row.itemResultList}" varStatus="j"><!-- 강 리스트 -->
					<c:if test="${j.count ne 1}">
					<tr>
					</c:if>				
						<td><c:out value="${rowSub.item.sortOrder+1}"/></td>
						<td class="align-l">
							<a href="javascript:doDetailWeek({'referenceSeq' : '<c:out value="${row.element.referenceSeq}" />','sortOrder' : '<c:out value="${rowSub.item.sortOrder}"/>'});"><c:out value="${rowSub.item.title}"/></a>
						</td>
						<td><c:out value="${rowSub.learnerDatamodel.attempt}"/></td>
						<td>
							<span class="profressPrint">
								<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>%
							</span>
							<span class="profressText" style="display: none;">
								<input type="text" name="progressMeasures" value="<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>" size="5" class="align-r">%
							</span>
							<input type="hidden" name="oldProgressMeasures" value="<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>">
							<input type="hidden" name="organizationSeqs" 	value="${rowSub.item.organizationSeq}" />
							<input type="hidden" name="itemSeqs" 			value="${rowSub.item.itemSeq}" />
							<input type="hidden" name="activeElementSeqs" 	value="${row.element.activeElementSeq}" />
						</td>
					</tr>
				</c:forEach>
		</c:forEach>
		</tbody>
	</table>
	<table class="tbl-detail">
	    <colgroup> 
	        <col width="80%" /> 
	        <col width="20%" /> 
	    </colgroup> 
	    <tbody> 
	        <tr> 
				<th><spring:message code="필드:성적관리:평균진도율" /></th> 
				<th><spring:message code="필드:성적관리:취득점수" /></th> 
	        </tr>
	        <tr>
				<td><aof:number value="${avgProgressMeasure }" pattern="#,###.#" />%</td>
				<td><c:out value="${progressScore }" /></td>
	        </tr>
	    </tbody> 
	</table>
</c:if>

<c:if test="${homeworkEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:과제" /></h4> 
	</div>
	<table class="tbl-list">
		<colgroup>
			<col style="width: 90px;" />
			<col style="width: auto;" />
			<col style="width: 120px;" />
			<col style="width: 80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:성적관리:구분" /></th>
				<th><spring:message code="필드:성적관리:제목" /></th>
				<th><spring:message code="필드:성적관리:제출일" /></th>
				<th><spring:message code="필드:성적관리:취득점수" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${applyElementList}" varStatus="i">
			<c:if test="${row.activeElement.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_HOMEWORK }">
			<tr>
				<td>
					<c:choose>
						<c:when test="${row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC }">
							<spring:message code="필드:성적관리:일반" />
						</c:when>
						<c:when test="${row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT }">
							<spring:message code="필드:성적관리:보충" />
						</c:when>
					</c:choose>
				</td>
				<td><c:out value="${row.activeElement.activeElementTitle }" /></td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.regDtime }">
							-
						</c:when>
						<c:otherwise>
							<aof:date datetime="${row.applyElement.regDtime }" />	
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.evaluateScore }">
							-
						</c:when>
						<c:otherwise>
							<aof:number value="${row.applyElement.evaluateScore }" pattern="#,###.#" /><spring:message code="글:성적관리:점" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
</c:if>

<c:if test="${teamprojectEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:팀프로젝트" /></h4> 
	</div>
	<table class="tbl-list">
		<colgroup>
			<col style="width: auto;" />
			<col style="width: 180px;" />
			<col style="width: 80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:성적관리:제목" /></th>
				<th><spring:message code="필드:성적관리:프로젝트기간" /></th>
				<th><spring:message code="필드:성적관리:취득점수" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${applyElementList}" varStatus="i">
			<c:if test="${row.activeElement.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_TEAMPROJECT }">
			<tr>
				<td><c:out value="${row.activeElement.activeElementTitle }" /></td>
				<td>
					<aof:date datetime="${row.activeElement.startDtime }" /> ~ <aof:date datetime="${row.activeElement.endDtime }" />	
				</td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.evaluateScore }">
							-
						</c:when>
						<c:otherwise>
							<aof:number value="${row.applyElement.evaluateScore }" pattern="#,###.#" /><spring:message code="글:성적관리:점" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
</c:if>

<c:if test="${discussEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:토론" /></h4> 
	</div>
	<table class="tbl-list">
		<colgroup>
			<col style="width: auto;" />
			<col style="width: 180px;" />
			<col style="width: 80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:성적관리:제목" /></th>
				<th><spring:message code="필드:성적관리:토론기간" /></th>
				<th><spring:message code="필드:성적관리:취득점수" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${applyElementList}" varStatus="i">
			<c:if test="${row.activeElement.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_DISCUSS }">
			<tr>
				<td><c:out value="${row.activeElement.activeElementTitle }" /></td>
				<td>
					<aof:date datetime="${row.activeElement.startDtime }" /> ~ <aof:date datetime="${row.activeElement.endDtime }" />	
				</td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.evaluateScore }">
							-
						</c:when>
						<c:otherwise>
							<aof:number value="${row.applyElement.evaluateScore }" pattern="#,###.#" /><spring:message code="글:성적관리:점" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
</c:if>

<c:if test="${quizEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:퀴즈" /></h4> 
	</div>
	<table class="tbl-list">
		<colgroup>
			<col style="width: auto;" />
			<col style="width: 120px;" />
			<col style="width: 80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:성적관리:제목" /></th>
				<th><spring:message code="필드:성적관리:응시일" /></th>
				<th><spring:message code="필드:성적관리:취득점수" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${applyElementList}" varStatus="i">
			<c:if test="${row.activeElement.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_QUIZ }">
			<tr>
				<td><c:out value="${row.activeElement.activeElementTitle }" /></td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.regDtime }">
							-
						</c:when>
						<c:otherwise>
							<aof:date datetime="${row.applyElement.regDtime }" />	
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.evaluateScore }">
							-
						</c:when>
						<c:otherwise>
							<aof:number value="${row.applyElement.evaluateScore }" pattern="#,###.#" /><spring:message code="글:성적관리:점" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
</c:if>

<c:if test="${offlineEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:오프라인출석" /></h4> 
		<div class="right"> 
			<a href="javascript:void(0);" onclick="doOpen('offlineTable')" class="btn gray"><span class="small"><spring:message code="버튼:성적관리:상세" /></span></a> 
		</div> 
	</div> 
	<aof:code type="set" var="codeGroupAttendType" codeGroup="ATTEND_TYPE" except="${CD_ATTEND_TYPE_004}"/>
	<table id="offlineTable" class="tbl-list" style="display: none;">
		<colgroup>
			<col style="width: 30px" />
			<col style="width: 30px" />
			<c:forEach var="row" items="${codeGroupAttendType}" varStatus="i">
				<col style="width: 30px" />
			</c:forEach>
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:주차:주차" /></th>
				<th><spring:message code="필드:오프라인출석결과:수업횟수" /></span></th>
				<c:forEach var="row" items="${codeGroupAttendType}" varStatus="i">
					<th><c:out value="${row.codeName}"/></th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="row" items="${listElement}" varStatus="i">
			<c:set var="activeElementSeq" value="${row.element.activeElementSeq}"/>
			<c:set var="subNum" value="${row.element.offlineLessonCount}"></c:set>  
				<c:forEach begin="1" end="${subNum}" step="1" varStatus="j">
				<tr>
					<c:set var="offlineLessonKey"  value="${activeElementSeq}_${j.index}"/>
					<c:if test="${j.index == 1}" >
						<td <c:if test="${j.index == 1}" >rowspan="${subNum}"</c:if>><c:out value="${row.element.sortOrder}" /><spring:message code="필드:주차:주차" /></td>
					</c:if>
					<td><c:out value="${j.index}" /><spring:message code="글:오프라인출석결과:회" /></td>
					<c:forEach var="codeRow" items="${codeGroupAttendType}" varStatus="i">
						<td>
							<c:if test="${applyAttendHash[offlineLessonKey] eq codeRow.code}">
								O
							</c:if>
						</td>
					</c:forEach>			
				</tr>
				</c:forEach>		
			</c:forEach>		
		</tbody>
	</table>
	<table class="tbl-detail">
	    <colgroup> 
	        <col width="15%" /> 
	        <col width="15%" /> 
	        <col width="15%" /> 
	        <col width="15%" /> 
	        <col width="15%" /> 
	        <col width="25%" /> 
	    </colgroup> 
	    <tbody> 
	        <tr> 
				<th><spring:message code="필드:성적관리:총수업횟수" /></th>
				<th><spring:message code="필드:성적관리:출석" /></th>
				<th><spring:message code="필드:성적관리:지각" /></th>
				<th><spring:message code="필드:성적관리:결석" /></th>
				<th><spring:message code="필드:성적관리:공결" /></th>
				<th><spring:message code="필드:성적관리:취득점수" /></th>
	        </tr>
	    <c:forEach var="row" items="${detailOffline }" varStatus="i">
	        <tr> 
				<td><c:out value="${offlineAttendCnt}"/></td>
				<td><c:out value="${row.applyAttend.attendTypeAttendCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendTypePerceptionCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendTypeAbsenceCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendTypeExcuseCnt }" /></td>
				<td><c:out value="${row.applyAttend.attendScore }" /></td>
	        </tr>
		</c:forEach>
	    </tbody> 
	</table>
</c:if>

<c:if test="${examEvaluateScore > 0 }">
	<div class="vspace"></div>
	<div class="lybox-tbl"> 
		<h4 class="title"><spring:message code="필드:성적관리:시험" /></h4> 
	</div>
	<table class="tbl-list">
		<colgroup>
			<col style="width: 90px;" />
			<col style="width: auto;" />
			<col style="width: 120px;" />
			<col style="width: 80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:성적관리:구분" /></th>
				<th><spring:message code="필드:성적관리:제목" /></th>
				<th><spring:message code="필드:성적관리:응시일" />(<spring:message code="필드:성적관리:제출일" />)</th>
				<th><spring:message code="필드:성적관리:취득점수" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${applyElementList}" varStatus="i">
			<c:if test="${row.activeElement.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_EXAM }">
			<tr>
				<td>
					<c:choose>
						<c:when test="${row.activeElement.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_EXAM and row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC }">
							<aof:code type="print" codeGroup="COURSE_ELEMENT_TYPE" selected="${row.activeElement.referenceTypeCd }" />
						</c:when>
						<c:when test="${row.activeElement.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_EXAM and row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT }">
							<spring:message code="필드:성적관리:보충시험" />
						</c:when>
					</c:choose>
				</td>
				<td><c:out value="${row.activeElement.activeElementTitle }" /></td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.regDtime }">
							-
						</c:when>
						<c:otherwise>
							<aof:date datetime="${row.applyElement.regDtime }" />	
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${empty row.applyElement.evaluateScore }">
							-
						</c:when>
						<c:otherwise>
							<aof:number value="${row.applyElement.evaluateScore }" pattern="#,###.#" /><spring:message code="글:성적관리:점" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
</c:if>
<div class="vspace"></div>

</body>
</html>