<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"              value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"            value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_MIDEXAM"        value="${aoffn:code('CD.COURSE_WEEK_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"   value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_QUIZ"        value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.QUIZ')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"          value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COURSE_ELEMENT_TYPE_MIDEXAM = "<c:out value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM}"/>";
var CD_COURSE_ELEMENT_TYPE_FINALEXAM = "<c:out value="${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/>";
var CD_COURSE_ELEMENT_TYPE_TEAMPROJECT = "<c:out value="${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}"/>";
var CD_COURSE_ELEMENT_TYPE_DISCUSS = "<c:out value="${CD_COURSE_ELEMENT_TYPE_DISCUSS}"/>";
var CD_COURSE_ELEMENT_TYPE_QUIZ = "<c:out value="${CD_COURSE_ELEMENT_TYPE_QUIZ}"/>";
var CD_COURSE_ELEMENT_TYPE_HOMEWORK = "<c:out value="${CD_COURSE_ELEMENT_TYPE_HOMEWORK}"/>";

var forListdata         = null;
var forSearch           = null;
var forMoveElement      = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
	
doInitializeLocal = function() {
	
	forSearch = $.action();
    forSearch.config.formId = "FormSrch";
    forSearch.config.url    = "<c:url value="/mypage/course/active/lecturer/mywork/list.do"/>";

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/mypage/course/active/lecturer/mywork/list.do"/>";
	
	forMoveElement = $.action();
	forMoveElement.config.formId = "FormData";
	
};
 
 /**
  * 목록보기 가져오기 실행.
  */
 doList = function() {
	 forSearch.run();
 };
 
 /**
  * 정렬및 출력개수 수정시 사용
  */
 doSearch = function(rows) {
 	var form = UT.getById(forSearch.config.formId);
 	
 	// 목록갯수 셀렉트박스의 값을 변경 했을 때
 	if (rows != null && form.elements["perPage"] != null) {  
 		form.elements["perPage"].value = rows;
 	}
 	forSearch.run();
 };
 
 /**
  * 목록페이지 이동. page navigator에서 호출되는 함수
  */
 doPage = function(pageno) {
 	var form = UT.getById(forListdata.config.formId);
 	if(form.elements["currentPage"] != null && pageno != null) {
 		form.elements["currentPage"].value = pageno;
 	}
 	doList();
 };
 
 /**
  * 채점하기 이동
  */
 doCourseActiveElementMove = function(mapPKs, type){
 	UT.getById(forMoveElement.config.formId).reset();
 	UT.copyValueMapToForm(mapPKs, forMoveElement.config.formId);
 	
 	if(CD_COURSE_ELEMENT_TYPE_DISCUSS == type){
 		forMoveElement.config.url = "<c:url value="/univ/course/discuss/result/list.do"/>";	
 	} else if(CD_COURSE_ELEMENT_TYPE_FINALEXAM == type || CD_COURSE_ELEMENT_TYPE_MIDEXAM == type) {
 		forMoveElement.config.url = "<c:url value="/univ/course/active/exampaper/result/list.do"/>";
 	} else if(CD_COURSE_ELEMENT_TYPE_HOMEWORK == type) {
 		forMoveElement.config.url = "<c:url value="/univ/course/homework/result/list.do"/>";
 	} else if(CD_COURSE_ELEMENT_TYPE_QUIZ == type) {
 		forMoveElement.config.url = "<c:url value="/univ/course/active/quiz/result/list.do"/>";
 	} else if(CD_COURSE_ELEMENT_TYPE_TEAMPROJECT == type) {
 		forMoveElement.config.url = "<c:url value="/univ/teamproject/result/list.do"/>";
 	}
 	
 	forMoveElement.run();
 };
 
/*
 * 쪽지,SMS,이메일 응시자 체크
 */
doCheckSub = function() {
	var $checked = jQuery("#listTable").find("tr").find(":input[name='checkkeys1']");
	$checked.each(function() {
		var $this = jQuery(this);
		var $tr = $this.closest("tr");
		if($this.is(":checked")){
			$tr.find(":input[name='checkkeys']").attr("checked", true);
		} else {
			$tr.find(":input[name='checkkeys']").attr("checked", false);
		}
	});
}
</script>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
	</form>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<input type="radio" name="orderby" value="1" onclick="doSearch();" <c:if test="${condition.orderby == 1 }">checked="checked"</c:if> /><spring:message code="글:마이페이지:제출완료일정렬" />
			<input type="radio" name="orderby" value="2" onclick="doSearch();" <c:if test="${condition.orderby == 2 }">checked="checked"</c:if> /><spring:message code="글:마이페이지:교과목정렬" />
		</div>
	</form>
		<c:import url="/WEB-INF/view/include/perpage.jsp">
			<c:param name="onchange" value="doSearch"/>
			<c:param name="selected" value="${condition.perPage}"/>
		</c:import>
	</div>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="shortcutCourseActiveSeq" />
        <input type="hidden" name="myworkCurrentPage" value="<c:out value="${condition.currentPage}"/>" />
        <input type="hidden" name="myworkPerPage"     value="<c:out value="${condition.perPage}"/>" />
        <input type="hidden" name="myworkOrderby"     value="<c:out value="${condition.orderby}"/>" />
		
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: 200px" />
		<col style="width: auto" />
		<col style="width: 120px" />
		<col style="width: 120px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys1','checkButton','checkButtonTop');doCheckSub();" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th colspan="2"><spring:message code="글:마이페이지:교과목명" /></th>
			<th><spring:message code="글:마이페이지:응시미채점" /></th>
			<th><spring:message code="글:마이페이지:채점하기" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys1" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop'); doCheckSub();">
				<c:forEach var="row1" items="${row.applyElement.takeList}" varStatus="j">
					<input type="checkbox" name="checkkeys" value="<c:out value="${j.index}"/>" style="display: none;">
		        	<input type="hidden" name="memberSeqs" value="<c:out value="${row1.member.memberSeq}" />">
					<input type="hidden" name="memberNames" value="<c:out value="${row1.member.memberName}" />">
					<input type="hidden" name="phoneMobiles" value="<c:out value="${row1.member.phoneMobile}" />">
				</c:forEach>
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
	        <td>
	        	<c:choose>
	        		<c:when test="${row.element.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_MIDEXAM}">
	        			<c:choose>
	        				<c:when test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_MIDEXAM }">
								<c:choose>
			        				<c:when test="${row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC }">
			        					<span class="section-btn blue02"><spring:message code="글:마이페이지:중간고사"/></span>
			        				</c:when>
			        				<c:otherwise>
			        					<span class="section-btn gree"><spring:message code="글:마이페이지:보충시험"/></span>				
			        				</c:otherwise>
			        			</c:choose>       				
	        				</c:when>
	        				<c:otherwise>
	        					<span class="section-btn blue02"><spring:message code="글:마이페이지:중간고사대체과제"/></span>
	        				</c:otherwise>
	        			</c:choose>
	        		</c:when>
	        		<c:when test="${row.element.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_FINALEXAM }">
	        			<c:choose>
	        				<c:when test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_MIDEXAM }">
								<c:choose>
			        				<c:when test="${row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC }">
			        					<span class="section-btn blue02"><spring:message code="글:마이페이지:기말고사"/></span>
			        				</c:when>
			        				<c:otherwise>
			        					<span class="section-btn gree"><spring:message code="글:마이페이지:보충시험"/></span>				
			        				</c:otherwise>
			        			</c:choose>       				
	        				</c:when>
	        				<c:otherwise>
	        					<span class="section-btn blue02"><spring:message code="글:마이페이지:기말고사대체과제"/></span>
	        				</c:otherwise>
	        			</c:choose>
	        		</c:when>
	        		<c:when test="${row.element.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_HOMEWORK }">
	        			<c:choose>
	        				<c:when test="${row.applyElement.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC }">
	        					<span class="section-btn blue02"><spring:message code="글:마이페이지:과제일반"/></span>
	        				</c:when>
	        				<c:otherwise>
	        					<span class="section-btn gree"><spring:message code="글:마이페이지:과제보충"/></span>			
	        				</c:otherwise>
	        			</c:choose>      
	        		</c:when>
	        		<c:when test="${row.element.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_TEAMPROJECT }">
	        			<span class="section-btn yellow"><spring:message code="글:마이페이지:팀프로젝트"/></span>
	        		</c:when>
	        		<c:when test="${row.element.referenceTypeCd eq CD_COURSE_ELEMENT_TYPE_DISCUSS }">
	        			<span class="section-btn yellow"><spring:message code="글:마이페이지:토론"/></span>
	        		</c:when>
	        	</c:choose>
	        </td>
			<td>
				<dl class="lecture-info"> 
					<dd>
						<c:out value="${row.category.categoryString }" />
					</dd>
                  	<dd>
                  		<c:if test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE }">
               				[<c:out value="${fn:substring(row.active.yearTerm,0,4)}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${fn:substring(row.active.yearTerm,4,6)}" removeCodePrefix="true"/>]
               				<c:out value="${row.active.courseActiveTitle }" /> - <span><c:out value="${row.active.division }" /><spring:message code="글:마이페이지:분반"/></span>
               			</c:if>
                 		<c:if test="${row.category.categoryTypeCd ne CD_CATEGORY_TYPE_DEGREE }">
                 			[<c:out value="${row.active.year }" />] <c:out value="${row.active.courseActiveTitle }" />
                 			<c:if test="${row.active.courseTypeCd eq CD_COURSE_TYPE_PERIOD }">
                  				 - [<c:out value="${row.active.periodNumber }" /><spring:message code="글:마이페이지:기"/>]
                  			</c:if>
                 		</c:if>
                 		<span><c:out value="${row.member.memberName }" /></span>
                  		<span><aof:date datetime="${row.element.startDtime }" /> ~ <aof:date datetime="${row.element.endDtime }" /></span>
                  	</dd>
                  	<dd>
                  		<c:out value="${row.element.activeElementTitle }" />
                  	</dd>
              	</dl> 
			</td>
	        <td><c:out value="${row.applyElement.takeCount }" /> (<c:out value="${row.applyElement.scoreCount }" />)</td>
	        <td><a href="#" onclick="doCourseActiveElementMove({'shortcutCourseActiveSeq' : '${row.active.courseActiveSeq}'},'<c:out value="${row.element.referenceTypeCd }" />');" class="btn blue"><span class="mid"><spring:message code="버튼:마이페이지:채점하기" /></span></a></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<%--
			<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue">
               	<span class="mid"><spring:message code="버튼:쪽지" /></span>
               </a>
			<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:SMS" /></span>
			</a>
			<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:이메일" /></span>
			</a>
			 --%>
		</div>
	</div>
</body>
</html>