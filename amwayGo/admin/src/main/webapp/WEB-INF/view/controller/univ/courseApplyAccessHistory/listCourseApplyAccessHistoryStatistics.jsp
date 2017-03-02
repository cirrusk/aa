<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_DEGREE = "<c:out value="${CD_CATEGORY_TYPE_DEGREE}"/>";

var forSearch = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]datepicker
    UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
		
	// [3] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	  
	UI.inputComment("FormSrch");
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action("submit", {formId : "FormSrch"});
	forSearch.config.url    = "<c:url value="/course/apply/access/history/statistics/list.do"/>";
	
	setValidate();
	
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forSearch.validator.set(function(){
		var startDate = $("input[name=srchStartRegDate]").val();
		var endDate = $("input[name=srchEndRegDate]").val();
			
		if(startDate != null && startDate != ''){
			if(endDate == null || endDate == ''){
				$.alert({message : "<spring:message code="필드:모니터링:종료일을선택해주세요"/>",
					button1 : {
			            callback : function() {
			            	$("input[name=srchEndRegDate]").focus();
			                }
				         }
			        });
				return false;
			}
		}else if(endDate != null && endDate != ''){
			if(startDate == null || startDate == ''){
				$.alert({message : "<spring:message code="필드:모니터링:시작일을선택해주세요"/>",
					button1 : {
			            callback : function() {
			            	$("input[name=srchStartRegDate]").focus();
			                }
				         }
			        });
				return false;
			}
		}
		
		return true;
	});
	
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작일"/>",
		name : "srchStartRegDate",
		check : {
			le : {name : "srchEndRegDate", title : "<spring:message code="필드:로그인:종료일"/>"}
		}
	});
	
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
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
 * 검색 학위 비학위 셀렉트 박스 변경시 2차검색셀렉트 박스 변경
 */
doSelectCategoryType = function(element) {
	
	var categoryType = element.value;
	
	if(categoryType == CD_CATEGORY_TYPE_DEGREE){
		$("#yearTerm").show();
		$("#srchYear").val("");
		$("#year").hide();
	}else {
		$("#srchYear").val("");
		$("#year").show();
		$("#srchYearTerm").val("");
		$("#yearTerm").hide();
	}
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<c:import url="srchAccessHistory.jsp"/>
				
	<div class="vspace"></div>
	<div class="vspace"></div>
							
	<c:choose>
		<c:when test="${condition.srchYn eq 'Y'}">

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width: 50px" />
				<col style="width: auto" />
				<col style="width: 150px" />
				<col style="width: 150px" />
				<col style="width: 100px" />
				<col style="width: 100px" />
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="필드:번호" /></th>
					<th><span class="sort" sortid="1"><spring:message code="필드:모니터링:교과목명" /></span></th>
					<th><span class="sort" sortid="2"><spring:message code="필드:모니터링:개설학과" /></span></th>
					<th><spring:message code="필드:모니터링:담당교수" /></th>
					<th><spring:message code="필드:모니터링:수강인원" /></th>
					<th><span class="sort" sortid="3"><spring:message code="필드:모니터링:접속자수" /></span></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
			       <td>
					<c:out value="${paginate.descIndex - i.index}"/>
			       </td> 
			       <td class="align-l">
					<c:out value="${row.courseActive.courseActiveTitle}"/><br/>
					<aof:code type="print" codeGroup="CATEGORY_TYPE" selected="${row.cate.categoryTypeCd}" /> |
					<c:choose>
						<c:when test="${row.cate.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
							<aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row.courseActive.completeDivisionCd}" />
						</c:when>
						<c:otherwise>
							<aof:code type="print" codeGroup="COURSE_TYPE" selected="${row.courseActive.courseTypeCd}" />
						</c:otherwise>
					</c:choose>
					<br/>
					<spring:message code="글:모니터링:학습기간" /> : 
					<aof:date datetime="${row.courseActive.studyStartDate}"/> ~
   				    <aof:date datetime="${row.courseActive.studyEndDate}"/>
			       </td>
			       <td>
			       	<c:out value="${row.cate.categoryName}"/>
			       </td>
			       <td>
			       	<c:out value="${row.accessHistory.peofPresidentName}"/>
			       </td>
			       <td>
			       	<c:out value="${row.accessHistory.totalApplyCount}"/>
			       </td>
			       <td>
			       	<c:out value="${row.accessHistory.totalAccessCount}"/>
			       </td>
				</tr>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="6">
						<spring:message code="글:데이터가없습니다" />
					</td>
				</tr>
			</c:if>
		</table>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
		</c:when>
		<c:otherwise>
			<div class="vspace"></div>
			<div class="lybox align-c">
				<spring:message code="글:검색조건을확인하신후검색버튼을클릭하십시오"/>
			</div>
		</c:otherwise>
	</c:choose>	

</body>
</html>