<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forInsert     = null;
var forUpdate     = null;
var forInsertCopy   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doSetYearTerm('<c:out value="${condition.srchYearTerm}" />');
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/gradelevel/list.do"/>";
	
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/gradelevel/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/gradelevel/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doComplete;
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/gradelevel/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = doComplete;
	
	forInsertCopy = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsertCopy.config.url             = "<c:url value="/univ/gradelevel/copy/insert.do"/>";
	forInsertCopy.config.target          = "hiddenframe";
	forInsertCopy.config.message.confirm = "<spring:message code="글:성적등급관리:이전학기성적등급복사"/>"; 
	forInsertCopy.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsertCopy.validator.set({
		title : "<spring:message code="필드:성적등급관리:년도학기"/>",
		name : "yearTerm",
		data : ["!null"]
	});
	forInsertCopy.config.fn.complete = doCompleteInsertCopy;
	
    setValidate();
    
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
        title : "<spring:message code="필드:성적등급관리:년도학기"/>",
        name : "yearTerm",
        data : ["!null"]
    });
	forInsert.validator.set({
        title : "<spring:message code="필드:성적등급관리:성적등급"/>",
        name : "gradeLevelCd",
        data : ["!null"]
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
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};

/**
 * 저장
 */
doInsert = function() { 
	var original = jQuery("#insertTable").find("tr").find("#gradeLevelCd").val();
	var target = jQuery("#listTable").find("tr").find(":input[name='gradeLevelCds']");
	var compareYn = false; 

	// 이미 등록한 성적등급 확인
	target.each(function(){
		if(this.value == original){
			compareYn = true;
		}
	});
	
	if(!compareYn){
		forInsert.run();
	} else {
		$.alert({
			message : "<spring:message code="글:성적등급관리:중복값이존재합니다"/>"
		});
	}
};

/**
 * 수정
 */
doUpdate = function() {
	forUpdate.run();
};

/**
 * 년도학기세팅
 */
doSetYearTerm = function(value) {
	var form = UT.getById(forInsert.config.formId);
	
	if(value != "") {
		var yearterm = value.substr(0,4)+"<spring:message code="글:성적등급관리:년"/>";
		form.elements['yearTerm'].value = value;
		
		if(value.substr(4,5) == '10'){
			yearterm += "<spring:message code="글:성적등급관리:1학기"/>";
		} else if(value.substr(4,5) == '11'){
			yearterm += "<spring:message code="글:성적등급관리:여름학기"/>";
		} else if(value.substr(4,5) == '20'){
			yearterm += "<spring:message code="글:성적등급관리:2학기"/>";
		} else {
			yearterm += "<spring:message code="글:성적등급관리:겨울학기"/>";
		}
		
		UT.getById("yearTermTd").innerHTML =  yearterm;
	}
	
};

/**
 * 등록, 수정 완료
 */
doComplete = function(success){
	if(success > 0){
		$.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doList();
				}
			}
		});		
	} else {
		$.alert({
			message : "<spring:message code="글:성적등급관리:중복값이존재합니다"/>",
		});
	}
};

doInsertCopy = function(){
	forInsertCopy.run();
};

doCompleteInsertCopy = function(success){
	if(success > 0){
		$.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doList();
				}
			}
		});		
	} else {
		$.alert({
			message : "<spring:message code="글:성적등급관리:복사할이전학기성적등급이없습니다"/>",
		});
	}
};
</script>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	    <div class="lybox">
	        <fieldset>
	        <div class="vspace"></div>
	        <!-- 년도학기 Select Include Area Start -->
	        <select name="srchYearTerm" onchange="doSetYearTerm(this.value);doSearch();" class="select">
	        	<option value=""><spring:message code="글:선택" /></option>
	            <c:import url="../include/yearTermInc.jsp"></c:import>
	        </select>
	        <!-- 년도학기 Select Include Area End -->
	        
	        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
	        <a href="#" onclick="doInsertCopy()" class="btn black"><span class="mid"><spring:message code="버튼:성적등급관리:성적등급복사" /></span></a>
	        </fieldset>
	    </div>
	</form>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	    <input type="hidden" name="srchYearTerm" value="<c:out value="${condition.srchYearTerm}"/>" />
	</form>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="yearTerm" value="${condition.srchYearTerm }" />
	<table id="insertTable" class="tbl-list">
	<colgroup>
		<col style="width: 200px" />
		<col style="width: 200px" />
		<col style="width: 200px" />
		<col style="width: 200px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:성적등급관리:년도학기"/></th>
			<td id="yearTermTd"  class="align-l" colspan="3"><c:out value="${param['yearTermName']}" /></td>
		</tr>
		<tr>
			<th><spring:message code="필드:성적등급관리:성적등급"/></th>
			<th><spring:message code="필드:성적등급관리:평점"/></th>
			<th><spring:message code="필드:성적등급관리:절대평가"/></th>
			<th><spring:message code="필드:성적등급관리:상대평가"/></th>
		</tr>
	</thead>
	<tbody>
        <tr>
            <td>
            	<select name="gradeLevelCd" id="gradeLevelCd">
            		<option value=""><spring:message code="필드:성적등급관리:등급"/></option>
            		<aof:code type="option" codeGroup="GRADE_LEVEL" />
            	</select>
            </td>
            <td><input type="text" name="ratingScore" style="width: 70px" /></td>
            <td><input type="text" name="evalAbsoluteScore" style="width: 50px" /> <spring:message code="글:성적등급관리:이상점수"/>&nbsp;<input type="text" name="evalAbsoluteScoreLast" style="width: 50px" readonly="readonly" value="-" /> <spring:message code="글:성적등급관리:미만점수"/></td>
            <td><input type="text" name="evelRelativeScore" style="width: 50px" /> <spring:message code="글:성적등급관리:이상퍼센트"/>&nbsp;<input type="text" name="evelRelativeScoreLast" style="width: 50px" readonly="readonly" value="-" /> <spring:message code="글:성적등급관리:미만퍼센트"/></td>
        </tr>
    </tbody>
	</table>
	</form>
	
	<div class="lybox-btn">	
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
			</c:if>
		</div>
	</div>
	
	<div class="vspace"></div>
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 200px" />
		<col style="width: 200px" />
		<col style="width: 200px" />
		<col style="width: 200px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:성적등급관리:성적등급"/></th>
			<th><spring:message code="필드:성적등급관리:평점"/></th>
			<th><spring:message code="필드:성적등급관리:절대평가"/></th>
			<th><spring:message code="필드:성적등급관리:상대평가"/></th>
		</tr>
	</thead>
	<tbody>
		<c:set var="evalAbsoluteScore" value="100" />
		<c:set var="evelRelativeScore" value="1" />
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
        <tr>
            <td>
            	<input type="hidden" name="yearTerms" value="<c:out value="${row.univGradeLevel.yearTerm }" />" />
            	<input type="hidden" name="gradeLevelCds" value="<c:out value="${row.univGradeLevel.gradeLevelCd }" />" />
           		<aof:code type="print" codeGroup="GRADE_LEVEL" selected="${row.univGradeLevel.gradeLevelCd }" />
            </td>
            <td><input type="text" name="ratingScores" style="width: 70px" value="<c:out value="${row.univGradeLevel.ratingScore }" />" /></td>
            <td>
            	<input type="text" name="evalAbsoluteScores" style="width: 50px" value="<c:out value="${row.univGradeLevel.evalAbsoluteScore }" />" /> <spring:message code="글:성적등급관리:이상점수"/>&nbsp;<input type="text" name="evalAbsoluteScoreLast" style="width: 50px" readonly="readonly" value="<c:out value="${evalAbsoluteScore }" />" /> <spring:message code="글:성적등급관리:미만점수"/>
            	<c:set var="evalAbsoluteScore" value="${row.univGradeLevel.evalAbsoluteScore }" />
            </td>
            <td>
            	<input type="text" name="evelRelativeScores" style="width: 50px" value="<c:out value="${row.univGradeLevel.evelRelativeScore }" />" /> <spring:message code="글:성적등급관리:이상퍼센트"/>&nbsp;<input type="text" name="evelRelativeScoreLast" style="width: 50px" readonly="readonly" value="<c:out value="${evelRelativeScore }" />" /> <spring:message code="글:성적등급관리:미만퍼센트"/>
            	<c:set var="evelRelativeScore" value="${row.univGradeLevel.evelRelativeScore }" />
            </td>
        </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
		</c:if>
    </tbody>
	</table>
	</form>
	
	<div class="lybox-btn">	
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<c:if test="${!empty paginate.itemList}">
					<a href="#" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
				</c:if>
			</c:if>
		</div>
	</div>
	
</body>
</html>