<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE"            value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_TYPE_ALWAYS"              value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_PLAN"        value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.PLAN')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EVALUATE"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EVALUATE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EXAM"        value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"   value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_OFFLINE"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.OFFLINE')}"/>

<html decorator="<c:out value="${decorator}"/>">
<head>
<title></title>
<script type="text/javascript">
var forListdata   = null;
var forUpdate     = null;
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
	forListdata.config.url    = "<c:url value="/univ/course/active/evaluate/edit.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/evaluate/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	setValidate();
};

/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};

/**
 * 수정
 */
doUpdate = function() {
	forUpdate.run();
};

setValidate = function() {
	forUpdate.validator.set({
        title : "<spring:message code="필드:평가기준:평가비율"/>",
        name : "scores",
        data : ["number"],
        check : {
			maxlength : 3
		}
    });
	forUpdate.validator.set({
        title : "<spring:message code="필드:평가기준:과락점수"/>",
        name : "limitScores",
        data : ["number"],
        check : {
			maxlength : 3
		}
    });
	forUpdate.validator.set(function() {
		var form = UT.getById(forUpdate.config.formId);	
		if(form.elements["scoresSum"].value == 100) {
			return true;
		} else {
			$.alert({
				message : "<spring:message code="글:평가기준:합계비율정보를확인바랍니다"/>"
			});
			return false;
		}
	});
};

/**
 * 평가기준 변경확인
 */
doChangeShow = function() {
	jQuery("#warning").show();
};

/**
 * 평가비율 합계 계산
 */
doScoreSum = function(count) {
	var sum = 0;
	for(var i = 0; i < count; i++){
		sum += Number($("#scores_"+i).val());
	}
	$("#scoresSum").val(sum);
}
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="../../include/commonCourseActive.jsp"></c:import>

	<c:set var="elementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_EVALUATE}"/>
	<c:import url="../include/commonCourseActiveElement.jsp">
		<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>
	
	<form id="FormList" name="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
	
	<div class="lybox-title mt10">
	    <h4 class="section-title"><spring:message code="필드:평가기준:평가기준" /></h4>
	</div>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}" />
	<table class="tbl-detail"><!-- tbl-detail --> 
		<colgroup> 
	        <col width="20%" /> 
	        <col width="80%" /> 
	    </colgroup> 
	    <tbody>
    <c:choose>
		<c:when test="${getDetail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE }">
			<tr> 
	            <th><spring:message code="필드:평가기준:평가기준" /></th> 
	            <td><aof:code type="radio" codeGroup="EVALUATE_METHOD_TYPE" name="evaluateMethodTypeCd" selected="${getDetail.courseActive.evaluateMethodTypeCd }" /></td> 
	        </tr>		
		</c:when>
		<c:otherwise>
			<tr> 
	            <th><spring:message code="필드:평가기준:수료점수" /></th> 
	            <td><input type="text" name="completionScore" value="${getDetail.courseActive.completionScore }" /></td> 
	        </tr>
		</c:otherwise>
	</c:choose>
	    </tbody> 
	</table> 

	<div class="vspace"></div>	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 100px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th rowspan="2"><spring:message code="필드:평가기준:평가항목" /></th>
			<th colspan="4"><spring:message code="필드:평가기준:평가기준" /></th>
		</tr>
		<tr>
			<th><spring:message code="필드:평가기준:평가비율" /></th>
			<th><spring:message code="필드:평가기준:과락점수" /></th>
			<th><spring:message code="필드:평가기준:등록수" /></th>
			<th><spring:message code="필드:평가기준:상세정보" /></th>
		</tr>
	</thead>
	<tbody>
	<c:set var="scoreSum" value="0" />
<c:choose>
	<c:when test="${empty list }">
		<c:choose>
			<c:when test="${getDetail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE }">
				<aof:code type="set" codeGroup="COURSE_ELEMENT_TYPE" var="codeList" except="${CD_COURSE_ELEMENT_TYPE_PLAN},${CD_COURSE_ELEMENT_TYPE_EVALUATE},${CD_COURSE_ELEMENT_TYPE_EXAM}" />			
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS }">
						<aof:code type="set" codeGroup="COURSE_ELEMENT_TYPE" var="codeList" except="${CD_COURSE_ELEMENT_TYPE_PLAN},${CD_COURSE_ELEMENT_TYPE_MIDEXAM},${CD_COURSE_ELEMENT_TYPE_FINALEXAM},${CD_COURSE_ELEMENT_TYPE_EVALUATE},${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT},${CD_COURSE_ELEMENT_TYPE_OFFLINE}" />
					</c:when>
					<c:otherwise>
						<aof:code type="set" codeGroup="COURSE_ELEMENT_TYPE" var="codeList" except="${CD_COURSE_ELEMENT_TYPE_PLAN},${CD_COURSE_ELEMENT_TYPE_MIDEXAM},${CD_COURSE_ELEMENT_TYPE_FINALEXAM},${CD_COURSE_ELEMENT_TYPE_EVALUATE}" />
					</c:otherwise>					
				</c:choose>
			</c:otherwise>
		</c:choose>
		<c:forEach var="row" items="${codeList}" varStatus="i">
			<tr>
				<td>
					<c:set var="count">${count+1 }</c:set>
					<input type="hidden" name="evaluateSeqs" />
					<input type="hidden" name="evaluateTypeCds" value="${row.code}" />
					<c:out value="${row.codeName }" />
				</td>
				<td>
					<input type="text" name="scores" id="scores_<c:out value="${i.index}"/>" value="0" onkeyup="doScoreSum('<c:out value="${fn:length(codeList)}"/>')" onkeydown="doScoreSum('<c:out value="${fn:length(codeList) }"/>')" onchange="doChangeShow();" /> %
				</td>
				<td><input type="text" name="limitScores" value="0" onchange="doChangeShow();" /> <spring:message code="글:평가기준:점" /></td>
				<td>
					-
				</td>
				<td><a href="#" onclick="doGoTab('<c:out value="${row.code }" />')" class="btn gray"><span class="small"><spring:message code="버튼:이동" /></span></a></td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<c:forEach var="row" items="${list}" varStatus="i">
			<tr>
				<td>
					<c:set var="count">${count+1 }</c:set>
					<input type="hidden" name="evaluateSeqs" value="<c:out value="${row.evaluate.evaluateSeq}" />" />
					<input type="hidden" name="evaluateTypeCds" value="${row.evaluate.evaluateTypeCd}" />
					<aof:code type="print" codeGroup="COURSE_ELEMENT_TYPE" selected="${row.evaluate.evaluateTypeCd}" />
				</td>
				<td>
					<c:set var="scoreSum">${scoreSum + row.evaluate.score }</c:set>				
					<input type="text" name="scores" id="scores_<c:out value="${i.index}"/>" value="<fmt:formatNumber value="${row.evaluate.score}" />" onkeyup="doScoreSum('<c:out value="${fn:length(list)}"/>')" onkeydown="doScoreSum('<c:out value="${fn:length(list)}"/>')" onchange="doChangeShow();" /> %
				</td>
				<td><input type="text" name="limitScores" value="<fmt:formatNumber value="${row.evaluate.limitScore}" />" onchange="doChangeShow();" /> <spring:message code="글:평가기준:점" /></td>
				<td>
					<c:out value="${row.evaluate.basicCount }" />
					<c:if test="${row.evaluate.supplementCount > 0}">
						(<c:out value="${row.evaluate.supplementCount}" />)
					</c:if>
				</td>
				<td><a href="#" onclick="doGoTab('<c:out value="${row.evaluate.evaluateTypeCd}" />')" class="btn gray"><span class="small"><spring:message code="버튼:이동" /></span></a></td>
			</tr>
		</c:forEach>
	</c:otherwise>
</c:choose>
		<tr>
			<td><spring:message code="필드:평가기준:합계" /></td>
			<td class="align-l" colspan="4"><input type="text" name="scoresSum" id="scoresSum" readonly="readonly" value="<fmt:formatNumber value="${scoreSum}" />" /> %</td>
		</tr>
	</tbody>
	</table>
	</form>
	

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<spring:message code="글:평가기준:평가비율총합은100%어야야합니다" />
		</div>
		<div class="lybox-btn-r">
			<span id="warning" style="display: none; color: red;"><spring:message code="글:평가기준:저장되지않는데이터가존재합니다" /></span>
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
			<a href="#" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:비율저장" /></span></a>
		</c:if>
			<a href="#" onclick="doList()" class="btn blue"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
		</div>
	</div>
	
</body>
</html>